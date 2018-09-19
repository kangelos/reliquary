/*
 *
 * SSL POP3 realy for all POP3 clients on a WINDOWS PC
 * Co 1998  Angelos Karageorgiou  angelos@unix.gr
 *
 *
 */




#include <windows.h>
#include <winsock.h>
#include <stdio.h>
#include <io.h>
#include <stdlib.h>
#include <memory.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>


#include "ssl.h"
#include "x509.h"
#define BUFSIZ 256000 /* I fucking hate windows , somebody fix this */

#define CHK_NULL(x) if ((x)==NULL) exit (1)
#define CHK_ERR(err,s) if ((err)==-1) { perror(s); exit(1); }
#define CHK_SSL(err) if ((err)==-1) { ERR_print_errors_fp(stderr); exit(2); }

void transfer(SSL *ssl, int tunnel);
  u_long socketbooster=1;

void main (int argc, char* argv[]) {
  int err;
  int sd,mysock,newsockfd;
  struct sockaddr_in sa,my_addr,cli_addr;
  SSL_CTX* ctx;
  SSL*     ssl;
  X509*    server_cert;
  char*    str;
  int bits,stop,cli_len;
  char buf[BUFSIZ];
  struct hostent *H,*me;
  char myhostname[400];
  char popip[300];
WORD wVersionRequested;
WSADATA WSAdata;


	wVersionRequested = MAKEWORD( 1, 1 );
	err = WSAStartup( wVersionRequested, &WSAdata );
	if ( err != 0 ) {
		printf("Error on WSA startup");
 		return;
	}
	if ( LOBYTE( WSAdata.wVersion ) != 1 ||
  		HIBYTE( WSAdata.wVersion ) != 1 ) {
		printf("Winsock doesn't support this version");
 		WSACleanup( );
 		return; 
	}


if ( argc != 2 ) {
  printf("Usage: popssl spop3-host\n");
  exit(1);
}
  printf("\nUniversal POP3 SSL relay (supports ALL pop3 clients)\n");
  printf("Copyright 1998 Angelos Karageorgiou, All rights reserved\n");


  stop=0;
  SSL_load_error_strings();

  ctx=(SSL_CTX *)SSL_CTX_new();                      
 /*
  SSLeay_add_algorithms();
  SSL_CTX_set_options(ctx,SSL_OP_ALL);
  SSL_CTX_set_default_verify_paths(ctx);
 */ 
  
if (gethostname(myhostname, sizeof(myhostname)) < 0)
	myhostname[0] = '\0';

me=gethostbyname(myhostname);
if ( me == NULL ) 
	perror("gethostname");
 
  mysock= socket (AF_INET, SOCK_STREAM, 0);  
  memset (&my_addr, '\0', sizeof(my_addr));
  my_addr.sin_family      = AF_INET;
  /* my_addr.sin_addr.s_addr=*((unsigned long *) me->h_addr);  */
  my_addr.sin_addr.s_addr= inet_addr ("127.0.0.1");
  my_addr.sin_port        = htons     (110);          /* Server Port number */

 


  if (bind(mysock,(struct sockaddr *)&my_addr,sizeof(my_addr)) > 0 ){
	perror("Cannot bind to local address");
	exit(1);
  }

  listen(mysock,5);



   H=gethostbyname(argv[1]);
   if ( H == NULL) {
	printf("Hostname %s is bad\n\n",argv[1]);
	exit(1);
  }
sa.sin_addr.s_addr=*((unsigned long *) H->h_addr); 
printf ("Your SPOP3 server's IP is %s\n",inet_ntoa(sa.sin_addr));


while ( !stop ) {

  sd    = socket (AF_INET, SOCK_STREAM, 0);       
  memset (&sa, '\0', sizeof(sa));
  sa.sin_family      = AF_INET;
  sa.sin_addr.s_addr=*((unsigned long *) H->h_addr); 
  sa.sin_port        = htons     (995);


   cli_len=sizeof(cli_addr);
   newsockfd=accept(mysock, (struct sockaddr *) &cli_addr,&cli_len);

   if ( newsockfd < 0 ) 	
	perror("Server accept error");
  


  err = connect(sd, (struct sockaddr*) &sa, sizeof(sa));
 if ( err < 0 ) {
	printf("Cannot connect to server");
	exit(1);
 }
  
  ssl = SSL_new (ctx);                         
  SSL_set_fd (ssl, sd);
  err = SSL_connect (ssl);                   
    

  SSL_get_cipher_bits(ssl,&bits);
  printf ("SSL connection using %s %d bits\n", SSL_get_cipher (ssl),bits);
           
  /* ioctlsocket(sd,FIONBIO,&socketbooster);  */
 transfer(ssl, newsockfd ); 
             
  printf("End of transfer block communication\n\n\n");

  shutdown (sd, 1);  /* Half close, send EOF to server. */


  SSL_free (ssl);
  closesocket (sd);
  closesocket (newsockfd);
}
  SSL_CTX_free (ctx);
}


/*
   The transfer function was lifted from stunell
*/
void transfer(SSL *ssl, int tunnel) 
{
    fd_set rin,rout;
    char buffer[BUFSIZ];
    int num, fdno, fd_ssl, bytes_in=0, bytes_out=0,bs,bufsize;
    

/*
  ioctlsocket(tunnel,FIONBIO,&socketbooster); 
  ioctlsocket(sd,FIONBIO,&socketbooster); 
  ioctlsocket(newsockfd,FIONBIO,&socketbooster); 
*/


    fd_ssl=SSL_get_fd(ssl);
    FD_ZERO(&rin);
    FD_SET(fd_ssl, &rin);
    FD_SET(tunnel, &rin);
    fdno=(fd_ssl>tunnel ? fd_ssl : tunnel)+1;
    while(1)
    {
        rout=rin;
        if(select(fdno, &rout, NULL, NULL, NULL)<0)
            perror("select");

        if(FD_ISSET(tunnel, &rout))
        {
           /* num=read(tunnel, buffer, BUFSIZ); */
            num=recv(tunnel, buffer, BUFSIZ,0);  
            if(num<0) 
                perror("Read"); /* close connection */
            if(num==0)
                break; /* close */
            if(SSL_write(ssl, buffer, num)!=num)
                perror("SSL_write");
            bytes_out+=num;
        }
        if(FD_ISSET(fd_ssl, &rout))
    	{
        rout=rin;
        if(select(fdno, &rout, NULL, NULL, NULL)<0)
            perror("select");
        if(FD_ISSET(tunnel, &rout))
        {
            num=recv(tunnel, buffer, BUFSIZ,0);
		printf("Bytes read from local con %d\n",num);
            	if(num<0) 
			perror("receive");
            if(num==0) 
                break; /* close connection */
            
            if(SSL_write(ssl, buffer, num)!=num)
                perror("SSL_write");
            bytes_out+=num;
        }
        if(FD_ISSET(fd_ssl, &rout))
        {
            num=SSL_read(ssl, buffer, BUFSIZ);
            if(num<0)
                perror("SSL_read");
            if(num==0)
                break; /* close */
        /*    if(write(tunnel, buffer, num)!=num)  */
             bs=send(tunnel, buffer, num,0)  ;
		if ( bs != num ) 
               	 perror("write");
            bytes_in+=num;
        }
    }
}
}

