parameter macctno
push menu  _msysmenu
set procedure to 'various'
set exclusive off
set filter to
*public vvid,vresult,vlocked,climenu,vfilename
declare homscreen[41 , 11 ]
homscits=0
private optopt,has,added

vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
mstreet=space(25)
mcity=space(25)
mcounty=space(10)
mstate='  '
mzip='     -     '
mACCTNO=client->acctno
miidno=space(30)
moldiidno=space(30)

mowner=space(30)
mname=space(30)

mOWNER=stuff(mowner,1,len(vappname),vappname)
mname=stuff(mname,1,len(vappname),vappname)
mADDR=space(20)
mage=0
mCONDITION=" "
*   14  COMMENT
mDWELLING=0
mPERSONAL=0
mLIABILITY=0
mDEDUCTIBLE=0
mPREMIUM=0
mOLDCARRIER=space(30)
mCARRIER=space(30)
mOLDPOLICY=space(30)
mPOLICY=space(30)
mCONSTRUCT=space(10)
mHOME=space(10)
mFAMILIES=1
mFLOORS=1
mNEW="N"
MHOME='H'


has=.f.
has=inithomsystem()
if has=.f.
     ?? CHR(7)
     wait window 'No property Found For this Customer' timeout 1
     ?? chr(7)
     wait window 'Press any key to ADD one'
   addedhom=addhom()
   if addedhom
      =inithomsystem()
      do homdisplay
   else
      return
   endif
endif
DO homPAINT with .t.
SAVE SCREEN TO vscreen
do homdisplay
mhq=0
do homoptions

do while mhq=0
   activate menu _msysmenu
enddo

set filter to
pop menu _msysmenu
return

******************************************************************************
*                    Procedure home system Initialization
******************************************************************************
function inithomsystem
private tf
tf=.t.

IF !USED('icompany')
   select d
   use icompany index icompany alias icompany
else
  select icompany
endif
set order to tag iidno

if !used('home')
   select 30
            use home index home alias home
else
   select home
endif
set filter to
LoCATE FOR ACCTNO=mACCTNO
*seek macctno
IF FOUND()
   set filter to acctno=macctno
   go top
ELSE
    tf=.f.
endif
return tf

******************************************************************************
*                    Procedure home options
******************************************************************************
Procedure homOptions
  DeFINE MENU _msysmenu bar color scheme 3
  * BAR AT LINE 1 COLOR SCHEME 4
  DEFINE PAD Add        OF _msysmenu  PROMPT '\<Add'         
  DEFINE PAD Options    OF _msysmenu  PROMPT '\<Options'     
  DEFINE PAD First      OF _msysmenu  PROMPT '\<First'       
  DEFINE PAD Previous   OF _msysmenu  PROMPT '\<Previous'    
  DEFINE PAD Next       OF _msysmenu  PROMPT '\<Next '       
  DEFINE PAD Last       OF _msysmenu  PROMPT '\<Last'        
  DEFINE PAD Edit       OF _msysmenu  PROMPT '\<Edit'        
  DEFINE PAD Delete     OF _msysmenu  PROMPT '\<Delete'      
  DEFINE PAD Undelete   OF _msysmenu  PROMPT '\<UnDelete'    
  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit'        


on selection pad  Add      of _msysmenu  do mhomAdd
*on pad  options  of _msysmenu  activate popup hompoptions
on selection pad  First    of _msysmenu  do mhomFirst
on selection pad  Previous of _msysmenu  do mhomPrevious
on selection pad  Next     of _msysmenu  do mhomNext
on selection pad  Last     of _msysmenu  do mhomLast
on selection pad  Edit     of _msysmenu  do mhomEdit
on selection pad  Delete   of _msysmenu  do mhomDelete
on selection pad  Undelete of _msysmenu  do mhomUndelete
on selection pad  Quit     of _msysmenu  do mhomQuit

return


******************************************************************************
*                       previous home
******************************************************************************
procedure mhomprevious
          skip -1
          if bof('home')
             Wait window 'This is the FIRST home' timeout 2
             go top
          else
              do homdisplay
          endif
return


******************************************************************************
*                    next home
******************************************************************************
procedure mhomnext
           skip
           if eof('home')
              wait window 'This is the LAST home' timeout 2
              go bottom
           else
               do homdisplay
           endif
return


******************************************************************************
*                     edit home
******************************************************************************
procedure mhomedit
          rec=recno()
*          hide menu _msysmenu
          vlocked=homdataedit()
          select home
          if ( (vlocked=.t.) and (lastkey() # 27) )
                 wait window "Updating" timeout 1
                 goto rec
                 do puthomdata
                 wait clear
          endif
          unlock in home
          vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
          do homdisplay
*          show menu _msysmenu
return


******************************************************************************
*                  delete home
******************************************************************************
procedure mhomdelete
     select client
     if recused('client',recno()) )
        ?? chr(7)
        wait window "Somebody is editing this home's owner" timeout 2
     else
     select home
            if dactive=.t.
               ?? chr(7)
               wait window "Cannot delete a Property with an Active Policy" timeout 2
               return
             endif
          tf=acertain('DELETE REALLY?',.f.)
          if ( (tf=.t.) and !recused('home',recno()) )
             delete
             unlock in home
             select home
             do homdisplay
          endif
        SELECT home
      ENDIF
return

******************************************************************************
*                   recall home
******************************************************************************
procedure mhomundelete
          rec=recno()
          recall FOR ACCTNO=MACCTNO
          goto rec
          do homdisplay
return

******************************************************************************
*                    goto first home
******************************************************************************
procedure mhomfirst
          go top
          do homdisplay
return


******************************************************************************
*                    goto last home
******************************************************************************
procedure mhomlast
          go bottom
          do homdisplay
return


******************************************************************************
*                    add home
******************************************************************************
procedure mhomadd
          addedhom=addhom()
          if addedhom
                =inithomsystem()		
          endif          
          do hompaint with .t.
          do homdisplay
return

******************************************************************************
*                    quit homes
******************************************************************************
procedure mhomquit
*          hide menu _msysmenu
*          DEACTIVATE MENU _msysmenu
*          RELEASE MENU _msysmenu
		   mhq=1
return



******************************************************************************
*                    Procedure display home info
******************************************************************************
procedure homdisplay


if type('homscits')='U'
        a=fname("homsc.mem")
	if file(a)
   		restore from &a additive
                restore screen from vscreen
	else
                do HOMpaint with .f.
	endif
else 
        restore screen from vscreen
endif
if !used('home')
   select 30
            use home index home alias home
else
   select home
endif

if type('homscits')='U'
        sdesign=.f.
        a=fname("homscre.mem")
        if file(a)
                restore from &a additive
                sdesign=.t.
        else
                sdesign=.f.
        endif
else
        sdesign=.t.
endif
SDESIGN=.F.
set color to gr+/b
@ 24,0 say space(80)
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=hash(myname)
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        quit
endif

MDHOMID        = DHOMID
MACCTNO        = ACCTNO
MDPID          = DPID
MIIDNO         = IIDNO
MOLDIIDNO      = OLDIIDNO
MOWNER         = OWNER
MADDR          = ADDR
MYEAR          = YEAR
MCONDITION     = CONDITION
MNAME          = NAME
MSTREET        = STREET
MCITY          = CITY
MCOUNTY        = COUNTY
MSTATE         = STATE
MZIP           = ZIP
MCOMMENT       = COMMENT
MDWELLING      = DWELLING
MPERSONAL      = PERSONAL
MLIABILITY     = LIABILITY
MDEDUCTIBLE    = DEDUCTIBLE
MpREMIUM       = dtotal
MOLDCARRIER    = OLDCARRIER
MCARRIER       = CARRIER
MOLDPOLICY     = OLDPOLICY
MPOLICY        = POLICY
MAGE           = AGE
MCONSTRUCT     = CONSTRUCT
MHOME          = HOME
MFAMILIES      = FAMILIES
MFLOORS        = FLOORS
MNEW           = NEW

if sdesign=.f.
     set color to gr+/b

*     @ 2,0 to 23,79 clear

    
	set color to gr+/r
	
	@ 4,1 say space(78)
	@ 14,1 say space(78)
     =centerc(4,"Property Information","gr+/r")
     =centerc(14,"Coverage Information","gr+/r")

set color to gr+/b

     @ 3,4 say 'Applicant Name:' get mname disabled color ,,,,,,,,w+/b,w+/b


     @ 5,2 say 'Owner:' get mowner disabled color ,,,,,,,,w+/b,w+/b
     @ 6,1 say 'Street:'get mstreet disabled color ,,,,,,,,w+/b,w+/b
     @ 7,3 say 'City:' get mcity size 1,15 disabled color ,,,,,,,,w+/b,w+/b
     @ 7,25 say 'County:' get mcounty size 1,10 disabled color ,,,,,,,,w+/b,w+/b
     @ 7,44 say 'State:' get mstate   disabled color ,,,,,,,,w+/b,w+/b
     @ 7,54 say 'ZIP:' get mzip picture '99999-99999' disabled color ,,,,,,,,w+/b,w+/b

*     @ 7,3 say 'City:' get mcity size 1,15 disabled color ,,,,,,,,w+/b,w+/b
*     @ 7,25 say 'State:' get mstate disabled color ,,,,,,,,w+/b,w+/b
*     @ 7,35 say 'ZIP:' get mzip picture '99999-99999' disabled color ,,,,,,,,w+/b,w+/b

     @ 9,1   say "           Age:" get mage picture '999' disabled color ,,,,,,,,w+/b,w+/b
     @ 9,50  say " Construction:"  get mconstruction disabled color ,,,,,,,,w+/b,w+/b
     @ 10,2  say "Home/Bus/Rent:" get mhome picture "X" disabled color ,,,,,,,,w+/b,w+/b
     @ 10,44 say "New/Existing Policy:" get mnew disabled color ,,,,,,,,w+/b,w+/b
     @ 11,1  say "      Families:" get mfamilies picture '999' disabled color ,,,,,,,,w+/b,w+/b
     @ 11,50 say "       Floors:" get mfloors    picture '999' disabled color ,,,,,,,,w+/b,w+/b

*     @ 13,1  say "Old Carrier:" get moldcono picture '999'
*     @ 13,20 say "Name:" get moldcarrier disabled color ,,,,,,,,w+/b,w+/b
*     @ 14,9  say "Old Policy #:" get moldpolicy disabled color ,,,,,,,,w+/b,w+/b

     @ 12,8 say "Old Carrier:" get moldiidno picture '999999' disabled color ,,,,,,,,w+/b,w+/b
     @ 12,30 say "Name:" get moldcarrier disabled color ,,,,,,,,w+/b,w+/b
     @ 13,8  say "Old Policy :" get moldpolicy disabled color ,,,,,,,,w+/b,w+/b

     @ 15,4 say "Current Carrier:" get miidno  picture '999999' disabled color ,,,,,,,,w+/b,w+/b
     @ 15,30 say "Name:" get mcarrier disabled color ,,,,,,,,w+/b,w+/b
     @ 16,4  say "Current Policy :" get mpolicy disabled color ,,,,,,,,w+/b,w+/b

     @ 17,1 say "                  Deductible:" get mdeductible picture '9999999.99' disabled color ,,,,,,,,w+/b,w+/b
     @ 18,1 say "Dwelling/Property Protection:" get mdwelling   picture '9999999.99' disabled color ,,,,,,,,w+/b,w+/b
     @ 19,1 say "Personal Property Protection:" get mpersonal   picture '9999999.99' disabled color ,,,,,,,,w+/b,w+/b
     @ 20,1 say "                   Liability:" get mliability  picture '9999999.99' disabled color ,,,,,,,,w+/b,w+/b
     @ 22,1 say "               Premium Total:" get mpremium    picture '9999999.99' disabled color ,,,,,,,,w+/b,w+/b

else
hidden=.f.
     for i=2 to homscits
        if homscreen[i,8]=.t.
              if homscreen[i,6]>0
                    @ homSCREEN[I,1],homSCREEN[I,2]+len(homSCREEN[I,3])+1 GET         (homSCREEN[I,4]);
                                                    picture     homSCREEN[I,5] ;
                                                    size         1,homscreen[i,6];
                                                    COLOR        gr+/b,w+/b
*         else
*                    @ homSCREEN[I,1],homSCREEN[I,2] SAY    homSCREEN[I,3] ;
*                                                    COLOR  gr+/b,w+/b
         endif
        else
                if type(homscreen[i,4])="C" .and. len(alltrim(evaluate(homscreen[i,4])))>0
                   hidden=.t.
                endif
        endif
     endfor
    if hidden
       wait window "There is Hidden Data that you do not see!" timeout 2
    endif
endif
clear gets

 if deleted()
   set color to gr+/r
   =center(23,'WARNING! this record has been marked for deletion')
   ?? chr(7)
   set color to gr+/b
else
   set color to gr+/b
   @23,0 say space(80)
endif
set color to gr+/n
@0,0 say space(80)
=center(0,'  PROPERTY DATA  ')
set reprocess to 1
if lock(alltrim(str(recno())),'home')=.f.
   ?? chr(7)
   wait window 'This home is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in home
set reprocess to 1
return



******************************************************************************
*                    Procedure edit home data
******************************************************************************
function homdataedit

select client
if recused('client',recno())
   ?? chr(7)
   wait window "NO EDITING,Somebody is editing the homes owner!!" timeout 2
   return .f.
endif

select home

if ( (len(alltrim(home.policy))>0) .or. ( home.dactive=.t. ) )
   ?? chr(7)
   wait window "NO EDITING,There is an Active Policy for this Property" timeout 2
   return .f.
endif


vlocked=.f.
if lock(alltrim(str(recno())),'home')=.f.
   wait window 'This Account is edited by Another User Try Again Later'
   vlocked =.f.
   return vlocked
else
   vlocked=.t.
endif


on key label f10 keyboard "{ctrl+w}"
set color to w/b
clear
*set color to w/b,b/w
*@ 1,0 to 24,79 clear
set color to gr+/n
@ 0,0 say space(80)
=CENTER(0,'EDITING PROPERTY DATA')
set color to gr+/b
@ 23,0 say space(80)



MDHOMID        = DHOMID
MACCTNO        = ACCTNO
MDPID          = DPID
MIIDNO         = IIDNO
MOLDIIDNO      = OLDIIDNO
MOWNER         = OWNER
MADDR          = ADDR
MYEAR          = YEAR
MCONDITION     = CONDITION
MNAME          = NAME
MSTREET        = STREET
MCITY          = CITY
mcounty        = county
MSTATE         = STATE
MZIP           = ZIP
MCOMMENT       = COMMENT
MDWELLING      = DWELLING
MPERSONAL      = PERSONAL
MLIABILITY     = LIABILITY
MDEDUCTIBLE    = DEDUCTIBLE
MPREMIUM       = dtotal
MOLDCARRIER    = OLDCARRIER
MOLDPOLICY     = OLDPOLICY
MPOLICY        = POLICY
MAGE           = AGE
MCONSTRUCT     = CONSTRUCT
MHOME          = HOME
MFAMILIES      = FAMILIES
MFLOORS        = FLOORS
MNEW           = NEW

set color to gr+/b
=center(24,'Press F10 to Accept this home')
* 0,0 say '³'
* 0,79 say '³'
* 1,0 say 'À'
* 1,79 say 'Ù'
* 1,1 to 1,78


if type('homscits')='U'
        sdesign=.f.
        a=fname("homscre.mem")
        if file(a)
                restore from &a additive
                sdesign=.t.
        else
                sdesign=.f.
        endif
else
        sdesign=.t.
endif
SDESIGN=.F.


     set color to gr+/b

     @ 2,0 to 24,79 clear
     @ 23,0 to 24,79 clear

    
	set color to gr+/r
	@  4,1 say space(78)
	@ 14,1 say space(78)

     =centerc(4,"Property Information","gr+/r")
     =centerc(14,"Coverage Information","gr+/r")
     
set color to gr+/b,w+/bg
=center(24,'Press F10 to Accept this PROPERTY')

     @ 3,4 say 'Applicant Name:' get mname


     @ 5,2 say 'Owner:' get mowner
     @ 6,1 say 'Street:'get mstreet
     @ 7,3 say 'City:' get mcity size 1,15
     @ 7,25 say 'County:' get mcounty size 1,10
     @ 7,44 say 'State:' get mstate
     @ 7,54 say 'ZIP:' get mzip picture '99999-99999'

*     @ 7,3 say 'City:' get mcity size 1,15
*     @ 7,25 say 'State:' get mstate
*     @ 7,35 say 'ZIP:' get mzip picture '99999-99999'

     @ 9,1   say "           Age:" get mage picture '999'
     @ 9,50  say " Construction:"  get mconstruction
     @ 10,2  say "Home/Bus/Rent:" get mhome picture "X"
     @ 10,44 say "New/Existing Policy:" get mnew PICTURE 'X'
     @ 11,1  say "      Families:" get mfamilies picture '999'
     @ 11,50 say "       Floors:" get mfloors    picture '999'


*     @ 13,1  say "Old Carrier:" get moldcono picture '999'
*     @ 13,20 say "Name:" get moldcarrier
*     @ 14,9  say "Old Policy #:" get moldpolicy

     @ 12,8 say "Old Carrier:" get moldiidno picture '999999' valid oldnum(moldiidno)
     @ 12,30 say "Name:" get moldcarrier disabled 
     @ 13,8  say "Old Policy :" get moldpolicy

     @ 15,4 say "Current Carrier:" get miidno  picture '999999' valid newnum(miidno)
     @ 15,30 say "Name:" get mcarrier disabled 
     @ 16,4  say "Current Policy :" get mpolicy disabled 

     @ 17,1 say "                  Deductible:" get mdeductible picture '9999999.99'
     @ 18,1 say "Dwelling/Property Protection:" get mdwelling   picture '9999999.99'
     @ 19,1 say "Personal Property Protection:" get mpersonal   picture '9999999.99'
     @ 20,1 say "                   Liability:" get mliability  picture '9999999.99'
     @ 22,1 say "               Premium Total:" get mpremium    picture '9999999.99'

     read cycle

@ 23,0 say space(80)
@ 24,0 say space(80)
on key label f10
return vlocked



******************************************************************************
*                    PAINT home SCREEN
******************************************************************************
PROCEDURE homPAINT
parameter first



fn=fname("homscre.mem")
if !file(fn)

set color to gr+/b
*=center(24,'Press F10 to Accept this PROPERTY')
     set color to gr+/b

     @ 2,0 to 24,79 clear
     @ 23,0 to 24,79 clear

    set color to gr+/r
	@  4,1 say space(78)
	@ 14,1 say space(78)
     =centerc(14,"Coverage Information","gr+/r")
     =centerc(4,"Property Information","gr+/r")

set color to gr+/b
=center(24,'Press F10 to Accept this PROPERTY')

     @ 3,4 say 'Applicant Name:'



     @ 5,2 say 'Owner:'
     @ 6,1 say 'Street:'
     @ 7,3 say 'City:'
     @ 7,25 say 'County:'
     @ 7,44 say 'State:'
     @ 7,54 say 'ZIP:'
*     @ 7,3 say 'City:'
*     @ 7,25 say 'State:'
*     @ 7,35 say 'ZIP:'

     @ 9,1   say "           Age:"
     @ 9,50  say " Construction:"
     @ 10,2  say "Home/Bus/Rent:"
     @ 10,44 say "New/Existing Policy:"
     @ 11,1  say "      Families:"
     @ 11,50 say "       Floors:"


*     @ 13,20 say "Name:"
*     @ 14,9  say "Old Policy #:"
     @ 12,8 say "Old Carrier:"
     @ 12,30 say "Name:"
     @ 13,8  say "Old Policy :"

     @ 15,4 say "Current Carrier:"
     @ 15,30 say "Name:"
     @ 16,4  say "Current Policy :"

     @ 17,1 say "                  Deductible:"
     @ 18,1 say "Dwelling/Property Protection:"
     @ 19,1 say "Personal Property Protection:"
     @ 20,1 say "                   Liability:"
     @ 22,1 say "               Premium Total:"


else
    restore from &fn additive
vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
    for i=1 to homscits
                  if homscreen[i,8]=.t.
                          @ homsCREEN[I,1],homSCREEN[I,2] SAY  homSCREEN[I,3] ;
                                                         COLOR gr+/b,w+/b
                  endif
                  clear gets
    endfor
endif
set color to gr+/n
@0,0 say space(80)
=center(0,'  PROPERTY DATA  ')

if first
  SAVE SCREEN TO vscreen
  A=FNAME("homSC.MEM")
  SAVE ALL LIKE vscreen TO &A
  set color to gr+/b
else
*  set color to n/w
*  @1,0 say space(80)
  SAVE SCREEN TO vscreen
  A=FNAME("homSC.MEM")
  SAVE ALL LIKE vscreen TO &A
  set color to gr+/b
endif
return



******************************************************************************
*                   call home edit screen
******************************************************************************
procedure mhomed
          save screen to ed
          hide popup hompoptions
*          hide menu _msysmenu
          tf=Mhomedit()
              release homscreen
              release homscits
              release vscreen
              set color to gr+/b
              @ 2,0 to 24,79 clear
              do hompaint with .f.
              do homdisplay
          show popup hompoptions
*          show menu _msysmenu
return


*fields

* DHOMID
* ACCTNO
* DPID
* IIDNO
* OWNER
* ADDR
* YEAR
* CONDITION
* NAME
* STREET
* CITY
* STATE
* ZIP
* COMMENT
* DWELLING
* PERSONAL
* LIABILITY
* DEDUCTIBLE
* PREMIUM
* OLDCARRIER
* OLDPOLICY
* POLICY
* AGE
* CONSTRUCT
* HOME
* FAMILIES
* FLOORS
* NEW
* OLDIIDNO




******************************************************************************
*                    Procedure Puthomdata
******************************************************************************
Procedure Puthomdata
private testlen,testzip,testdate,testss
if !used('home')
   select 30
            use home index home alias home
else
   select home
endif
   testzip = alltrim(Mzip)
   testlen = len(testzip)
   if right(testzip,1)='-'
       vlesszip=left( testzip,(testlen-1) )
   else
       vlesszip=testzip
   endif

id=gethomid()
select home
replace dhomid with id,;
    acctno      with      CLIENT.acctno,;
    OWNER      with       upper(ALLTRIM(mOWNER)),;
    ADDR       with       upper(ALLTRIM(mADDR)),;
    CONDITION  with       mCONDITION,;
    NAME       with       upper(ALLTRIM(mNAME)),;
    STREET     with       upper(ALLTRIM(mSTREET)),;
    CITY       with       upper(ALLTRIM(mCITY)),;
    CounTY     with       upper(ALLTRIM(mCounTY)),;
    STATE      with       upper(ALLTRIM(mSTATE)),;
    ZIP        with       VLESSZIP,;
    DWELLING   with       mDWELLING,;
    PERSONAL   with       mPERSONAL,;
    LIABILITY  with       mLIABILITY,;
    DEDUCTIBLE with       mDEDUCTIBLE,;
    DTOTAL     with       mPREMIum,;
    OLDCARRIER with       upper(ALLTRIM(mOLDCARRIER)),;
    CARRIER    with       upper(ALLTRIM(mCARRIER)),;
    iidno      with       upper(alltrim(miidno)),;
    oldiidno   with       upper(alltrim(moldiidno)),;
    OLDPOLICY  with       upper(ALLTRIM(mOLDPOLICY)),;
    POLICY     with       upper(ALLTRIM(mPOLICY)),;
    AGE        with       mAGE,;
    CONSTRUCT  with       upper(ALLTRIM(mCONSTRUCT)),;
    FAMILIES   with       mFAMILIES,;
    FLOORS     with       mFLOORS,;
    HOME       WITH       MHOME,;
    NEW        WITH       MNEW

select home
return


procedure oldnum
parameter num
     select icompany
     set order to tag iidno
     seek num
     if ( !found() ) 
        go top
        @ 24,0 say space(80)
        =center(24,"Press F10 to Accept Entry")
        on key label enter keyboard "{ctrl+w}"
        set deleted on
        set order to tag iname
        go top
        browse fields iname:h="Company Name",iidno:h="Number" nomodify;
        	nomenu color scheme 10 font "Arial",11
        set deleted off
        on key label enter
     endif
     set filter to
     moldcarrier=icompany->iname
     moldiidno=icompany->iidno
show gets
select home
return


procedure newnum
parameter num
     select icompany
     set order to tag iidno
     seek num
     if (!found())
        go top
        @ 24,0 say space(80)
        =center(24,"Press F10 to Accept Entry")
        on key label enter keyboard "{ctrl+w}"
        set deleted on
        set order to tag iname
        go top
        browse fields iname:h="Company Name",iidno:h="Number" nomodify;
        	nomenu color scheme 10 font "Arial",11
        set deleted off
        on key label enter
     endif
     set filter to
     mcarrier=icompany->iname
     miidno=icompany->iidno
show gets
select home
return


