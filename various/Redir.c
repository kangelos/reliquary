#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <regex.h>



#undef DEBUG 
#define MAXPATTERNS 1024
#define ABUFSIZE 10240


/*
 A generic SQUID redirector written in
 C Angelos Karageorgiou Jan 2005 ankar@hol.net angelos at unix.gr


	redir.conf should reside in /etc/squid
	and contain pattern <tab> replacement
*/


/* put the below in main for some magic */
char pattern[ABUFSIZE],replacement[ABUFSIZE];
char patterns[MAXPATTERNS][ABUFSIZE],replacements[MAXPATTERNS][ABUFSIZE];
char newstring[ABUFSIZE];

/**********************************************************************/
int readpats(){
FILE *conf;
int i=0,numps=0;
char buff[ABUFSIZE];

	conf=fopen("/etc/squid/redir.conf","r");
	if ( conf == NULL){
		fprintf(stderr,"No conf file");
		return(-1);
	}


	while (fgets(buff,ABUFSIZE,conf)!=NULL ) {
		buff[strlen(buff)]='\0';
		if (buff[0] == '#' ) {
			continue;
		}
		sscanf(buff,"%s %s",pattern,replacement);
		strncpy(patterns[i],pattern,ABUFSIZE-1);
		strncpy(replacements[i],replacement,ABUFSIZE-1);
		i++;
	}	

	fclose(conf);
	numps=i-1;
	return(numps);
}

/**********************************************************************/
int main(int argc,char **argv){
int i=0,numps=0;
regex_t regex;
regmatch_t matches[MAXPATTERNS];
char *currindex;
FILE *log;
char buff[ABUFSIZE];


	while (fgets(buff,ABUFSIZE,stdin)!=NULL ) { /* read from squid */
		buff[strlen(buff)-1]='\0';
		numps=readpats();	/* every time bub */
		if (numps<0 ) {	/* an error has occured */
			fprintf(stdout,"%s\n",buff);
			fflush(stdout);
			continue;
		}
		strncpy(newstring,buff,ABUFSIZE-1);
		for (i=0;i<numps;i++) {
			regcomp(&regex,patterns[i],REG_ICASE|REG_EXTENDED);
			int result=regexec(&regex,buff, MAXPATTERNS, matches, 0);
			if ( result != REG_NOMATCH ) {
				/* replace the string */
				int j=0;
				currindex=buff;
				bzero(newstring,ABUFSIZE);
				while ( (matches[j].rm_so !=-1) && (matches[j].rm_eo !=-1) ) {
					strncat(newstring,currindex,matches[j].rm_so);
					strncat(newstring,replacements[i],strlen(replacements[i]));
					currindex+=matches[j].rm_eo;
					j++;
				}
				strncat(newstring,currindex,strlen(currindex)); /*the rest of the string */
				i=numps; /* soft break */
			}
			regfree(&regex);
		}
	fprintf(stdout,"%s\n",newstring);
	fflush(stdout);
	}	

}
