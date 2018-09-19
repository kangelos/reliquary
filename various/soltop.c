/*      
        Process CPU usage monitoring Tool , for Solaris boxes
                        Quick hack by the voodooman

        This software is released to the public domain under the GNU copyleft
        use it , but do not expect any supoort or liability from me.
        
        You can distribute it and use it but you have to abide to the 
        GNU copyright.


        Angelos Karageorgiou Summer 1995


DISCLAIMER:
        I have tried to make this program as accurate as possible ,if you
        feel that its reports are erroneous please advise me as to the
        extent of it.



        Solaris 2.3-4... specific, probably broader support but I don't know.

Usage: top [-t] [+m]
        -t: do not look for controlling TTY ( speeds it up )
        +m: sort by memory size
*/




#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <errno.h>
#include <pwd.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/signal.h>
#include <sys/fault.h>
#include <sys/syscall.h>
#include <sys/procfs.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <time.h>
#include <math.h>
#include <dirent.h>

#define SLEEP 3
#define DEVSIZE 15
#define ARGSIZE 31
#define NUMPROCS 256    /* well increase it for a larger system */
#define PROCFS "/proc"

int findproc(int id);
void finddev( char **buf,dev_t devnum);
int cfindproc(const char *prcname);
int findloc(void);
void clearproc(int id);
void qrproc(int id);
void purge(void);
void cfree(char *pointer);
void printtable(int elements);
void loadavg(void);

struct stat tempstat;
int findtty,bymem;

struct passwd *temppwd;
char tabs[5];

struct mstat {
        int     pid;
        int     ppid;
        char    *owner;
        char    *procfname; /* filename in procfs */
        char    *name;          /* command line */
        char    *args;          /* command line args */
        double  secs;
        double  oldsecs;
        double  percent;
        double  oldsystime;
        double  systime;
        int     size;
        int     active;
        int     existing;
        char    *tty;
};

struct prpsinfo piocstat;

struct mstat status[NUMPROCS];
struct mstat sortedstatus[NUMPROCS];
struct dirent *thisdev;
int proccomp(const struct mstat *first, const struct mstat *second);
int memcomp(const struct mstat *first, const struct mstat *second);

char hostname[32];




main(int argc, char *argv[])
{
struct timeval ltime;
double ftemp;
DIR *prcfs;
struct dirent *process;
int i,numprocs,temp;
int fproc;
char tempname[100];
struct prpsinfo temppiocstat;
int loc;
int firsttime,elements;
int oldtime,time;
char *tempargs;
FILE *p;
int len;


p=popen("/usr/ucb/hostname","r");
if ( p==NULL)
        strcpy(hostname,"\t");
else {
        fgets(hostname,sizeof(hostname)-1,p);
        len=strlen(hostname);
        hostname[len-1]='\0';
        pclose(p);
}

findtty=1;
bymem=0;
for ( i=1; i<argc; i++){
        if ((strcmp(argv[i],"-t"))==0)
                findtty=0;
        if ((strcmp(argv[i],"+m"))==0)
                bymem=1;
}
oldtime=time=0;
printf(" [H [J"); 
for (i=0; i<NUMPROCS;i++){
        status[i].pid=-1;
        sortedstatus[i].pid=-1;
        sortedstatus[i].existing=-1;
}

while(1)
{

for (i=0; i<NUMPROCS;i++)
        status[i].existing=-1;

i=0;
if( (prcfs=opendir(PROCFS))==NULL){
        perror(PROCFS);
        exit(1);
}

while( (process=readdir(prcfs))!=NULL){

if ( (strcmp(process->d_name,".")==0) || (strcmp(process->d_name,"..")==0))
        continue;

        firsttime=0;
        loc=cfindproc(process->d_name);

        if ( loc < 0 ){
                loc=findloc();
                status[loc].procfname=strdup(process->d_name); /* first timer */
                firsttime=1;
        }
        status[loc].existing=1; /* and it is a good one */

        strcpy(tempname,"/proc/");
        strcat(tempname,status[loc].procfname);

        if ( (fproc=open(tempname,O_RDONLY))<0){ /* open the process file */
                qrproc(loc);            /* remove process */
                continue;               /* next please */
        }
        if ( (temp=fstat(fproc,&tempstat))<0 ){ /* stat the file */
                qrproc(loc);            /* remove process */
                close(fproc);
                continue;
        }
        if ((temppwd=getpwuid(tempstat.st_uid))==NULL){ /* get the owner */
                qrproc(loc);            /* remove process */
                close(fproc);
                continue;
        }
        if (firsttime)
                status[loc].owner=strdup(temppwd->pw_name);
        ioctl(fproc,PIOCPSINFO,&temppiocstat); /* i hope this works */
        close(fproc); /* all clear */

        if (firsttime){
                status[loc].pid=temppiocstat.pr_pid;
                status[loc].ppid=temppiocstat.pr_ppid;
                status[loc].name=strdup(temppiocstat.pr_fname);

           if (temppiocstat.pr_argc>1){
                tempargs=temppiocstat.pr_psargs;
                while ( ( *tempargs != ' ' ) && (tempargs != NULL) ){
                        tempargs++;
                }
                if ( ( *tempargs==' ') && (tempargs != NULL) )
                        tempargs++; /* skip the space */
                        /* I did not want a full pathname */
                status[loc].args=strdup(tempargs);
           }

        
                status[loc].size=(int)(temppiocstat.pr_bysize)/1024.0;
        }

        memset(&ltime,'\0',sizeof(struct timeval));
        gettimeofday(&ltime);
        ftemp=ltime.tv_usec/1e6;

        status[loc].oldsecs=status[loc].secs;
        status[loc].oldsystime=status[loc].systime;

        status[loc].secs=(double)temppiocstat.pr_time.tv_sec+
                (double)temppiocstat.pr_time.tv_nsec/1e9;
        status[loc].systime=(double)ltime.tv_sec;
        status[loc].systime += ftemp;
        status[loc].systime += ftemp;

        if ( (findtty==1) && (status[loc].tty==NULL) )
                finddev(&status[loc].tty,temppiocstat.pr_lttydev);

        status[loc].percent=((status[loc].secs-status[loc].oldsecs)/
                (status[loc].systime-status[loc].oldsystime))*100.0;

        if ( firsttime) {
                status[loc].oldsecs=status[loc].secs;
                status[loc].oldsystime=status[loc].systime;
                status[loc].percent=00.0;       /* new process */
        }       
}
closedir(prcfs);        /* all read */
purge();
elements=copyover();
if ( ! bymem )
        qsort(sortedstatus,elements,sizeof(struct mstat),proccomp);
else
        qsort(sortedstatus,elements,sizeof(struct mstat),memcomp);
printtable(elements);
sleep(SLEEP);
} 
} /* end main */




int findproc(int id)
{
int i;
int found=-1;

for (i=0; i<NUMPROCS; i++)
        if ( status[i].pid==id ){
                found=i;
                break;
        } return found;
}



int cfindproc(const char *prcname)
{
int i;

i=atoi(prcname);
return findproc(i);
}



void clearproc(int id)
{
int loc;

        loc=findproc(id);
        if (loc <0 ){
                printf(" BUG BUG BUG process disappeared \n");
        }
        else
        {
                status[loc].pid = -1;
                status[loc].ppid = -1;
                status[loc].existing = -1;
                cfree(status[loc].name );
                cfree(status[loc].procfname );
                cfree(status[loc].owner );
                cfree(status[loc].args );
                cfree(status[loc].tty );
        }
}


int findloc(void)
{
int i,loc;
for (i=0;i<NUMPROCS;i++){
        if (status[i].pid == -1 ) {
                loc=i;
                break;
        }
} return loc;
}


void qrproc(int loc)
{
        cfree(status[loc].procfname);   /* remove process */
        status[loc].existing=0;
}

void purge(void)
{
int loc;

for (loc=0;loc<NUMPROCS;loc++){
        if (status[loc].existing <= 0){
                status[loc].pid = -1;
                status[loc].ppid = -1;
                status[loc].existing = -1;
                free(status[loc].name );
                free(status[loc].procfname );
                free(status[loc].owner );
                free(status[loc].args );
                free(status[loc].tty );
                 
        }
        sortedstatus[loc].pid = -1;     /* since we are going through */
        sortedstatus[loc].ppid = -1;
        sortedstatus[loc].existing = -1;
}
}



void cfree( char *point)
{
        if ( point != NULL )
                free(point);
}



int copyover()
{
int i,j;

j=0;
for(i=0; i<NUMPROCS; i++){
        if (status[i].existing > 0){
                memcpy(&sortedstatus[j],&status[i],sizeof(struct mstat));
        j++;
        }
}

return j;
}

void printtable(int elements)
{
int loc,number;
char buffer[181];
int diff,len,i;

printf(" [H"); 
loadavg();
if (findtty)
        printf("%-9s%6s%6s %-8s %6s  %5s %s\n","OWNER","PID","PPID","TTY","SIZE","CPU %","PROCESS NAME");
else
        printf("%-9s%6s%6s %6s  %5s %s\n","OWNER","PID","PPID","SIZE","CPU %","PROCESS NAME");
number=0;
for (loc=elements-1;( loc>=0 && number <21 ); loc--){
        number++;
if ( findtty){
        sprintf(buffer,"%-9s%6ld%6ld %-8s%6dk %5.2f %s %s",
                        sortedstatus[loc].owner,
                        sortedstatus[loc].pid,
                        sortedstatus[loc].ppid,
                        sortedstatus[loc].tty,
                        sortedstatus[loc].size,
                        sortedstatus[loc].percent,
                        sortedstatus[loc].name,
                        (sortedstatus[loc].args==NULL ? "   " : sortedstatus[loc].args));
        len=strlen(buffer);
        for (i=0;i<(79-len);i++)
                strcat(buffer," ");
        buffer[79]='\0';
        puts(buffer);
}
else{
        sprintf(buffer,"%-9s%6ld%6ld %6dk %5.2f %s %s",
                        sortedstatus[loc].owner,
                        sortedstatus[loc].pid,
                        sortedstatus[loc].ppid,
                        sortedstatus[loc].size,
                        sortedstatus[loc].percent,
                        sortedstatus[loc].name,
                        (sortedstatus[loc].args==NULL ? "   " : sortedstatus[loc].args));
        len=strlen(buffer);
        for (i=0;i<(79-len);i++)
                strcat(buffer," ");
        buffer[79]='\0';
        puts(buffer);

}
/*
                        sortedstatus[loc].name, 
                        sortedstatus[loc].secs-sortedstatus[loc].oldsecs,
                        sortedstatus[loc].systime-sortedstatus[loc].oldsystime,
*/
        }
}

int proccomp(const struct mstat *first, const struct mstat *second)
{
        if (first->percent > second->percent)
                return 1;

        if (first->percent<second->percent)
                return -1;
return 0;

}

int memcomp(const struct mstat *first, const struct mstat *second)
{
        if (first->size > second->size)
                return 1;

        if (first->size<second->size)
                return -1;
return 0;

}

void finddev( char **buf,dev_t devnum)
{
DIR *devdir;
struct dirent *ddev;
struct stat statbuf;
char fname[80];

/* only check console and /dev/pts/* */

stat("/dev/console",&statbuf);
if (statbuf.st_rdev==devnum ) {
        *buf=strdup("console"); 
        return;
}

if( (devdir=opendir("/dev/pts/"))==NULL){
        perror("/dev/pts");
        exit(1);
}
while( (ddev=readdir(devdir))!=NULL){
        sprintf(fname,"/dev/pts/%s",ddev->d_name);
        if (stat(fname,&statbuf)<0)
                continue;
        if (S_ISCHR(statbuf.st_mode))
        if (statbuf.st_rdev==devnum ) {
                *buf=strdup(fname+5);   
                closedir(devdir);
                return;
        }
}
closedir(devdir);
*buf=strdup("?");
}




/*
 * get loadaverage thru kstat
 *
 * Casper Dik
 */
#include <sys/param.h>
#include <kstat.h>
#include <string.h>
#include <stdio.h>

void loadavg(void)
{
        int i;
        kstat_ctl_t *kc;
        kstat_t *ksp;
        kstat_named_t *kn1,*kn5,*kn15;


        if ((kc = kstat_open()) == 0)
        {
                perror("kstat_open");
                exit(1);
        }

        if (( ksp = kstat_lookup(kc, "unix", 0, "system_misc")) == 0)
        {
                perror("kstat_lookup");
                exit(1);
        }
/*
        for(i = 0; i < 15; i++)
        {
*/
                if (kstat_read(kc, ksp,0) == -1)
                {
                        perror("kstat_read");
                        exit(1);
                }

                if ((kn1 = kstat_data_lookup(ksp, "avenrun_1min")) == 0)
                {
                        fprintf(stderr,"avenrun_1min not found by kstat\n");
                        exit(1);
                }
                if ((kn5 = kstat_data_lookup(ksp, "avenrun_5min")) == 0)
                {
                        fprintf(stderr,"avenrun_5min not found by kstat\n");
                        exit(1);
                }
                if ((kn15 = kstat_data_lookup(ksp, "avenrun_15min")) == 0)
                {
                        fprintf(stderr,"avenrun_15min not found by kstat\n");
                        exit(1);
                }


                printf("%s\tload average:\t%.2f\t%.2f\t%.2f\n",
                      hostname,
                    (double)kn1->value.ul/FSCALE,
                    (double)kn5->value.ul/FSCALE,
                    (double)kn15->value.ul/FSCALE);
/*              sleep(60); 
        } */
}

