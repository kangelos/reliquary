set procedure to 'various'
push menu _msysmenu
set exclusive off
*set talk off
set notify on
set color to w/b
clear
         if !used('codes')
            select g
            use codes index codenum alias codes
         else
             select codes
         endif
go top
count to numrecs
if numrecs=0
   ?? chr(7)
   wait window 'No Service Codes Found' timeout 1
   ?? chr (7)
   wait window 'Press any key to add one' timeout 1
   =addsvccode()
endif
go top
mcdtaxable=.f.
mcdnotes=space(40)
mcdnum=0
mcdname=space(25)
mprice1=0.0
mprice2=0.0
mprice3=0.0
mprice4=0.0
mprice5=0.0
mprice6=0.0

*define window wcd at 1,1 size 25,81 in desktop system float shadow nogrow;
*	Title "Service Code Section" Font "Fixedsys",9
*activate window wcd	
do svccddisplay
do menuofservices
pquit=0
do while pquit=0
	activate menu _msysmenu
enddo	

*release window wcd
POP MENU _MSYSMENU
return

******************************************************************************
*                    Procedure service menu
******************************************************************************
procedure menuofservices
private rec,cdpad
select codes
go top
  DEFINE MENU _MSYSMENU BAR AT LINE 1 KEY ALT+Z MARK CHR(254) COLOR SCHEME 3
  DEFINE PAD ADD        OF _MSYSMENU  PROMPT '\<Add'
  DEFINE PAD Search     OF _MSYSMENU  PROMPT '\<Search'
  DEFINE PAD First      OF _MSYSMENU  PROMPT '\<First'
  DEFINE PAD Previous   OF _MSYSMENU  PROMPT '\<Previous'
  DEFINE PAD Next       OF _MSYSMENU  PROMPT '\<Next '
  DEFINE PAD Last       OF _MSYSMENU  PROMPT '\<Last'
  DEFINE PAD Edit       OF _MSYSMENU  PROMPT '\<Edit'
  DEFINE PAD Delete     OF _MSYSMENU  PROMPT '\<Delete'
  DEFINE PAD Undelete   OF _MSYSMENU  PROMPT '\<UnDelete'
  DEFINE PAD Quit       OF _MSYSMENU  PROMPT '\<Quit'

  on selection pad add      of _msysmenu do cadd
  on selection pad search   of _msysmenu do csearch
  on selection pad first    of _msysmenu do cfirst
  on selection pad previous of _msysmenu do cprevious
  on selection pad next     of _msysmenu do cnext
  on selection pad last     of _msysmenu do clast
  on selection pad edit     of _msysmenu do cedit
  on selection pad delete   of _msysmenu do cdel
  on selection pad undelete of _msysmenu do cundel
  on selection pad quit     of _msysmenu do pcquit
return

procedure pcquit
	pquit=1
return

  
procedure cprevious
          skip -1
          if bof('codes')
             Wait window 'This is the FIRST Record' nowait
             go top
          endif
          do svccddisplay
return

procedure cnext
          skip
          if eof('codes')
                   wait window 'This is the Last Record' nowait
                   go bottom
          endif
          do svccddisplay
return

procedure cedit
		if dcdnum>100		
          svclocked=svcdataedit()
          select codes
          if  ( (svclocked=.t.) and (lastkey() # 27) )
                 do svccdputdata
          endif
          unlock in codes
          do svccddisplay
        else
        	wait window "You cannot edit code 100"+chr(13)+"It is a system code"
        endif  
return

procedure csearch
          rec=recno()
          temp=.f.
          temp=findcode()
          if temp=.f.
             go (rec)
          endif
          do svccddisplay
return

procedure cdel
          tf=acertain('DELETE REALLY?',.f.)
          if ( (tf=.t.) and !recused('codes',recno()) )
             delete
             unlock in codes
          endif
          do svccddisplay
return

procedure cundel          
          recall
          do svccddisplay
return

procedure cfirst          
          go top
          do svccddisplay
return

procedure clast          
          go bottom
          do svccddisplay
return

procedure cadd
          rec= recno()
          temp=addsvccode()
          if temp=.f.
             go (rec)
          endif
          do svccddisplay
return          






******************************************************************************
*                    Procedure svccddisplay
******************************************************************************
procedure svccddisplay
set color to gr+/n
@ 0,0 say space(81)
=center(0,'SERVICE CODE INFORMATION')

set color to gr+/b
select codes
mcdtaxable=dcdtaxable
mcdnotes=dcdnotes
mcdnum=dcdnum
mcdname=dcdname
mprice1=dcdprice1
mprice2=dcdprice2
mprice3=dcdprice3
mprice4=dcdprice4
mprice5=dcdprice5
mprice6=dcdprice6


if type('codsc')='U'
        a=fname("codsc.mem")
        if file(a)
                restore from &a additive
           restore screen from codsc
        else
                do paintcode
        endif
else
        restore screen from codsc
endif

set color to gr+/b,w+/b
@ 6,33 GET codes.dcdname SIZE 1,25 DEFAULT " "  PICTURE "@!"
@ 5,33 GET mcdnum  SIZE 1,8  DEFAULT 0
@ 6,33 GET mcdname SIZE 1,25 DEFAULT " "  PICTURE "@!"
@ 8,37 GET mtaxable  SIZE 1,3 DEFAULT .F. picture '@L Y;N'
@ 11,28 GET mprice1  SIZE 1,11  DEFAULT 0 picture '999,999,999.99'
@ 13,28 GET mprice2  SIZE 1,11  DEFAULT 0 picture '999,999,999.99'
@ 15,28 GET mprice3  SIZE 1,11  DEFAULT 0 picture '999,999,999.99'
@ 11,54 GET mprice4  SIZE 1,11  DEFAULT 0 picture '999,999,999.99'
@ 13,54 GET mprice5  SIZE 1,11  DEFAULT 0 picture '999,999,999.99'
@ 15,54 GET mprice6  SIZE 1,11  DEFAULT 0 picture '999,999,999.99'
@ 17,26 GET mcdnotes SIZE 1,40  DEFAULT " "
clear gets
if deleted()
   set color to gr+/r
   =center(23,'WARNING! this record has been marked for deletion')
   ?? chr(7)
   set color to gr+/b
else
   set color to gr+/b
   @23,0 to 23,79
endif
set color to gr+/b
set reprocess to 1
if lock(alltrim(str(recno())),'codes')=.f.
   ?? chr(7)
   wait window 'This CODE is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in codes
set reprocess to 1
return






******************************************************************************
*                    Procedure add service code
******************************************************************************
function addsvccode
private tf
define window wcod at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Code Adding Window" font "FixedSys",9
activate window wcod

set color to gr+/n
@ 0,0 say space(80)
=center(0,'ADDING NEW SERVICE CODE')

set color to gr+/b
@2,0 say space(80)
select codes

mcdtaxable=.f.
mcdnotes=space(40)
mcdnum=0
mcdname=space(25)
mprice1=0.0
mprice2=0.0
mprice3=0.0
mprice4=0.0
mprice5=0.0
mprice6=0.0

set color to gr+/b,w/bg+
@ 23,0 to 23,79
@ 24,0 say space(80)
=center(24,'Press <F10> to accept new code,or <ESC> to Quit')
on key label f10 keyboard '{ctrl+w}'
@ 4,3 TO 19,76 double color gr+/b
@ 5,20 SAY "Code Number:"
@ 6,20 SAY "Code   Name:"
@ 8,20 SAY "Code is Taxable:"
@ 11,45 SAY "Price 4: "
@ 13,45 SAY "Price 5: "
@ 15,45 SAY "Price 6: "
@ 11,20 SAY "Price 1: "
@ 13,20 SAY "Price 2: "
@ 15,20 SAY "Price 3: "
@ 17,19 SAY "Notes:"
set color to
@ 5,33 GET mcdnum  SIZE 1,8  DEFAULT 0 valid (ADDcheckfordouble(mcdnum)) error "Invalid Code Number ( In use ? )"
@ 6,33 GET mcdname SIZE 1,25 DEFAULT " "  PICTURE "@!"
@ 8,37 GET mtaxable  DEFAULT .F. picture '@L Y;N'
@ 11,28 GET mprice1  SIZE 1,11  DEFAULT 0
@ 13,28 GET mprice2  SIZE 1,11  DEFAULT 0
@ 15,28 GET mprice3  SIZE 1,11  DEFAULT 0
@ 11,54 GET mprice4  SIZE 1,11  DEFAULT 0
@ 13,54 GET mprice5  SIZE 1,11  DEFAULT 0
@ 15,54 GET mprice6  SIZE 1,11  DEFAULT 0
@ 17,26 GET mcdnotes SIZE 1,40  DEFAULT " " picture "@!"
@ 4,3 TO 19,76 double color gr+/b
read cycle
on key label f10
deactivate window wcod
release window wcod

if lastkey()=27
   return .f.
endif

set color to gr+/b
*mcdnum=newsvccode()
select codes
*if mcdnum<>0
*?? chr(7)
*wait window "The new Code's Number is: "+alltrim(str(mcdnum)) timeout 1
append blank
if lock(alltrim(str(recno())),'codes')=.f.
   ?? chr(7)
   wait window 'Fatal Cannot lock New record' timeout 1
   cancel
endif
replace  dcdtaxable  with mcdtaxable,;
         dcdnotes    with  alltrim(upper(mcdnotes)),;
         dcdnum      with  mcdnum,;
         dcdname     with  alltrim(upper(mcdname)),;
         dcdprice1   with  mprice1,;
         dcdprice2   with  mprice2,;
         dcdprice3   with  mprice3,;
         dcdprice4   with  mprice4,;
         dcdprice5   with  mprice5,;
         dcdprice6   with  mprice6
unlock in codes
*endif
return .t.





******************************************************************************
*                    Procedure svcdataedit
******************************************************************************
function svcdataedit
private tf,locked

define window wcod at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Code Editing Window" font "FixedSys",9

locked=.f.
if lock(alltrim(str(recno())),'codes')=.f.
   wait window 'This CODE is edited by Another User Try Again Later'
   locked =.f.
   return locked
else
   locked=.t.
endif
activate window wcod

set color to gr+/n
@ 0,0 say space(80)
=center(0,'EDITING SERVICE CODE')
set color to gr+/b
@2,0 say space(80)
select codes
mcdtaxable=dcdtaxable
mcdnotes=dcdnotes
mcdnum=dcdnum
mcdname=space(25)
mcdname=stuff(mcdname,1,len(dcdname),dcdname)
mprice1=dcdprice1
mprice2=dcdprice2
mprice3=dcdprice3
mprice4=dcdprice4
mprice5=dcdprice5
mprice6=dcdprice6


set color to gr+/b,w/bg+
@ 23,0 to 23,79
@ 24,0 say space(80)
=center(24,'Press <F10> to accept the code,or <ESC> to quit')
on key label f10 keyboard '{ctrl+w}'
@ 4,3 TO 19,76 double color gr+/b
@ 8,20 SAY "Code is Taxable:"
@ 5,20 SAY "Code Number:"
@ 6,20 SAY "Code   Name:"
@ 11,45 SAY "Price 4: "
@ 13,45 SAY "Price 5: "
@ 15,45 SAY "Price 6: "
@ 11,20 SAY "Price 1: "
@ 13,20 SAY "Price 2: "
@ 15,20 SAY "Price 3: "
@ 17,19 SAY "Notes:"
set color to
@ 5,33 GET mcdnum  SIZE 1,8  DEfault 0 valid (checkfordouble(mcdnum)) error "Invalid Code Number"
@ 6,33 GET mcdname SIZE 1,25 DEFAULT " "  picture "@!"
@ 8,37 GET mtaxable  DEFAULT .F. picture '@L Y;N'
@ 11,28 GET mprice1  SIZE 1,11  DEFAULT 0
@ 13,28 GET mprice2  SIZE 1,11  DEFAULT 0
@ 15,28 GET mprice3  SIZE 1,11  DEFAULT 0
@ 11,54 GET mprice4  SIZE 1,11  DEFAULT 0
@ 13,54 GET mprice5  SIZE 1,11  DEFAULT 0
@ 15,54 GET mprice6  SIZE 1,11  DEFAULT 0
@ 17,26 GET mcdnotes SIZE 1,40  DEFAULT " " picture "@!"
@ 4,3 TO 19,76 double color gr+/b
read cycle
on key label f10
deactivate window wcod
release window wcod
return locked


******************************************************************************
*                    function CurrentPad
******************************************************************************
Function sccurrentpad
parameter svcresult
private cdpad,tf

do case
   case      svcresult=1
             cdpad='PREVIOUS'
   case      svcresult=2
             cdpad='NEXT'
   case      svcresult=3
             cdpad='EDIT'
   case      svcresult=4
             cdpad='SEARCH'
   case      svcresult=5
             cdpad='DELETE'
   case      svcresult=6
             cdpad='UNDELETE'
   case      svcresult=0
             cdpad='QUIT'
   case      svcresult=7
             cdpad='FIRST'
   case      svcresult=8
             cdpad='LAST'
   case      svcresult=9
             cdpad='ADD'
   case      svcresult=-1
             cdpad='Repeat'
endcase
RETURN cdpad


******************************************************************************
*                    Procedure tmenu
******************************************************************************
Procedure scmenu
parameter svcresult
private cdpad,tf

   cdpad=space(4)
   cdpad=pad()
     svcresult=-1
   if cdpad='PREVIOUS'
           svcresult=1
   endif
   if cdpad='NEXT'
           svcresult=2
   endif
   if cdpad='EDIT'
           svcresult=3
   endif

   if cdpad='SEARCH'
           svcresult=4
   endif
   if cdpad='DELETE'
           svcresult=5
   endif
   if cdpad='UNDELETE'
           svcresult=6
   endif
   if cdpad='QUIT'
           svcresult=0
   endif
   if cdpad='FIRST'
           svcresult=7
   endif
   if cdpad='LAST'
           svcresult=8
   endif
   if cdpad='ADD'
           svcresult=9
   endif
   if lastkey()=27
      svcresult=-1
   endif
RETURN



wait window 'service codes'



******************************************************************************
*                    procedure put service code data
******************************************************************************
procedure svccdputdata
replace  dcdtaxable  with mcdtaxable,;
         dcdnotes    with  alltrim(upper(mcdnotes)),;
         dcdnum      with  mcdnum,;
         dcdname     with  alltrim(upper(mcdname)),;
         dcdprice1   with  mprice1,;
         dcdprice2   with  mprice2,;
         dcdprice3   with  mprice3,;
         dcdprice4   with  mprice4,;
         dcdprice5   with  mprice5,;
         dcdprice6   with  mprice6
return



******************************************************************************
*                    Function findcode
******************************************************************************
function findcode
private tf,indata,test
define window cinfo from 8,5 to 14,67 color scheme 10 system float shadow in desktop;
	Title "Looking for a code" font "Arial",11
continue=.t.

set exact off
tf=.f.
clear gets
indata=space(25)
number=0
do while continue=.t.
     test=0
     activate window cinfo
     clear
*     SET COLOR TO GR+/B,w/bg+
     @ 1,5 say 'Please enter Code Number or Name' get indata picture replicate('X',30) size 1,20
     read
     deactivate window cinfo
     continue=.t.
     if lastkey()=27
        continue=.f.
        number=0
     endif
     if continue=.t.
          set exact off
          test=val(alltrim(indata))
          number=0
          go top
          if test <= 0
             locate for dcdname=alltrim(upper(indata))
          else
             seek val(indata)
          endif
             if found()
                 tf=.t.
             else
                 tf=.f.
             endif
          continue=.f.
     endif
enddo
release window cinfo
if tf=.f.
   ?? chr(7)
   wait window 'Code not in database'
endif
RETURN tf
return tf


******************************************************************************
*            unction check for double code WHEN ADDING
******************************************************************************
function ADDcheckfordouble
parameter codenum
private rec,tf
select codes
seek codenum
if ((found()))
   tf=.f.
else
   tf=.t.
endif
if tf=.t.
   if (codenum<100) .or. (codenum>=1000)
   ?? chr(7)
   	wait window "Valid numbers must be greater than 100 and less than 1000"
      tf=.f.
   endif
endif

return tf

******************************************************************************
*                    Function check for double code
******************************************************************************
function checkfordouble
parameter codenum
private rec,tf
select codes
rec=recno()
seek codenum
if ((found()) and (recno()<>rec))
   tf=.f.
else
   tf=.t.
endif
go (rec)
if tf=.t.
   if (codenum<100) .or. (codenum>=1000)
   ?? chr(7)
   	wait window "Valid numbers must be greater than 100 and less than 1000"
      tf=.f.
   endif
endif

if (codenum<>codes->dcdnum) .and. tf=.t.
       if !used('invoice')
          select 13
          use INVOICE alias invoice
       else
          SELECT INVOICE
       endif
      set order to tag code

	set exact on
*	seek codenum
temp=codes->dcdnum
locate for invoice->dcode=temp
*wait window str(codenum)+chr(13)+str(codes->dcdnum)
*browse
	set exact off
	if found()=.t. 
		tf=.f.
		?? chr(7)
		Wait window "You cannot change this number ("+alltrim(str(codes->dcdnum))+")"+chr(13)+"There are inoices using it"	
	endif
endif

return tf

procedure paintcode
set color to gr+/b,w+/b
@ 4,3 TO 19,76 double color gr+/b
@ 5,20 SAY "Code Number:"
@ 6,20 SAY "Code   Name:"
@ 8,20 SAY "Code is Taxable:"
@ 11,45 SAY "Price 4: "
@ 13,45 SAY "Price 5: "
@ 15,45 SAY "Price 6: "
@ 11,20 SAY "Price 1: "
@ 13,20 SAY "Price 2: "
@ 15,20 SAY "Price 3: "
@ 17,19 SAY "Notes:"
set color to gr+/b
@23,0 to 23,79
save screen to codsc
a=fname("codsc.mem")
delete file &a
save all like codsc to &a
return




