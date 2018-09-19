#
# Makefile for voice 0.6
#
# "make" or "make all"	to compile binaries
# "make install"	to make dirs and install everything (must be root)
# "make clean"		to remove compiled binaries
# "make uninstall"	to remove installed files (not the directories)

# Program used to install and set ownership.
INSTALL=install -o root -g root

# Directories involved (see below).
TMPDIR=/tmp
LCKDIR=/var/lock
RUNDIR=/var/run
BINDIR=/usr/bin
MANDIR=/usr/man/man8
LOCDIR=/usr/local/bin
FAXDIR=/var/spool/fax
VOCDIR=/var/spool/voice
LIBDIR=/usr/local/lib/ans

all: vmcp

vmcp: vmcp.c
	cc -o vmcp vmcp.c

install: chkbin
	# Create directories if not already existing:
	$(INSTALL) -m 1777 -d $(TMPDIR)
	$(INSTALL) -m 0755 -d $(LCKDIR)
	$(INSTALL) -m 0755 -d $(RUNDIR)
	$(INSTALL) -m 0755 -d $(BINDIR)
	$(INSTALL) -m 0755 -d $(MANDIR)
	$(INSTALL) -m 0755 -d $(LOCDIR)
	$(INSTALL) -m 0755 -d $(FAXDIR)
	$(INSTALL) -m 0755 -d $(VOCDIR)
	$(INSTALL) -m 0755 -d $(LIBDIR)
	# Install files:
	$(INSTALL) -s -m 0755 vmcp $(BINDIR)
	$(INSTALL) -m 0644 ans.8 vmcp.8 $(MANDIR)
	$(INSTALL) -m 0755 ans vplay vrec $(LOCDIR)
	$(INSTALL) -m 0640 passwd $(LIBDIR)
	# Compress man pages:
	gzip $(MANDIR)/ans.8
	gzip $(MANDIR)/vmcp.8

# Binary files needed by ans, check before installing...
chkbin:	/sbin/agetty /bin/cat /bin/cp /bin/cut /bin/date /bin/echo \
	/usr/bin/diff /usr/bin/find /bin/kill /bin/ls /bin/mv \
	/bin/rm /usr/bin/sed /usr/bin/sort /bin/touch /usr/bin/wc

clean:
	rm -f vmcp

uninstall:
	rm -f $(BINDIR)/vmcp
	rm -f $(MANDIR)/ans.8 $(MANDIR)/vmcp.8
	rm -f $(LOCDIR)/ans $(LOCDIR)/vplay $(LOCDIR)/vrec
	rm -f $(LIBDIR)/passwd
