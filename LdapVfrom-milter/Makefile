

all: LdapVfrom-milter Makefile

LdapVfrom-milter.o: LdapVfrom-milter.c Makefile
	gcc -g -DDEBUG -c LdapVfrom-milter.c 

LdapVfrom-milter: LdapVfrom-milter.o Makefile ldap-query.o
	gcc -g -o LdapVfrom-milter  LdapVfrom-milter.o -lmilter -lpthread -llber -lldap

