

			.GR Xray package
			Angelos Karageorgiou Nov 2000
			             Updated Nov 2001




Old stuff , skip to the end for newer stuff. Thank you people and developpers
on the net for your support and code all these years.

============================================================================

Ok this is the description of this package.

First we do a transfer of the .GR domains from a trusting DNS server.
Note, do not run this ofter since it puts the DNS servers under a lot of 
strain and they might decide to block transfers. Which they did in 2001.

Then we extract the .GR domains and their name servers. 
We sort all domains according to name server and we
know how many domains there are and which local DNS server has them
registered. We also generate the top 10 of DNS hostings in greece


Now we can scan all these domains, and see which ones are active,
get the Server they are running and the IP of their hosting machine.
The timeout is 5 seconds , if the name does not resolve and the machine
does not answer within 11 seconds the domain is considered irresponsive.
This timeout is programmable. The source for the scanner is in the 
masscrawler package unide http://www.unix.gr

Now we know all the Software used so we can have the top 10 of server
software.

WE also have the IPs os all the machines and we can find out the 
number of active web hosting computers.

now we do a reverse dns and find out the company that owns the computers
and have the top 10 of hosting companies.

Also we can have 2nd order statistics of DNS vs WEB hostings for each company

In other words this is a complete Xray of the GR domain.


This process takes about 6-8 hours to run and it grinds the source machine
heavily, so I would suggest to run it only once or twice a month.

*see notes below

		For Tuesday Nov 6 2000 we have
=============================================================================
	
There are   24430 Unique domains
Web count Specifics are in file  Tue-7-11-2000//count_per_server
 
DNS count rankings are in Tue-7-11-2000//ranking
To 10 DNS hosting companies are
	1638	forthnet.gr.
	1470	otenet.gr.
	1352	hol.gr.
	703	domi.gr.
	589	thewebpower.net.
	535	internet.gr.
	506	compulink.gr.
	482	pegasus.net.gr.
	440	combos.net.
	432	nameserve.net.
Domains' results appear in Tue-7-11-2000//domains_scanned
 
There are    8016 bad domains and   16413 active domains
There are    5768 actual web server with different IPs
 
Top 10 of webserver hosting machines are 
    703	forthnet.gr.
    618	193.92.26.84
    586	hol.gr.
    467	otenet.gr.
    303	combos.net.
    301	compulink.gr.
    291	incredible.com.
    242	mbn.gr.
    217	spark.net.gr.
    184	hellasnet.gr.
 
Rankings of servers are in  Tue-7-11-2000//software_ranking
Top 10 software used is
   7832	 Microsoft-IIS
   6989	 Apache
    711	 Netscape-Enterprise
    290	 Rapidsite
    163	 WebSitePro
    113	 Zeus
     30	 WebSTAR
     29	 Lotus-Domino
     29	 AOLserver
     28	 Apache-AdvancedExtranetServer
 
Top 10 of OSes used *
    171 Windows NT4
     81 Unknown Irix?
     66 Linux 2.0.35-37
     12 Linux 2.1.122
     11 Windows 2000
      5 MS Windows2000
      2 MacOS 7.5.5
      2 FreeBSD 2.2.1
      1 Solaris 2.6
      1 Raptor Firewall

==========================================================================

* Note OS data is incomplete, please run xray and let it finish

Notes:

First time this program runs it will be very slow, since all the 
names will have to be resolved and all the IPs also.

Subsequent runs will be much faster, since all the above information
will be cached in the DNS server.

Of course if you restart BIND all this information will be lost.
There are companies with very miserable reverse DNS tables. 
For these common IPS and maps that do not resolve reversely 
their IPs should go in your computer's hosts file like so:

	195.119.142.126 someserver.combos.net
	195.119.137.2   someserver.interagora.gr


The local DNS server caches all the requests it receives from the Xray
In other words the stats system gets better every time you run it


IT would be interesting to get second order statistics like
given the amount of registered domains per company see
how many of them are active , or How many web serving companies
are at the about 100 web sites mark. The size of the involved
companies. etc etc


to Get OS results you must be able to run queso/nmap  as root
either make queso/nmap SUID , or run the scripts as root

Better OS results can be obtained with Nmap , BUT, it is extremely slow 
to get. My current guestimate is that it will take more than 4 days to get 
results with nmap , and even that might be an understatement.
==================================

SSL SCAN  


to see how far e-commerce  has made inroutees in Greece I scan 
the active IPs  for SSL servers.  This will give us the software used as 
well as the certificate authority and certificate.

Unfortunatelly the majority of SSL hosts is badly misconfigured so I had
to redo the scan including the criterion of certificate validation
i.e. that the certificate has not expired and the forward and reverse DNS
entries matched exactly. This will narrow significantly down the
number of actual SSL hosts.

==============================================================================

	Historical and upgrade note written in Nov 2001.


	Xray is not limited to the .GR domain. It can be used anywhere in 
the world, just edit some lines in the Xray script.

	The Xray package started as a Perl engine, during runs I realized 
that to gain fine control over alarms (time outs) I needed to code in C.
So I opened up the trunk of old school projects, pulled out webdump and 
hacked it heavily.

	I left most of the other code, the one generating  the statistics
from the raw data that masscrawler generates well enough alone. It is
not smart to reinvent the wheel even for artistic purposes some times.

	One optimization trick in the scanner was to leave the hosts
input file unsorted. This would align the domain names by Name server.
So when I scan a host and retriece its software I already have its IP address.
If the next availlable host's IP resolves to the same as before, then
I do not need to scan it. Of course it is not entirely accurate, but for
statistical purposes it is more than enough given that most machines 
now-adays use a signle server software for multiple domains.

	The above optimization trick allows me to use a sigle variable
to maintain state, rather than a large hash table, not to mention that I
could not get the hash table implementation to work properly under Linux 
and Gnu-C. Any ideas why not ?

	The trick to fast scanning is to break your dataset in pieces
and give each piece to a different masscawler process. When they are done
you connect the pieces together and you are done.

	There is a separate stats script that generates the better statistics
from the raw data. Use that to obtain the final data. The package
leaves laying around too many files. I thought at the time that they were
usefull, please visit them and see what they have.


	Once upon a time I had an nmap based OS scanner, but some intrusion
detection systems , unabashed plug packetlog.pl , started carping; so I
removed that bit from executing, but it is still buried in the code somewhere.

	The little proggie that displays added and removed domains from
each run is called ddiff. It is self explanatory. There is also a lot of legacy 
perl code in the package. This is for your edification purposes only.


	Oh, this is not a GNU package, this is totally freeware, use it
and abuse it at your own free will. But I would appreciate it if you mentioned
my name and my web site as follows.

Xray package created by: Angelos Karageorgiou http://www.unix.gr





Hack well and have fun.
