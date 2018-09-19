/*

        November 1998 , Angelos Karageorgiou  angelos@unix.gr

         Hello people.

        This is a pop-3 to sslpop3 wrapper, you need SSLeay-0.9.0b to compile

gcc -o popssl popssl.c -I/usr/local/ssl/include -L/usr/local/ssl/lib -lcrypto -l
ssl


say your inetd spawned servers reside in /usr/sbin
then install in in /usb/sbin and change your pop-3 line in your inetd.conf file
to this

pop-3   stream  tcp     nowait  root    /usr/sbin/tcpd  popssl spop3-server


where spop3-server is your SSL supporting server
the program logs to the DAEMON facility in your syslog


Credits:
	Parts were a rip off from Michal Trojnara's Stunnel and of course 
	improved upon :-)

License:
	 Use it as you wish,  and if you make any money out of it,
	oh well keep it :-)

Systems:
	 it worked on Linux and BSD/OS, should be plenty generic

*/

#include <stdio.h>
#include <memory.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <syslog.h>

#include <ssl.h>
#include <bio.h>
#include <x509.h>
#include <rsa.h>       /* SSLeay stuff */
#include <crypto.h>
#include <pem.h>
#include <err.h>

#define GREECE


void transfer(SSL *ssl, int tunnel);

void main (int argc, char* argv[]) {
  int err;
  int sd,mysock,newsockfd;
  struct sockaddr_in sa,my_addr,cli_addr;
  SSL_CTX* ssl_ctx;
  SSL*     ssl_data_con;
  X509*    server_cert;
  char*    str;
  int bits,stop,cli_len;
  char buf[BUFSIZ];
  struct hostent *H,*me;
  char myhostname[400];
  char popip[300];
 int ret,res;
   char buffer[3400];







openlog("popssl", LOG_CONS | LOG_NDELAY | LOG_PID, LOG_DAEMON);

if ( argc != 2 ) {
  syslog(LOG_ERR,"in your inetd.conf put this\n");
  syslog(LOG_ERR,"pop-3  stream  tcp     nowait  root    /usr/sbin/tcpd popssl s
pop3-host");
  exit(1);
}



H=gethostbyname(argv[1]);
if ( H == NULL) {
        syslog(LOG_ERR,"Hostname %s is bad",argv[1]);
        exit(1);
}


  sd    = socket (AF_INET, SOCK_STREAM, 0);
 if ( sd <=0 ) {
        syslog(LOG_ERR,"No more sockets");
        exit(1);
}
  memset (&sa, '\0', sizeof(sa));
  sa.sin_family      = AF_INET;
  sa.sin_addr.s_addr = *((unsigned long *) H->h_addr);
  sa.sin_port        = htons     (995);

res=connect(sd, (struct sockaddr *) &sa, sizeof(sa)) ;
if ( res <= -1 ) {
        syslog(LOG_ERR,"Cannot connect to server %s",argv[1]);
        exit(1);
}

SSL_load_error_strings();
SSLeay_add_ssl_algorithms();
ssl_ctx=(SSL_CTX *)SSL_CTX_new(SSLv23_method());
SSL_CTX_set_options(ssl_ctx,SSL_OP_ALL);
SSL_CTX_set_cipher_list(ssl_ctx,NULL);

ssl_data_con=SSL_new(ssl_ctx);
SSL_set_verify(ssl_data_con,SSL_VERIFY_NONE,NULL);

SSL_set_fd(ssl_data_con,sd);
syslog(LOG_INFO,"[- SSL POP3 opening link -]");
 if ((ret=SSL_connect(ssl_data_con))<=0) {
    syslog(LOG_ERR,"ftp: SSL_connect DATA error %d - %s",
           ret,ERR_error_string(ERR_get_error(),NULL));
    close(sd);
    exit(1);
  }

syslog(LOG_INFO,"[SSL Cipher %s]",SSL_get_cipher(ssl_data_con));
SSL_get_cipher_bits(ssl_data_con,&bits);
syslog(LOG_INFO,"[Encryption %d bits]",bits);


  transfer(ssl_data_con, fileno(stdin) );

  syslog(LOG_INFO,"[- SSL POP3 closing link -]");

  shutdown (sd, 1);  /* Half close, send EOF to server. */


  SSL_free (ssl_data_con);
  close (sd);

  SSL_CTX_free (ssl_ctx);
}


/*
	tranfer() was lifted from an early version of stunell
*/
void transfer(SSL *ssl, int tunnel)
{
    fd_set rin,rout;
    char buffer[BUFSIZ];
    int num, fdno, fd_ssl, bytes_in=0, bytes_out=0,bs,bufsize;


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
            num=read(tunnel, buffer, BUFSIZ);
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
            if(write(tunnel, buffer, num)!=num)
                        if ( bs != num )
                 perror("write");
            bytes_in+=num;
        }
        }
    }

}
