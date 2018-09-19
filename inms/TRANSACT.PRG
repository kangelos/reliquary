
*
* stub for statement of transaction / Affidavit of sale
*
*set talk off

set exclusive off
* Statement of transaction or affidavit of sale/gift
page='Statement of Transaction'
*   ='Affidavit of Sale/Gift'

reg_entered=0
*        Variable Description By function called

               *************************
               * Function  transaction *
               *************************

***************   New/Previous owner Information **************************
trsale=.f.                  &&          sale
trgift=.f.                  &&          gift
prelname=space(30)          &&     Previous owner Last Name
prefname=space(30)          &&                    First Name
premi=space(1)              &&                    Middle Initial
premaddress=space(45)       &&                    Mailing address
premcity=space(30)          &&                       -//-
premstate=space(2)          &&                       -//-
premzip=space(5)            &&                       -//-
premcounty=space(30)        &&                       -//-
newlname=space(30)          &&     NEW owner Last Name
newfname=space(30)          &&                    First Name
newmi=space(1)              &&                    Middle Initial
newmaddress=space(45)       &&                    Mailing address
newmcity=space(30)          &&                       -//-
newmstate=space(2)          &&                       -//-
newmzip=space(5)            &&                       -//-
newmcounty=space(30)        &&                       -//-
newssoc=space(11)           &&                 Social security

baddress=space(45)          &&                Business Address
bcity=space(30)             &&                    -//-
bstate=space(2)             &&                    -//-
bzip=space(1)               &&                    -//-
bcounty=space(30)           &&                    -//-

motovehicle=.f.             &&             Vehicle information
atv=.f.                     &&                  -//-
snowmobile=.f.              &&                  -//-
boat=.f.                    &&                  -//-
length=space(6)             &&                  -//-

year='19  '                 &&            Vehicle info
make=space(30)              &&                -//-
model=space(30)             &&                -//-
vehidnum=space(25)          &&           vehicle ID number

delcity=space(30)           &&        city of delivery
delcounty=space(30)         &&        county of delivery
stocity=space(30)           &&        city of storage
stocounty=space(30)         &&        county of storage
residence=.f.               &&        in county of storage/use

purchase=.f.                &&        Type of transaction
gif=.f.                     &&               -//-

pdate=space(8)             &&         Purchase  Date of
pprice=0                   &&          -//-     price
ptaxrate=0                 &&          -//-     taxrate
ptax=0                     &&          -//-     total tax
pparent=.f.                &&          -//-     from parent etc.
prelation=space(30)        &&          relation to purchaser

fgift=.f.                  &&          Gift from foreigner
rgift=.f.                  &&          Gift from relative

rparent=.f.                &&            Relationship
rchild=.f.                 &&
rstepparent=.f.            &&
rstepchild=.f.             &&
rspouse=.f.                &&
*************************************************************************




               *************************
               * Function  Affidavit *
               *************************

***************   New/Previous owner Information **************************
afsale=.f.                    &&     Affidavit of sale
afgift=.f.                    &&       -//-    of gift
afprelname=space(30)          &&     Previous owner Last Name
afprefname=space(30)          &&                    First Name
afpremi=space(1)              &&                    Middle Initial
afpremaddress=space(45)       &&                    Mailing address
afpremcity=space(30)          &&                       -//-
afpremstate=space(2)          &&                       -//-
afpremzip=space(5)            &&                       -//-
afpremcounty=space(30)        &&                       -//-
afnewlname=space(30)          &&     NEW owner Last Name
afnewfname=space(30)          &&                    First Name
afnewmi=space(1)              &&                    Middle Initial
afnewmaddress=space(45)       &&                    Mailing address
afnewmcity=space(30)          &&                       -//-
afnewmstate=space(2)          &&                       -//-
afnewmzip=space(5)            &&                       -//-
afnewmcounty=space(30)        &&                       -//-
afnewssoc=space(11)           &&                 Social security

afmotovehicle=.f.            &&             Vehicle information
afatv=.f.                    &&                  -//-
afsnowmobile=.f.             &&                  -//-
afboat=.f.                   &&                  -//-

afyear='19  '                &&            Vehicle info
afmake=space(30)             &&                -//-
afmodel=space(30)            &&                -//-
afvehidnum=space(25)         &&           vehicle ID number

afvgood=.f.                  &&             vehicle condition
afvfair=.f.                  &&                  -//-
afvpoor=.f.                  &&                  -//-
afvmiles=0                   &&            miles or hours

afpdate=space(8)             &&         Purchase  Date of
afpplace=space(50)           &&         Place of delivery
afpprice=0                   &&          -//-     price
afrelation='NONE'            &&          Relationship of buyer/recipient

afservice=.f.                &&        Service performed ?
afservalue=0                 &&            How much
afservexplain=space(50)      &&            explain
afbalance=.f.                &&        Balance assumed ?
afbalvalue=0                 &&            how much
afbalexplain=space(50)       &&            explain
afelse=.f.                   &&        Anything else given ?
afelsexplain=space(50)       &&            explain
aftrade=.f.                  &&        Trade Made ?
aftradexplain=space(50)      &&            explain
afofficer=.f.                &&        Officer of corporation ?
afoffexplain=space(50)       &&            explain
afemploy=.f.                 &&        Employment contract ?
afemployexplain=space(50)    &&            explain
afoffrelate=.f.              &&        related with officer
afoffrelexplain=space(50)    &&            explain
*************************************************************************

public reallygetout
reallygetout=.f.
on key label f10 keyboard "{CTRL+W}"
do transaffid
return


*****************************************************************************
*                  get Vehicle Registration / Title Application
*****************************************************************************
procedure transaffid


set color to gr+/b
clear
@ 0,0 to 24,79 double

DO DEFINE_WINDOWS

set color to gR+/b


sections=1
* reverse logic for the following loop
store .f. to trans,affid
do while (notallcompleted(trans,affid) and ( reallygetout =.f. ))
   sections=transcontrol()


   do case
      case sections=1
                    trans=aftransaction()
      case sections=2
                    affid=affidavit()
      case sections=3
                    do afmissing with trans,affid
      otherwise
                    wait window 'Fatal failed control in transact.prg' timeout 1
   endcase

enddo

do getout
return



***************************************************************************
*                  control input
***************************************************************************
function transcontrol
private select,value,last


last=27
do while last=27
   ACTIVATE WINDOW section
   select="Statement of Transaction"
   clear 
   set color to r/w
   @ 1,1 get select picture "@*! Statement of Transaction;Affidavit of Sale/Gift;Accept and Exit" size 1,26
   read cycle
   if select='Accept and Exit'
      tf=.f.
   endif
   last=lastkey()
enddo


do case
   case select='Statement of Transaction'
       value=1
   case select='Affidavit of Sale/Gift'
       value=2
   case select='Accept and Exit'
       value=3
   otherwise
       value=0   * error
endcase

deactivate window section
return value



***************************************************************************
*                  procedure missing
***************************************************************************
procedure afmissing
parameter log1,log2
private string1,string2,string3,string4,string5,string6,yesno,tf

store  space(30) to string1,string2,string3,string4,string5,string6

if log1=.f.
   string1='STATEMENT OF TRANSACTION'
endif
if log2=.f.
   string2='AFFIDAVIT OF SALE/GIFT'
endif

set color to gr+/b
activate window missing
clear
set color to GR+/r+
@ 0,5 SAY 'You still have to fill in the following sections'
set color to gr+/b
@ 2,20 say string1
@ 3,20 say string2

set color to w/b
@ 6,1 say 'Do you wish to go back and Fill in the missing sections ?'
@ 7,1 say 'If you select < EXIT >, this form entry will be finished'
yesno='GO BACK'
set color to gr+/b

@ 9,25 get yesno picture '@*! GO BACK;EXIT' size 1,9 color ,,,,,,,,gr+/b,w/b
read cycle

if lastkey()=27
   tf=.f.
else
    tf=.f.
    if yesno='GO BACK'
       TF=.t.
    else
       TF=.f.
    endif
endif

deactivate window missing
set color to gr+/b
if tf=.f.
   reallygetout=.t.
*   do getout
endif

return


***************************************************************************
*                  procedure TFOH
***************************************************************************
procedure getout
  DEACTIVATE WINDOW section
  deactivate window registrant
  deactivate window owner
  deactivate window changes
  deactivate window vdescription
*  deactivate window
  release window
  clear
return


***************************************************************************
*                       Function paint
***************************************************************************
procedure transpaint
parameter which
clear
set color to gr+/b
clear
@ 0,0 to 24,79 double
set color to gr+/r
if which=1 then
   =center(0,'Statement of transaction')
else
    =center(0,'Affidavit  of  Sale/Gift')
endif
*set color to gr+/r
*@ 24,1 say 'Press <F10> to Accept'
*@ 24,57 say 'Press <ESCAPE> to Exit'

set color to gr+/b
return


***************************************************************************
*                  function allcompleted
***************************************************************************
function notallcompleted
parameter log1,log2
private result

if log1=.t. and log2=.t.
   result=.f.
else
   result=.t.
endif

return


***************************************************************************
*                  procedure WINDOW DEFINITION
***************************************************************************
PROCEDURE DEFINE_WINDOWS

set color to gr+/b

define window sure from 3,5 to 10,48 color scheme 4 double float shadow;
       Title 'ARE YOU SURE' in screen

define window section from 1,50 to 7,79 color scheme 4 double float shadow;
       title 'SPECIFY FILL IN SECTIONS'  in screen

define window WHATTodO from 5,15 to 10,60 color scheme 4 double float shadow;
       title 'WHAT DO YOU WANT TO DO ?' in screen

define window missing from 8,10 to 21,70 color scheme 2 double float shadow;
       title 'SECTIONS TO BE FILLED IN' in screen

define window abc from 1,1 to 23,74 color scheme 2 double float shadow;
       title 'SECTIONS A B & C' in screen

RETURN




***************************************************************************
*                       Function Transaction
***************************************************************************
function aftransaction
private last,tf,YESNO,test

set color to gr+/b
do transpaint with 1

if boat=.f.
   length=space(6)
endif

set color to gr+/b
*@ 2,1 to 2,78 double
@ 1,40 to 5,40 double
@ 6,1  to 6,78 double

@ 6,0  say 'Ì'
@ 6,79 say '¹'
@ 6,40 say 'Ê'


@ 9,1 to 9,78 double
@ 9,0  say 'Ì'
@ 9,79 say '¹'

@ 12,1 to 12,78 double
@ 12,0  say 'Ì'
@ 12,79 say '¹'

@ 13,40 to 15,40 double
@ 16,1  to 16,78 double
@ 16,40 say 'Ê'
@ 12,40 say 'Ë'
@ 16,0  say 'Ì'
@ 16,79 say '¹'
*@ 2,40 say 'Ë'

@ 17,40 to 23,40 double
@ 24,40 say 'Ê'
set color to r+/b
@ 1,55   say 'Previous Owner'
@ 1,13   say 'New Owner'
@ 7,14   say 'Business Adress of New Owner for Commercial Vehicle'
@ 13,6   say 'Point of Delivery in NY state'
@ 13,44  say 'Storage/Use location in NY State'
@ 18,11 say 'Purchase Information'
@ 18,55 say 'Gift information'

set color to gr+/b
@ 2,1  say 'Last' get newlname picture replicate('!',30) size 1,10
@ 2,18 say 'First' get newfname picture replicate('!',30) size 1,10
@ 2,35 say 'MI' get newmi picture '!'

@ 3,1  say 'Address' get newmaddress picture replicate('X',30)
@ 4,1  say 'City' get newmcity picture replicate('X',30) size 1,14
@ 4,21 say 'State' get newmstate picture replicate('!',1) size 1,2
@ 4,30 say 'ZIP' get newmzip picture replicate('9',5) size 1,5
@ 5,1  say 'County' get newmcounty picture replicate('!',30) size 1,15
@ 5,24 say 'SSC' get newssoc picture '999-99-9999'

@ 2,41 say 'Last' get prelname picture replicate('!',30) size 1,10
@ 2,58 say 'First' get prefname picture replicate('!',30) size 1,10
@ 2,75 say 'MI' get premi picture '!'

@ 3,41 say 'Address' get premaddress picture replicate('X',30)
@ 4,41 say 'City' get premcity picture replicate('X',30) size 1,14
@ 4,61 say 'State' get premstate picture replicate('!',1) size 1,2
@ 4,70 say 'ZIP' get premzip picture replicate('9',5) size 1,5
@ 5,41 say 'County ' get newmcounty picture replicate('!',30) size 1,30

@ 8,1  say 'Address' get baddress picture replicate('X',30) size 1,15
@ 8,25 say 'City' get bcity picture replicate('X',30) size 1,14
@ 8,44 say 'State' get bstate picture replicate('!',1) size 1,2
@ 8,53 say 'ZIP' get bzip picture replicate('9',5) size 1,5
@ 8,62 say 'County' get bcounty picture replicate('!',30) size 1,10

@10,1  get motovehicle picture '@*C Motorvehicle' when ( atv=.f. and snowmobile=.f. and boat =.f. )
@10,18 get atv picture '@*C All Terrain Vehicle' when ( motovehicle=.f. and snowmobile=.f. and boat =.f. )
@10,42 get snowmobile picture '@*C Snowmobile' when ( motovehicle=.f. and atv=.f. and boat=.f. )
@10,57 get boat picture '@*C Boat' when ( motovehicle=.f. and atv=.f. and snowmobile =.f. )
@10,66 say 'Length' get length picture '999.99' when boat=.t.
@11,1  say 'Year' get year picture '9999'
@11,11 say 'Make' get make picture replicate('X',30) size 1,15
@11,32 say 'Model' get model picture replicate('X',30) size 1,15
@11,54 say 'Vehicle ID #' get vehidnum picture replicate('X',30) size 1,12

@14,3  say 'City' get delcity picture replicate('X',30) size 1,30 when ( atv=.t. or snowmobile=.t. or boat=.t. )
@15,1  say 'County' get delcounty picture replicate('X',30) size 1,30 when ( atv=.t. or snowmobile=.t. or boat=.t. )
@14,42 say 'City' get stocity picture replicate('X',30) size 1,12 when ( atv=.t. or snowmobile=.t. or boat=.t. )
@14,60 say 'County' get stocounty picture replicate('X',30) size 1,12 when ( atv=.t. or snowmobile=.t. or boat=.t. )
@15,42 say 'Resident in County of storage/use ?' get residence picture 'Y' when ( atv=.t. or snowmobile=.t. or boat=.t. )

@17,15 Say 'Is this Transaction a'
@17,37 get purchase picture '@*C Purchase' when trgift=.f.
@17,51 say 'or a'
@17,54 get trgift picture '@*C Gift' when purchase=.f.

@19,5 say 'Date ' get pdate picture '99/99/99' when purchase=.t. valid date_validate(pdate)
@20,4 say 'Price' get pprice picture '999999.99' when purchase =.t.
@21,2 say 'Tax Rate %' get ptaxrate picture '99.999' when purchase=.t.
@22,2 say 'Tax Due' get ptax picture '999999,99' when purchase=.t. default pprice*(ptaxrate/100) enable
@19,20 get pparent picture '@*C Bought from' when purchase=.t.
@20,20 say 'parent,spouse,... ?'
@21,20 say 'Specify Relation :'
@22,20 get prelation picture replicate('X',30) size 1,20 when ( purchase=.t. and pparent=.t. )

@19,41 get fgift picture '@*C Gift from ' when (trgift=.t. and rgift=.f.)
@20,46 say 'a non-relative'
@22,41 get rgift picture '@*C Gift from ' when (trgift=.t. and fgift=.f.)
@23,46 say 'a relative'

@19,65 get rparent picture '@*C Parent' when (trgift=.t. and rgift=.t. and rchild=.f. and rstepparent=.f. and rstepchild=.f. and rspouse=.f.)
@20,65 get rchild picture '@*C Child' when (trgift=.t. and rgift=.t. and rparent=.f. and rstepparent=.f. and rstepchild=.f. and rspouse=.f.)
@21,65 get rstepparent picture '@*C Stepparent' when (trgift=.t. and rgift=.t.  and rparent=.f. and rchild=.f. and rstepchild=.f. and rspouse=.f.)
@22,65 get rstepchild picture '@*C Stepchild' when (trgift=.t. and rgift=.t.  and rparent=.f. and rchild=.f. and rstepparent=.f. and rspouse=.f.)
@23,65 get rspouse picture '@*C Spouse' when (trgift=.t. and rgift=.t.  and rparent=.f. and rchild=.f. and rstepparent=.f. and rstepchild=.f.)

read cycle

set color to gr+/b
* standard return stub
last=lastkey()

if last=27
   tf=.f.
else
   tf=.t.
endif

return tf



***************************************************************************
*                       Function affidavit
***************************************************************************
function affidavit
private last,tf,YESNO,test

do transpaint with 2

if ( afboat=.f. and afsnowmobile=.f. )
   afvmiles=0
endif
set color to gr+/b
*@ 2,1 to 2,78 double
@ 2,40 to 6,40 double
@ 7,1  to 7,78 double

@ 7,0  say 'Ì'
@ 7,79 say '¹'
@ 7,40 say 'Ê'


@ 12,1 to 12,78 double
@ 12,0  say 'Ì'
@ 12,79 say '¹'

*@ 12,1 to 12,78 double
*@ 12,0  say 'Ì'
*@ 12,79 say '¹'

*@ 13,40 to 15,40 double
*@ 16,1  to 16,78 double
*@ 16,40 say 'Ê'
*@ 12,40 say 'Ë'
*@ 16,0  say 'Ì'
*@ 16,79 say '¹'
*@ 2,40 say 'Ë'

*@ 17,40 to 23,40 double
*@ 24,40 say 'Ê'
set color to r+/b

@ 2,55   say 'Seller/Donor'
@ 2,13   say 'Purchaser Recipient'
=center(8,'Vehicle Information')
=center(13,'Additional Information')
=center(20,'Complete only if vehicle sold/given by company')
*@ 13,6   say 'Point of Delivery in NY state'
*@ 13,44  say 'Storage/Use location in NY State'
*@ 18,11  say 'Purchase Information'
*@ 18,55  say 'Gift information'



set color to gr+/b
@ 1,26 say 'Affidavit of'
@ 1,36 get afsale picture '@*C Sale' when afgift=.f.
@ 1,46 get afgift picture '@*C Gift' when afsale=.f.

@ 3,1  say 'Last' get newlname picture replicate('!',30) size 1,10
@ 3,18 say 'First' get newfname picture replicate('!',30) size 1,10
@ 3,35 say 'MI' get newmi picture '!'

@ 4,1  say 'Address' get newmaddress picture replicate('X',30)
@ 5,1  say 'City' get newmcity picture replicate('X',30) size 1,14
@ 5,21 say 'State' get newmstate picture replicate('!',1) size 1,2
@ 5,30 say 'ZIP' get newmzip picture replicate('9',5) size 1,5
@ 6,1  say 'County' get newmcounty picture replicate('!',30) size 1,15
@ 6,24 say 'SSC' get newssoc picture '999-99-9999'

@ 3,41 say 'Last' get prelname picture replicate('!',30) size 1,10
@ 3,58 say 'First' get prefname picture replicate('!',30) size 1,10
@ 3,75 say 'MI' get premi picture '!'

@ 4,41 say 'Address' get premaddress picture replicate('X',30)
@ 5,41 say 'City' get premcity picture replicate('X',30) size 1,14
@ 5,61 say 'State' get premstate picture replicate('!',1) size 1,2
@ 5,70 say 'ZIP' get premzip picture replicate('9',5) size 1,5
@ 6,41 say 'County ' get newmcounty picture replicate('!',30) size 1,30


@9,10 get motovehicle picture '@*C Motorvehicle' when ( atv=.f. and snowmobile=.f. and boat =.f. )
@9,30 get atv picture '@*C ATV' when ( motovehicle=.f. and snowmobile=.f. and boat =.f. )
@9,40 get snowmobile picture '@*C Snowmobile' when ( motovehicle=.f. and atv=.f. and boat=.f. )
@9,56 get boat picture '@*C Boat' when ( motovehicle=.f. and atv=.f. and snowmobile =.f. )
@10,1  say 'Year' get year picture '9999'
@10,11 say 'Make' get make picture replicate('X',30) size 1,15
@10,32 say 'Model' get model picture replicate('X',30) size 1,15
@10,54 say 'Vehicle ID #' get vehidnum picture replicate('X',30) size 1,12
@11,1 say 'Condition of Vehicle'
@11,22 get afvgood picture '@*C Good' when ( afvfair=.f. and afvpoor=.f.)
@11,31 get afvfair picture '@*C Fair' when ( afvgood=.f. and afvpoor=.f.)
@11,40 get afvpoor picture '@*C Poor' when ( afvfair=.f. and afvgood=.f.)
@11,49 say 'Miles(hours-boat/snow)' get afvmiles picture '9999999'

@14,1 say 'Date of sale/gift' get afpdate picture '99/99/99' valid date_validate(afpdate)
@14,40 say 'Place of delivery' get afpplace picture replicate('X',30) size 1,20
@15,1 say 'Total price (if applicable) including cash,tradeable goods,etc...' get afpprice picture '99999.99'

@16,1 get afservice Picture '@*C Recipient performed service'
@16,33 say 'Value' get afservalue picture '999999.99' range 0-999999.99 when afservice=.t.
@16,50 say 'Explain' get afservexplain picture replicate ('X',30) size 1,20 when afservice=.t.


@17,1 get afbalance Picture '@*C Recipient assumed a balance'
@17,33 say 'Value' get afbalvalue picture '999999.99' range 0-999999.99 when afservice=.t.
@17,50 say 'Explain' get afbalexplain picture replicate ('X',30) size 1,20 when afservice=.t.

@18,1 get afbalance Picture '@*C Recipient gave anything else than money'
@18,50 say 'Explain' get afelsexplain picture replicate ('X',30) size 1,20 when afservice=.t.

@19,1 get aftrade Picture '@*C Recipient gave anything else than money'
@19,50 say 'Explain' get aftradexplain picture replicate ('X',30) size 1,20 when afservice=.t.

@21,1 get afofficer Picture '@*C Recipient affiliated with company?'
@21,50 say 'Explain' get afoffexplain picture replicate ('X',30) size 1,20 when afservice=.t.

@22,1 get afemploy Picture '@*C Was transaction part of employment terms?'
@22,50 say 'Explain' get afemployexplain picture replicate ('X',30) size 1,20 when afservice=.t.

@23,1 get afoffrelate Picture '@*C Recipient related with person affiliated?'
@23,50 say 'Explain' get afoffrelexplain picture replicate ('X',30) size 1,20 when afservice=.t.
read cycle


set color to gr+/b
* standard return stub
last=lastkey()

if last=27
   tf=.f.
else
   tf=.t.
endif

return tf

