
parameter pid

         if !used('driver')
            select f
            use driver index driver alias driver
         else
             select driver
         endif
set cursor on
*hide menu polmenu
define window wdrv at 1,1 size 25,81 in desktop float shadow grow noclose ;
	color scheme 10 Title "Drivers Section" font "FixedSys",9
	
activate window wdrv	
UP=5
DOWN=24
NEXT=3
PREVIOUS=18
SELECTkey=13
DESELECT=13
ENDkey=23
QUITkey=27
gooddata=.t.
lnamesize =25
fnamesize =25
adrsize   =35
aptsize   =8
salsize   =10
dlicsize  =20
occsize   =30
empsize   =30
empadsize =30
empcszsize=30
refsize   =30
notesize  =50
varsize   =70
citysize  =20
countysize=20
use=100
lname=space(lnamesize)
fname=space(fnamesize)
mi=' '
address=space(adrsize)
aptno=space(aptsize)
salutation=space(salsize)
bdate={  /  /    }
sex='M'
ssc='   -  -    '
drivlic=space(dlicsize)
homephone='(   )-   -    '
workphone='(   )-   -    '
occupation=space(occsize)
employer=space(empsize)
empadress=space(empadsize)
empcsz=space(empcszsize)
emphone='(   )-   -    '
marstat='S'
notes=space(notesize)
city=space(citysize)
state='  '
zip=space(11)
county=space(countysize)
relation=space(25)
  issstate='  '
  issdate={  /  /    }
set procedure to 'various'
set exclusive off
public dresult
has=.f.
has=initdrvsystem()
On key label f10 keyboard "{ctrl+w}"
ON KEY LABEL ENTER
if has=.f.
     ?? CHR(7)
     wait window 'No DRIVERS Found For this POLICY' timeout 1
     ?? chr(7)
     wait window 'Press any key to ADD one'
   added=.f.
   added=adddrv()
   clear
   if (added=.t.)
      =initdrvsystem()
   else
	   release window wdrv
      return
   endif
endif
set color to w/b
clear
set filter to dpid=pid
do drvdisplay
DEACTIVATE MENU drvmenu
do drvoptions
set filter to
on key label f10
release window wdrv
return


******************************************************************************
*                    Procedure driver system Initialization
******************************************************************************
function initdrvsystem
private tf
tf=.t.
if !used('driver')
   select f
   use driver index driver alias driver
else
   select driver
endif
go top
LOCATE FOR dpid=pid
IF FOUND()
   set filter to dpid=pid
   go top
   tf=.t.
ELSE
    tf=.f.
endif
return tf



******************************************************************************
*                    Procedure driver options
******************************************************************************
Procedure drvOptions
  DEFINE MENU drvmenu BAR AT LINE 1 COLOR SCHEME 4
  DEFINE PAD Add        OF drvmenu  PROMPT '\<Add'
  DEFINE PAD options    OF drvmenu  PROMPT '\<Options'
  DEFINE PAD First      OF drvmenu  PROMPT '\<First'
  DEFINE PAD Previous   OF drvmenu  PROMPT '\<Previous'
  DEFINE PAD Next       OF drvmenu  PROMPT '\<Next '
  DEFINE PAD Last       OF drvmenu  PROMPT '\<Last'
  DEFINE PAD Edit       OF drvmenu  PROMPT '\<Edit'
  DEFINE PAD Delete     OF drvmenu  PROMPT '\<Delete'
  DEFINE PAD Undelete   OF drvmenu  PROMPT '\<UnDelete'
  DEFINE PAD Quit       OF drvmenu  PROMPT '\<Quit'

  ON SELECTION MENU drvmenu DO dmenu with dresult

dresult=-1
do while dresult<>0
  mpad=dcurrentpad(dresult)
  ACTIVATE MENU drvmenu pad (mpad)
  mpad=dcurrentpad(dresult)
  show MENU drvmenu pad (mpad)
  if lastkey()=27
     dresult=-1
  endif
    do case
     case dresult=1
          select driver
          skip -1
          if bof('driver')
             Wait window 'This is the FIRST Driver' nowait
             go top
          endif
          do drvdisplay
     case dresult=2
           select driver
           skip
           if eof('driver')
              wait window 'This is the LAST Driver' nowait
              go bottom
           endif
          do drvdisplay
     case dresult=3
          select driver
          rec=recno()
          dlocked=drvdataedit()
          select driver
          if ( (dlocked=.t.) and (lastkey() # 27) )
                 wait window "Updating" nowait
                 goto rec
                 do putdrvdata
                 wait clear
          endif
          unlock in driver
          do drvdisplay
     case dresult=4
 *         select driver
 *          set filter to
 *          do drvmenu with dpid
 *          select driver
 *          set filter to
 *          do drvdisplay
            wait window 'No Options Availlable' nowait
     case dresult=5
          select driver
          tf=acertain('DELETE REALLY?',.f.)
          if ( (tf=.t.) and !recused('driver',recno()) )
             delete
             unlock in driver
          endif
          do drvdisplay
     case dresult=6
          select driver
          rec=recno()
          recall
          goto rec
          do drvdisplay
     case dresult=7
          select driver
          go top
          do drvdisplay
     case dresult=8
          select driver
          go bottom
          do drvdisplay
     case dresult=9
          select driver
          rec=recno()
          =adddrv()
          goto rec
          do drvdisplay
     case dresult=-1
*	   wait window 'Watch It' timeout 1
  endcase
enddo
hide menu drvmenu
DEACTIVATE MENU drvmenu
RELEASE MENU drvmenu
return






******************************************************************************
*                    Function adddriver
******************************************************************************
Function Adddrv
private tf,selection,cont,string,ACCEPT
select driver
count for dpid=pid to amount
if amount >=3
   wait window 'Only THREE drivers Per Insurance Policy Allowed' timeout 1
   return .f.
endif
cont=.t.
   lnamesize =25
   fnamesize =25
   adrsize   =35
   aptsize   =8
   salsize   =10
   dlicsize  =20
   occsize   =30
   empsize   =30
   empadsize =30
   empcszsize=30
   refsize   =30
   notesize  =50
   varsize   =70
   citysize  =20
   countysize=20
   use=100

 **
****  Initialize the variables now.
 **
   lname=space(lnamesize)
   fname=space(fnamesize)
   mi=' '
   address=space(adrsize)
   aptno=space(aptsize)
   salutation=space(salsize)
   bdate={  /  /    }
   sex='M'
   ssc='   -  -    '
   drivlic=space(dlicsize)
   homephone='(   )-   -    '
   workphone='(   )-   -    '
   occupation=space(occsize)
   employer=space(empsize)
   empadress=space(empadsize)
   empcsz=space(empcszsize)
   emphone='(   )-   -    '
   marstat='S'
   notes=space(notesize)
   city=space(citysize)
   state='  '
   zip=space(11)
   county=space(countysize)
  issstate='  '
  issdate={  /  /    }
  marstat='S'
  relation=space(25)
  use =100

ACCEPT=.F.
do while cont=.t.
SET COLOR TO gr+/b
CLEAR
@ 0,0 TO 2,79 FILL COLOR W/RB+
@ 23,0 say space(80)
@ 24,0 say space(80)
=center(24,'Press F10 to process this Entry')
SET COLOR TO W/RB+
=CENTER(1,'ADDING NEW DRIVER')
SET COLOR TO gr+/b,w/bg+
@5,2 say  'Last Name:' get lname picture '!'+replicate('X',(lnamesize)-1) size 1,25
@5,40 say 'First Name:' get fname picture '!'+replicate('X',(fnamesize)-1) size 1,20
@5,73 say 'MI:' get mi picture '!'
@ 6,4 say 'Address:' get address  picture '!'+replicate('X',(adrsize)-1) size 1,30
@ 6,44 SAY 'Apt No:' get aptno picture replicate('X',(aptsize)-1) size 1,10
@ 7,7 say 'City:' get city picture replicate('X',citysize) size 1,15
@ 7,29 say 'County:' get county picture replicate('X',countysize) size 1,14
@ 7,52 say 'State:' get state picture '!!'
@ 7,62 say 'Zip:' get zip picture '99999-99999'

@ 9,1 say 'Salutation:' get salutation  picture replicate('X',(salsize)-1) size 1,10
@10,1 say 'Birth Date:' get bdate picture '@D'
@10,27 say 'Sex:' get sex picture '!' valid (sex='M' or sex='F' )
@11,1 say 'Social Sec:' get ssc picture '999-99-9999'
@12,1 say 'Driv Lic #:' get drivlic picture replicate('X',(dlicsize)) size 1,20
@13,1 say 'State Issd:' get issstate picture '!!'
@13,17 say 'Date Issd:'  get issdate picture '@D'
@14,3 say  'Relation:' get relation picture replicate('X',25) size 1,20
@15,1 say 'Mar Status:' get marstat picture '!' valid (marstat='M' or marstat='S' or marstat='W' )
@16,4 say 'Veh Use:' get use picture '999' valid (use <=100)

@ 9,40 say 'Home phone:' get homephone picture '(999)-999-9999'
@ 10,40 say 'Work phone:' get workphone picture '(999)-999-9999'
@ 11,40 say 'Occupation:'get occupation picture '!'+replicate('X',(occsize)-1) size 1,26
@ 12,42 say 'Employer:' get employer picture '!'+replicate('X',(empsize)-1) size 1,26
@ 13,39 say 'Emp Address:' get empadress picture '!'+replicate('X',(empadsize)-1) size 1,26
@ 14,43 say 'Emp CSZ:' get empcsz picture '!'+replicate('X',(empcszsize)-1) size 1,26
@ 15,41 say 'Emp Phone:' get emphone picture '(999)-999-9999'
@ 19,7 say 'Notes:' get notes picture '!'+replicate('X',(notesize)-1) size 1,60

SET SYSMENU OFF
READ CYCLE
STATE=UPPER(STATE)
last=lastkey()
tf=.f.
if last=23
    cont=.f.
    tf=.t.
ENDIF
if last=27
    cont=.f.
    tf=.f.
ENDIF
ENDDO

if tf=.t.
   append blank
   rec=recno()
   if !lock(alltrim(str(rec)),'driver')
       wait window 'Fatal: Cannot lock new record'
       ? chr(7)
       cancel
   endif
endif
wait window "Updating" nowait
do putdrvdata
wait clear
unlock in driver
@ 0,0 to 2,79 clear
@ 24,0 say space(80)
return TF




******************************************************************************
*                    Procedure dmenu
******************************************************************************
Procedure dmenu
parameter dresult
private mpad,tf

   mpad=space(4)
   mpad=pad()
     dresult=-1
   if mpad='PREVIOUS'
           dresult=1
   endif
   if mpad='NEXT'
           dresult=2
   endif
   if mpad='EDIT'
           dresult=3
   endif

   if mpad='OPTIONS'
           dresult=4
   endif
   if mpad='DELETE'
           dresult=5
   endif
   if mpad='UNDELETE'
           dresult=6
   endif
   if mpad='QUIT'
           dresult=0
   endif
   if mpad='FIRST'
           dresult=7
   endif
   if mpad='LAST'
           dresult=8
   endif
   if mpad='ADD'
           dresult=9
   endif
   if lastkey()=27
      dresult=-1
   endif
RETURN


******************************************************************************
*                    function pCurrentPad
******************************************************************************
Function dcurrentpad
parameter dresult
private mpad,tf

do case
   case      dresult=1
             mpad='PREVIOUS'
   case      dresult=2
             mpad='NEXT'
   case      dresult=3
             mpad='EDIT'
   case      dresult=4
             mpad='OPTIONS'
   case      dresult=5
             mpad='DELETE'
   case      dresult=6
             mpad='UNDELETE'
   case      dresult=0
             mpad='QUIT'
   case      dresult=7
             mpad='FIRST'
   case      dresult=8
             mpad='LAST'
   case      dresult=9
             mpad='ADD'
   case      dresult=-1
             mpad='Repeat'
endcase
RETURN mpad


******************************************************************************
*                    procedure display driver
******************************************************************************
procedure drvdisplay
select driver
   lnamesize =25
   fnamesize =25
   adrsize   =35
   aptsize   =8
   salsize   =10
   dlicsize  =20
   occsize   =30
   empsize   =30
   empadsize =30
   empcszsize=30
   refsize   =30
   notesize  =50
   varsize   =70
   itysize  =20
   countysize=20

 **
****  Initialize the variables now.
 **
   lname=space(lnamesize)
   fname=space(fnamesize)
   mi=' '
   address=space(adrsize)
   aptno=space(aptsize)
   salutation=space(salsize)
   bdate={  /  /    }
   sex='M'
   ssc='   -  -    '
   drivlic=space(dlicsize)
   homephone='(   )-   -    '
   workphone='(   )-   -    '
   occupation=space(occsize)
   employer=space(empsize)
   empadress=space(empadsize)
   empcsz=space(empcszsize)
   emphone='(   )-   -    '
   marstat='S'
   city=space(citysize)
   state='  '
   zip=space(11)
   county=space(countysize)
   use=duse

lname=        dlastn
fname=        dfirstn
mi=           dmi
address=      dadd
aptno=        daptno
salutation=   dsalut
bdate=        dbdate
sex=          dsex
ssc=          dss
drivlic=      ddr_lic_no
homephone=    dphoneh
workphone=    dphonew
occupation=   doccu
employer=     demp_name
empadress=    demp_add
empcsz=       demp_csz
emphone=      dphoneem
marstat=      dmarstatus
notes=        dnotes
city=         dcity
state=        dstate
zip=          dzip
county=       dcounty
relation=drelation
issstate= dissstate
issdate= dissdate

set color to b/n
	@ 2,0 say space(80)

set color to gr+/b,w+/b
for i=3 to 25 
	@ i,0 say space(80)
endfor

@5,2 say  'Last Name:' get lname picture '!'+replicate('X',(lnamesize)-1) size 1,25   disabled color ,,,,,,,,w+/b,w+/b
@5,40 say 'First Name:' get fname picture '!'+replicate('X',(fnamesize)-1) size 1,20  disabled color ,,,,,,,,w+/b,w+/b
@5,73 say 'MI:' get mi picture '!'                                                    disabled color ,,,,,,,,w+/b,w+/b
@ 6,4 say 'Address:' get address  picture '!'+replicate('X',(adrsize)-1) size 1,30    disabled color ,,,,,,,,w+/b,w+/b
@ 6,44 SAY 'Apt No:' get aptno picture replicate('X',(aptsize)-1) size 1,10           disabled color ,,,,,,,,w+/b,w+/b
@ 7,7 say 'City:' get city picture replicate('X',citysize) size 1,15                  disabled color ,,,,,,,,w+/b,w+/b
@ 7,29 say 'County:' get county picture replicate('X',countysize) size 1,14           disabled color ,,,,,,,,w+/b,w+/b
@ 7,52 say 'State:' get state picture 'aa'                                            disabled color ,,,,,,,,w+/b,w+/b
@ 7,62 say 'Zip:' get zip picture '99999-99999'                                       disabled color ,,,,,,,,w+/b,w+/b

@ 9,1 say 'Salutation:' get salutation  picture replicate('X',(salsize)-1) size 1,10 disabled color ,,,,,,,,w+/b,w+/b
@10,1 say 'Birth Date:' get bdate picture '@D' disabled color ,,,,,,,,w+/b,w+/b &&valid date_validate(cbdate)
@10,27 say 'Sex:' get sex picture '!' valid (sex='M' or sex='F' )
@11,1 say 'Social Sec:' get ssc picture '999-99-9999' disabled color ,,,,,,,,w+/b,w+/b
@12,1 say 'Driv Lic #:' get drivlic picture replicate('X',(dlicsize)) size 1,20 disabled color ,,,,,,,,w+/b,w+/b
@13,1 say 'State Issd:' get issstate picture '!!' disabled color ,,,,,,,,w+/b,w+/b
@13,17 say 'Date Issd:'  get issdate picture '@D' disabled color ,,,,,,,,w+/b,w+/b
@14,3 say  'Relation:' get relation picture replicate('X',25) size 1,20 disabled color ,,,,,,,,w+/b,w+/b
@ 15,1 say 'Mar Status:' get marstat picture '!' valid (marstat='M' or marstat='S' or marstat='W' ) disabled color ,,,,,,,,w+/b,w+/b
@16,4 say 'Veh Use:' get use picture '999' valid (use <=100)

@ 9,40 say 'Home phone:' get homephone picture '(999)-999-9999' disabled color ,,,,,,,,w+/b,w+/b
@ 10,40 say 'Work phone:' get workphone picture '(999)-999-9999' disabled color ,,,,,,,,w+/b,w+/b
@ 11,40 say 'Occupation:'get occupation picture '!'+replicate('X',(occsize)-1) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
@ 12,42 say 'Employer:' get employer picture '!'+replicate('X',(empsize)-1) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
@ 13,39 say 'Emp Address:' get empadress picture '!'+replicate('X',(empadsize)-1) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
@ 14,43 say 'Emp CSZ:' get empcsz picture '!'+replicate('X',(empcszsize)-1) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
@ 15,41 say 'Emp Phone:' get emphone picture '(999)-999-9999' disabled color ,,,,,,,,w+/b,w+/b
@ 19,7 say 'Notes:' get notes picture '!'+replicate('X',(notesize)-1) size 1,60 disabled color ,,,,,,,,w+/b,w+/b
clear gets
if deleted()
   set color to gr+/r+
   =center(23,'WARNING! This Record Is Marked For Deletion')
   ? chr(7)
   else
   set color to gr+/b
   @ 23,0 to 23,79
endif
set color to gr+/b
@ 0,0 say space(80)
=center(0,'  DRIVER INFORMATION  ')
set reprocess to 1
if lock(alltrim(str(recno())),'driver')=.f.
   @ 1,1 say ' '
   ? chr(7)
   wait window 'This DRIVER is edited by Another User' timeout 1
   ? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in driver
set reprocess to 1
return







***************************************************************************
*                     driver edit
***************************************************************************
function drvdataedit
select driver
dlocked=.f.
if lock(alltrim(str(recno())),'DRIVER')=.f.
   wait window 'This Record is edited by Another User, Try Again Later'
   dlocked =.f.
   return dlocked
else
  dlocked=.t.
endif
   lnamesize =25
   fnamesize =25
   adrsize   =35
   aptsize   =8
   salsize   =10
   dlicsize  =20
   occsize   =30
   empsize   =30
   empadsize =30
   empcszsize=30
   refsize   =30
   notesize  =50
   varsize   =70
   itysize  =20
   countysize=20

 **
****  Initialize the variables now.
 **
   lname=space(lnamesize)
   fname=space(fnamesize)
   mi=' '
   address=space(adrsize)
   aptno=space(aptsize)
   salutation=space(salsize)
   bdate={  /  /    }
   sex='M'
   ssc='   -  -    '
   drivlic=space(dlicsize)
   homephone='(   )-   -    '
   workphone='(   )-   -    '
   occupation=space(occsize)
   employer=space(empsize)
   empadress=space(empadsize)
   empcsz=space(empcszsize)
   emphone='(   )-   -    '
   marstat='S'
   city=space(citysize)
   state='  '
   zip=space(11)
   county=space(countysize)
   use=duse
lname=        dlastn
fname=        dfirstn
mi=           dmi
address=      dadd
aptno=        daptno
salutation=   dsalut
bdate=        dbdate
sex=          dsex
ssc=          dss
drivlic=      ddr_lic_no
homephone=    dphoneh
workphone=    dphonew
occupation=   doccu
employer=     demp_name
empadress=    demp_add
empcsz=       demp_csz
emphone=      dphoneem
marstat=      dmarstatus
notes=        dnotes
city=         dcity
state=        dstate
zip=          dzip
county=       dcounty
relation=drelation
issstate= dissstate
issdate= dissdate
ACCEPT=.F.
SET COLOR TO gr+/b
CLEAR
@ 0,0 TO 2,79 FILL COLOR W/RB+
@ 24,0 say space(80)
@ 23,0 say space(80)
=center(24,'Press F10 to process this Entry')
SET COLOR TO W/RB+
=CENTER(1,'EDITING DRIVER')
SET COLOR TO gr+/b,w/bg+
@5,2 say  'Last Name:' get lname picture '!'+replicate('X',(lnamesize)-1) size 1,25
@5,40 say 'First Name:' get fname picture '!'+replicate('X',(fnamesize)-1) size 1,20
@5,73 say 'MI:' get mi picture '!'
@ 6,4 say 'Address:' get address  picture '!'+replicate('X',(adrsize)-1) size 1,30
@ 6,44 SAY 'Apt No:' get aptno picture replicate('X',(aptsize)-1) size 1,10
@ 7,7 say 'City:' get city picture replicate('X',citysize) size 1,15
@ 7,29 say 'County:' get county picture replicate('X',countysize) size 1,14
@ 7,52 say 'State:' get state picture 'aa'
@ 7,62 say 'Zip:' get zip picture '99999-99999'

@ 9,1 say 'Salutation:' get salutation  picture replicate('X',(salsize)-1) size 1,10
@10,1 say 'Birth Date:' get bdate picture '@D'
@10,27 say 'Sex:' get sex picture '!' valid (sex='M' or sex='F' )
@11,1 say 'Social Sec:' get ssc picture '999-99-9999'
@12,1 say 'Driv Lic #:' get drivlic picture replicate('X',(dlicsize)) size 1,20
@13,1 say 'State Issd:' get issstate picture '!!'
@13,17 say 'Date Issd:'  get issdate picture '@D'
@14,3 say  'Relation:' get relation picture replicate('X',25) size 1,20
@ 15,1 say 'Mar Status:' get marstat picture '!' valid (marstat='M' or marstat='S' or marstat='W' )
@16,4 say 'Veh Use:' get use picture '999' valid (use <=100)

@ 9,40 say 'Home phone:' get homephone picture '(999)-999-9999'
@ 10,40 say 'Work phone:' get workphone picture '(999)-999-9999'
@ 11,40 say 'Occupation:'get occupation picture '!'+replicate('X',(occsize)-1) size 1,26
@ 12,42 say 'Employer:' get employer picture '!'+replicate('X',(empsize)-1) size 1,26
@ 13,39 say 'Emp Address:' get empadress picture '!'+replicate('X',(empadsize)-1) size 1,26
@ 14,43 say 'Emp CSZ:' get empcsz picture '!'+replicate('X',(empcszsize)-1) size 1,26
@ 15,41 say 'Emp Phone:' get emphone picture '(999)-999-9999'
@ 19,7 say 'Notes:' get notes picture '!'+replicate('X',(notesize)-1) size 1,60

SET SYSMENU OFF
READ CYCLE
STATE=UPPER(STATE)
@ 0,0 to 2,79 clear
@ 24,0 say space(80)
return dlocked



***************************************************************************
*                     driver put data
***************************************************************************
procedure putdrvdata
private testlen,testzip
   select driver
   testzip=alltrim(zip)
   testlen=len(testzip)
   if right(testzip,1)='-'
       zip = left( testzip,(testlen-1) )
   else
       zip = testzip
   endif
   replace dpid         with   pid,;
        dlastn        with   upper(alltrim(lname)),;
        dfirstn       with   upper(alltrim(fname)),;
        dmi           with   upper(alltrim(mi)),;
        dadd          with   upper(alltrim(address)),;
        daptno        with   upper(alltrim(aptno)),;
        dsalut        with   upper(alltrim(salutation)),;
        dbdate        with   bdate,;
        dsex          with   upper(alltrim(sex)),;
        dss           with   ssc,;
        ddr_lic_no    with   upper(alltrim(drivlic)),;
        dphoneh       with   upper(alltrim(homephone)),;
        dphonew       with   upper(alltrim(workphone)),;
        doccu         with   upper(alltrim(occupation)),;
        demp_name     with   upper(alltrim(employer)),;
        demp_add      with   upper(alltrim(empadress)),;
        demp_csz      with   upper(alltrim(empcsz)),;
        dphoneem      with   upper(alltrim(emphone)),;
        dmarstatus    with   upper(alltrim(marstat)),;
        dnotes        with   upper(alltrim(notes)),;
        dcity         with   upper(alltrim(city)),;
        dstate        with   upper(alltrim(state)),;
        dzip          with   upper(alltrim(zip)),;
        dcounty       with   upper(alltrim(county)),;
        drelation     with   alltrim(upper(relation)),;
        dissstate     with   issstate,;
        dissdate      with   issdate,;
        duse          with   use
return
