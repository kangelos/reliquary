do CALCK

set exclusive off
* just in case some code wanders around here
return

******************************************************************************
*                    Function make temporary name
******************************************************************************
function tempname
private line
  line=space(8)
  line=time()
  line=stuff(line,3,1,'-')
  line=stuff(line,5,1,'-')
  line=stuff(line,7,1,'-')
  line=line+'.DBF'
return line


***************************************************************************
*                  center text on the screen
***************************************************************************
function center
parameter row,message
private column
        column=int( (wcols()-len(message)) /2 )
        @ row,column say message
return  .t.



***************************************************************************
*                  end text on the screen
***************************************************************************
procedure end
parameter row,message
private column
        column=wcols()-len(message)
        @ row,column say message
return



***************************************************************************
*                  procedure yesno
***************************************************************************
function acertain
parameter string,def
private yesno,TF,column

if def=.f.
   yesno=1
else
   yesno=2
endif
set color to
define window sure from 7,19 to 12,59 none float shadow in screen ;
       title 'ARE YOU SURE ?' color scheme 10

activate window sure

set color to w+/g,b/w
clear
column=(40-len(string))/2
@ 1,column say (string)
@ 3,1 prompt '                  NO                   '
@ 4,1 prompt '                  YES                  '
menu to yesno
deactivate window sure

if lastkey()=27
   tf=.f.
else
    tf=.f.
    if yesno=2
       TF=.t.
    else
       TF=.f.
    endif
endif
release window sure
set color to w/n
RETURN TF


***************************************************************************
*                  procedure select output
***************************************************************************
function spf
private yesno,TF,column,PRETTY

String="Where do you want the output to go ?"
   yesno=1
PRETTY=GETLASER()
IF PRETTY
    define window sure from 7,22 to 15,64  NONE float shadow in screen ;
           title '[ OUTPUT GOES WHERE ]' COLOR SCHEME 10
    activate window sure
    set color to
    clear
    lastk=27
    do while lastk=27
        column=(40-len(string))/2
        @ 1,column say (string)
        @ 3,1 prompt '                ON SCREEN                '
        @ 4,1 prompt '                HARD COPY                '
        @ 5,1 prompt '              LASER PRINTER              '
        @ 6,1 prompt '             ABORT OPERATION             '
        menu to yesno
        lastk=lastkey()
    enddo
ELSE
    define window sure from 7,22 to 13,64  float shadow in screen NONE ;
           title '[ OUTPUT GOES WHERE ]' COLOR SCHEME 10
    activate window sure
    set color to
    clear
    lastk=27
    do while lastk=27
        column=(40-len(string))/2
        @ 1,column say (string)
         SET COLOR TO W/BG+,B/W
        @ 3,1 prompt '                ON SCREEN                '
        @ 4,1 prompt '                HARD COPY                '
        @ 5,1 prompt '             ABORT OPERATION             '
        menu to yesno
        lastk=lastkey()
    enddo
    if yesno=3
       yesno=0
    endif
ENDIF
deactivate window sure
release window sure
set color to w/n
RETURN yesno

***************************************************************************
*                       Function validate date
***************************************************************************
function date_validate
parameter some_date
private result,tf,char1,char2,mydate,some

some=alltrim(some_date)
*char1=right(some,1)
*char2=left(some,1)
*  if (char1='/' or char2='/' )
*     tf=.f.
*  else
*     tf=.t.
*  endif
*? '|'+some_date+'|',' char1:',char1,' char2:',char2

tf=.t.
if tf=.t.
  mydate=alltrim(dtoc(ctod(some_date)))
  tf=.t.
*  char1=right(mydate,1)
*  char2=left(mydate,1)
  result= ( len(mydate) >4 )
  if result=.f.
     tf=.f.
  else
     tf=.t.
  endif
endif
*?  some_date,' ',mydate,' ',char1,' ',char2
return tf




***************************************************************************
*                    function whatnext
***************************************************************************
function whatnext
private tf,last

tf=0
last=.t.
do while last=.t.
set color to w/b
define window whattodo from 13,5 to 20,48 color scheme 1 double float shadow;
       Title '[ ENTRY FINISHED ]' in screen

activate window whattodo
selection='Accept this Entry'
@ 0,2 say "What do you want to do with this Entry"
@ 2,8 get selection picture '@*! Accept this Entry;Revise this Entry;Quit and Ignore the entry' size 1,27
read cycle
if lastkey()=27
   LAST=.T.
ELSE
   LAST=.F.
ENDIF
do case
   case selection='Accept this Entry'
        tf=1
   case selection='Revise this Entry'
        tf=2
   case selection='Quit and Ignore the entry'
        tf=.3
endcase
deactivate window whattodo
release window whattodo
enddo
return tf




*                     *** systeM STUFF ***


***************************************************************************
*                        get company name
***************************************************************************
function getcompany
private file,line,i,j,k
restore from comem additive
line=coconame
return  alltrim(line)



***************************************************************************
*                        get automatic policy
***************************************************************************
function getautopol
private tf

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif
go top

do while lock('1','system')=.f.
enddo
    tf=autopol
    unlock in system
if len(alltrim(oldalias))>0
   select &oldalias
endif
return  tf


***************************************************************************
*                        get automatic policy
***************************************************************************
function getkey
private tf

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif
go top

do while lock('1','system')=.f.
enddo
    mkey=key
    unlock in system
if len(alltrim(oldalias))>0
   select &oldalias
endif
return  mkey

***************************************************************************
*                        get LASER STUFF
***************************************************************************
function getLASER
private tf

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif
go top

do while lock('1','system')=.f.
enddo
    tf=LASER
    unlock in system
if len(alltrim(oldalias))>0
   select &oldalias
endif
return  tf

***************************************************************************
*                        get new account number
***************************************************************************
function getcacctno
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.acctno
number=number+1
replace system.acctno with number
unlock in system

if len(alltrim(oldalias))>0
   select &oldalias
endif
return number


***************************************************************************
*                        get new account number
***************************************************************************
function getusers
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.users
number=number+1
replace system.users with number
unlock in system

if len(alltrim(oldalias))>0
   select &oldalias
endif
return number

***************************************************************************
*                        get new account number
***************************************************************************
function putusers
private file,line,i,j,k,number

if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.users
number=number-1
if number<0
   number=0
endif
replace system.users with number
unlock in system
return number

***************************************************************************
*                        get new account number
***************************************************************************
function getprints
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.prints
number=number+1
replace system.prints with number
unlock in system

if len(alltrim(oldalias))>0
   select &oldalias
endif
return number



***************************************************************************
*                        get new vehicle number
***************************************************************************
function getvehid
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.carno
number=number+1
replace system.carno with number
unlock in system

if len(alltrim(oldalias))>0
   select &oldalias
endif
return number


***************************************************************************
*                        get new policy number
***************************************************************************
function getpolno
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.polnumber
number=number+1
replace system.polnumber with number
unlock in system

if len(alltrim(oldalias))>0
   select &oldalias
endif
return number

***************************************************************************
*                        get new insurance company number
***************************************************************************
function getinsnum
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.insnumber
number=number+1
replace system.insnumber with number
unlock in system
if len(alltrim(oldalias))>0
   select &oldalias
endif
return number


***************************************************************************
*                        get new car number
***************************************************************************
function getcarno
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.carno
number=number+1
replace system.carno with number
unlock in system
if len(alltrim(oldalias))>0
   select &oldalias
endif
return number


***************************************************************************
*                        get new invoice number
***************************************************************************
function getinvno
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.invno
number=number+1
replace system.invno with number
unlock in system
if len(alltrim(oldalias))>0
   select &oldalias
endif
return number

***************************************************************************
*                        get new service code number
***************************************************************************
function newsvccode
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.svccodenum
number=number+1
replace system.svccodenum with number
unlock in system
if len(alltrim(oldalias))>0
   select &oldalias
endif
return number






********************************************************************************
*                 get insurance company number
********************************************************************************
function getinscomp
parameter number
private tf,covsc,num

if !used('icompany')
   select d
   use icompany index icompany alias icompany
else
   select icompany
endif

seek number
if found()
  num=iidno
else
    save screen to covsc
    =center(24,"Press F10 to select Insurance Company")
    on key label f10 keyboard "{ctrl+w}"
    browse nomodify title 'SELECT INSURANCE COMPANY'
    on key label f10
    restore screen from covsc
endif
num=iidno
return num




******************************************************************************
*                    check coverage id
******************************************************************************
function checkcovid
parameter pid
private tf,id


id=alltrim(pid)
if len(id)=0
   tf=.t.
else
   tf=!checkcovdoubleid(id)
endif

return tf





******************************************************************************
*                    function checkcovdoubleid
******************************************************************************
function checkcovdoubleid
parameter pid
private tf,id,rec

id=alltrim(pid)
tf=.f.
rec=recno()
go top
set exact on
locate for policyno=pid
set exact off
if ( found() and (rec # recno()) )
   tf=.t.
else
   tf=.f.
endif
return tf



******************************************************************************
*                    procedure imserror
******************************************************************************
procedure imserror
PARAMETER merror, mess, mess1, mprog, mlineno
private selection

set color to gr+/r
define window error from 2,9 to 22,69 double title '[ ERROR ]' shadow;
       color gr+/r,gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r
activate window error

set color to gr+/r,B/w
=center(0,'Number')
=center(2,'Message')
=center(4,'Line of code with error')
=center(6,'Line number of error')
=center(8,'Program with error')
=center(15,'Please call the COSMODATA technical support at')
=center(17,'Make sure you print a snapshot of this screen')
=center(18,'by pressing [Shift]+[Prt Sc]')

set color to w+/r,r+/w
=center(1,alLTRIM(STR(merror)) )
=center(3,mess)
=center(5,left(mess1,58))
=center(7,alLTRIM(STR(mlineno)) )
=center(9,mprog)
set color to W+/r,B/w
=center(16,'(718)-626-1010')
c=1
@ 11,0 prompt '                           RETRY                           '
@ 12,0 prompt '                           IGNORE                          '
@ 13,0 prompt '                           CANCEL                          '
menu to selection
deactivate window error
release    window error
do case
   case selection =1
        retry
   case selection =3
        do crashout
   CASE SELECTION=2
        DEACTIVATE WINDOW ERROR
        RELEASE WINDOW ERROR
        RETURN
endcase
return


***************************************************************************
*                        crashout
***************************************************************************
procedure crashout

release windows all
SET COLOR TO W/N
CLEAR
*close databases
=putusers()
CANCEL
*QUIT
return



********************************************************************************
*                 CALCULATE TOTAL
********************************************************************************
FUNCTION ICALC_1_TOT
TOTAL1=BodIn1+PrpDm1+BaPIP1+Obelc1+AdPIP1+FADPIP1+MedPa1+StUnM1+VoUnM1+COMPR1+COLL1+EIP1
@16,60 get TOTAL1 picture '99999.9' disabled color ,,,,,,,,r/b,r/b
clear gets
RETURN .T.



***************************************************************************
*                     commit or abort ?
***************************************************************************
FUNCTION COMMITABORT
PRIVATE ACTION,TF,unique

define window UNIQUE from 8,19 to 14,67 float shadow NONE ;
              COLOR SCHEME 10 Title '[ RECORD ENTRY ? ]' in screen

activate window unique
*CLEAR
tf=.f.
   =center(1,'Do you wish to COMMIT this entry ?')
   =center(2,'Or would you rather ABORT it?')
   action=0

   ACTION=2
   SET COLOR TO W+/BG+,B+/W
   @ 4,1 prompt '                    ABORT                      '
   @ 5,1 prompt '                    COMMIT                     '
   menu to action
   tf=.f.
   if lastkey()=27
      tf=.f.
   else
    if action=2
       TF=.t.
    else
       TF=.f.
    endif
   endif
   deactivate window unique
   release windOw unique
RETURN TF


***************************************************************************
*                     post activity
***************************************************************************
function post_act
PARAMETER INVOICE,dACCTNO,TRANCD,QTY,PRICE,TOTAL,DATE,CLERK,DECRIPTION,POSTED,BILLED,CHECKNO,VVID

  if !used('activity')
     SELECT 24
     USE ACTIVITY index activity,DATE ALIAS ACTIVITY
  ELSE
     SELECT ACTIVITY
  ENDIF
  set order to tag acctno

APPEND BLANK
       REPLACE  DINVOICENO  WITH       INVOICE,;
                ACCTNO     WITH        dACCTNO,;
                DTRANCODE   WITH       TRANCD,;
                DQTY        WITH       QTY,;
                DPRICE      WITH       PRICE,;
                DTOTAL      WITH       TOTAL,;
                DDATE       WITH       DATE,;
                DCLERK      WITH       ALLTRIM(UPPER(CLERK)),;
                DDESCRIPT   WITH       ALLTRIM(UPPER(DECRIPTION)),;
                DPOSTED     WITH       POSTED,;
                DBILLED     WITH       BILLED,;
                DCHECKNO    WITH       ALLTRIM(UPPER(CHECKNO)),;
                DVIN        WITH       ALLTRIM(VVID)
RETURN



***************************************************************************
*                        function used
***************************************************************************
function recused
parameter dbase,rec
private tf
if lock(alltrim(str(rec)),(dbase))=.f.
   wait window "Record is in use,try again later" nowait
   tf=.t.
else
    tf=.f.
endif
*unlock in (dbase)
return tf

***************************************************************************
*                        function fname
***************************************************************************
function fname
parameter filename
return getenv('inmsname')+"\"+(filename)



***************************************************************************
*                        function SET PAGE LENGTH
***************************************************************************
FUNCTION SETPGLEN
RESTORE FROM COMEM additive
_PLENGTH=COPAGELEN
RETURN _PLENGTH


***************************************************************************
*                        procedure preview
***************************************************************************
procedure preview
parameter repname,filter

repstyle=1
if repstyle=1
   if val(sys(12))<15000
      ?? chr(7)
       wait window "Memory availlable "+sys(12) timeout 1
       wait window "This machine does not have enough memory for this report" timeout 1
       wait window "Try it on the SERVER" nowait
      return
   endif

   local=.f.

   if val(sys(12))<50000
      local=.t.
   endif

   size=diskspace()
   if size<500000
      ?? chr(7)
      wait window "Server Disk is almost full" timeout 1
      ?? chr(7)
      wait window "If you continue you might run into problems" nowait
      tf =acertain("Continue with program ?",.f.)
      if tf=.f.
         do getout
      endif
   endif
   save screen to q
   namex=fname("temp.txt")
   WAIT WINDOW "Coming UP" nowait
   if local=.f.
       if len(alltrim(filter)) > 0
          report form (repname) to file &namex noconsole FOR &FILTER
       ELSE 
          report form (repname) to file &namex noconsole
       ENDIF
   else
       if len(alltrim(filter)) > 0
          report form (repname) FOR &FILTER PREVIEW
       ELSE
          report form (repname) PREVIEW
       ENDIF
   endif
   wait clear
   if local=.f.
       namex=fname("temp.txt")
       *wait window (namex) nowait
       if filesize(namex) = 0
          ?? chr(7)
          wait window "This report is empty" timeout 1
          DELETE FILE &NAMEx
          return
       endif
   *    run /200k readme &namex
*   run readme &namex
        set topic to "EDITOR"
        if wexist('editor')
           release window editor
        endif
        set color to
*        set color of scheme 8 to gr+/b,gr+/b,n/w
        on key label f10 keyboard "{ctrl+w}"
        define window editor from 0,0 to 24,79 system shadow float ;
          color scheme 10 ;
          Title 'Report Viewer Screen';
          footer "Press  to Move , <PGUP> <PGDN> to Move Fast, <ESC> to Exit"
        save screen to sc

*        set color of scheme 8 to gr+/b,gr+/b,n/w
*       activate window editor
                        modify file (namex) window editor noedit
       deactivate window editor
       release window editor
       restore screen from sc
       on key label f10
   endif
	restore screen from q
else  && different report style
       if len(alltrim(filter)) > 0
          report form (repname) FOR &FILTER PREVIEW
       ELSE
          report form (repname) PREVIEW
       ENDIF
endif
RETURN


***************************************************************************
*                        procedure preview
***************************************************************************
procedure LASER
parameter repname,filter

if (!file("rreports.dbf")) or (!file("rruntime.exe"))
   ?? chr(7)
   ?? chr(7)
   ?? chr(7)
   ?? chr(7)
   wait window "Please no Hacking" timeout 4
   return
endif
*?? filter
OLDALIAS=ALIAS()
set exclusive off
IF !USED('RREPORTS')
   SELECT 21
   USE RREPORTS ALIAS RREPORTS
ELSE
    SELECT RREPORTS
ENDIF

   save screen to q
   namex=fname("RREP")
   WAIT WINDOW "Coming UP" nowait
   LOCATE FOR ALLTRIM(UPPER(RI_REPORT))=UPPER(ALLTRIM(REPNAME))
   IF !FOUND()
      ?? CHr(7)
      WAIT WINDOW "NO such report" timeout 1
      return
   endif
   NUMBER=ALLTRIM(STR(RECNO('RREPORTS')))
   if !lock(number,'RREPORTS')
      ?? chr(7)
      wait window "Somebody else is Doing this report now"  timeout 1
      wait window "Please try again in a while" Timeout 2
      return
   endif
   outp=laserchoic()
   replace ri_printer with ALLTRIM(STR(outp));
           RI_FILTER WITH FILTER
   unlock in rreports
*   ? number
*   ? repname
*   ? filter
*   ? space(59)+"|"
   run rruntime rreports &number &namex/O /Y
   do while !lock(number,'RREPORTS') do
   enddo
   replace ri_printer with "0";
           RI_FILTER WITH space(50)

unlock in rreports
use
IF LEN(OLDALIAS)>0
   SELECT &OLDALIAS
ENDIF
RETURN

***************************************************************************
*     Procedure strip
***************************************************************************
procedure strip
parameter namex
private string1,string2

name2=fname("strip.txt")
file2=fcreate(name2)
file1=fopen(namex)
if file1=-1 or file2=-1
   =fclose(file1)
   =fclose(file2)
endif
string1=fread(file1,1)
do while ferror()=0
string2=""
for i=1 to len(string1)
    if asc(substr(string1,i,1)) > 31
       string2=string2+substr(string1,i,1)
    endif
endfor
=fputs(file2,string2)
string1=fgets(file1,256)
enddo

   =fclose(file1)
   =fclose(file2)
copy file &name2 to &name1
delete file &name2
return

***************************************************************************
*                        procedure help
***************************************************************************
procedure helpme
push key clear
*if !wexist('HELPWIN')
*   define window helpwin from 0,0 to 24,79 system float shadow in screen color scheme 10
*endif
*activate window helpwin
*help in window helpwin
*deactivate window helpwin
help in window screen
pop key
return

***************************************************************************
*                        procedure filesize
***************************************************************************
function filesize
parameter namex
private size,file

file=fopen(namex)
if file=-1
*    tf=fclose(file)
   return 0
endif
STORE FSEEK(file, 0, 2) TO size && Move pointer to EOF
tf=fclose(file)
return size


***************************************************************************
*                  REMOVE TEMPORARY FILES
***************************************************************************
PROCEDURE REMOVETEMP
         a=fname("temp.dbf")
         if file(a)
            delete file &a
         endif
         a=fname("temp1.dbf")
         if file(a)
            delete file &a
         endif
         a=fname("temp2.dbf")
         if file(a)
            delete file &a
         endif
         a=fname("temp3.dbf")
         if file(a)
            delete file &a
         endif
         a=fname("temp.TXT")
         if file(a)
            delete file &a
         endif
         a=fname("STRIP.TXT")
         if file(a)
            delete file &a
         endif
         a=fname("SCREEN.TXT")
         if file(a)
            delete file &a
         endif
         a=fname("res.mem")
         if file(a)
            delete file &a
         endif
         a=fname("root.mem")
         if file(a)
            delete file &a
         endif
         a=fname("MAINSC.mem")
         if file(a)
            delete file &a
         endif
         a=fname("COVSC.mem")
         if file(a)
            delete file &a
         endif
         a=fname("CEHSC.mem")
         if file(a)
            delete file &a
         endif
RETURN


***************************************************************************
*                  rebuildidx
***************************************************************************
procedure rebuildidx
set color to w+/b,b/w
define window suppinfo from 5,20 to 7,60 title " NOW " SHADOW FLOAT color scheme 2
activate window suppinfo
SET TALK ON
SET TALK WINDOW
CLOSE DATA
SET EXCLUSIVE ON


         =center(0,'Rebuiling CLIENT  index')
         if !used('client')
            select a
            use client 
         else
             select client
         endif
         index on acctno tag acctno of client  compact
         index on lastn  tag lastn  of client   compact

         =center(0,'                       ')
         =center(0,'Rebuiling VEHICLE index')
         if !used('VEHICLE')
            select B
            use VEHICLE
         else
             select vehicle
         endif
         index on vin          tag vin     of vehicle compact
         index on acctno       tag acctno  of vehicle compact
         INDEX ON PLATES       TAG PLATES  OF VEHICLE COMPACT
         index on year         tag year    of vehicle compact

         =center(0,'                       ')
         =center(0,'Rebuiling PREMIUM index')
         IF !USED('coverage')
            select c
            use coverage
         else
           select coverage
         endif
         index on vin     tag vin     of coverage  compact
         INDEX ON DPID    tag dpid    of coverage  compact
         INDEX ON iidno   tag iidno   of COverage  compact
         index on acctno tag acctno   of coverage  compact

         =center(0,'                        ')
         =center(0,'Rebuiling INS. COMPANY index')
         IF !USED('icompany')
            select d
            use icompany
         else
           select icompany
         endif
         index on inumber tag inumber of icompany compact
         index on iname   tag iname   of icompany COmpact
         index on iIDNO   tag iiDNO   of icompany compact

         =center(0,'                            ')
         =center(0,'Rebuiling POLICY  index')
         if !used('POLICY')
            select e
           use POLICY
         else
             select policy
         endif
         index on policyno tag policyno of policy compact
         index on dpid     tag dpid     of policy compact
         index on acctno   tag acctno   of policy compact
         index on iidno    tag iidno   of policy  compact


         =center(0,'Rebuiling DRIVER  index')
         if !used('driver')
            select f
           use driver
         else
             select driver
         endif
         index on dpid tag dpid of driver   compact

         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling SERVICE CODES index')
         if !used('codes')
            select g
            use codes 
         else
             select codes
         endif
         index on dcdnum to codenum

       @ 0,0 to 0,79 clear
       =center(0,'Rebuiling INSTALLMENT index')
       if !used('installm')
          select 11
          use installm
       else
          SELECT installment
       endif
       index on dpid    tag dpid   of installm   compact
       index on acctno  tag acctno of installm   compact
       index on iidno   tag iidno  of installm   compact
       index on dtype   tag dtype  of installm   compact
       index on ddate   tag ddate  of installm   compact

       @ 0,0 to 0,79 clear
       =center(0,'Rebuiling INVOICE index')
       if !used('invoice')
          select 13
          use INVOICE
       else
          SELECT INVOICE
       endif
       INDEX ON ACCTNO tag acctno of INvoice compact
       index on DINVNO tag invno  of INVOICE compact
       index on idate  tag idate  of invoice compact descending
       index on dcode  tag code   of invoice compact


       @ 0,0 to 0,79 clear
       =center(0,'Rebuiling DOCUMENT index')
       if !used('document')
          select 14
          use document
       else
          select document
       endif
       index on dpid tag dpid of polid compact



         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling ADJUSTMENT CODES index')
         if !used('adj')
            select h
            use adj 
         else
             select adjustment
         endif
         index on dadjnum to ADJNUM

         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling PAYMENT CODES index')
         if !used('paycode')
            select i
            use paycode
         else
             select paycode
         endif
         index on dtype to paynum


         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling COMMISSION index')
         if !used('comision')
            select 12
            use comision 
         else
            select comision
         endif
         index on dpid   tag dpid   of comision compact
         index on acctno tag acctno of comision compact
         index on date   tag date   of comision compact
         index on iidno  tag iidno  of comision compact


         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling ACTIVITY index')
         if !used('activity')
            SELECT 24
            USE ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF
         index on acctno   tag acctno of activity compact
         index on dtrancode tag actcode of activity compact
         index on ddate     tag ddate   of activity compact
         index on ddate     to date

SET TALK OFF
deactivate window suppinfo
release window suppinfo
CLOSE DATA
*wait window "Done" nowait
wait clear
return


***************************************************************************
*                  packdatabases
***************************************************************************
procedure packdatabases

set talk on
set talk window
if !wexist('maininfo')
   define window maininfo from 5,19 to 7,59 title ' CURRENTLY ' shadow float double
endif
activate window maininfo
         close data
         set color to
         clear
         =center(0,'Packing  CLIENT  Database')
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         pack

         set color to
         clear
         =center(0,'Packing VEHICLE  database')
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         pack

         set color to
         clear
         =center(0,'Packing  POLICY  database')
         if !used('POLICY')
            select C
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         pack

         set color to
         clear
         =center(0,'Packing  DRIVER  database')
         if !used('driver')
            select f
           use driver index driver alias driver
         else
             select driver
         endif
         pack

         set color to
         clear
         =center(0,'Packing PREMIUM database')
         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         pack

         set color to
         clear
         =center(0,'Packing INSURANCE database')
         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         pack

         set color to
         clear
         =center(0,'Packing SERVICE CODES database')
         if !used('codes ')
            select g
           use codes  index codenum alias codes
         else
             select codes
         endif
         pack

         set color to
         clear
       =center(0,'Packing INSTALLMENT database')
       if !used('installm')
          select 11
          use installm index install alias installment
       else
          SELECT installment
       endif
       pack

         set color to
         clear
       =center(0,'Packing DOCUMENTS database')
       if !used('document')
          select 14
          use document index polid alias document
       else
          select document
       endif
       pack

         set color to
         clear
       =center(0,'Packing ACTIVITY database')
         if !used('activity')
            SELECT 24
            USE ACTIVITY index activity,date ALIAS ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF
         pack
*         @ 0,0 to 0,79 clear
*         =center(0,'Packing ADJUSTMENT CODES database')
*         if !used('adj')
*            select h
*            use adj index adjnum alias adjustment
*         else
*             select adjustment
*         endif
*         pack

deactivate window maininfo
set talk off
wait clear
return


*****************************************************************
*            Procedure CALCK
*****************************************************************
procedure CALCK
SET TALK OFF
define window comem from 2,2 to 22,76 ;
       title " Company Information ";
       float shadow system;
       Footer "Press <F10> to Accept new data, <ESC> to Quit";
       color scheme 10
   STORE SPACE(30) TO coconame, coaddr1, coaddr2,COPASS
   STORE SPACE(18) TO netinfo
   STORE SPACE(13) TO cophone

* get new values
mok=.F.
mok1=.F.
size=0
cluster=0
minfo=0
cpu=0
done=.f.

activate window comem
on key label f10 keyboard "{ctrl+w}"
do while done=.f.
   CLEAR
   @  0,0 say '         1         2         3         4         5         6         7  '
   @  1,0 say '1234567890123456789012345678901234567890123456789012345678901234567890123'
   @  2,6 say "Network info " get netinfo picture replicate('X',18)

   @  4,6 SAY "Company Name" GET coconame SIZE 1,30
   @  6,8 say "Disk space" get size picture '999999999999'
   @  8,6 say "Cluster Size" get cluster picture '99999'
   @ 10,10 say "CPU type" get cpu picture '99999'
   @ 12,10 say "Memory Info" get minfo picture '99999999'

   READ cycle

   lastk=lastkey()
   if lastk<>27
        =hash(UPPER(ALLTRIM(coconame)))
        =sechash(UPPER(ALLTRIM(NETINFO)),SIZE,CLUSTER,CPU,minfo)
    else
        done=.t.
    endif
enddo
deactivate window comem
release window comem
on key label f10
set exclusive off
RETURN



***************************************************************************
*                  which day
***************************************************************************
procedure getdate

wait clear

save screen to wm
set color to gr+/b,b/w
define window dates from 3,30 to 8,50 Title '[ DATE ]' shadow float COLOR SCHEME 10
activate window dates

lk=27
SET COLOR TO N/W,W/BG+
CLEAR
do while lk = 27
      =center(0,'Start Date Please')
      start=date()-7
      @1,5 get start picture '@d'
      =center(2,'End Date Please')
      end=date()
      @3,5 get end picture '@d'
      read
      lk=lastkey()
enddo
*on key label enter
deactivate window dates
release window dates
restore screen from wm
date1=start
date2=end
return



***************************************************************************
*                        HASH GENERATOR
***************************************************************************
FUNCTION HASH
PARAMETER S
R=0.0
L=LEN(S)
FOR I=1 TO L
        C=SUBSTR(S,I,1)
        R=16*R+ASC(C)
ENDFOR
NUMBER=ALLTRIM(SUBSTR(ALLTRIM(STR(R,20)),2,14))
L=LEN(NUMBER)
IF L<14
        if mod(l,2)=0
                NUMBER=REPLICATE('6',INT((14-L)/2))+NUMBER+REPLICATE('6',INT((14-L)/2))
        ELSE
                NUMBER=REPLICATE('6',INT((14-L)/2)+1)+NUMBER+REPLICATE('6',INT((14-L)/2))
        ENDIF
ENDIF
wait window "Customer Key "+number
RETURN NUMBER
RETURN

***************************************************************************
*                        Second HASH GENERATOR
***************************************************************************
FUNCTION SECHASH
parameter  name,size,cluster,cpu,minfo
S=ALLTRIM(UPPER(name))
R=0.0
L=LEN(S)
FOR I=1 TO L
        C=SUBSTR(S,I,1)
        R=16*R+ASC(C)
ENDFOR
r=r+size+cluster*cpu+minfo

NUMBER=ALLTRIM(SUBSTR(ALLTRIM(STR(R,25)),4,14))
L=LEN(NUMBER)
IF L<14
        if mod(l,2)=0
                NUMBER=REPLICATE('8',INT((14-L)/2))+NUMBER+REPLICATE('6',INT((14-L)/2))
        ELSE
                NUMBER=REPLICATE('8',INT((14-L)/2)+1)+NUMBER+REPLICATE('6',INT((14-L)/2))
        ENDIF
ENDIF
wait window "Workstation Key "+number
RETURN NUMBER
RETURN


***************************************************************************
*                        getout
***************************************************************************
procedure getout
set color to b/n
if ! used('system')
   select 25
   use system
endif
    set color to w/n
    deactivate menu rootmenu
    clear all
    for i=79 to 0 step -1
        scroll 0,0,24,79,0,-1
    endfor
release windows
release windows
release windows
release windows
SET COLOR TO W/N
do removetemp
wait CLEAR

SET TALK OFF
on error
close databases
clear all
CLEAR
CANCEL
return

function Strip
parameter s
private first result
first=at(' ',s)
if first<=8
        result=substr(s,1,first)
else
        result=substr(s,1,8)
endif
return upper(result)

