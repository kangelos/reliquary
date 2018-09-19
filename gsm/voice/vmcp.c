/*----------------------------------------------------------------------*/
/* vmcp		Voice Modem Control Program.				*/
/*		A little program to send commands to the modem		*/
/*		with special features for voice modems.			*/
/*									*/
/* Version	0.6		Sep 8 1997				*/
/*									*/
/* Author:	Niccolo Rigacci <fd131@cleveland.freenet.edu>		*/
/*									*/
/* Copyright (C) 1996 Niccolo Rigacci					*/
/*									*/
/* This program is free software; you can redistribute it and/or modify	*/
/* it under the terms of the GNU General Public License as published by	*/
/* the Free Software Foundation; either version 2 of the License, or	*/
/* (at your option) any later version.					*/
/*									*/
/* This program is distributed in the hope that it will be useful,	*/
/* but WITHOUT ANY WARRANTY; without even the implied warranty of	*/
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	*/
/* GNU General Public License for more details.				*/
/* 									*/
/* You should have received a copy of the GNU General Public License	*/
/* along with this program; if not, write to the Free Software		*/
/* Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.		*/
/*----------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <signal.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
 
/*----------------------------------------------------------------------*/
/* Macro definitions
/*----------------------------------------------------------------------*/
/* DLE			Escape char for voice mode.			*/
/* BREAK_KEY		Break key for -k switch.			*/
/* MAX_LEN_FNAME	Max len for filename strings.			*/
/* TEMP_DIR		Where to put the lock file.			*/
/* DEVS_DIR		Where modem devices are.			*/
/* DFLT_DEV		Default modem device.				*/
/* DEV_NULL		Black-hole file.				*/
/* HDB_LCK_FORMAT	Format string for printing PID in HDB lockfile.	*/
/* HDB_LCK_LEN		Len of HDB lockfile.				*/

#define TRUE		1
#define FALSE		0
#define DLE		16
#define BREAK_KEY	27
#define MAX_LEN_FNAME	255
#define TEMP_DIR	"/tmp/"
#define DEVS_DIR	"/dev/"
#define DFLT_DEV	"ttyS0"
#define DEV_NULL	"/dev/null"
#define HDB_LCK_FORMAT	"%10d\n"
#define HDB_LCK_LEN	11

#define EXIT_OK		0
#define EXIT_TIMEOUT	100
#define EXIT_KEYPRESS	101
#define ERR_MEMORY	150
#define ERR_SYNTAX	151
#define ERR_DEVICE	152
#define ERR_OPEN	153
#define ERR_WRITE	154
#define ERR_CLOSE	155
#define ERR_LOCK	156
#define ERR_IOCTL	157
#define ERR_LCKFILE	158
#define ERR_BAUDRATE	159
#define ERR_SIGNAL	200

/*----------------------------------------------------------------------*/
/* Function prototypes
/*----------------------------------------------------------------------*/
int out_chr(int c);
int out_esc(int c);
void no_response(int i);
void end_on_signal(int i);
void fatal(int exit_code);
char *strdupcvt(char *str);
void safeprint(char *msg, char *str);
void port_reset(int fd);

/*----------------------------------------------------------------------*/
/* Global variables
/*----------------------------------------------------------------------*/
struct termios ts;			/* Saved stdin line settings	*/
int debug = FALSE;			/* Be verbose			*/
int timeout = 5;			/* Seconds to wait		*/
int break_on_key = FALSE;		/* Return on keypress		*/
int escaping_dle = FALSE;		/* Handle escaping of DLE	*/
int make_lock_file = FALSE;		/* Must create lock file	*/
int made_lock_file = FALSE;		/* Lock file created		*/
int changed_std_input = FALSE;		/* Std input settings changed	*/
int quit_on_eof = FALSE;		/* Return on end of input file	*/
int skip_out_string = FALSE;		/* Do not output the -W string	*/
FILE *inp_fp;				/* Input file pointer		*/
FILE *out_fp;				/* Output file pointer		*/
FILE *esc_fp;				/* Escape file pointer		*/
unsigned char *lckfname = NULL;		/* Name of the lock file	*/
unsigned char *command = NULL;		/* Command to send		*/
unsigned char *out_string = NULL;	/* String to wait		*/
unsigned char *esc_string = NULL;	/* Escape chars to wait		*/
int out_len;				/* Len of out_string		*/
int out_pos = 0;			/* Index to scan out_string	*/
int ok_exit_code;			/* Exit code if OK (0 - 99)	*/
long baud_rate;				/* Baud rate of serial line	*/

/*----------------------------------------------------------------------*/
/* Main program
/*----------------------------------------------------------------------*/
void main(int argc, char **argv)
   {
   int i, c, fd, opt;
   int eof_inp = TRUE;
   int finito = FALSE;
   int reset_port = FALSE;
   int previous_dle = FALSE;
   int sent_one_dle = FALSE;
   unsigned char pid_buf[HDB_LCK_LEN + 1];
   unsigned char filename[MAX_LEN_FNAME + 1];
   unsigned char *inp_file, *out_file, *esc_file;
   unsigned char *device;
   unsigned char buf;
   struct termios new_ts;
   fd_set rfds;
   pid_t pid;

   /* Set default values for some strings. */
   inp_file = out_file = esc_file = DEV_NULL;
   device = DFLT_DEV;

   /* Process command line arguments */
   while ((opt = getopt(argc, argv, "c:d:eghi:kl:o:qs:t:w:W:x:z:")) != -1)
      {
      switch (opt)
         {
         case 'e':
            escaping_dle = TRUE; break;
         case 'g':
            debug = TRUE; break;
         case 'k':
            break_on_key = TRUE; break;
         case 'q':
            quit_on_eof = TRUE; break;
         case 'c':
            if ((command = strdupcvt(optarg)) == NULL) fatal(ERR_MEMORY);
            break;
         case 'd':
            if ((device = strdup(optarg)) == NULL) fatal(ERR_MEMORY);
            break;
         case 'h':
            fprintf(stderr, "Voice Modem Control Program\n");
            fprintf(stderr, "Usage: %s [OPTION]...\n", argv[0]);
            fprintf(stderr, "\t-c command\n\t-d device\n\t-e\n\t-g\n\t-h\n");
            fprintf(stderr, "\t-i in_file\n\t-k\n\t-l lockfile\n");
            fprintf(stderr, "\t-o out_file\n\t-q\n\t-s esc_file\n");
            fprintf(stderr, "\t-t sec\n\t-w waitstring\n\t-W skipstring\n");
            fprintf(stderr, "\t-x esc_string\n\t-z baudrate\n");
            exit(0);
            break;
         case 'i':
            if ((inp_file = strdup(optarg)) == NULL) fatal(ERR_MEMORY);
            eof_inp = FALSE;
            break;
         case 'l':
            if ((lckfname = strdup(optarg)) == NULL) fatal(ERR_MEMORY);
            make_lock_file = TRUE; break;
         case 'o':
            if ((out_file = strdup(optarg)) == NULL) fatal(ERR_MEMORY);
            break;
         case 's':
            if ((esc_file = strdup(optarg)) == NULL) fatal(ERR_MEMORY);
            break;
         case 't':
            timeout = atoi(optarg); break;
         case 'W':
            skip_out_string = TRUE;
         case 'w':
            if ((out_string = strdupcvt(optarg)) == NULL) fatal(ERR_MEMORY);
            out_len = strlen(out_string);
            break;
         case 'x':
            if ((esc_string = strdup(optarg)) == NULL) fatal(ERR_MEMORY);
            break;
         case 'z':
            baud_rate = atol(optarg);
            reset_port = TRUE;
            break;
         default:
            fprintf(stderr, "Try `vmcp -h' for help.\n");
            fatal(ERR_SYNTAX);
            break;
         }
      }

   /* Set standard input line settings in non-canonical mode:	*/
   /* no line buffering, no echo, no wait.			*/
   if (break_on_key)
      {
      /* Get standard input (file descriptor 0) line settings. */
      if (ioctl(0, TCGETS, &ts) != 0) fatal(ERR_IOCTL);
      new_ts = ts;
      new_ts.c_lflag &= ~ICANON;
      new_ts.c_lflag &= ~ECHO;
      new_ts.c_cc[VTIME] = 0;
      new_ts.c_cc[VMIN] = 0;
      if (ioctl(0, TCSETS, &new_ts) != 0) fatal(ERR_IOCTL);
      changed_std_input = TRUE;
      }

   /* Set the timeout alarm. */
   if (timeout != 0)
      {
      signal(SIGALRM, no_response);
      alarm(timeout);
      }

   /* Set some signal handling functions. */
   signal(SIGHUP, end_on_signal);
   signal(SIGINT, end_on_signal);
   signal(SIGQUIT, end_on_signal);
   signal(SIGTERM, end_on_signal);

   /* Open communication file device. */
   sprintf(filename, "%s%s", DEVS_DIR, device);
   if ((fd = open(filename, O_RDWR | O_NONBLOCK)) == -1) fatal(ERR_DEVICE);
   if (flock(fd, LOCK_EX | LOCK_NB) != 0) fatal(ERR_LOCK);

   if (reset_port)
      {
      if (debug) fprintf(stderr, "Resetting the serial line\n");
      port_reset(fd);
      }

   /* Create lock file if required. Use HDB lockfile format:	*/
   /* ten byte ASCII decimal number, with a trailing newline.	*/
   if (make_lock_file)
      {
      pid = getpid();
      sprintf(pid_buf, HDB_LCK_FORMAT, pid);
      sprintf(filename, "%sTMP..%d", TEMP_DIR, pid);
      /* Create a temp lock file and write PID to it. */
      if ((i = creat(filename, 0644)) == -1) fatal(ERR_LCKFILE);
      if (write(i, pid_buf, HDB_LCK_LEN) != HDB_LCK_LEN) fatal(ERR_LCKFILE);
      if (close(i) != 0) fatal(ERR_LCKFILE);
      /* Change name to the lock file. */
      if (link(filename, lckfname) == 0) made_lock_file = TRUE;
      unlink (filename);
      if (!made_lock_file) fatal(ERR_LCKFILE);
      }

   /* Write command to communication file device. */
   /* NOTE: no check is made for EAGAIN error, we */
   /* suppose command string to be small enough   */
   /* to fit entirely in the output buffer.       */
   if (command != NULL)
      {
      /* Just paranoia: US-Robotic requires a pause	*/
      /* of 1 ms before "AT" commands, we do 2 ms.	*/
      if (strncmp(command, "AT", 2) == 0 || strncmp(command, "at", 2) == 0)
         {
         struct timeval tv;

         tv.tv_sec = 0;
         tv.tv_usec = 2000;
         select(0, NULL, NULL, NULL, &tv);
         }

      if (debug) safeprint("Sending", command);
      i = strlen(command);
      if (write(fd, command, i) != i) fatal(ERR_WRITE);
      }
   else
      if (debug && (out_string != NULL))
         if (skip_out_string)
            safeprint("Skipping", out_string);
         else
            safeprint("Waiting for", out_string);

   /* Open input, output and escape files. */
   if ((inp_fp = fopen(inp_file, "rb")) == NULL) fatal(ERR_OPEN);
   if ((out_fp = fopen(out_file, "wb")) == NULL) fatal(ERR_OPEN);
   if ((esc_fp = fopen(esc_file, "wb")) == NULL) fatal(ERR_OPEN);

   /* Main loop to send input file to communication device's input */
   /* and to capture output to output file. If escaping of DLE     */
   /* char is enabled, escaped chars are sent to escape file.      */

   while (!finito)
      {
      /* If "-i file" has more characters to send, do one. */
      if (!eof_inp)
         {
         /* Write a char from "-i file" to device, escape DLE if required. */
         if ((c = fgetc(inp_fp)) == EOF)
            {
            eof_inp = TRUE;
            finito = quit_on_eof;
            }
         else
            {
            buf = (unsigned char)c;
            if (write(fd, &buf, 1) == 1)
               { /* No error, check for DLE escaping. */
               if (buf == DLE && escaping_dle && !sent_one_dle)
                  {
                  sent_one_dle = TRUE;
                  if (ungetc(c, inp_fp) == EOF) fatal(ERR_WRITE);
                  }
               else
                  sent_one_dle = FALSE;
               }
            else
               { /* Error writing, check for error type. */
               if (errno == EAGAIN)
                  { /* May be buffer full, retry later. */
                  if (ungetc(c, inp_fp) == EOF) fatal(ERR_WRITE);
                  }
               else
                  fatal(ERR_WRITE);
               }
            }
         }
      else
         {
         /* No more char to send, can wait chars from kbd or device. */
         FD_ZERO(&rfds);
         if (break_on_key) FD_SET(0, &rfds);
         FD_SET(fd, &rfds);
         /* Sleep until chars ready for reading. */
         select(fd + 1, &rfds, NULL, NULL, NULL);
         }

      /* Read a character from device, escape DLE if required. */
      if (read(fd, &buf, 1) == 1)
         {
         if (escaping_dle)
            if (previous_dle)
               {
               previous_dle = FALSE;
               if (buf == DLE)
                  finito = out_chr((int)buf);
               else
                  finito = out_esc((int)buf);
               }
            else
               if (buf == DLE)
                  previous_dle = TRUE;
               else
                  finito = out_chr((int)buf);
         else
            finito = out_chr((int)buf);
         }

      /* Check BREAK_KEY pressed. */
      if (break_on_key)
         if ((getchar() == BREAK_KEY))
            {
            ok_exit_code = EXIT_KEYPRESS;
            finito = TRUE;
            }
      }

   /* Close input, output, escape files and modem device. */
   i = 0;
   if (fclose(inp_fp) == EOF)    i +=  1;
   if (fclose(out_fp) == EOF)    i +=  2;
   if (fclose(esc_fp) == EOF)    i +=  4;
   if (flock(fd, LOCK_UN) == -1) i +=  8;
   if (close(fd) == -1)          i += 16;

   if (i)
      {
      if (debug) fprintf(stderr, "Close error: %d\n", i);
      fatal(ERR_CLOSE);
      }
   else
      fatal(ok_exit_code);
   }

/*----------------------------------------------------------------------*/
/* Write c to output file, return TRUE if received out_string.		*/
/*----------------------------------------------------------------------*/
int out_chr(int c)
   {
   if (!skip_out_string) fputc(c, out_fp);
   if (out_string == NULL)
      return FALSE;
   else
      {
      if ((unsigned char)c == out_string[out_pos]) out_pos++;
      else out_pos = 0;
      if (out_pos == out_len)
         if (skip_out_string)
            {
            skip_out_string = FALSE;
            free(out_string);
            out_string = NULL;
            return FALSE;
            }
         else
            {
            ok_exit_code = EXIT_OK;
            return TRUE;
            }
      else
         return FALSE;
      }
   }

/*----------------------------------------------------------------------*/
/* Write c to escape file, return TRUE if c is in esc_string.		*/
/*----------------------------------------------------------------------*/
int out_esc(int c)
   {
   int i;

   fputc(c, esc_fp);
   if (esc_string == NULL)
      return FALSE;
   else
      {
      for (i = 0; esc_string[i] != '\0' && esc_string[i] != (unsigned char)c; i++);
      if (esc_string[i] == '\0')
         return FALSE;
      else
         {
         ok_exit_code = ++i;
         return TRUE;
         }
      }
   }

/*----------------------------------------------------------------------*/
/* Timeout: exit program.						*/
/*----------------------------------------------------------------------*/
void no_response(int i)
   {
   fatal(EXIT_TIMEOUT);
   }

/*----------------------------------------------------------------------*/
/* Signal: exit program.						*/
/*----------------------------------------------------------------------*/
void end_on_signal(int i)
   {
   fatal(ERR_SIGNAL + i);
   }

/*----------------------------------------------------------------------*/
/* Fatal errors handling.						*/
/*----------------------------------------------------------------------*/
void fatal(int exit_code)
   {
   /* Restore standard input line settings earlier saved. */
   if (break_on_key)
      if (changed_std_input)
         if (ioctl(0, TCSETS, &ts) != 0)
            if (debug) fprintf(stderr, "ioctl(2) error %d\n", errno);

   /* Remove lock file if required. */
   if (made_lock_file)
      if (unlink(lckfname) != 0)
         if (debug) fprintf(stderr, "Can't remove %s", lckfname);

   if (debug) fprintf(stderr, "Exit code %d\n", exit_code);
   exit(exit_code);
   }

/*----------------------------------------------------------------------*/
/* Make a duplicate of the string, do some backslash parsing, add CR.	*/
/*----------------------------------------------------------------------*/
char *strdupcvt(char *str)
   {
   unsigned char *newstr, *pt1, *pt2;
   int i, addcr = TRUE;

   /* Allocate max space for new string. */
   if ((newstr = (unsigned char*)malloc(strlen(str) + 3)) != NULL)
      {
      strcpy(newstr, str);
      for (pt1 = pt2 = newstr; *pt1; pt1++, pt2++)
         {
         if (*pt1 != '\\')
            *pt2 = *pt1;
         else
            {
            pt1++;
            switch (*pt1)
               {
               case 'c': pt2--; addcr = FALSE; break;
               case 'n':  *pt2 = '\n'; break;
               case 'r':  *pt2 = '\r'; break;
               case '0': case '1': case '2': case '3':
               case '4': case '5': case '6': case '7':
                  *pt2 = 0;
                  for (i = 0; i < 3 && *pt1 && *pt1 >= '0' && *pt1 <= '7'; i++, pt1++)
                     *pt2 = (*pt2 << 3) + (*pt1 & 7);
                  pt1--;
                  break;
               default: pt1--; *pt2 = *pt1; break;
               }
            }
         }
      if (addcr) *(pt2++) = '\r';
      *pt2 = '\0';
      }
   return newstr;
   }

/*----------------------------------------------------------------------*/
/* Print msg and str. Unprintable chars in str are printed in hex.	*/
/*----------------------------------------------------------------------*/
void safeprint(char *msg, char *str)
   {
   int i;

   fprintf(stderr, "%s ", msg);
   for (i = 0; str[i]; i++)
      {
      if (str[i] >= ' ' && str[i] <= '~')
         fprintf(stderr, "%c", str[i]);
      else
         fprintf(stderr, " 0x%02x", str[i]);
      }
   fprintf(stderr, "\n");
   }

/*----------------------------------------------------------------------*/
/* Set the serial line to raw, etc.					*/
/*----------------------------------------------------------------------*/
void port_reset(int fd)
   {
   int line;
   struct termios ts;

   /* Flush input and output queues. */
   if (ioctl(fd, TCFLSH, 2) != 0) fatal(ERR_IOCTL);

   /* Turn off DTR control line. */
   line = TIOCM_DTR;
   if (ioctl(fd, TIOCMBIC, &line) != 0) fatal(ERR_IOCTL);

   /* Pauses for 3 seconds. */
   /* No modem should resist over 3 seconds with	*/
   /* DTR off: they return at least in command mode!	*/
   sleep(3);

   /* Turn on DTR control line. */
   line = TIOCM_DTR;
   if (ioctl(fd, TIOCMBIS, &line) != 0) fatal(ERR_IOCTL);
 
   /* Fetch the current terminal parameters. */
   if (ioctl(fd, TCGETS, &ts) != 0) fatal(ERR_IOCTL);
 
   /* Sets hardware control flags:                              */
   /* 8 data bits                                               */
   /* Enable receiver                                           */
   /* Ignore CD (local connection)                              */
   /* Use RTS/CTS flow control                                  */

   ts.c_cflag = CS8 | CREAD | CLOCAL | CRTSCTS;
   ts.c_iflag = 0;
   ts.c_oflag = NL0 | CR0 | TAB0 | BS0 | VT0 | FF0;
   ts.c_lflag = 0;

   switch ((int)(baud_rate / 100))
      {
      case   96: ts.c_cflag |= B9600;   break;
      case  192: ts.c_cflag |= B19200;  break;
      case  384: ts.c_cflag |= B38400;  break;
      case  576: ts.c_cflag |= B57600;  break;
      case 1152: ts.c_cflag |= B115200; break;
      case 2304: ts.c_cflag |= B230400; break;
      default: fatal(ERR_BAUDRATE); break;
      }

   /*-----------------------------------------------------------*/
   /* All these capabilities are turned off; see termios(2)	*/
   /* and stty(1L) man pages:					*/
   /*								*/
   /* c_cflag		CSTOPB	PARENB	HUPCL			*/
   /*								*/
   /* c_iflag		IGNBRK	BRKINT	IGNPAR	PARMRK	INPCK	*/
   /*			ISTRIP	INLCR	IGNCR	ICRNL	IXON	*/
   /*			IXOFF	IUCLC	IXANY	IMAXBEL		*/
   /*								*/
   /* ts.c_oflag	OPOST	OLCUC	OCRNL	ONLCR	ONOCR	*/
   /*			ONLRET	OFILL	OFDEL			*/
   /*								*/
   /* ts.c_lflag	ISIG	ICANON	IEXTEN	ECHO	ECHOE	*/
   /*			ECHOK	ECHONL	NOFLSH	XCASE	TOSTOP	*/
   /*			ECHOPRT	ECHOCTL	ECHOKE			*/
   /*-----------------------------------------------------------*/

   ts.c_cc[VINTR]    = '\0';
   ts.c_cc[VQUIT]    = '\0';
   ts.c_cc[VERASE]   = '\0';
   ts.c_cc[VKILL]    = '\0';
   ts.c_cc[VEOF]     = '\0';
   ts.c_cc[VTIME]    = '\0';
   ts.c_cc[VMIN]     = 1;
   ts.c_cc[VSWTC]    = '\0';
   ts.c_cc[VSTART]   = '\0';
   ts.c_cc[VSTOP]    = '\0';
   ts.c_cc[VSUSP]    = '\0';
   ts.c_cc[VEOL]     = '\0';
   ts.c_cc[VREPRINT] = '\0';
   ts.c_cc[VDISCARD] = '\0';
   ts.c_cc[VWERASE]  = '\0';
   ts.c_cc[VLNEXT]   = '\0';
   ts.c_cc[VEOL2]    = '\0';

   /* Sets the new terminal parameters. */
   if (ioctl(fd, TCSETS, &ts) != 0) fatal(ERR_IOCTL);

   return;
   }
