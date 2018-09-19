set procedure to 'various'


define window wins at 1,1 size 25,80 in desktop system float shadow nogrow noclose ;
 	title "Incurance Company processing" font "FixedSys",11
 	
activate window wins

set exclusive off
set color to rb+/b
clear
set notify on
set topic to "INSURANCE"
if !used('icompany')
   select d
   use icompany index icompany alias icompany
else
   select icompany
endif
set order to tag iname
recordnum=recno()
COMIS=0
*public iresult,mname,mnumber,madd1,madd2,mcity,mstate,mzip,mphone1,mphone2;
*       ,midno,mperson,MITYPE,ilocked,comis,recordnum

mnumber=0
mname   =space(35)
madd1   =space(35)
madd2   =space(35)
mcity   =space(25)
mstate  =space(2)
mzip    ="     -     "
mphone1 ="(   )   -    "
mphone2 ="(   )   -    "
midno   =space(20)
mperson =space(50)
MITYPE="AUTO"
go TOP
recordnum=0

*@ 2,0 to 24,79 clear   && pretty window
*set color to n/rb+
*for i=60 to 0 step -1
*    @ 6,4 to 18-(i/10),74-i double color gr+/b
*    @ 7,5 to 17-(i/10),(74-i-1) clear
*endfor


*@ 6,4 to 18,74 double color gr+/b
do idisplay
do insoptions
set order to tag inumber
set topic to "FILING"
set notify off
release window wins
return


******************************************************************************
*                    Procedure Insurance options
******************************************************************************
Procedure insOptions
  DEACTIVATE  MENU insurmenu
  DEFINE MENU insurmenu BAR AT LINE 1 COLOR SCHEME 4
  DEFINE PAD Add        OF insurmenu  PROMPT '\<Add'
  DEFINE PAD Find       OF insurmenu  PROMPT '\<Search'
*  DEFINE PAD Options    OF insurmenu  PROMPT '\<Options'
  DEFINE PAD List       OF insurmenu  PROMPT 'L\<ist'
  DEFINE PAD First      OF insurmenu  PROMPT '\<First'
  DEFINE PAD Previous   OF insurmenu  PROMPT '\<Previous'
  DEFINE PAD Next       OF insurmenu  PROMPT '\<Next'
  DEFINE PAD Last       OF insurmenu  PROMPT '\<Last'
  DEFINE PAD Edit       OF insurmenu  PROMPT '\<Edit'
  DEFINE PAD Delete     OF insurmenu  PROMPT '\<Delete'
  DEFINE PAD Undelete   OF insurmenu  PROMPT '\<UnDelete'
  DEFINE PAD Quit       OF insurmenu  PROMPT '\<Quit'

  ON SELECTION MENU insurmenu DO imenu with iresult

iresult=-1
do while iresult<>0
  mpad=icurrentpad(iresult)
  ACTIVATE MENU insurmenu pad (mpad)
  mpad=icurrentpad(iresult)
  show MENU insurmenu pad (mpad)
  if lastkey()=27
     iresult=-1
  endif
    do case
     case iresult=1
          skip -1
          if bof('icompany')
             Wait window 'This is the FIRST Company' nowait
             go top
          endif
          do idisplay
     case iresult=2
           skip
           if eof('icompany')
              wait window 'This is the LAST Company' nowait
              go bottom
           endif
           do idisplay
     case iresult=3
          ILOCKED=insedit()
          select icompany
          if ( (ilocked=.t.) and (lastkey() # 27) )
                 do putinsdata
          endif
          unlock in icompany
          do idisplay
     case iresult=4
*            recordnum=recno()
*            do insoptmenu
*            goto recordnum
*            do idisplay

             save screen to q
             outp=spf()
             do case
                case outp=1
                     =setpglen()
                     deactivate window wins
                     RECordnum=RECNO()
                      do preview with "inslist",""
                      activate window wins
                      GOTO RECordnum
                case outp=2
                     do prnchoic
                     wait window "Now Printing" NOWAIT
                     =setpglen()
                     RECordnum=RECNO()
                     report form inslist to print noconsole
                     GOTO RECordnum
                     WAIT CLEAR
                case outp=3
                     do laser with "inslist",""
             endcase
             restore screen from q
     case iresult=5
          tf=acertain('DELETE REALLY?',.f.)
          if ( (tf=.t.) and !recused('icompany',recno()) )
             delete
             unlock in icompany

     * Activity posting
     MINVOICENO=0
     MACCTNO   =mnumber
     MTRANCODE =9903
     MQTY      =1
     MPRICE    =0
     MTOTAL    =0
     MDATE     =date()
     MCLERK    =''
     MDESCRIPT ="Insurance Company Deleted"
     MPOSTED   =.f.
     MBILLED   =.f.
     MCHECKNO  =''
     DVID      ="00"

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
          select icompany
          endif
          do idisplay
     case iresult=6
          recall
          do idisplay
     case iresult=7
          go top
          do idisplay
     case iresult=8
          go bottom
          do idisplay
     case iresult=9
          do addins
          do idisplay
     case iresult=10
            recordnum=recno()
            tf=findit()
            if tf=.f.
               goto recordnum
            endif
            do idisplay
     case iresult=-1
*	   wait window 'Watch It' nowait
  endcase
enddo
hide menu insurmenu
DEACTIVATE MENU insurmenu
RELEASE MENU insurmenu
return



******************************************************************************
*                    Procedure findit
******************************************************************************
function findit
private tf,indata
indata=space(20)
tf=.f.

*set color to w/rb+,w/bg+
define window cinfo from 8,5 to 14,67 color scheme 10 system float shadow in desktop;
	title "Searching for a company" Font "Arial",11
activate window cinfo
clear
@ 1,5 say 'Please enter Company Name' get indata picture replicate('X',25) size 1,25
read
set exact off
locate for iname=alltrim(upper(indata))
set exact on
if found()
   tf=.t.
else
    wait window "No such company" timeout 2
endif
deactivate window cinfo
release window cinfo
return tf

******************************************************************************
*                    Procedure Insurance Display
******************************************************************************
procedure idisplay
set color to w/b
*@ 2,0 to 24,79 clear

for i=3 to 25
	@ i,0 say space(80)
endfor
*@ 6,4 to 18,74 double color gr+/b

set color to gr+/b,w+/bg
mnumber = inumber
mname   = iname
madd1   = iadd1
madd2   = iadd2
mcity   = icity
mstate  = istate
mzip    = izip
mphone1 = iphone1
mphone2 = iphone2
midno   = iidno
mperson = iperson
MITYPE  = ITYPE
comis   = dcom

@ 4,0 TO 21,79 DOUBLE COLOR gr+/b
@  7, 4 SAY "Insurance Company Name:"
@  5, 2 SAY "Insurance Company Number:"
@  9,11 SAY "Address Line 1 :"
@ 10,11 SAY "Address Line 2 :"
@ 11,21 SAY "City :"
@ 12,20 SAY "State :"
@ 12,48 SAY "ZIP :"
@ 14,18 SAY "Phone 1 :"
@ 14,44 SAY "Phone 2 :"
@  5,43 SAY "Code Number :"
@ 16,11 SAY "Contact Person :"

@  5,28 GET Mnumber SIZE 1,6 disabled color ,,,,,,,,w+/b,w+/b
@  5,56 GET Midno SIZE 1,20 PICTURE REPLICATE ('9',20)        disabled color ,,,,,,,,w+/b,w+/b
@  7,28 GET Mname SIZE 1,35 PICTURE REPLICATE ('X',35)        disabled color ,,,,,,,,w+/b,w+/b
@ 09,28 GET Madd1 SIZE 1,35 PICTURE REPLICATE ('X',35)        disabled color ,,,,,,,,w+/b,w+/b
@ 10,28 GET Madd2 SIZE 1,35 PICTURE REPLICATE ('X',35)        disabled color ,,,,,,,,w+/b,w+/b
@ 11,28 GET Mcity SIZE 1,25 PICTURE REPLICATE ('X',25)        disabled color ,,,,,,,,w+/b,w+/b
@ 12,28 GET Mstate SIZE 1,2 PICTURE "aa" FUNCTION "@!"        disabled color ,,,,,,,,w+/b,w+/b
@ 12,54 GET Mzip SIZE 1,11  PICTURE "99999-99999"             disabled color ,,,,,,,,w+/b,w+/b
@ 14,28 GET Mphone1 SIZE 1,13 PICTURE "(999)999-9999"         disabled color ,,,,,,,,w+/b,w+/b
@ 14,54 GET Mphone2 SIZE 1,13 PICTURE "(999)999-9999"         disabled color ,,,,,,,,w+/b,w+/b
@ 16,28 GET Mperson SIZE 1,50 PICTURE REPLICATE ('X',50)      disabled color ,,,,,,,,w+/b,w+/b
@ 19,40 SAY "INSURANCE TYPE:"
@ 19,11 say "Commission Rate:" get comis picture '99' valid (comis >0) disabled color ,,,,,,,,w+/b,w+/b
@ 19,31 say "%"
@ 19,55 GET MITYPE picture "@^ AUTO;HOME;LIFE;FIRE;GENERAL;COMMERCIAL;AGENCY;WORKMENS' COMP"   disabled color ,,,,,,,,w+/b,w+/b
clear gets

@24,0 TO 24,79   color gr+/b
*@23,0 SAY "Date: "+dtoc(date()) color gr+/b
*@23,66 say "Time: "+time() color gr+/b

set color to gr+/n
@ 0,0 to 0,79 clear
=center(0,"INSURANCE COMPANY INFORMATION")
if deleted('icompany')
  ??chr(7)
  set color to gr+/r
  =center(3,"WARNING! This Record has been marked for deletion")
else
  SET COLOR TO gr+/b
  =center(3,"                                                 ")
endif

set reprocess to 1
if lock(alltrim(str(recno())),'icompany')=.f.
   ?? chr(7)
   wait window 'This Company is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in icompany
set reprocess to 1
return






******************************************************************************
*                    Procedure Insurance Add
******************************************************************************
procedure addins
set color to w/b

@ 3,0 to 24,79 clear
*@ 6,4 to 18,74 double color gr+/b
set color to gr+/n
@ 0,0 say space(80)
=center(0,"ADDING INSURANCE COMPANY")
set color to gr+/b
@ 23,0 to 23,79
=center(24,"Press F10 to Accept Entry")

on key label f10 keyboard "{CTRL+w}"
set color to gr+/b,w+/bg
mnumber=0
mname   =space(35)
madd1   =space(35)
madd2   =space(35)
mcity   =space(25)
mstate  =space(2)
mzip    ="     -     "
mphone1 ="(   )   -    "
mphone2 ="(   )   -    "
midno   =space(20)
mperson =space(50)
MITYPE="AUTO"

@ 4,0 TO 21,79 DOUBLE COLOR gr+/b
@  7, 4 SAY "Insurance Company Name:"
@  5, 2 SAY "Insurance Company Number:"
@ 09,11 SAY "Address Line 1 :"
@ 10,11 SAY "Address Line 2 :"
@ 11,21 SAY "City :"
@ 12,20 SAY "State :"
@ 12,48 SAY "ZIP :"
@ 14,18 SAY "Phone 1 :"
@ 14,44 SAY "Phone 2 :"
@  5,43 SAY "Code Number :"
@ 16,11 SAY "Contact Person :"

set color to
@  5,28 GET Mnumber SIZE 1,6 disabled color ,,,,,,,,w+/b,w+/b
@  5,56 GET Midno SIZE 1,20 PICTURE REPLICATE ('9',20) VALID NOTAGAIN(MIDNO) ERROR "ID# in use"
@  7,28 GET Mname SIZE 1,35 PICTURE REPLICATE ('X',35)
@ 09,28 GET Madd1 SIZE 1,35 PICTURE REPLICATE ('X',35)
@ 10,28 GET Madd2 SIZE 1,35 PICTURE REPLICATE ('X',35)
@ 11,28 GET Mcity SIZE 1,25 PICTURE REPLICATE ('X',25)
@ 12,28 GET Mstate  PICTURE "aa" FUNCTION "@!"
@ 12,54 GET Mzip    PICTURE "99999-99999"
@ 14,28 GET Mphone1 PICTURE "(999)999-9999"
@ 14,54 GET Mphone2 PICTURE "(999)999-9999"
@ 16,28 GET Mperson PICTURE REPLICATE ('X',50)
@ 19,40 SAY "INSURANCE TYPE:"
@ 19,11 say "Commission Rate:" get comis picture '99' valid (comis > 0 )
@ 19,31 say "%"
@ 19,55 GET MITYPE picture "@^ AUTO;HOME;LIFE;FIRE;GENERAL;COMMERCIAL;AGENCY;WORKMENS' COMP"
read cycle
on key label f10
@ 23,0 TO 23,79 CLEAR
tf=.f.
if lastkey() # 27
   TF=ACERTAIN('ACCEPT  THIS  ENTRY?',.t.)
   IF TF=.T.
      append blank
      recordnum=recno()
      if !lock(alltrim(str(recordnum)),'icompany')
          wait window 'Fatal: Cannot lock new record for Insurance' TIMEOUT 1
          ?? chr(7)
          cancel
          tf=.f.
      endif
     mnumber=getinsnum()
     set color to gr+/b
*     define window account from 8,5 to 16,47 color scheme 1 double float shadow;
*                Title ' COMPANY NUMBER ' in screen
*     activate window account
*     =center(1,"The Company's number is")
*     set color to g+/b
*     string=alltrim(str(mnumber))
*     =center(3,string)
*     set color to gr+/b
*     =center(5, 'Please make a note of it')
*     =inkey(10)
*     deactivate window account
*     release window account
replace inumber with  mnumber,;
           iname   with  alltrim(upper(mname)),;
           iname   with  alltrim(upper(mname)),;
           iadd1   with  alltrim(upper(madd1)),;
           iadd2   with  alltrim(upper(madd2)),;
           icity   with  alltrim(upper(mcity)),;
           istate  with  alltrim(upper(mstate)),;
           izip    with  alltrim(upper(mzip)),;
           iphone1 with  alltrim(upper(mphone1)),;
           iphone2 with  alltrim(upper(mphone2)),;
           iidno   with  alltrim(midno),;
           iperson with  alltrim(upper(mperson)),;
           ITYPE   WITH  alltrim(upper(MITYPE)),;
           dcom    with  comis
     unlock in icompany


     * Activity posting
     MINVOICENO=0
     MACCTNO   =mnumber
     MTRANCODE =9901
     MQTY      =1
     MPRICE    =0
     MTOTAL    =0
     MDATE     =date()
     MCLERK    =''
     MDESCRIPT ="Insurance Company Added"
     MPOSTED   =.f.
     MBILLED   =.f.
     MCHECKNO  =''
     DVID      ="00"

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
     select icompany
   ENDIF
endif
return




******************************************************************************
*                    Procedure Insurance Edit
*****************************************************************************
FUNCTION insedit
set color to w/b

ilocked=.f.
if lock(alltrim(str(recno())),'icompany')=.f.
   wait window 'This Account is edited by Another User Try Again Later' TIMEOUT 1
   ilocked=.f.
   return ilocked
else
   ilocked=.t.
endif

@ 3,0 to 24,79 clear
*@ 6,4 to 18,74 double color gr+/b
set color to gr+/n
@ 0,0 say space(80)
=center(0,"EDITING INSURANCE COMPANY")
set color to gr+/b
@ 23,0 to 23,79
=center(24,"Press F10 to Accept Entry")

on key label f10 keyboard "{CTRL+w }"
set color to gr+/b,w+/bg
* INITIALIZE THE MEMORY VARIABLES

mnumber = inumber
mname   = iname
mnumber = inumber
mname   = iname
madd1   = iadd1
madd2   = iadd2
mcity   = icity
mstate  = istate
mzip    = izip
mphone1 = iphone1
mphone2 = iphone2
midno   = iidno
mperson = iperson
MITYPE  = ITYPE

*@ 7,5 say "Number:" get mnumber picture '9999' disabled color ,,,,,,,,w+/b,w+/b
*@ 7,25 say "Name:"  get mname picture replicate ('X',30)

@ 4,0 TO 21,79 DOUBLE COLOR gr+/b
@  7, 4 SAY "Insurance Company Name:"
@  5, 2 SAY "Insurance Company Number:"
@ 09,11 SAY "Address Line 1 :"
@ 10,11 SAY "Address Line 2 :"
@ 11,21 SAY "City :"
@ 12,20 SAY "State :"
@ 12,48 SAY "ZIP :"
@ 14,18 SAY "Phone 1 :"
@ 14,44 SAY "Phone 2 :"
@  5,43 SAY "Code Number :"
@ 16,11 SAY "Contact Person :"

set color to
@  5,28 GET Mnumber SIZE 1,6 disabled color ,,,,,,,,w+/b,w+/b
@  5,56 GET Midno SIZE 1,20 PICTURE REPLICATE ('9',20) VALID NOTedit(MIDNO) ERROR "ID# in use"
@  7,28 GET Mname SIZE 1,35 PICTURE REPLICATE ('X',35)
@ 09,28 GET Madd1 SIZE 1,35 PICTURE REPLICATE ('X',35)
@ 10,28 GET Madd2 SIZE 1,35 PICTURE REPLICATE ('X',35)
@ 11,28 GET Mcity SIZE 1,25 PICTURE REPLICATE ('X',25)
@ 12,28 GET Mstate SIZE 1,2 PICTURE "aa" FUNCTION "@!"
@ 12,54 GET Mzip SIZE 1,11  PICTURE "99999-99999"
@ 14,28 GET Mphone1 SIZE 1,13 PICTURE "(999)999-9999"
@ 14,54 GET Mphone2 SIZE 1,13 PICTURE "(999)999-9999"
@ 16,28 GET Mperson SIZE 1,50 PICTURE REPLICATE ('X',50)
@ 19,40 SAY "INSURANCE TYPE:"
@ 19,11 say "Commission Rate:" get comis picture '99' valid (comis > 0 )
@ 19,31 say "%"
@ 19,55 GET MITYPE picture "@^ AUTO;HOME;LIFE;FIRE;GENERAL;COMMERCIAL;AGENCY;WORKMENS' COMP"
read cycle
on key label f10
@ 23,0 TO 23,79 CLEAR
return ILOCKED






******************************************************************************
*                    Procedure Insurance Options
******************************************************************************

procedure insoptmenu

define window insoption from 8,15 to 24,60 double in screen ;
       title 'AVAILLABLE OPTIONS';
       color gr+/b,gr+/b,gr+/b,gr+/b ,gr+/b ,gr+/b ,gr+/b ,gr+/b ;
       shadow float
activate window insoption
private optopt

optopt=0
do while optopt # 7
set color to gr+/b,w+/bg
@  1,4 prompt ' A. List Companies on Screen '
@  3,4 prompt ' B. List Companies to Printer'
@  5,4 prompt ' C. Choose Printer Device    '
@  7,4 prompt ' D. Selection D              '
@  9,4 prompt ' E. Selection E              '
@ 11,4 prompt ' F. Selection F              '
@ 13,4 prompt ' Q. Quit Options Menu        '

menu to optopt
if lastkey()=27
   deactivate window insoption
   release window insoption
   return
endif

deactivate window insoption
save screen to q
do case
   case optopt=1
        =setpglen()
*        report form inslist preview
         RECordnum=RECNO()
         do preview with "inslist",""
         GOTO recordnum
   case optopt=2
        define window patient from 8,20 to 10,70 TItle ' WORKING ' ;
               color w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+ ;
               float shadow
        activate window patient
        =center(0,'Please be patient PRINTING in Progress')
        =setpglen()
        recordnum=RECNO()
        report form inslist to print noconsole
        GOTO REC
        ?? chr(7)
        wait window 'Printing is done' nowait
        deactivate window patient
        release window patient
   case optopt=3
         do prnchoic
   case optopt=4
         WAIT WINDOW 'Selection D'
   case optopt=5
         WAIT WINDOW 'Selection E'
   case optopt=6
         WAIT WINDOW 'Selection F'
endcase
restore screen from q
activate window insoption
enddo
deactivate window insoption
release window insoption
return

return







******************************************************************************
*                    Procedure Put Insurance Data
******************************************************************************
procedure putinsdata
if !used('icompany')
   select d
   use icompany index icompany alias icompany
else
   select icompany
endif

replace inumber with  mnumber,;
           iname   with  alltrim(upper(mname)),;
           iname   with  alltrim(upper(mname)),;
           iadd1   with  alltrim(upper(madd1)),;
           iadd2   with  alltrim(upper(madd2)),;
           icity   with  alltrim(upper(mcity)),;
           istate  with  alltrim(upper(mstate)),;
           izip    with  alltrim(upper(mzip)),;
           iphone1 with  alltrim(upper(mphone1)),;
           iphone2 with  alltrim(upper(mphone2)),;
           iidno   with  alltrim(midno),;
           iperson with  alltrim(upper(mperson)),;
           ITYPE   WITH  alltrim(upper(MITYPE)),;
           dcom    with  comis

     * Activity posting
     MINVOICENO=0
     MACCTNO   =mnumber
     MTRANCODE =9902
     MQTY      =1
     MPRICE    =0
     MTOTAL    =0
     MDATE     =date()
     MCLERK    =''
     MDESCRIPT ="Insurance Company Edited"
     MPOSTED   =.f.
     MBILLED   =.f.
     MCHECKNO  =''
     DVID      ="00"

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )

     select icompany
return


******************************************************************************
*                    function iCurrentPad
******************************************************************************
Function icurrentpad
parameter iresult
private mpad,tf

do case
   case      iresult=1
             mpad='PREVIOUS'
   case      iresult=2
             mpad='NEXT'
   case      iresult=3
             mpad='EDIT'
*   case      iresult=4
*             mpad='OPTIONS'
   case      iresult=4
             mpad='LIST'
   case      iresult=5
             mpad='DELETE'
   case      iresult=6
             mpad='UNDELETE'
   case      iresult=0
             mpad='QUIT'
   case      iresult=7
             mpad='FIRST'
   case      iresult=8
             mpad='LAST'
   case      iresult=9
             mpad='ADD'
   case      iresult=10
             mpad='FIND'
   case      iresult=-1
             mpad='Repeat'
endcase
RETURN mpad


******************************************************************************
*                    Procedure imenu
******************************************************************************
Procedure imenu
parameter iresult
private mpad,tf

   mpad=space(4)
   mpad=pad()
     result=-1
   if mpad='PREVIOUS'
           iresult=1
   endif
   if mpad='NEXT'
           iresult=2
   endif
   if mpad='EDIT'
           iresult=3
   endif

*   if mpad='OPTIONS'
*           iresult=4
*   endif
   if mpad='LIST'
           iresult=4
   endif
   if mpad='DELETE'
           iresult=5
   endif
   if mpad='UNDELETE'
           iresult=6
   endif
   if mpad='QUIT'
           iresult=0
   endif
   if mpad='FIRST'
           iresult=7
   endif
   if mpad='LAST'
           iresult=8
   endif
   if mpad='ADD'
           iresult=9
   endif
   if mpad='FIND'
           iresult=10
   endif
   if lastkey()=27
      iresult=-1
   endif
RETURN


FUNCTION NOTAGAIN
PARAMETER IDnu
PRIVATE REC,TF
TF=.T.
recordnum=RECNO()
SET ORDER TO TAG iIDNO
SEEK alltrim(IDnu)
IF FOUND()
   TF=.F.
ENDIF
SET ORDER TO TAG INAME
GOTO (recordnum)
RETURN TF


FUNCTION NOTedit
PARAMETER IDnu
PRIVATE REC
TF=.T.
recordnum=RECNO()
SET ORDER TO TAG iIDNO
SEEK alltrim(IDnu)
IF FOUND() .and. recno()<>recordnum
   TF=.F.
ENDIF
SET ORDER TO TAG INAME

GOTO (recordnum)
*wait window alltrim(idnu)+chr(13)+alltrim(icompany->iidno)
if tf=.t. .and. alltrim(idnu)<>alltrim(icompany->iidno)

	IF !USED('coverage')
	select c
            use coverage index coverage alias coverage
	else
			select coverage
	endif
	set order to iidno
	set exact on
	seek icompany->iidno
	set exact off
	if found()=.t. 
		tf=.f.
		?? chr(7)
		Wait window "You cannot change this number("+alltrim(iidno)+")"+chr(13)+"There are coverages using it"	
	endif

	if !used('home')
   		select 30
  		use home index home alias home
	else
   		select home
	endif
	
	set order to iidno
	set exact on
	seek icompany->iidno
	set exact off
	if found()=.t. 
		tf=.f.
		?? chr(7)
		Wait window "You cannot change this number("+alltrim(iidno)+")"+chr(13)+"There are coverages using it"	
	endif


endif

select icompany
RETURN TF
