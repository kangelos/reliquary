
deactivate menu all
release all
private all
clear all
set notify on
set talk off
set sysmenu off
set exclusive off
set century on
SET DATE AMERICAN
public company,section,macctno,presult
set safety off
set exclusive on

set procedure to "various"
set reprocess to 1
set talk off
ON ERROR DO imserror WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()

a=getenv("inmSROOT")
if a==""
   wait window "INMS Root Not set" timeout 1
   wait window "Please set the 'INMSROOT' environment variable" timeout 1
   clear all
   close data
   cancel
ENDIF
a=getenv("inmsname")
if a==""
   wait window "Machine Name Not set" timeout 1
   wait window "Please set the 'INMSNAME' environment variable" timeout 1
   clear all
   close data
   cancel
endif

mscreen=fopen('c:\dos\fp.xxx')
if (mscreen < 0)
   ?? chr(7)
   wait window "Unauthorized Copy" timeout 1
   ?? chr(7)
   wait window "Please Do not try again" timeout 1
   ?? chr(7)
   wait window "Call Cosmodata to order" timeout 1
   clear all
   close data
   set help to
   cancel
else
    =fclose(mscreen)
    release mscreen
endif



close databases


declare alphabet[24]
for i=1 to 24
    alphabet[i]=chr(asc("C")+i-1)
endfor

set color to
clear
selection="C"
   @ 10,5 say "Please Specify your Target Drive"
   @ 0,40 get selection from alphabet
   read
if lastkey()=27
   clear
   cancel
endif

root=getenv("INMSROOT")
if left(root,1)="\"
   prepend=""
else
    prepend="\"
endif
currentdir=sys(5)+sys(2003)
name=selection+":"+prepend+root

rrcnf=currentdir+"\rr.cnf"

if !file(rrcnf)
   ?? chr(7)
   wait window "Please Run this program from the distribution diskette" timeout 3
   cancel
endif

wait window "Copying files , Please Wait" Nowait

targetcnf=name+"\rr.cnf"

copy file (rrcnf) to (targetcnf)

rrudf=currentdir+"\rr.udf"
targetudf=name+"\rr.udf"

copy file (rrudf) to (targetudf)

rrp1=currentdir+"\inms.rp1"
targetrp1=name+"\inms.rp1"

copy file (rrp1) to (targetrp1)

rrun=currentdir+"\rrun.exe"
targetrun=name+"\rrun.exe"

copy file (rrun) to (targetrun)

rruntime=currentdir+"\rruntime.exe"
targetruntime=name+"\rruntime.exe"

copy file (rruntime) to (targetruntime)

rreports=currentdir+"\rreports.dbf"
targetrreports=name+"\rreports.dbf"

copy file (rreports) to (targetrreports)

syst=selection+":"+prepend+root+"\system.dbf"

         if !used(syst)
            SELECT 25
            USE (syst) ALIAS SYSTEM
         ELSE
            SELECT SYSTEM
         ENDIF
replace system.laser with .t.
wait window "All Done" timeout 5
close data         
clear
quit


***************************************************************************
*                        getout
***************************************************************************
procedure getout
return

