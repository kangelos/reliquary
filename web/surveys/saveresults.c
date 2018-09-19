/* 
	An attempt to have perl like functionality from within c code
	for WWW forms.

	September 1995 

	Angelos Karageorgiou, the voodooman
	real nitty gritty engine here folks 
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <time.h>

#define BUFSIZE 16000
#define MAX 1000

char *myenv[1000][2],tempelem[BUFSIZE];
char *elements[1024][2];
int noels;
char myinput[BUFSIZE];
char hexchar[5];
char temp[BUFSIZE];
char *tok,*eletok;
char *value;
char *convert(const char *buf);

/* #define EMAILS          "/usr/local/etc/yuordir/cgi-bin/dragon.emails"    */
#define HTDIR		"/home/unix/htdocs"
#define DATUMDIR	"/home/unix/htdocs/web/surveys"
#define SITE		"http://www.unix.gr"
#define SERVER		"www.unix.gr"
#define ENDSURV		"endsurv.htm"
#define ERRSURV		"err.htm"
#define REGERR          "register.htm"       
#define RECIPIENT	"angelos@unix.gr"
#define WEBMASTER	"angelos@unix.gr"
#define MESSAGE		"auto.message"
#define MAILER		"/usr/sbin/sendmail"
#define SENDER		"webmaster"
#define SUBJECT		"Survey results"
#define THANKYOU	"Thank you"

void thanks(void);
char *form(const char *what);
void blankform();
void htout(char *string);
void inithttp();
void dataout();
void mailout();
int mailback(const char *filename);
int findprev(char *email,char *file);
int findreg(char *email,char *file);
void badboy();
void check_register();
void bademail(const char *email);
void toomany();

char tempdatafile[1000];
char datumfile[1000],*basename;
char filename[1000];
char subject[1000];
int totals=0;
int maxreplies;
char buf[BUFSIZE];
int len;

/* all the work */
main( int argc , char *argv[], char *envp[])
{
int i,j,k;
FILE *out;
int hex;
char temp[1000],email[1000];
char *parts;

/* tzset(); */
inithttp(); 

if (argc<1){
	htout("<h1>No survey data file</h1>");
	exit(0);
}


/* now process the Command line parameters */
  strcpy(temp,argv[1]);

#ifdef DEBUG
	printf("temp is %s\n",temp);
#endif

  parts=strtok(temp,"\\;?|+-\n");
  strcpy(tempdatafile,parts);
  parts=strtok(NULL,"\\;?|+-\n");
if ( parts != NULL)
	maxreplies=atoi(parts);
else
	maxreplies=MAX;

#ifdef DEBUG
i=0;
while (envp[i] != NULL ) {
	 sprintf(buf,"<br>envp[%d] = %s",i,envp[i++]);
	htout(buf);
}
#endif

memset(buf,'\0',sizeof(buf));
if (gets(buf)==NULL)
	blankform();

len=strlen(buf);

#ifdef DEBUG 
printf("<br><br>And this is the input \"%s\"<br>",buf);
#endif


memset(myinput,'\0',sizeof(myinput));
/*
i=0;
j=0;
while ( (buf[i] != '\0') ) {
	if ( buf[i]=='%') {
	 memset(hexchar,'\0',sizeof(hexchar));
	 i++;
	 strcpy(hexchar,"0X");
	 hexchar[2]=buf[i];
	 i++;
	 hexchar[3]=buf[i];
	 hex=(int)strtol(hexchar,(char **) NULL,16); 

	 myinput[j]=hex;
	}
	else
		if (buf[i]=='+')
			myinput[j]=' ';
		else
			myinput[j]=buf[i];

	i++;
	j++;
}
*/
strcpy(myinput,buf);
#ifdef DEBUG 
htout("<br><br>And this is the input converted");
htout(myinput);
#endif
if (myinput[0]=='\0')
	blankform();
tok=strtok(myinput,"&");
noels=0;
if (tok!=NULL)
	while(tok!=NULL){
		strcpy(tempelem,tok);
		eletok=strchr(tempelem,'=');
#ifdef DEBUG
		printf("eletok is %s\n<br>",eletok);
#endif
		if (strcmp(eletok,"=")!=0){
			eletok++;
			elements[noels][1]=strdup(eletok);
			eletok--;

			*eletok='\0';
			elements[noels][0]=strdup(tempelem);
			noels++;
		}
		tok=strtok(NULL,"&");
	}
else
	blankform();

#ifdef DEBUG 
printf("<pre>\n-------------\n");
for (i=0; i<noels;i++){
	printf("%s = \"%s\" \n",elements[i][0],elements[i][1]);
}
printf("-------------\n</pre>\n");
#endif

/* this is where you check for necessary fields 
if ( (value=form("QT1"))==NULL)
	blankform();

if ( (value=form("QT1")) ==NULL ) 
	bademail("No Email");

strcpy(email,form("QT1"));
if  (
	 ( strstr(email,"@.") != NULL)  || 
	 ( strstr(email,"+") != NULL)  || 
	 ( strstr(email,"@") == NULL)  || 
	 ( strstr(email,".") == NULL)

    ) {
	bademail(form("QT1"));
}
 find if (s)he is in the dragon.emails 

if (findreg(form("QT1"),EMAILS)<=0)
        check_register();                        
*/

/* uncomment this for output to a datafile   
sprintf(filename,"%s.pos",tempdatafile); 
if (findprev(form("qt1"),filename) ) {
	 badboy();
}
*/


dataout();
/* mailout();  */
thanks();
}


void thanks(void)
{

char location[200];

printf( "\n\n\n\n\n\n\n\n\n<script>\n");
printf( "<!--\n");
printf( " function bye() {\n");
printf( "         window.close()\n");
printf( " }\n");
printf( "//-->\n");
printf( "</script>\n");
printf(" <body bgcolor=\"#FFFFFF\">\n");
/* printf( "Thank you <b>%s</b> for completing our survey, your information has been successfully submitted<p>\n",form("QT1"));
printf( "<form method=\"get\" >\n");
printf( "<center><input type=\"button\" onclick=\"bye()\" value=\"Click here to return to our Web site\"></center>\n");
printf( "</form>\n");
*/
printf( "Σας ευχαριστουμε <b>%s</b> που λαβατε μερος οι πληροφοριες που μας δωσατε εχουν αποθηκευτει<p>\n",form("QT1"));
printf( "<p>Thank you <b>%s</b> for taking this survey. Your info has been saved<p>\n",form("QT1"));
printf( "<form method=\"get\" >\n");
printf( "<center><input type=\"button\" onclick=\"bye()\" value=\"Επιστροφή / return\"></center>\n");
printf( "</form>\n");
}


char *form(const char *what)
{
int i;
for (i=0;i<noels;i++)
	if ( (strcasecmp(elements[i][0],what)==0)){
/*
	  printf("found %s at %d > %s\n",what,i,elements[i][0]);
*/
	  if  ( strlen(elements[i][1]) >0)
		return(convert(elements[i][1]));
	}
return NULL;
}


void blankform()
{
 printf( "Some of your entries appear to be blank, and thus were not sent ");
 printf( "to our webmasters.  Please re-enter your entries, or ");
 printf( "return to our <A HREF=\"%s\">home page</A>, if you want.<P>",SITE);

    exit(2);

}


void htout(char *string)
{
FILE *out;
/*
out=fopen("ctest.out","a+");
if (out==NULL){
	perror("ctest.out");
	exit(1);
}
*/
	printf("%s\n\n",string);
/*
	fprintf(out,"%s\n\n",string);
fclose(out);
*/
}


void inithttp()
{
int i;
	printf("Content-type: text/html\r\n\r\n\r\n\r\n\r\n");
}

void dataout()
{
FILE *out;
int i;
char *temp;
time_t mytime;
char filename[1000];


sprintf(filename,"%s.pos",tempdatafile); 

#ifdef DEBUG
	printf ("<br>filename is %s<br>\n",filename);
#endif

time(&mytime);
out=fopen(filename,"a");
if (out ==NULL) {
	printf("<H1> Your response could not be saved , please email <b>%s</b> </H1>\n",RECIPIENT);
	exit(0);
}


fprintf(out,"%s\n",buf);
fclose(out);
}


void mailout()
{
FILE *out;
int i;
char *temp;
time_t mytime;
int io[2],pid;
char command[300];


time(&mytime);
sprintf(command,"%s %s",MAILER,RECIPIENT);
out=popen(command,"w");
if (out ==NULL) {
	printf("<H1> Your data cannot be mailed , please email <b>%s</b> </H1>\n",RECIPIENT);
	exit(0);
}
fprintf(out,"Return-Path: %s \n",form("qt1"));
fprintf(out,"From: %s\n",form("qt1"));
fprintf(out,"To: %s\n",RECIPIENT);
fprintf(out,"Reply-To: %s \n",form("qt1"));
sprintf(subject,"%s",SUBJECT);
fprintf(out,"Subject: %s %s\n",subject,SERVER);
fprintf(out,"%s\n===========================================================\n",
		ctime(&mytime));
temp=getenv("REMOTE_ADDR");
fprintf(out,"User's IP address     :%s\n",temp);
temp=getenv("REMOTE_HOST");
if ( temp != NULL ){
	fprintf(out,"User's FQDN           :%s\n",temp);
}
temp=getenv("HTTP_USER_AGENT");
fprintf(out,"User's Browser Program:%s\n",temp);
fprintf(out,"------ DATA FIELDS ----------\n");
for (i=0;i<noels;i++){
fprintf(out,"%s = ",elements[i][0]);
fprintf(out,"%s\n",form(elements[i][0]));
}
pclose(out);
}

int mailback(const char *filename)
{
FILE *out,*in;
int i;
char *temp;
time_t mytime;
int io[2],pid;
char command[300],buff[10000];
char file[200];

sprintf(file,"%s/messages/email/%s",HTDIR,filename);


time(&mytime);
in=fopen(file,"r");
if (in ==NULL) {
	return(0);
}
sprintf(command,"%s -f%s %s",MAILER,WEBMASTER,form("qt1"));
out=popen(command,"a");
if (out ==NULL) {
        printf("<H1> I cannot reply to you  , please email <b>%s</b> </H1>\n",WEBMASTER);
        exit(0);
}
fprintf(out,"Return-Path: %s\n",WEBMASTER);
fprintf(out,"From: %s\n",WEBMASTER);
fprintf(out,"To: %s\n",form("qt1"));
fprintf(out,"Reply-To: %s\n",WEBMASTER);
fprintf(out,"Subject: %s\n",THANKYOU);

	while ( !feof(in) ) {
		temp=fgets(buff,sizeof(buf)-1,in );
		if ( temp != NULL ) 
			fprintf(out,"%s",buff);
	}
pclose(out);
fclose(in);
}

int findreg(char *email,char *file)
{
FILE *data;
char buff[1000];
char *loc;
int previous;

data=fopen(file,"r");
if ( data == NULL ) { return(-1); }

previous=-1;
while ( ! feof(data) ) {
        fgets(buff,sizeof(buff)-1,data);
        if ( strstr(buff,email) != NULL ){
                previous=1;
                break;
        }
}

fclose(data);
return(previous);
}                                      


int findprev(char *email,char *file)
{
FILE *data;
char buff[1024];
char *loc;
int previous;

if ( access(file,R_OK|W_OK)!=0 ){
	/* printf("<h2> Data file does not exist or not writable %s </h2>\n",file); */
	return(-1); /* well if does not exist we will create it */
}

data=fopen(file,"r");
if ( data == NULL ) { /* i.e. file exists */
	printf("<h2> Cannot Read Data file  %s </h2>\n",file); 
	return(-1);
}

previous=-1;
while ( ! feof(data) ) {
	fgets(buff,sizeof(buff)-1,data);
	if ( ( previous == -1 ) && ( strstr(buff,email) != NULL )){
		previous=1;
		break;
	}

#ifdef DEBUG
	printf ("looking for %s in %s<br>\n",email,buff);
#endif
	if (strncasecmp(buff,"QT1=",4)==0) 
		totals++;

}

fclose(data);
return(previous);
}

void bademail(const char *email)
{
inithttp();
printf("\n\n\n\n\n<h2> I am sorry but the e-mail address you provided is <b>invalid</b> </h2><br>\n");
 printf( "If you wish you can return to the <A HREF=\"%s\">survey page</A><P>\n",getenv("HTTP_REFERER"));
printf("");
exit(2);
}

void check_register()
{
        printf("Status: 302 Moved Temporarily\r\n");
        printf("Location: /error/%s\r\n",REGERR);
        printf("This page has moved <a href=\"/error/%s\">here</a>\r\n\r\n",REGERR);
        exit(2);             
}


void badboy()
{

printf (" You have already taken this survey dude\n");
 printf("Status: 302 Moved Temporarily\r\n");
 printf("Location: /error/%s\r\n",ERRSURV);
 printf("This page has moved <a href=\"/error/%s\">here</a>\r\n\r\n",ERRSURV);   
exit(2);
}

void toomany()
{
inithttp();
printf("\n\n\n\n\n\n<h2> I am sorry but this survey is closed </h2><br>\n");
 printf( "If you wish you can return to our <A HREF=\"%s\">home page</A><P>\n",SITE);
exit(2);
}


char *convert(const char *buf)
{
int i,j;
int hex;

i=0;
memset(myinput,'\0',sizeof(myinput));
j=0;
while ( (buf[i] != '\0') ) {
   switch(buf[i]) {
        case '%':
                        memset(hexchar,'\0',sizeof(hexchar));
                        i++;
                        strcpy(hexchar,"0X");
                        hexchar[2]=buf[i];
                        i++;
                        hexchar[3]=buf[i];
                        hex=(int)strtol(hexchar,(char **) NULL,16);

                switch(hex){
                        case '\r':
                                j--;
                                break;
                        case '\n':
                                myinput[j]=',';
                                break;
                        default:
                                myinput[j]=hex;
                                break;
                }
                break;
        case '+':
                        myinput[j]=' ';
                        break;
        default:
                        myinput[j]=buf[i];
                        break;
   }
i++;
j++;
}
#ifdef DEBUG
htout("<br><br>And this is the input converted");
htout(myinput);
#endif
return myinput;
}

