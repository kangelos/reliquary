#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <setjmp.h>
#include <signal.h>
#include <mysql/mysql.h>
#include <syslog.h>
#include <unistd.h>
#include <sys/types.h>

// #define DEBUG 1

/*
	ankar magic
	Black and White list processing for Qmail
	the actual program to be executed is 
	/usr/bin/procmail -m HOME=$HOME PARM=$PARM /export/home/procmailrcs/GlobalFilter
	where $PARM is a string of ssss equal to the antispam level of the user

	The procmail filter matches 
		X--Hol-blacklist: yes 
		or
		X--Hol-whitelist: yes
	and sends incoming email directly into the new or .sparm maildirs
	otherwise it Greps
	^X--Mailscanner: ssss
	which is the mailscanner score in the emails header 
#=============================cut here for GlobalFilter.quota==========================================

# set variables
LINEBUF=131072
ARG=$1
SHELL=/bin/sh
PATH=/bin:/usr/sbin/:/usr/bin:/usr/local/bin:/usr/bin/mh:/usr/lib/mh:
VERBOSE=off
MAILDIR=$HOME/Maildir/
JUNKMAILDIR=$HOME/Maildir/.JunkMail/
#LOGFILE=/tmp/quota.procmail.log
LOGFILE=/dev/null
FORMAIL=/usr/bin/formail
SENDMAIL=/usr/sbin/sendmail
TOGREP="^X--MailScanner-SpamScore: "

# Whitelist
:0 w
* ^X--Hol-whitelist:.yes
|deliverquota -c -w 90 $MAILDIR $MAILDIRQUOTA

# blacklist
:0 E w
* ^X--Hol-blacklist:.yes
|deliverquota -c -w 90 $JUNKMAILDIR $MAILDIRQUOTA

######## Spam Filter
:0 E w
*  H ?? ? grep "$TOGREP$PARM"
|deliverquota -c -w 90 $JUNKMAILDIR $MAILDIRQUOTA


:0 E w
|deliverquota -c -w 90 $MAILDIR $MAILDIRQUOTA


######## End of spam report process
#---------------------------------------------------------
:0 e w
{

	  EXITCODE="77"  

	:0
	/dev/null
}
#---------------------------------------------------------
#===================================cut here===========================================
*/


/***********************************************************************/
#define TIMEOUT		9	/* server can be slow sometimes this is just here to avoid hanging processes */
#define BLACKYES	"X--Hol-blacklist: yes"
#define WHITEYES	"X--Hol-whitelist: yes"

#define PROG		"/usr/bin/procmail"
#define FILTER		"/export/home/procmailrcs/GlobalFilter.quota"
#define CHECKFILE	"/export/home/procmailrcs/MYSQL.OK"

#define MYSERVER	"SERVER"	/* same host must be in CheckMy */
#define MYUSER		"mail"
#define MYPASS		"pass"
#define MYPORT		3306
#define MYDB		"ERP"

#define QUERY		"SELECT type \
				from  \
					rmail_spamlists  \
				where  \
						uid=%d \
					and  \
						( \
							LOWER(originator)=LOWER('%s') \
						or \
							LOWER(originator)=LOWER('%s') \
						) \
				order by \
					weight asc  \
				limit 1"

#define	MAXLIST		100
#define	MAXLISTEL	2048	/* big email addresses :-) */
#define	MAXLINE		10240

#define	QMAILSOFTERR	111
#define	QMAILHARDERR	100
#define QMAILOK		99

#define BLACK		5
#define WHITE		10
#define UNKNOWN		15
/***********************************************************************/



/***********************************************************************/
void makeparms(int argc ,char **argv,char *command);
int domysql(const char *from,const char *fromdom);
inline void getfromdom(const char *line, char *from,char *fromdom);
int checkstatus(void);

/* globals */
static jmp_buf  env_alrm;		/* for alarms */
static int MYSQLOK=1;
/***********************************************************************/


void catch_alarm (int sig) { siglongjmp(env_alrm, 1); }


/*======================================================================*/
int main (int argc ,char **argv){
char command[MAXLISTEL],line[MAXLINE];
char email[MAXLISTEL];
char from[MAXLISTEL];		/* from address */	
char fromdom[MAXLISTEL];	/* from domain part*/
int linesize=MAXLINE-1;
FILE *OUT;
int i;
	

//	openlog("BWQuotaSpamFilter",LOG_NDELAY|LOG_PID,LOG_MAIL);
	openlog("BWQSF",LOG_NDELAY|LOG_PID,LOG_MAIL);
	makeparms(argc,argv,command); /* I will need this later */
	checkstatus();

	strncpy(email,getenv("RECIPIENT"),MAXLISTEL);	

	signal (SIGALRM, catch_alarm);	/* set up the alarm functions */
	alarm(0);

  	int caughtALRM=0;

	/* pipe if you can */
	if ( (OUT=popen(command,"w"))==NULL) {
		syslog(LOG_ERR,"Cannot open Pipe to %s",command );
		closelog();
		exit(QMAILSOFTERR);
	}

	putenv("LINEBUF=131072");
	
	/* read the input pipe it to the procmail filter */
	/* retrieve the from field, not option for locale encoded stuff */
	int foundfrom=0;
	while ( fgets(line, linesize, stdin)!=NULL) {
	    fputs(line,OUT); 	/* procmail gets everything */

	    /* only process while in header */
	    if ( ! foundfrom )
		if ( strncmp(line,"From: ",6) == 0 ) {
			foundfrom=1; /* in any case */
#ifdef DEBUG
			syslog(LOG_INFO,"Found From = \'%s\'",line);	/* if debug */
#endif
			getfromdom(line,from,fromdom);		
#ifdef DEBUG
			syslog(LOG_INFO,"Message to %s from %s",email,from);	/* if debug */
#endif
			/* timeout checking */
			caughtALRM=sigsetjmp(env_alrm,1);
  			if (caughtALRM==1) {
       				syslog(LOG_CRIT,"[ALARM] MYSQL Server timeout no BW processing");
				alarm(0);
				continue;
			}
			alarm(TIMEOUT);
			int color=UNKNOWN;
			color=domysql(from,fromdom);   /* all the work is in this function */
			alarm(0);

			switch(color) {
				case WHITE:
					syslog(LOG_WARNING,"Originator %-30s in   white list of %s",from,email); 
					fprintf(OUT,"%s\n",WHITEYES); 
					break;
				case BLACK:
					syslog(LOG_WARNING,"Originator %-30s in   black list of %s",from,email);
					fprintf(OUT,"%s\n",BLACKYES); 
					break;
				default:	
					syslog(LOG_INFO,   "Originator %-30s in neither list of %s",from,email);
					break;
			}
		} /* From */
	 }/* fgets */
fclose(stdin);


int ret=pclose(OUT);
if ( ret != 0 ) {
        syslog(LOG_ERR,"Delivery failed error %d",ret/256);
} else {
        ret=QMAILOK;
}

closelog();
return(ret);	/* qmail success */
}
/*======================================================================*/



/***********************************************************************/
int domysql(const char *from,const char *fromdom){
MYSQL DB;
MYSQL_ROW row;
MYSQL_RES *res;
char query[MAXLISTEL];
int i,result=UNKNOWN;


	if (MYSQLOK==0) {	/* was reported bad */
		return(1);
	}

	sprintf(query,QUERY,(long)getuid(),from,fromdom); /* qmail must have our uid set up already */
#ifdef DEBUG
        syslog(LOG_INFO,"query=%s",query);	/* if debug */
#endif

	mysql_init(&DB);	/* a must */
	mysql_real_connect(&DB, MYSERVER,MYUSER,MYPASS,MYDB,MYPORT,NULL,0); 
	if ( &DB == NULL ) {
		syslog(LOG_ERR,"Mysql Connect Failed %s", mysql_error(&DB));
		return(-1); 	/* error */
	}

   mysql_query(&DB, query);
   res = mysql_store_result(&DB);
   if ( res == NULL) {
    	mysql_close(&DB);
   	syslog(LOG_ERR,"Mysql query Failed %s", mysql_error(&DB));
   	return(-1);	/* error */
   }

    if ( ! (row = mysql_fetch_row(res)) ) {
#ifdef DEBUG
       syslog(LOG_INFO,"Mysql no data");	/* if debug */
#endif
       mysql_free_result(res);
       mysql_close(&DB);
      return(0);	/* not an error , just no data */
    }


    int mytype=row[0]?atoi(row[0]):UNKNOWN;	/* thanks cakrit */
    mysql_free_result(res);
    mysql_close(&DB);

	switch(mytype){
		case 0:
			result=BLACK;
			break;
		case 1:
			result=WHITE;
			break;
		default:
			result=UNKNOWN;
			break;
	}

return(result);
}
/***********************************************************************/






/***********************************************************************/
void makeparms(int argc ,char **argv, char *command){
register int i;
char prog[]=PROG;
char m[]="-m";
char HOME[MAXLISTEL];
char PARM[MAXLISTEL];
char MQUOTA[MAXLISTEL];
char filter[]=FILTER;
char *newargv[MAXLIST];	/* pointers to above for old execvp usage*/
char newparams[MAXLIST][MAXLISTEL];	/* parameter list for procmail */


#ifdef DEBUG
	syslog(LOG_INFO,"MakeArgs Param %s",argv[1]);
#endif

	strncpy(HOME,"HOME=",MAXLISTEL);
	strncat(HOME,getenv("HOME"),MAXLISTEL-5);	
	if ( argc > 1 ) {
		strncpy(PARM,"PARM=",MAXLISTEL);
		for (i=1;i<=atoi(argv[1]);i++) strcat(PARM,"s"); 
	}

	i=0; /* for local storage */
	strncpy(newparams[i++],prog,MAXLISTEL);
	strncpy(newparams[i++],m,MAXLISTEL);
	strncpy(newparams[i++],HOME,MAXLISTEL);
	if ( argc > 1 )  strncpy(newparams[i++],PARM,MAXLISTEL); 
	if ( getenv("MAILDIRQUOTA") ) {
		strncpy(MQUOTA,"MAILDIRQUOTA=",MAXLISTEL);
		strncat(MQUOTA, getenv("MAILDIRQUOTA"),MAXLISTEL );
		strncpy(newparams[i++],MQUOTA,MAXLISTEL);
	}
	strncpy(newparams[i++],filter,MAXLISTEL);
	strncpy(newparams[i++],"2> /dev/null",MAXLISTEL); /* we cannot read the output any way */
	newparams[i][0]='\0';
	
	/* initialize the new **argv array */ /* not needed any more */
	for (i=0; newparams[i][0] != '\0' ;i++) 
		newargv[i]=(char *) newparams[i];	
	
	newargv[i]=(char *) NULL;
	

	/* make the popen command */
	i=1;
	strncpy(command,PROG,MAXLISTEL);
	for (i=1; newargv[i] != NULL ; i++)  {
		strcat(command," ");
		strcat(command,newargv[i]);
	}
#ifdef DEBUG
	syslog(LOG_INFO,"command=%s",command);	/* if debug */
#endif
}

/***********************************************************************/





/***********************************************************************/
void getfromdom(const char *line, char *from ,char *fromdom){	/* scan from field for b&w list */
char *wheretofindemail;
char *wheretofinddomain;

        bzero(from,MAXLISTEL);
	bzero(fromdom,MAXLISTEL);
        /* locate the originator mail */
        wheretofindemail=strstr(line,"<");

	if (wheretofindemail!=NULL) {
        	wheretofindemail++;
        	/* copy it over */
               	strncpy(from,wheretofindemail,MAXLISTEL);
        	wheretofindemail=strstr(from,">");
        	/* terminate nicely */
        	*wheretofindemail='\0';
#ifdef DEBUG
		syslog(LOG_INFO,"from is <%s>",from);
#endif
	} else { /* From address not in <> */ 
		wheretofindemail=(char *)line;
		wheretofindemail+=6;
               	strncpy(from,wheretofindemail,MAXLISTEL);
		from[strlen(from)-1]='\0';
#ifdef DEBUG
		syslog(LOG_INFO,"from is %s",from);
#endif
	}
                  
	/* now locate the domain */                                                                                            
	wheretofinddomain=strchr(from,'@');
	wheretofinddomain++;
	strncpy(fromdom,wheretofinddomain,MAXLISTEL);
}
/***********************************************************************/





/***********************************************************************/
int checkstatus(void){
struct stat check;
extern char **environ;
char **myenv;
int i;

	myenv=environ;

#ifdef DEBUG
	for ( i=0;  myenv[i] != NULL;i++ ) { 
		syslog(LOG_INFO,"ENV %s",myenv[i]); 
	}
#endif

	if (!getenv("RECIPIENT")) {
		syslog(LOG_CRIT,"No RECIPIENT in $ENV, exiting");
		closelog();
		exit(QMAILHARDERR);
	}
	if (strlen(getenv("RECIPIENT")) <1 ) {
		syslog(LOG_CRIT,"RECIPIENT too small in $ENV, exiting %s",getenv("RECIPIENT"));
		closelog();
	        exit(QMAILHARDERR);
	}
	/*	oooh sometimes it does not exist
	if (!getenv("SENDER")) {
		syslog(LOG_CRIT,"No SENDER in $ENV, exiting");
		closelog();
		exit(QMAILHARDERR);
	}
	if (strlen(getenv("SENDER")) <1 ) {
		syslog(LOG_CRIT,"SENDER too small in $ENV, exiting %s",getenv("SENDER"));
		closelog();
	        exit(QMAILHARDERR);
	}
	*/

#ifdef DEBUG
	if (  getenv("MAILDIRQUOTA") ) {
		syslog(LOG_INFO,"User Quota %s",getenv("MAILDIRQUOTA"));
	}
#endif
	if (getenv("HOME")==NULL) {
		syslog(LOG_CRIT,"No HOME in $ENV, exiting");
		closelog();
		exit(QMAILHARDERR);
	}
	/* check the file that reports mysql status */
	if ( stat(CHECKFILE,&check) == -1 ) {
		syslog(LOG_ERR,"Mysql is Reported down by %s, no BWlist processing",CHECKFILE);
		MYSQLOK=0;	
	}


}
/***********************************************************************/

