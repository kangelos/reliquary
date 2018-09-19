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
*	set color to w+/r*
*	@ row,0 say space(80)
        column=int( (wcols()-len(message)) /2 )
        @ row,column say message        
return  .t.

***************************************************************************
*                  center text on the screen with color
***************************************************************************
function centerc
parameter row,message,mycolor
private column
        column=int( (wcols()-len(message)) /2 )
        @ row,column say message color &mycolor
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
function OLDacertain
parameter string,def
private yesno,TF,column

if def=.f.
   yesno=1
else
   yesno=2
endif
set color to
define window sure from 7,19 to 12,59 none float shadow  ;
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
*                  procedure yesno
***************************************************************************
function acertain
parameter string,def
private YES,NO,column

repl=msgbox(string,"Query",36)

if repl=6
	return .t.
else 
	return .f.
endif

yes=0
no=0


define window sure AT 7,19 SIZE 8,40 none float shadow in desktop ;
       title 'ARE YOU SURE ?' color r/w* font "TimesRoman" style "B"

activate window sure

set color to
clear
column=(40-len(string))/2
@ 1,1 say "help.bmp" bitmap
@ 2,column+1 say (string)
@ 5,8 GET NO FUNCTION '* No' size 2,8
@ 5,24 GET YES FUNCTION '* Yes' size 2,8
READ cycle
deactivate window sure
release window sure
*set color to w/n
*wait window "Yes="+str(yes)+",No="+str(no)

if lastkey()=27
   return .f.
endif

if NO=1
	return .f.
endif
* ALl other cases
return .t.



***************************************************************************
*                  procedure select output
***************************************************************************
function OLDspf
private yesno,TF,column,PRETTY

String="Where do you want the output to go ?"
   yesno=1
PRETTY=GETLASER()
IF PRETTY
    define window sure from 7,22 to 15,64  NONE float shadow  ;
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
    define window sure from 7,22 to 13,64  float shadow  NONE ;
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
*                  procedure select output
***************************************************************************
function spf
private yesno,TF,column,PRETTY,yes,no
yes=0
no=0

String="Where do you want the output to go ?"
yesno=1
define window sure AT 7,22 SIZE 9,45  in desktop float shadow system ;
           grow title 'Report Selector' COLOR SCHEME 10 font "Arial",9
activate window sure
set color to
clear
=center(1,"Where do you want this report to go ? ")
@ 2,15 GET YESNO FUNCTION "*R ON SCREEN;HARD COPY" size 2,10
@ 6,13 get yes function "* OK" size 2,8
@ 6,26 get no function  "* Cancel" size 2,8
READ CYCLE

if no=1
    yesno=0
endif
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
       Title '[ ENTRY FINISHED ]' 

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




***************************************************************************
*                     cvalid  update the total field
***************************************************************************
function cvalid
 ctotal=cthirty+csixty+cninety+conetwenty
 @ 20,61 say ctotal picture '999,999.99' color r/b
return .t.




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
*                        get new property number
***************************************************************************
function gethomid
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

number=system.homno
number=number+1
replace system.homno with number
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
*                        get new receipt number
***************************************************************************
function getrecno
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

number=system.receipt
number=number+1
replace system.receipt with number
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
=center(15,'Please call the technical support')
=center(17,'Make sure you print a snapshot of this screen')
=center(18,'by pressing [Shift]+[Prt Sc]')

set color to w+/r,r+/w
=center(1,alLTRIM(STR(merror)) )
=center(3,mess)
=center(5,left(mess1,58))
=center(7,alLTRIM(STR(mlineno)) )
=center(9,mprog)
set color to W+/r,B/w
*=center(16,'(718) 204-585')
c=1
*@ 11,0 prompt '                           RETRY                           '
*@ 12,0 prompt '                           IGNORE                          '
*@ 13,0 prompt '                           CANCEL                          '
*menu to selection
@ 11,0 GET SELECTION FUNCTION '* RETRY; IGNORE; CANCEL' SIZE 3,40
READ CYCLE
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

define window UNIQUE from 8,19 to 19,67 float shadow system ;
              COLOR SCHEME 10 Title ' RECORD ENTRY ? ' font "Arial",11 ;
              in desktop

activate window unique
*CLEAR
tf=.f.
   =center(0,'Do you wish to COMMIT this entry ?')
   =center(1,'Or would you rather ABORT it?')
   action=0

   ACTION=2
   SET COLOR TO W+/BG+,B+/W
*   @ 4,1 prompt '                    ABORT                      '
*   @ 5,1 prompt '                    COMMIT                     '
*   menu to action
	@ 3,18 get action function '* Abort;Commit' size 1,15,1 font "Arial",13
	 read cycle
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


 if len(alltrim(filter)) > 0
          report form (repname) FOR &FILTER PREVIEW
       ELSE
          report form (repname) PREVIEW
       ENDIF
       
return 


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
        define window editor at 1,1 size 24,79 system shadow float grow ;
          color scheme 10 font "Fixedsys",11;
          Title 'Report Viewer Screen';
          footer "Press <PGUP> <PGDN> to Move Fast, <ESC> to Exit"
        save screen to sc

*        set color of scheme 8 to gr+/b,gr+/b,n/w
*       activate window editor
                        modify file (namex) noedit
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
*   define window helpwin from 0,0 to 24,79 system float shadow  color scheme 10
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
         delete tag all
         index on acctno tag acctno of client  compact
         index on ref_no tag ref_no of client  compact
         index on lastn  tag lastn  of client   compact

         =center(0,'                       ')
         =center(0,'Rebuilding VEHICLE index')
         if !used('VEHICLE')
            select B
            use VEHICLE
         else
             select vehicle
         endif
         delete tag all
         index on vin               tag vin      of vehicle compact
         index on dvehid            tag dvehid   of vehicle compact
         index on acctno            tag acctno   of vehicle compact
         INDEX ON PLATES            TAG PLATES   OF VEHICLE COMPACT
         index on year              tag year     of vehicle compact
         index on year+str(acctno)  tag combyear of vehicle compact
         index on year+vin          tag combyvin of vehicle compact

         =center(0,'                       ')
         =center(0,'Rebuiling Premium index')
         IF !USED('coverage')
            select c
            use coverage
         else
           select coverage
         endif
         delete tag all
         index on vin     tag vin     of coverage  compact
         index on dvehid  tag dvehid   of coverage compact
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
         delete tag all
         index on inumber tag inumber of icompany compact
         index on iname   tag iname   of icompany COmpact
         index on iIDNO   tag iiDNO   of icompany compact

         =center(0,'                            ')
         =center(0,'Rebuiling AUTO POLICY  index')
         if !used('POLICY')
            select e
           use POLICY
         else
             select policy
         endif
         delete tag all
         index on policyno tag policyno of policy compact
         index on dpid     tag dpid     of policy compact
         index on acctno   tag acctno   of policy compact
         index on iidno    tag iidno    of policy compact
         index on ctod(to) tag lastdate of policy compact


         =center(0,'Rebuiling DRIVER  index')
         if !used('driver')
            select f
           use driver
         else
             select driver
         endif
         delete tag all
         index on dpid tag dpid of driver   compact

         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling SERVICE CODES index')
         if !used('codes')
            select g
            use codes 
         else
             select codes
         endif
         delete tag all
         index on dcdnum to codenum

       @ 0,0 to 0,79 clear
       =center(0,'Rebuiling INSTALLMENT index')
       if !used('installm')
          select 11
          use installm
       else
          SELECT installment
       endif
         delete tag all
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
         delete tag all
       INDEX ON ACCTNO tag acctno of INvoice compact
       index on DINVNO tag invno  of INVOICE compact
       index on idate  tag idate  of invoice compact descending
       index on dcode  tag code   of invoice compact
       index on dpid  tag dpid   of invoice compact
       index on policyno  tag policyno   of invoice compact


       @ 0,0 to 0,79 clear
       =center(0,'Rebuiling DOCUMENT index')
       if !used('document')
          select 14
          use document
       else
          select document
       endif
         delete tag all
       index on dpid tag dpid of polid compact



         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling ADJUSTMENT CODES index')
         if !used('adj')
            select h
            use adj 
         else
             select adjustment
         endif
         delete tag all
         index on dadjnum to ADJNUM

         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling PAYMENT CODES index')
         if !used('paycode')
            select i
            use paycode
         else
             select paycode
         endif
         delete tag all
         index on dtype to paynum


         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling COMMISSION index')
         if !used('comision')
            select 12
            use comision 
         else
            select comision
         endif
         delete tag all
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
         delete tag all
         index on acctno   tag acctno of activity compact
         index on dtrancode tag actcode of activity compact
         index on ddate     tag ddate   of activity compact
         index on ddate     to date

         @ 0,0 to 0,79 clear
         =center(0,'Rebuiling REFFERENCE index')
       if !used('reffer')
          select 15
          use reffer alias refferance
       else
          select refferance
       endif
         delete tag all
       index on ref_no tag ref_no of reffer compact



         =center(0,'                       ')
         =center(0,'Rebuilding HOME index')
         if !used('home')
            select 30
            use home
         else
             select home
         endif
         delete tag all
          index on dhomid            tag dhomid   of home compact
          index on acctno            tag acctno   of home compact
          index on year              tag year     of home compact
          index on iidno             tag iidno    of home compact
*         index on year+str(acctno)  tag combyear of home compact
*         index on year+vin          tag combyvin of home compact

*         =center(0,'                            ')
*         =center(0,'Rebuiling HOME POLICY  index')
*         if !used('HOMPOL')
*            select 31
*           use hompol
*         else
*             select hompol
*         endif
*         index on policyno tag policyno of hompol compact
*         index on dpid     tag dpid     of hompol compact
*         index on acctno   tag acctno   of hompol compact
*         index on iidno    tag iidno   of  hompol compact

SET TALK OFF
deactivate window suppinfo
release window suppinfo
CLOSE DATAbases
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


         set color to
         clear
         =center(0,"Packing PRINTERS' database")
         if !used('PRINTERS')
            SELECT 20
            USE PRINTERS ALIAS PRINTERS
         ELSE
            SELECT PRINTERS
         ENDIF
         pack



         set color to
         clear
         =center(0,"Packing REFFERENCES' database")
       if !used('reffer')
          select 15
          use reffer index reffer alias refferance
       else
          select refferance
       endif
       set order to tag ref_no
       pack

         set color to
         clear
         =center(0,'Packing HOME database')
         if !used('home')
            select 30
            use home
         else
             select home
         endif
         pack

*         set color to
*         clear
*         =center(0,'Packing HOME database')
*         if !used('home')
*            select 31
*            use hompol
*         else
*             select hompol
*         endif
*         pack
deactivate window maininfo
set talk off
wait clear
return


*****************************************************************
*            Procedure Comem
*****************************************************************
procedure comem
private c,yes,no

yes=0
no=0

c=' '
SET TALK OFF
define window comem at 1,10 size 21,64 in desktop;
       title "System Information" float shadow system nogrow noclose;
       Footer "Press <F10> to Accept new data, <ESC> to Quit";
       color scheme 10 font "FixedSys",9
       
if file("c:\\dos\\ext2ems.sys")
        handle=fopen("c:\\dos\\ext2ems.sys")
        if handle<0
                ?? chr(7)
                wait window "Cannot Read workstation key" timeout 5
                workkey=space(14)
        else
                for i=1 to 12
                        c=fread(handle,1024)
                endfor
                workkey=fgets(handle,14)
                =fclose(handle)
        endif
else
        workkey=space(14)
endif

IF FILE("comem.mem")
   RESTORE FROM comem ADDITIVE
   copsetup=SUBSTR(copsetup+SPACE(70),1,70)
   copreset=SUBSTR(copreset+SPACE(70),1,70)
   coconame=Upper(SUBSTR(coconame+SPACE(30),1,30))
   cocobroker=Upper(SUBSTR(cocobroker+SPACE(30),1,30))
   coaddr1=Upper(SUBSTR(coaddr1+SPACE(30),1,30))
   coaddr2=Upper(SUBSTR(coaddr2+SPACE(30),1,30))
   cophone=SUBSTR(cophone+SPACE(13),1,13)
   cofax=SUBSTR(cofax+SPACE(13),1,13)
   coLINE1=upper(left(SUBSTR(coLINE1+SPACE(48),1,48),8))
   coLINE2=upper(left(SUBSTR(coLINE2+SPACE(48),1,48),8))
   coLINE3=Upper(SUBSTR(coLINE3+SPACE(48),1,48))
   copass=Upper(SUBSTR(copass+SPACE(48),1,28))
*   cname=fname("cobars.mem")
*   if file(cname)
*      restore from &cname additive
*   else
*      cobars=.t.
*   endif
   cofast=.f.
ELSE
   STORE "Customer-Account System" TO cotitle
   STORE SPACE(70) TO copsetup,copreset
   store space(8) to coline1,coline2,coline3
   STORE 0 TO copmargin
   STORE 55 TO copagelen
   STORE SPACE(30) TO coconame,cocobroker, coaddr1, coaddr2,COPASS
   STORE SPACE(13) TO cophone,cofax
   conumbers=.t.
   cofast=.f.
   store 0 to cotaxrate
*   cname=fname("cobars.mem")
*   if file(cname)
*      restore from &cname additive
*   else
*      cobars=.t.
*   endif
   cofast=.f.
ENDIF

* get new values
mok=.F.
mok1=.F.
activate window comem
on key label f10 keyboard "{ctrl+w}"
  
*DO WHILE .not.mok
   * Display data entry screen
   set color to w+/w,w+/bg
   clear
*   =center(18,"Press F10 to accept new data, ESC otherwise")
*   @  0,  2 SAY "PRINTER LEFT MARGIN:"  GET copmargin PICTURE "999" RANGE 0,132
*   @  1,  40 SAY "PRINTER PAGE LENGTH:" GET copagelen PICTURE "99" RANGE 1, 99
*   @  2,  2 SAY "SETUP COMPRESSED PRINT:"
*   @  3,1 GET copsetup
*   @  4,  2 SAY "RESET PRINTER TO NORMAL:"
*   @  5,1 GET copreset
*   @ 0,0 say '         1         2         3         4         5         6         7  '
*   @ 1,0 say '1234567890123456789012345678901234567890123456789012345678901234567890123'
*  =center(2,"'"+sys(0)+"',"+sys(2020)+","+sys(2022)+","+sys(17)+","+sys(1001))
*   @ 3,0 say replicate (' ',73) color w/w
*   =centerc(3," Installation Information ",'gr+/w')
   @   2, 11 SAY      "BROKER NAME:" get cocobroker
   @   3, 10 SAY     "COMPANY NAME:" get coconame
   @   4, 15 SAY         "ADDRESS:" get coaddr1
   @   5, 6 SAY "CITY, STATE, ZIP:" get coaddr2
   marcode=left(cophone,3)
   mphone=substr(cophone,4,8)
   mfarcode=left(cofax,3)
   mfphone=substr(cofax,4,8)
   @   7, 10 SAY  "PHONE NUMBER:(   )"
   @   8, 12 SAY "FAX NUMBER:(   )"
   @   7, 24 GET marcode
   @   7, 28 GET mphone
   @   8, 24 GET mfarcode
   @   8, 28 GET mfphone
   mkey=getkey()
   @   10, 10 say 'CUSTOMER KEY:' get mkey size 1,14 picture '99999999999999'
   @   11,7 say 'WORKSTATION KEY:' get workkey size 1,14 picture '99999999999999'
   @  13, 14 SAY "Screen Banner Line  1 :" GET coLINE1
   @  14, 14 SAY "Screen Banner Line  2 :" GET coLINE2
   @  16,1 Say "Administrative Password" get copass
*   @  18, 56 Say "Bar Menus ?" get cobars pict '@L Y;N'
   *@  18, 30 Say "Fast Start ?" get cofast pict '@L Y;N'
   conumbers=.t.
   @ 18,22 get yes function '* Accept' size 2,7
   @ 18,35 get no function  '* Cancel' size 2,7

   READ cycle
   cophone=marcode+mphone
   cofax=mfarcode+mfphone
   coline2=upper(coline2)
*   @ 17, 1 SAY SPACE(78)

*    lastk=lastkey()
*    if lastk=23 or lastk=27
*       mok=.t.
*    endif
*ENDDO

on key label f10



if yes=0 or no=1
   deactivate window comem
   release window comem
   return
else
     tf=acertain("Accept this data ?",.t.)
endif

* If ok, Save new memory file
IF tf=.t.
   coLINE1=allTRIM(upper(coLINE1))
   coLINE2=upper(allTRIM(coLINE2))
   coLINE3=upper(allTRIM(coLINE3))
   copsetup=upper(allTRIM(copsetup))
   copreset=upper(allTRIM(copreset))
   coconame=upper(allTRIM(coconame))
   cocobroker=upper(allTRIM(cocobroker))
   coaddr1=upper(allTRIM(coaddr1))
   coaddr2=upper(allTRIM(coaddr2))
   coPASS=upper(allTRIM(coPASS))

   SAVE TO comem ALL LIKE co*
*   name=fname('cowork.mem')
*   save to &name all like workkey
   set exclusive on
   if !used('SYSTEM')
      SELECT 25
      USE SYSTEM ALIAS SYSTEM
   ELSE
      SELECT SYSTEM
   ENDIF
   set exclusive off
   REPLACE SYSTEM.COMPANYNAM WITH COCONAME,;
           system.key        with mkey,;
           system.barmenu    with .t.

*      cname=fname("cobars.mem")
*      delete file &cname
*      save all like cobars to &cname
      
      handle=fcreate("coname.txt")
      if handle<0
         ?? chr(7)
         wait window "Cannot Open/Create Coname.txt"
      else
          =fwrite(handle,upper(alltrim(coconame)),25)
          =fclose(handle)
      endif

      handle=fcreate("fullname.txt")
      if handle<0
         ?? chr(7)
         wait window "Cannot Open/Create Fullname.txt"
      else
          temp=space(25)
          temp=stuff(temp,1,len(coconame),coconame)
          =fputs(handle,temp,25)

          temp=space(25)
          temp=stuff(temp,1,len(coaddr1),coaddr1)
          =fputs(handle,temp,25)

          temp=space(25)
          temp=stuff(temp,1,len(coaddr2),coaddr2)
          =fputs(handle,temp,25)

          temp=space(25)
          temp=stuff(temp,1,14,"("+left(cophone,3)+") "+right(cophone,8))
          =fputs(handle,temp,25)
          =fclose(handle)
     endif


      handle=fcreate("c:\\dos\\ext2ems.sys")
      if handle<0
         ?? chr(7)
         wait window "Cannot Open/Create Workstation key file"
      else
         for i=1 to 12
                c=replicate(str(irand(1024,2048),4),256)
                =fwrite(handle,c,1024)
         endfor
         =fwrite(handle,workkey,14)
         for i=1 to 16
                c=replicate(str(irand(1024,2048),4),256)
                =fwrite(handle,c,1024)
         endfor
         =fclose(handle)
      endif


        deactivate window comem
        release window comem
        on key label f10
        set exclusive off
ENDIF
      ?? chr(7)
      ?? chr(7)
      wait window "Please Restart This program" TIMEOUT 3
      DO MBMEM
      DO GETOUT
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

define window dates at 3,30 size 11,28 Title 'DATES' ;
system shadow float grow COLOR SCHEME 10 ;
font "Arial",10 style "B"

activate window dates
dummy=1

lk=27
*SET COLOR TO N/W,W/BG+
SET COLOR TO r/w*,w+/bg
clear
	@ 0,11 say "query.bmp" bitmap
*do while lk = 27
      =center(3,'Start Date Please')
      start=date()
      @4,8 get start picture '@d'
      
      =center(6,'End Date Please')
      end=date()+7
      @7,8 get end picture '@d'
      
      @9,11 get dummy function "* OK "
      read cycle
*      lk=lastkey()
*enddo
*on key label enter
deactivate window dates
release window dates
restore screen from wm
date1=start
date2=end
return


***************************************************************************
*                  external programs caller
***************************************************************************
procedure dosupport
parameter selection,command
CLOSE DATABASES
do case
   case selection=1
        run nyaip.bat
   case selection=2
        run nyMC.bat
   case selection=3
        a='MODEM.MEM'
        TEMPFILE=getenv('INMSNAME')
        IF FILE(a)
           restore from &a additive
           ?? chr(7)
           wait window "The User on "+tempfile+" is using the MODEM" timeout 1
           wait window "Please Try Again In a few Minutes" timeout 1
        else
            SAVE ALL LIKE TEMPFILE TO &A
            run MV.bat
            DELETE FILE &A
        endif
   case selection=4
        set topic to "EDITOR"
        if wexist('editor')
           release window editor
        endif
        set color to
        on key label f10 keyboard "{ctrl+w}"
        define window editor from 0,0 to 24,79 system shadow float ;
                      color scheme 10 ;
                      footer "Press <F10> to Save, <ESC> to Abort"
        save screen to sc
*       activate window editor
                        modify file ? 
       deactivate window editor
       release window editor
       restore screen from sc
       on key label f10
        set topic to "REPORTS"
*       set default to
   case selection=5
        filename=alltrim(command)
        if file(filename)
           do prnchoic
           set console off
           wait window "Now Printing File:"+filename nowait
           set topic to "EDITOR"
           type &filename to printer
           eject
           set printer to lpt1:
           set console on
           wait clear
           set topic to "SUPPORT"
        else
            wait window "File Does not Exist" timeout 3
        endif
   case selection=6
       CLEAR
       run &command
   case selection=7
       wait window "ELIAS is Receiving" nowait
       run "net run \\elias fn&command"
       run "net run/nocr \\elias ofe"
       wait clear
   case selection=8
       wait window "RUBIA is Receiving" nowait
       run "net run \\rubia fn&command"
       run "net run/nocr \\rubia ofe"
       wait clear
   case selection=9
       wait window "NIKOS is Receiving" nowait
       run "net run \\nikos fn&command"
       run "net run/nocr \\nikos ofe"
       wait clear
   case selection=10
        run prgr.bat
   case selection=11
        run nd.bat
   case selection=12
        run nu-main.bat
   case selection=13
       CLEAR
       run &command
   case selection=14
       CLEAR
       run &command
   case selection=15
       CLEAR
       run &command
endcase
return


***************************************************************************
*                  choose printer
***************************************************************************
function laserchoic
PRIVATE NUMBER
define window local from 4,20 to 18,48 color w/rb+,w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+;
       shadow float Title " DEVICES "
activate window local

optopt=0
do while optopt < 8
set color to w/rb+,n/w
@  1,6 prompt '     PRN:      '
@  3,6 prompt '     LPT1:     '
@  5,6 prompt '     LPT2:     '
@  7,6 prompt '     LPT3:     '
@  9,6 prompt '     COM1:     '
@ 11,6 prompt '     COM2:     '
*@ 13,6 prompt '   DISK FILE   '
*@ 15,6 prompt ' Quit  Choices '

menu to optopt
if lastkey()=27
   deactivate window local
   release window local
   return
endif

do case
   case optopt=1
        set printer to PRN:
        optopt=8 && terminate the loop
        NUMBER=0
   case optopt=2
        set printer to LPT1:
        optopt=8 && terminate the loop
        NUMBER=1
   case optopt=3
        set printer to LPT2:
        optopt=8 && terminate the loop
        NUMBER=2
   case optopt=4
        set printer to LPT3
        optopt=8 && terminate the loop
        NUMBER=3
   case optopt=5
        set printer to COM1:
        optopt=8 && terminate the loop
        NUMBER=4
   case optopt=6
        set printer to COM2:
        optopt=8 && terminate the loop
        NUMBER=5
endcase
optopt=8 && terminate the loop
enddo

CLEAR
*do printselect

deactivate window local
release window local
RETURN NUMBER
return


***************************************************************************
*                  prune activity log
***************************************************************************
procedure prune
         if !used('activity')
            SELECT 24
            USE ACTIVITY index activity,date ALIAS ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF
wait window "Please Specify Dates to be removed" timeout 1
date1={  /  /  }
date2={  /  /  }
do getdate
tf=acertain("Delete all Those Activity Records",.f.)
if tf
   delete for (ddate>=date1 .and. ddate<=date2)
endif

    if wexist('browser')
      release window browser
    endif

       define window browser from 6,10 to 20,68;
          Title "Activity Log Listing    Press <ESC> to Exit" color scheme 10 float none shadow;
          footer "Press  to Move, <ESC> to Exit"
browse noedit window browser
?? chr(7)
wait window "Don't Forget to PACK the databases" timeout 1
return


function display_bar
pct=(recno()*100)/reccount()
@ 18,14 say replicate(chr(219),(pct/2)+1)
return .t.

******************************************************************************
* Utility programs
******************************************************************************
procedure calcme
PRIVATE SC
     save screen to sc
     set color to gr+/r
     @ 24,0 to 24,79 clear
     on key label esc keyboard "{ctrl+w}"+"{enter}"
     =center(24,'---   Press <ESC> to exit   ---')
     activate screen
     activate window calculator
     read valid .t.
     restore screen from sc
     on key label esc
return


procedure calend
PRIVATE SC
     save screen to sc
     set color to gr+/r
     @ 24,0 to 24,79 clear
     on key label esc keyboard "{ctrl+w}"+"{enter}"
     =center(24,'---   Press <ESC> to exit   ---')
     activate screen
     activate window calendar
     read valid .t.
     restore screen from sc
     on key label esc
return


procedure puz
PRIVATE SC
     save screen to sc
     set color to gr+/r
     @ 24,0 to 24,79 clear
     on key label esc keyboard "{ctrl+w}"+"{enter}"
     =center(24,'---   Press <ESC> to exit   ---')
     activate screen
     activate window puzzle
     read valid .t.
     restore screen from sc
     on key label esc
return


procedure asc
PRIVATE SC
     save screen to sc
     set color to gr+/r
     @ 24,0 to 24,79 clear
     on key label esc keyboard "{ctrl+w}"+"{enter}"
     =center(24,'---   Press <ESC> to exit   ---')
     activate screen
     activate window ascii
     read valid .t.
     restore screen from sc
     on key label esc
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
*wait window number
RETURN NUMBER

***************************************************************************
*                        Second HASH GENERATOR
***************************************************************************
FUNCTION SECHASH
S=ALLTRIM(UPPER(sys(0)))
R=0.0
L=LEN(S)
FOR I=1 TO L
        C=SUBSTR(S,I,1)
        R=16*R+ASC(C)
ENDFOR
r=r+val(sys(2020))+val(sys(2022))*val(sys(17))
r=r*123477
*r=r+val(hash(progname))

NUMBER=ALLTRIM(SUBSTR(ALLTRIM(STR(R,25)),4,14))
L=LEN(NUMBER)
IF L<14
        if mod(l,2)=0
                NUMBER=REPLICATE('8',INT((14-L)/2))+NUMBER+REPLICATE('6',INT((14-L)/2))
        ELSE
                NUMBER=REPLICATE('8',INT((14-L)/2)+1)+NUMBER+REPLICATE('6',INT((14-L)/2))
        ENDIF
ENDIF
*wait window number
RETURN NUMBER


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

FUNCTION irand
PARAMETER i, j
RETURN int((j-i+1)*rand()+i)




******************************************************************************
*                   loss payee update screen
******************************************************************************
function vlupdate
parameter vloss
if vloss=.t.
    vlessname=stuff(vlessname,1,;
    LEN(ALLTRIM(CLIENT.SALUT)+' '+ALLTRIM(client.firstn)+' '+ALLTRIM(client.lastn) );
    ,ALLTRIM(CLIENT.SALUT)+' '+ALLTRIM(client.firstn)+' '+ALLTRIM(client.lastn) )
    vlestreet=stuff(vlestreet,1,len(client.APPadRESS),client.APPadRESS)
    vlesscity=stuff(vlesscity,1,len(client.APPcity),client.APPcity)
    vlessstate=stuff(vlessstate,1,len(client.APPstate),client.APPstate)
    vlesszip=stuff(vlesszip,1,len(client.APPzip),client.APPzip)
else
    vlessname=space(35)
    vlestreet=space(25)
    vlesscity=space(25)
    vlessstate='  '
    vlesszip='     -     '
    vlesscomment=space(45)
endif
show gets
return .t.





***************************************************************************
*                  procedure do labels
***************************************************************************
procedure prlabels
parameter lblfname
private i,selection,k,filename,lblfname,value

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag acctno
         set filter to policy.dcanceled=.f. .and. policy.renewed=.f.

if !used('client')
   select a
   use client index client alias client
else
    select client
endif
set order to tag acctno
selection=space(25)
filename=space(25)


select client
set relation to acctno into policy
set order to tag lastn

if len(alltrim(lblfname))>0

String="Where do you want the output to go ?"
   yesno=1
set color to w+/b,w+/b
*define window sure from 7,19 to 13,59  NONE float shadow  ;
*       title ' OUTPUT GOES WHERE ' color SCHEME 4
*       w+/b,w+/b, w+/b , w+/b, w+/b, w+/b, w+/b, w+/b, w+/b, w+/b

*activate window sure


*browse fields client.acctno,client.lastn,policy.acctno,policy.policyno;
*        for (len(alltrim(policy.policyno))>0)

yesno=spf()

     do case
        case yesno=1
                 label form (lblfname) for (len(alltrim(policy.policyno))>0) preview
        case yesno=2
                WAIT WINDOW "Please Wait I am printing" nowait
                label form (lblfname) for (len(alltrim(policy.policyno))>0)  to printer noconsole
                eject
                wait clear
*        case selection="FIle"
*             activate window filenames
*             @ 0,0 say "Filename : " get filename picture "!!!!!!!!!!!!!!!!!!!!!!!!!"
*             read
*             if len(alltrim(filename)) > 0
*               if file(filename) = .T.
*                    activate window exists
*                    @ 0,0 say "Trying to create File : "+(filename)
*                    label form (lblfname) noconsole to file (filename)
*                    deactivate window exists
*                else
*                    label form (lblfname) noconsole to file (filename)
*                endif
*              endif
*              deactivate window filenames
        otherwise
             selection=''
        endcase
*     deactivate window getlabels
endif
close databases
return



***************************************************************************
*             procedure do the automatic cancelations
***************************************************************************
PROCEDURE AUTOCANCEL
         close databases
         if !used('document')
            select 14
            use document index polid alias document
         else
            select document
         endif
         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag acctno
         set filter to dcanceled=.f.

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0


         select client
         set relation to acctno into policy

         select policy
         set relation to dpid into document
         set skip to document
         select client
         set skip to policy,document

*browse fields client.acctno,policy.acctno,policy.dpid,document.dpid,document.recdate
        do preview with "autocncl","(document.recdate={"+dtoc(date())+"} and ('CANCEL' $ alltrim(upper(document.doctype))))"

        go top
        replace policy.dcanceled with .t.,;
                policy.canceldate with dtoc(date());
                for (document.recdate=date() and ('CANCEL' $ alltrim(upper(document.doctype))))
        set relation to
        set filter to
        close databases
RETURN

