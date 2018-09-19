
/*
	Ugly hack to verify from addresses , code grabbed from sample-milter.c and sun docs
	can be further enhanced by verifying if the IPs from the from addresses's belong to a particular ISP
	any takers ?


Makefile
LdapVfrom-milter: LdapVfrom-milter.o
        gcc -g -o LdapVfrom-milter  LdapVfrom-milter.o -lmilter -lpthread -llber -lldap

LdapVfrom-milter.o: LdapVfrom-milter.c 
        gcc -g -DDEBUG -c LdapVfrom-milter.c  


	Reduces back scatter from spammers 


ldap organization is as follows 
	o=top
	|
	ou=domains		
	|	
	+----------- ou=unix.gr ------------------------- ou=someother_domain
			|
			mail=angelos@unix.gr
			|
			mail=sdfsdfsdf

	Angelos Karageorgiou Feb 2007
	angelos@unix.gr
*/

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sysexits.h>
#include <unistd.h>
#include <syslog.h>
#include <ldap.h>
#include <signal.h>

#include <libmilter/mfapi.h>

/* Change these as needed. */
#define HOST1		"lookup1"
#define HOST2		"lookup2"
#define BINDDN		"cn=readonly,ou=admins,o=top"
#define BINDPASS	"readpass"
#define BASEDN		"ou=domains,o=top"
#define DOMAINFILTER	"(&(ou=%s)(objectclass=organizationalunit)(objectClass=qmailUser))"
#define MAILFILTER_COMPLEX	"(&(|(mail=%s)(mailalternateaddress=%s)(mailalternateaddress=catchall@%s))(accountstatus=active))"
#define MAILFILTER	"(&(mail=%s)(accountstatus=active))"
#define MAILUID 8
#define MAILGID 12
#define UNVERIFIABLE -1
#define XHEADER	"X-LdapVfrom"



#ifndef bool
# define bool	int
# define TRUE	1
# define FALSE	0
#endif /* ! bool */

const char *delim="@";

int ldapquery( char *filter, char *base);
void daemonize();

int dryrun=FALSE;



struct mlfiPriv
{
	char	*mlfi_connectfrom;
	char	*mlfi_helofrom;
	char 	*mail,*username,*domain;
	int	VERIFIED;
};

#define MLFIPRIV	((struct mlfiPriv *) smfi_getpriv(ctx))

extern sfsistat		mlfi_cleanup(SMFICTX *, bool);

sfsistat
mlfi_connect(ctx, hostname, hostaddr)
	 SMFICTX *ctx;
	 char *hostname;
	 _SOCK_ADDR *hostaddr;
{
	struct mlfiPriv *priv;
	char *ident;

	/* allocate some private memory */
	priv = malloc(sizeof *priv);
	if (priv == NULL)
	{
		/* can't accept this message right now */
		return SMFIS_TEMPFAIL;
	}
	memset(priv, '\0', sizeof *priv);

	/* save the private data */
	smfi_setpriv(ctx, priv);

	ident = smfi_getsymval(ctx, "_");
	if (ident == NULL)
		ident = "???";
	if ((priv->mlfi_connectfrom = strdup(ident)) == NULL)
	{
		(void) mlfi_cleanup(ctx, FALSE);
		return SMFIS_TEMPFAIL;
	}

	priv->mail=calloc(sizeof(char),1024);
	priv->username=calloc(sizeof(char),1024);
	priv->domain=calloc(sizeof(char),1024);
	return SMFIS_CONTINUE;
}

sfsistat
mlfi_helo(ctx, helohost)
	 SMFICTX *ctx;
	 char *helohost;
{
	size_t len;
	char *tls;
	char *buf;
	struct mlfiPriv *priv = MLFIPRIV;

	/* continue processing */
	return SMFIS_CONTINUE;
}

sfsistat
mlfi_envfrom(ctx, argv)
	 SMFICTX *ctx;
	 char **argv;
{
	struct mlfiPriv *priv = MLFIPRIV;
	char *mailaddr = smfi_getsymval(ctx, "{mail_addr}");
char base[1024];
char filter[1024];


strcpy(priv->mail,mailaddr);
char temp[1024];
strcpy(temp,priv->mail);
char *username=strtok(temp,delim);

if (username == NULL ) {
	syslog(LOG_ERR,"Null From");
	(void) mlfi_cleanup(ctx, FALSE);
	priv->VERIFIED=UNVERIFIABLE;
	return SMFIS_CONTINUE;
}
strcpy(priv->username,username);

/*
if ( strcmp(priv->domain,"topnet.gr") != 0 ) {
	priv->VERIFIED=UNVERIFIABLE;
	syslog(LOG_INFO,"Not from topnet.gr");
	return SMFIS_CONTINUE;
}
*/

char *domain=strtok(NULL,delim);
if ( domain == NULL ) {
	syslog(LOG_ERR,"Null domain");
	(void) mlfi_cleanup(ctx, FALSE);
	priv->VERIFIED=UNVERIFIABLE;
	return SMFIS_CONTINUE;
}
strcpy(priv->domain,domain);


sprintf(base,"%s",BASEDN);
sprintf(filter,DOMAINFILTER,domain);
priv->VERIFIED=ldapquery(filter,base);
 
if ( priv->VERIFIED<0 ){
	syslog(LOG_ERR,"ldap query failed %s",filter);
	return SMFIS_CONTINUE;
}

if ( priv->VERIFIED == 0 ){
	priv->VERIFIED=UNVERIFIABLE; /* just in case */
#ifdef DEBUG
	syslog(LOG_INFO,"%s Domain not in LDAP server",priv->domain);
#endif
	(void) mlfi_cleanup(ctx, FALSE);
	return SMFIS_CONTINUE;
}
#ifdef DEBUG
syslog(LOG_INFO,"%s domain found",filter);
#endif



sprintf(base,"ou=%s,%s",domain,BASEDN);
sprintf(filter,MAILFILTER_COMPLEX,mailaddr,mailaddr,domain);
//sprintf(filter,MAILFILTER);
priv->VERIFIED=ldapquery(filter,base);


if (priv->VERIFIED < 0 ){
	syslog(LOG_ERR,"ldap query failed %s",filter);
	return SMFIS_CONTINUE;
}

if (priv->VERIFIED == 0 ){
	syslog(LOG_ERR,"%s Bad From Address",filter);
	char msg[1024];
	sprintf(msg,"Your From Address (%s) is Invalid",mailaddr);
	smfi_setreply(ctx, "550", "5.7.1",msg);
	if ( dryrun == TRUE ) {
		return SMFIS_CONTINUE;
	} else {
		return SMFIS_REJECT;
	}
}

syslog(LOG_INFO,"%s mailaddr %s OK",filter,mailaddr);
return SMFIS_CONTINUE;
}



mlfi_envrcpt(ctx, argv)
	 SMFICTX *ctx;
	 char **argv;
{
	return SMFIS_CONTINUE;


}

sfsistat
mlfi_header(ctx, headerf, headerv)
	 SMFICTX *ctx;
	 char *headerf;
	 unsigned char *headerv;
{
	return SMFIS_CONTINUE;
}

sfsistat
mlfi_eoh(ctx)
	 SMFICTX *ctx;
{
	return SMFIS_CONTINUE;
}

sfsistat
mlfi_body(ctx, bodyp, bodylen)
	 SMFICTX *ctx;
	 unsigned char *bodyp;
	 size_t bodylen;
{
	return SMFIS_CONTINUE;

}

sfsistat
mlfi_eom(ctx)
	 SMFICTX *ctx;
{
	bool ok = TRUE;
	struct mlfiPriv *priv = MLFIPRIV;

 	char *msgid=smfi_getsymval(ctx, "i");
	char msg[1024];

	
	if ( priv->VERIFIED < 0  ){
		sprintf(msg,"From Address %s not Ours",priv->mail);
		if ( dryrun)
			smfi_addheader(ctx, XHEADER,"From Address Not Ours");
	} else if ( priv->VERIFIED  > 0  ){
		sprintf(msg,"MsgID:%s From Address:%s Verified",msgid,priv->mail);
		if ( dryrun)
			smfi_addheader(ctx, XHEADER,"From Address Verified");
	} else {
		sprintf(msg,"MsgID:%s From Address:%s Program Error, I should not be here",msgid,priv->mail);
	}

	syslog(LOG_INFO,msg);
	return mlfi_cleanup(ctx, ok);
}



sfsistat mlfi_abort(ctx) SMFICTX *ctx; {
	return mlfi_cleanup(ctx, FALSE);
}



sfsistat mlfi_cleanup(SMFICTX *ctx, bool ok) {
	sfsistat rstat = SMFIS_CONTINUE;
	struct mlfiPriv *priv = MLFIPRIV;
	return SMFIS_CONTINUE;
}

sfsistat mlfi_close(SMFICTX *ctx) {
	struct mlfiPriv *priv = MLFIPRIV;

	if (priv == NULL)
		return SMFIS_CONTINUE;
	if (priv->mlfi_connectfrom != NULL)
		free(priv->mlfi_connectfrom);
	if (priv->mlfi_helofrom != NULL)
		free(priv->mlfi_helofrom);
	if ( priv->mail != NULL )
		free(priv->mail);
	if ( priv->username != NULL )
		free(priv->username);
	if ( priv->domain != NULL )
		free(priv->domain);

	free(priv);
	smfi_setpriv(ctx, NULL);
	return SMFIS_CONTINUE;
}

sfsistat mlfi_unknown(SMFICTX *ctx, char *cmd) {
	return SMFIS_CONTINUE;
}

sfsistat mlfi_data(SMFICTX *ctx) {
	return SMFIS_CONTINUE;
}



sfsistat mlfi_negotiate(SMFICTX *ctx,
	unsigned long f0, unsigned long f1, unsigned long f2, unsigned long f3, 
	unsigned long *pf0, unsigned long *pf1, unsigned long *pf2, unsigned long *pf3) {
		*pf0 =  SMFIF_ADDHDRS;
        	*pf1 = SMFIP_NOHELO | SMFIP_NOHDRS | SMFIP_NOEOH | 
               	SMFIP_NOBODY;

		return SMFIS_CONTINUE;
}

struct smfiDesc smfilter =
{
	"LdapVfrom",	/* filter name */
	SMFI_VERSION,	/* version code -- do not change */
	SMFIF_ADDHDRS,	/* flags */
	mlfi_connect,	/* connection info filter */
	mlfi_helo,	/* SMTP HELO command filter */
	mlfi_envfrom,	/* envelope sender filter */
	mlfi_envrcpt,	/* envelope recipient filter */
	mlfi_header,	/* header filter */
	mlfi_eoh,	/* end of header */
	mlfi_body,	/* body block filter */
	mlfi_eom,	/* end of message */
	mlfi_abort,	/* message aborted */
	mlfi_close,	/* connection cleanup */
//	mlfi_unknown,	/* unknown SMTP commands */
//	mlfi_data,	/* DATA command */
//	mlfi_negotiate	/* Once, at the start of each SMTP connection */
};

static void usage(char *prog) {
	fprintf(stderr,
		"Usage: %s -p socket-addr [-t timeout] [-r] [-h] \n",
		" -r is for dry runnning, just display the actions\n",
		" -h display this help\n",
		prog);
}

int main(int argc, char **argv) {

	bool setconn = FALSE;
	int c;
	const char *args = "p:t:h:r";
	extern char *optarg;

	/* Process command line options */
	while ((c = getopt(argc, argv, args)) != -1)
	{
		switch (c)
		{
		  case 'p':
			if (optarg == NULL || *optarg == '\0')
			{
				(void) fprintf(stderr, "Illegal conn: %s\n",
					       optarg);
				exit(EX_USAGE);
			}
			if (smfi_setconn(optarg) == MI_FAILURE)
			{
				(void) fprintf(stderr,
					       "smfi_setconn failed\n");
				exit(EX_SOFTWARE);
			}

			/*
			**  If we're using a local socket, make sure it
			**  doesn't already exist.  Don't ever run this
			**  code as root!!
			*/

			if (strncasecmp(optarg, "unix:", 5) == 0)
				unlink(optarg + 5);
			else if (strncasecmp(optarg, "local:", 6) == 0)
				unlink(optarg + 6);
			setconn = TRUE;
			break;

		  case 't':
			if (optarg == NULL || *optarg == '\0')
			{
				(void) fprintf(stderr, "Illegal timeout: %s\n",
					       optarg);
				exit(EX_USAGE);
			}
			if (smfi_settimeout(atoi(optarg)) == MI_FAILURE)
			{
				(void) fprintf(stderr,
					       "smfi_settimeout failed\n");
				exit(EX_SOFTWARE);
			}
			break;

		  case 'r':
			dryrun=TRUE;
			break;

		  case 'h':
		  default:
			usage(argv[0]);
			exit(EX_USAGE);
		}
	}
	if (!setconn)
	{
		fprintf(stderr, "%s: Missing required -p argument\n", argv[0]);
		usage(argv[0]);
		exit(EX_USAGE);
	}
	if (smfi_register(smfilter) == MI_FAILURE)
	{
		fprintf(stderr, "smfi_register failed\n");
		exit(EX_UNAVAILABLE);
	}
	daemonize();
	openlog("LdapVfrom",LOG_NOWAIT|LOG_PID,LOG_MAIL);
 
 	/* block the SIGCHLD signal */
 	signal(SIGCHLD, SIG_BLOCK);
 
 	/* enter main 'loop' */
	syslog(LOG_INFO,"Ldap From Verifier starting ");
	return smfi_main();
}


/*
 ugly hack ripped from docs.sun.com

        Angelos Karageorgiou Feb 2007
*/


int ldapquery( char *filter, char *base)
{
LDAP *ld;
LDAPMessage *res, *msg;
LDAPControl **serverctrls;
BerElement *ber;
char *a, *dn, *matched_msg = NULL, *error_msg = NULL;
char **vals, **referrals;
int version, i, rc, parse_rc, msgtype, num_entries = 0,
num_refs = 0;

/* Get a handle to an LDAP connection. */
if ( (ld = ldap_init( HOST1, LDAP_PORT )) == NULL ) {
	syslog(LOG_ERR,"ldap_init failed on %s",HOST1 );
	if ( (ld = ldap_init( HOST2, LDAP_PORT )) == NULL ) {
		syslog(LOG_ERR,"ldap_init failed on %s",HOST2 );
		return( -1 );
	}
}

version = LDAP_VERSION3;
if ( ldap_set_option( ld, LDAP_OPT_PROTOCOL_VERSION, &version ) != LDAP_SUCCESS ) {
	syslog( LOG_ERR, "ldap_set_option: failed");
	ldap_unbind( ld );
	}

/* Bind to the server anonymously. */
rc = ldap_simple_bind_s( ld, BINDDN, BINDPASS );
if ( rc != LDAP_SUCCESS ) {
	syslog( LOG_ERR, "ldap_simple_bind_s: %s\n", ldap_err2string( rc ) );
if ( matched_msg != NULL && *matched_msg != '\0' ) {
	syslog( LOG_ERR, "Part of the DN that matches an existing entry: %s\n", matched_msg );
}
ldap_unbind_s( ld );
return( -1 );
}
/* Perform the search operation. */
rc = ldap_search_s( ld, base, LDAP_SCOPE_SUBTREE, filter, NULL, 0, &res );

	if ( rc != LDAP_SUCCESS ) {
	syslog( LOG_ERR, "ldap_search_ext_s: %s\n", ldap_err2string( rc ) );
	if ( error_msg != NULL && *error_msg != '\0' ) {
		syslog( LOG_ERR, "%s\n", error_msg );
	}
	if ( matched_msg != NULL && *matched_msg != '\0' ) {
		syslog( LOG_ERR, "Part of the DN that matches an existing entry: %s\n", matched_msg );
	}
	ldap_unbind_s( ld );
	return( -1 );
	}
num_entries = ldap_count_entries( ld, res );
num_refs = ldap_count_references( ld, res );

#ifdef DEBUG
syslog(LOG_INFO,"Found %d entries base=%s filter=%s\n",num_entries,base,filter);
syslog(LOG_INFO,"Found %d referrals base=%s filter=%s \n",num_refs,base,filter);
#endif

/* Disconnect when done. */
ldap_unbind( ld );
return( num_entries );
}







void daemonize() {
 	int f;
 	switch(fork()) {
 		case 0:	/* child */
 			break;
 		case -1: /* error */
 			exit(EX_TEMPFAIL);
 		default: /* parent */
 			exit(EX_OK);
 	}
 #ifdef HAVE_SETSID
 	setsid();
 #endif
 	/* FIXME: implement chrooting! */
 	chdir("/etc/mail");
	setuid(MAILUID);
	setgid(MAILGID);
 
 }
