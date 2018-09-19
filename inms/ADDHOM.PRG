set procedure to 'various'
set exclusive off
declare homscreen[41 , 11 ]
homscits=0
release homscits
if menu()=upper("homemen")
   hide menu homemenu
endif
if menu()=upper("mainmenu")
   hide menu mainmenu
endif
private what
clear read
clear gets

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
on key label f10 keyboard "{CTRL+W}"


vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
mstreet=space(25)
mcity=space(25)
mcounty=space(10)
mstate='  '
mzip='     -     '
mACCTNO=client->acctno

mowner=space(30)
mname=space(30)

mOWNER=stuff(mowner,1,len(vappname),vappname)
mname=stuff(mname,1,len(vappname),vappname)


mstreet=stuff(mstreet,1,len(client->add),client->add)
mcity=stuff(mcity,1,len(client->city),client->city)
mcounty=left(stuff(mcounty,1,len(client->county),client->county),10)
mstate=client->state
mzip=client->zip
mage=0
mCONDITION=" "
*   14  COMMENT
mDWELLING=0
mPERSONAL=0
mLIABILITY=0
mDEDUCTIBLE=0
mPREMIUM=0
moldiidno=space(20)
miidno=space(20)
mOLDCARRIER=space(30)
mCARRIER=space(30)
mOLDPOLICY=space(30)
mPOLICY=space(30)
mCONSTRUCT=space(10)
mHOME="H"
mFAMILIES=1
mFLOORS=1
mNEW="N"

*save screen to addhomsc
what=addhome()
*wait window "Now Press a Key to add a PREMIUM for this car"
*do mcover
*restore screen from addhomsc
*release addhomsc
return what


******************************************************************************
*                    Procedure add home
******************************************************************************
function addhome
private tf,double

double=.t.
vvid=space(20)
set color to w/b
clear
set color to gr+/n
@ 0,0 say space(80)
=CENTER(0,'ADDING  NEW  PROPERTY ')
set color to gr+/b
@ 23,0 say space(80)
set color to gr+/b,w+/bg

do while double=.t.
set color to gr+/b
=center(24,'Press F10 to Accept this PROPERTY')
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

     set color to gr+/b

     @ 2,0 to 24,79 clear
     @ 23,0 to 24,79 clear

     set color to gr+/r
     @ 4,1 say space(78)
     @ 14,1 say space(78)
     =centerc(4,"Property Information","gr+/r")
     =centerc(14,"Coverage Information","gr+/r")
set color to gr+/b
=center(24,'Press F10 to Accept this PROPERTY')

     @ 3,4 say 'Applicant Name:' get mname


     @ 5,2 say 'Owner:' get mowner
     @ 6,1 say 'Street:'get mstreet
     @ 7,3 say 'City:' get mcity size 1,15
     @ 7,25 say 'County:' get mcounty size 1,10
     @ 7,44 say 'State:' get mstate
     @ 7,54 say 'ZIP:' get mzip picture '99999-99999'

     @ 9,1   say "           Age:" get mage picture '999'
     @ 9,50  say " Construction:"  get mconstruction
     @ 10,2  say "Home/Bus/Rent:" get mhome picture "X"
     @ 10,44 say "New/Existing Policy:" get mnew
     @ 11,1  say "      Families:" get mfamilies picture '999'
     @ 11,50 say "       Floors:" get mfloors    picture '999'


     @ 12,8 say "Old Carrier:" get moldiidno picture '999999' valid oldnum(moldiidno)
     @ 12,30 say "Name:" get moldcarrier disabled
     @ 13,8  say "Old Policy :" get moldpolicy

     @ 15,4 say "Current Carrier:" get miidno  picture '999999' valid newnum(miidno)
     @ 15,30 say "Name:" get mcarrier disabled
*     @ 16,4  say "Current Policy :" get mpolicy disabled color ,,,,,,,,w+/b,w+/b

     @ 17,1 say "                  Deductible:" get mdeductible picture '9999999.99'
     @ 18,1 say "Dwelling/Property Protection:" get mdwelling   picture '9999999.99'
     @ 19,1 say "Personal Property Protection:" get mpersonal   picture '9999999.99'
     @ 20,1 say "                   Liability:" get mliability  picture '9999999.99'
     @ 22,1 say "               Premium Total:" get mpremium    picture '9999999.99'

     read cycle


if lastkey()=27
        return .f.
endif
       tf=acertain('Proceed with ADDING this PROPERTY?',.t.)
       if tf=.f.
          return .f.
       else
           append blank
           do puthomdata
           double =.f.
       endif
enddo
return .t.


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
    acctno      with       CLIENT.acctno,;
    OWNER       with       upper(ALLTRIM(mOWNER)),;
    ADDR        with       upper(ALLTRIM(mADDR)),;
    CONDITION   with       mCONDITION,;
    NAME        with       upper(ALLTRIM(mNAME)),;
    STREET      with       upper(ALLTRIM(mSTREET)),;
    CITY        with       upper(ALLTRIM(mCITY)),;
    COUNTY      with       upper(ALLTRIM(mCOUNTY)),;
    STATE       with       upper(ALLTRIM(mSTATE)),;
    ZIP         with       VLESSZIP,;
    DWELLING    with       mDWELLING,;
    PERSONAL    with       mPERSONAL,;
    LIABILITY   with       mLIABILITY,;
    DEDUCTIBLE  with       mDEDUCTIBLE,;
    dtotal      with       mPREMIUM,;
    OLDCARRIER  with       upper(ALLTRIM(mOLDCARRIER)),;
    CARRIER     with       upper(ALLTRIM(mCARRIER)),;
    OLDPOLICY   with       upper(ALLTRIM(mOLDPOLICY)),;
    AGE         with       mAGE,;
    CONSTRUCT   with       upper(ALLTRIM(mCONSTRUCT)),;
    FAMILIES    with       mFAMILIES,;
    FLOORS      with       mFLOORS,;
    HOME        WITH       MHOME,;
    NEW         WITH       MNEW,;
    iidno       with       miidno,;
    oldiidno    with       moldiidno,;
    county      with       upper(alltrim(mcounty))

*    POLICY      with       ALLTRIM(mPOLICY),;

select home
return



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
* oldiidno



procedure oldnum
parameter num
     select icompany
     set order to tag iidno
     seek num
     if ( !found() )
        go top
        @ 24,0 to 24,79 clear
        =center(24,"Press F10 to Accept Entry")
        on key label enter keyboard "{ctrl+w}"
        set deleted on
        set order to tag iname
        go top
        browse fields iname:h="Company Name",iidno:h="Number" nomodify nomenu ;
        	color scheme 10 font "Arial",11
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
     if ( !found() )
        go top
        @ 24,0 to 24,79 clear
        =center(24,"Press F10 to Accept Entry")
        on key label enter keyboard "{ctrl+w}"
        set deleted on
        set order to tag iname
        go top
        browse fields iname:h="Company Name",iidno:h="Number" nomodify nomenu;
        	color scheme 10 font "Arial",11
        set deleted off
        on key label enter
    endif
    mcarrier=icompany->iname
    miidno=icompany->iidno
show gets
select home
return


