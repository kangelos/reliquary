parameter VVID,MACCTNO
SET PROCEDURE TO 'VARIOUS'
*
* changed  primary filter form vin to dvehid
* maybe more fixes are needed
*
*public pfilename,cresult,plocked
push menu _msysmenu
getout=0
declare covscreen[50 , 11]
covscits=0
release covscits
set exclusive off
has=initcovsystem()
MEN=MENU()
*IF LEFT (MEN,7)="VEHICLE"
*   hide menu vehiclemenu
*ENDIF
if has=.f.
*     ?? CHR(7)
*     wait window 'No Premiums Found for this VEHICLE' timeout 1
     ?? chr(7)
     wait window 'Press any key to ADD a PREMIUM' timeout 1
     SET CURSOR ON
     added=ADDCOVER(VEHICLE->VIN,CLIENT->ACCTNO,VEHICLE->DVEHID)
     if added
*        =initcovsystem()
         SELECT POLICY
         SET RELATION TO
         SET FILTER TO
         select coverage      && test system
         set filter to        && test system
         set relation to      && test system
         return               && test system
     else
         SELECT POLICY
         SET RELATION TO
         SET FILTER TO
         select coverage      && test system
         set filter to        && test system
         set relation to      && test system
         return
     endif
endif

STORE 0 TO BodIn1, PrpDm1, BaPIP1, AdPIP1, FADPIP1, Obelc1, MedPa1, StUnM1, VoUnM1
STORE 0 TO Total1, Depos1, Payms1, Compr1, Coll1, OldCl1, BscCl1,eip1

*STORE 0 TO BodIn2, PrpDm2, BaPIP2, AdPIP2, FADPIP2, Obelc2, MedPa2, StUnM2, VoUnM2
*STORE 0 TO Total2, Depos2, Payms2, Compr2, Coll2, OldCl2, BscCl2

STORE space(20) TO BBodIn1, BPrpDm1, BBaPIP1, BAdPIP1, BFADPIP1, BObelc1, BMedPa1, BStUnM1, BVoUnM1
STORE space(20) TO BDepos1, BPayms1, bCompr1, bColl1, BOldCl1, BBscCl1,BEIP1,DVEHID

*STORE space(20) TO BBodIn2, BPrpDm2, BBaPIP2, BAdPIP2, BFADPIP2, BObelc2, BMedPa2, BStUnM2, BVoUnM2
*STORE space(20) TO BDepos2, BPayms2, bCompr2, bColl2,  BOldCl2, BBscCl2,beip1

icompanyno=space(20)
limits =space(30)
temp=space(50)
policy=space(30)
pactive=.f.
expiRDATE='00/00/00'
ESTTOTPRE=0
ESTDEPRE=0
nopol='N'
vehicles=1
STORE .F. TO OPTION1,OPTION2
FINANCED=.F.
FINCOMPANY=SPACE(30)
PREMIUM=0
INSTALLMENT=0
TOTPRE=0
DOWN1=0
DOWN2=0
option1=.t.
option2=.f.
major=.t.
dummyvin=vehicle->vin
dummyname=replicate('X',30)


do covpaint with .t.
save screen to sccov
do covdisplay
*DEACTIVATE MENU coveragemenu
do covxmenu
select coverage
set filter to
set relation to
pop menu _msysmenu
RETURN




*******************************************************************************
*                 get coverage selection
********************************************************************************
procedure covxmenu
private optopt
  DEFINE MENU coveragemenu bar color scheme 3

  *BAR AT LINE 1 COLOR SCHEME 4
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

*  ON SELECTION MENU _msysmenu DO cmenu with cresult && uses main menu procedures

DEFINE POPUP covpoptions margin relative shadow color scheme 4

on selection pad  Add      of _msysmenu  do mcovAdd
on           pad  options  of _msysmenu  activate popup covpoptions
on selection pad  First    of _msysmenu  do mcovFirst
on selection pad  Previous of _msysmenu  do mcovprevious
on selection pad  Next     of _msysmenu  do mcovNext
on selection pad  Last     of _msysmenu  do mcovLast
on selection pad  Edit     of _msysmenu  do mcovEdit
on selection pad  Delete   of _msysmenu  do mcovDelete
on selection pad  Undelete of _msysmenu  do mcovUndelete
on selection pad  Quit     of _msysmenu  do mcovQuit

*DEFINE BAR 1 OF covpoptions PROMPT  '\<Utilities'

*ON BAR 1 OF covpoptions activate popup utils

do while getout=0
   activate menu _msysmenu
*   lastk=lastkey()
enddo
getout=0
return

********************************************************************************
*                  quit
********************************************************************************
procedure mcovquit
*	deactivate menu _msysmenu*
*	release menu _msysmenu
	getout=1
return


********************************************************************************
*                  previous coverage
********************************************************************************
procedure mcovprevious
          skip -1
          if bof('coverage')
              wait window 'This is the FIRST Premium' timeout 1
              go top
          else
              do covdisplay
          endif
return


********************************************************************************
*                  next coverage
********************************************************************************
procedure mcovnext
           skip +1
           if eof('coverage')
              wait window 'This is the LAST Premium' timeout 1
              go bottom
           else
               do covdisplay
           endif
return

********************************************************************************
*                  edit coverage
********************************************************************************
procedure mcovedit
PRIVATE REC
		rec=recno()
          plocked=covdataedit()
          select coverage
          if ( (plocked=.t.) AND LASTKEY()<>27)
                 wait window "Updating" timeout 1
                 do putcovdata
                 select coverage
                 wait clear
          endif
          unlock in coverage
          go rec
          do covdisplay
return

********************************************************************************
*                  delete coverage
********************************************************************************
procedure mcovdelete
     select client
     if (recused('client',recno()) )
        ?? chr(7)
        wait window "Somebody is editing this Premium's owner/vehicle" timeout 1
     else
     select vehicle
     if (recused('vehicle',recno()) )
        ?? chr(7)
        wait window "Somebody is editing this Premium's vehicle" timeout 1
     else
     select coverage
          if dactive=.t.
             ?? chr(7)
             wait window "Cannot delete an active Premium" timeout 1
          else
              if drenewed=.t.
                 ?? chr(7)
                 wait window "Cannot delete a Frozen Premium" timeout 1
             else
          tf=acertain('DELETE REALLY?',.f.)
          if ( (tf=.t.) and !recused('coverage',recno()) )
             delete
             unlock in coverage

             * Activity posting
             =POST_ACT(0,CLIENT->ACCTNO,3003,1,0,0,;
                       DATE(),'','PREMIUM DELETED',.F.,.F.,'',VEHICLE->VIN )
          select coverage
          do covdisplay
          endif
        endif
        endif
        endif
        endif
        select coverage
        do covdisplay
return

********************************************************************************
*                 undelete coverage
********************************************************************************
procedure mcovundelete
          recall
          do covdisplay
return

********************************************************************************
*                 first coverage
********************************************************************************
procedure mcovfirst
          go top
          do covdisplay
return

********************************************************************************
*                 last coverage
********************************************************************************
procedure mcovlast
          go bottom
          do covdisplay
return


********************************************************************************
*                 add coverage
********************************************************************************
procedure mcovadd
          rec=recno()
          SET CURSOR ON
          added=addcover(VEHICLE->VIN,CLIENT->ACCTNO,VEHICLE->DVEHID)
          if added
            =initcovsystem()
*            go TOP
            go BOTTOM
          else
              select coverage
              unlock in coverage
              go (rec)
          endif
              do covdisplay
return


********************************************************************************
*                 display coverage
********************************************************************************
PROCEDURE covdisplay
SET COLOR TO gr+/b,w+/b

IF !USED('coverage')
   select c
            use coverage index coverage alias coverage
else
  select coverage
endif


spolicy=space(30)
spolicy=policy->policyno
*VEHICLE->VIN       =vin
dummyvin=vehicle->vin
dummyname=replicate('X',30)
nopol      =NONOWRPO
bBodIn1    =BDYINJL
bodIn1     =BDYINJLPR
bPrpDm1    =PROPDMGL
PrpDm1     =PROPDMGLPR
bBaPIP1    =PERINJ
BaPIP1     =PERINJPR
bObelc1    =obelc
Obelc1     =obelcpr
bAdPIP1    =ADPIP
AdPIP1     =ADPIPPR
bFADPIP1   =FADDPIP
FADPIP1    =FADDPIPPR
bMedPa1    =MEDPCOV
MedPa1     =MEDPCOVPR
bStUnM1    =STUNMOT
StUnM1     =STUNMOTPR
bVoUnM1    =VUNMOCO
VoUnM1     =VUNMOCOPR
bCOMPR1    =COSUSI
COMPR1     =COSUSIPR
bCOLL1     =COLSION
COLL1      =COLSIONPR
BEIP1      =EXINDPO
EIP1       =EXINDPOPR
icompanyno   =iidno
limits     =LMTPROV
policy     =policyNO
expirdate  =EXPDT
OPTION1    =POPTION1
OPTION2    =POPTION2
DOWN1      =DOWNPAY1
DOWN2      =DOWNPAY2
TOTPRE     =TOTPREMIUM
INSTALLMENT=FEE
PREMIUM    =PREM
FINANCED   =FIN
FINCOMPANY =FINCO
total1     =dtotal
pactive    =dactive
major      =dmajor
pfom	   =policy->from
pto	       =policy->to

Set Color to gr+/b,w+/b
if type('covscits')='U'
        a=fname("sccov.mem")
	if file(a)
   		restore from &a additive
                restore screen from sccov
        else
                do covpaint with .f.
	endif

else
    restore screen from sccov
endif

if policy->dcanceled=.t.
   ?? chr(7)
   wait window "This Premium's policy has been canceled" timeout 1
endif

if type('covscits')='U'
        sdesign=.f.
        a=fname("covscre.mem")
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

if sdesign=.f.
*   set color to rb+/n
   @ 18,20 say icompanyno picture '99999999999999999999' color w+/b
   @ 22,20 say spolicy picture replicate ('X',30)        color w+/b
   @ 22,66 say pactive picture '@L Y;N'                  color w+/b
if drenewed=.t.
   =centerc(21,"Premium is Frozen Due to Renewal","gr+/r")
else
   =centerc(21, "                                ","w+/b")
endif
   @ 23,25 say policy->from                              color w+/b
   @ 23,40 say policy->to                                color w+/b

   set color to gr+/b,w+/b
   *@  4,50 to 15,58 fill color rb+/n
   @  4, 50 SAY bBodIn1  picture REPLICATE('X',20) size 1,9 color w+/b
   @  5, 50 SAY bPrpDm1  picture REPLICATE('X',20) size 1,9 color w+/b
   @  6, 50 SAY bBaPIP1  picture REPLICATE('X',20) size 1,9 color w+/b
   @  7, 50 SAY bObelc1  picture REPLICATE('X',20) size 1,9 color w+/b
   @  8, 50 SAY bAdPIP1  picture REPLICATE('X',20) size 1,9 color w+/b
   @  9, 50 SAY bFADPIP1 picture REPLICATE('X',20) size 1,9 color w+/b
   @ 10, 50 SAY bMedPa1  picture REPLICATE('X',20) size 1,9 color w+/b
   @ 11, 50 SAY bStUnM1  picture REPLICATE('X',20) size 1,9 color w+/b
   @ 12, 50 SAY bVoUnM1  picture REPLICATE('X',20) size 1,9 color w+/b
   @ 13, 50 SAY bCOMPR1  picture REPLICATE('X',20) size 1,9 color w+/b
   @ 14, 50 SAY bCOLL1   picture REPLICATE('X',20) size 1,9 color w+/b
   @ 15, 50 SAY BEIP1    picture REPLICATE('X',20) size 1,9 color w+/b

   *@ 4,60 to 15,66 fill color n/r
   @  4, 60 SAY BodIn1  picture '99999.9' color w+/b
   @  5, 60 SAY PrpDm1  picture '99999.9' color w+/b
   @  6, 60 SAY BaPIP1  picture '99999.9' color w+/b
   @  7, 60 SAY Obelc1  picture '99999.9' color w+/b
   @  8, 60 SAY AdPIP1  picture '99999.9' color w+/b
   @  9, 60 SAY FADPIP1 picture '99999.9' color w+/b
   @ 10, 60 SAY MedPa1  picture '99999.9' color w+/b
   @ 11, 60 SAY StUnM1  picture '99999.9' color w+/b
   @ 12, 60 SAY VoUnM1  picture '99999.9' color w+/b
   @ 13, 60 SAY COMPR1  picture '99999.9' color w+/b
   @ 14, 60 SAY COLL1   picture '99999.9' color w+/b
   @ 15, 60 SAY EIP1    picture '99999.9' color w+/b
   @ 16, 60 SAY TOTAL1  PICTURE '99999.9' color r+/b

     @ 18, 1 Say "Insurance Company:"
     @ 18,45 say "Name:"
*     @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N' valid getnewmajor(major) error 'Major Coverage Already Exists'

else
    set color to gr+/b,w+/b
    hidden=.f.
    for i=4 to 40
        if (covscreen[i,8]=.t.) .and. (covscreen[i,6]>0)   && not disabled
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         &covSCREEN[I,4];
                                                     picture     covSCREEN[I,5] ;
                                                     COLOR       w+/b,w+/b
        else
                if type(covscreen[i,4])="C" .and. len(alltrim(evaluate(covscreen[i,4])))>0
                   hidden=.t.
                endif
        endif
    endfor
    clear gets
    if hidden
       wait window "There is Hidden Data that you do not see!" timeout 1
    endif
 endif
   @ 18,20 say icompanyno picture '99999999999999999999' color w+/b
   @ 18,20 get icompanyno picture '99999999999999999999'
   @ 18,45 say "Name:"
   icompanyno=iidno
   @ 18,50  say left(icompany->iname,30) color w+/b
   @ 22,20 say spolicy picture replicate ('X',30)        color w+/b
   @ 22,66 say pactive picture '@L Y;N'                  color w+/b
   @ 23,25 say policy->from                              color w+/b
   @ 23,40 say policy->to                                color w+/b

TOTAL1=BodIn1+PrpDm1+BaPIP1+Obelc1+AdPIP1+FADPIP1+MedPa1+StUnM1+VoUnM1+COMPR1+COLL1+EIP1+1
@16,61 get TOTAL1 picture '99999.9' disabled color ,,,,,,,,r+/b,r+/b
clear gets
    clear gets
    set color to gr+/b
    select coverage
    If DELETED()
    
       @24,0 say space(80)
     
       SET COLOR TO GR+/R      
        =CENTER(24,'WARNING! This Record is marked for DELETION')
       ?? chr(7)
    else
set color to gr+/b
@ 24,0 say space(80)
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
   endif
select coverage
set reprocess to 1
if lock(alltrim(str(recno())),'coverage')=.f.
   ?? chr(7)
   wait window 'This Premium is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
 endif
 unlock in coverage
 set reprocess to 1
 return



********************************************************************************
*                 edit coverage
********************************************************************************
function covdataedit
private plocked
vehicles=1

select client
if recused('client',recno())
   ?? chr(7)
   wait window "NO EDITING,Somebody is editing the Premium's owner!!" timeout 1
   return  .f.
endif

select vehicle
if recused('vehicle',recno())
   ?? chr(7)
   wait window "NO EDITING,Somebody is editing the Premium's vehicle!!" timeout 1
   return  .f.
endif

select coverage
if ((lock(alltrim(str(recno('policy'))),'policy')=.f.) .and. ((coverage.dpid#0) and (coverage.dpid=policy.dpid)))
   ?? chr(7)
   wait window "This premium's Policy is edited by Another User, Try Again Later" timeout 1
   return
endif

plocked=.f.
if lock(alltrim(str(recno())),'coverage')=.f.
   wait window 'This Account is edited by Another User Try Again Later' timeout 1
   plocked =.f.
   unlock in policy
   return plocked
else
   plocked=.t.
endif


vehicles=1

IF COVERAGE.DACTIVE=.T.
   WAIT wINDOW 'Cannot EDIT an ACTIVE Premium' timeout 1
   unlock in coverage
   unlock in policy
   return .f.
endif

IF COVERAGE.Drenewed=.T.
   WAIT wINDOW 'Cannot EDIT a frozen Premium' timeout 1
   unlock in coverage
   unlock in policy
   return .f.
endif

define window wcod at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Coverage Editing Window" font "FixedSys",9 color scheme 10
activate window wcod



SET COLOR TO gr+/b
Clear
set color to gr+/n
@ 0,0 say space(80)
@  0, 34 Say '  EDITING PREMIUM  '
*@ 19,  1 Say Repl('Ä', 33) + '  PAY PLAN  ' + Repl ('Ä', 33)
set color to gr+/b


Set Color to gr+/b,w+/b
if type('covscits')='U'
        a=fname("sccov.mem")
	if file(a)
   		restore from &a additive
                restore screen from sccov
        else
                do covpaint with .f.
	endif

else
    restore screen from sccov
endif

if policy->dcanceled=.t.
   ?? chr(7)
   wait window "This Premium's policy has been canceled" timeout 1
endif

if type('covscits')='U'
        sdesign=.f.
        a=fname("covscre.mem")
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

on key label f10 keyboard '{ctrl+w}'
set color to gr+/n
@0,0 say space(80)
=center(0,'EDITING PREMIUM INFORMATION')
Set Color to gr+/b
@  2,1  Say 'Customer :'
@  2,12 say alltrim(client->lastn)+','+alltrim(client->firstn)  color r+/b size 1,30
@  2,47 say 'Vehicle :' color r+/b
@  2,60 say VEHICLE->VIN color r+/b size 1,20
@  3, 1 Say 'Non - Owner Policy                            '
if sdesign=.f.
     @  4, 1 Say 'Bodily Injuiry Liability . . . . . . . . . . .'
     @  5, 1 Say 'Property Damage Liability  . . . . . . . . . .'
     @  6, 1 Say 'Mandatory Personal Injury Protection Coverage '
     @  7, 1 Say 'Optional Basic Economic Loss Coverage. . . . .'
     @  8, 1 Say "Addit'l PIP Cov. Opt.  * Guest Occup. OoS PIP "
     @  9, 1 Say '                       * Full Additional PIP  '
     @ 10, 1 Say 'Medical Payments Coverage  . . . . . . . . . .'
     @ 11, 1 Say 'Statutory Uninsured Motorists Coverage . . . .'
     @ 12, 1 Say 'Voluntary Uninsured Motorists Coverage . . . .'
     @ 13, 1 Say 'Comprehen. Submit Signed Auth. For Insp. Form '
     @ 14, 1 Say 'Collision  . . . . . . . . . . . . . . . . . .'
     @ 15, 1 Say 'Excess Indemnity Policy  . . . . . . . . . . .'
     @ 16, 1 Say '           Estimated Premium Includes $1 NY Law Enf. Fee'

     @ 18, 1 Say "Insurance Company:"
     @ 18,45 say "Name:"
*     @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N' valid getnewmajor(major) error 'Major Coverage Already Exists'
else
          for i=4 to 40 && the rest are done manually
          if covscreen[i,6]>0
             if covscreen[i,8]=.t.   && not disabled
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     COLOR        gr+/b,n/w
                endif             
          else
            if covscreen[i,8]=.t.   && not disabled
                @ covSCREEN[i,1],covSCREEN[i,2] SAY         covSCREEN[i,3] ;
                                              COLOR       gr+/b,w+/b
            endif
       endif
      endfor
endif
@ 18,20 get icompanyno picture '99999999999999999999'
@ 18,45 say "Name:"
icompanyno=iidno
*select icompany
*set order to icompany
*seek icompanyno
@ 18,50 say left(icompany->iname,30) color w+/b
*select coverage
*@ 22, 5  SAY "Policy Number:" get spolicy picture replicate('X',30) disabled color ,,,,,,,,w+/b,w+/b
@ 22, 51 say "Active Policy:" get pactive picture '@L Y;N'         disabled color ,,,,,,,,w+/b,w+/b
*@ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N' valid getnewmajor(major) error 'Major Coverage Already Exists'
clear gets

do pcoverval
@ 23,0 say space(80)

set color to ,w+/bg

@  3, 51 Get NOPol Pict '!'
*ESTTOTPRE=TOTAL1+TOTAL2
ESTTOTPRE=TOTAL1
ESTDEPRE=ESTTOTPRE*0.4
if sdesign=.f.
     @  4, 50 get bBodIn1  picture REPLICATE('X',20) size 1,9
     @  4, 60 get BodIn1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @  5, 50 get bPrpDm1  picture REPLICATE('X',20) size 1,9
     @  5, 60 get PrpDm1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALiD ICALC_1_TOT()
     @  6, 50 get bBaPIP1  picture REPLICATE('X',20) size 1,9
     @  6, 60 get BaPIP1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @  7, 50 get bObelc1  picture REPLICATE('X',20) size 1,9
     @  7, 60 get Obelc1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @  8, 50 get bAdPIP1  picture REPLICATE('X',20) size 1,9
     @  8, 60 get AdPIP1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @  9, 50 GET bFADPIP1 picture REPLICATE('X',20) size 1,9
     @  9, 60 GET FADPIP1  picture '99999.9' COLOR GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @ 10, 50 get bMedPa1  picture REPLICATE('X',20) size 1,9
     @ 10, 60 get MedPa1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @ 11, 50 get bStUnM1  picture REPLICATE('X',20) size 1,9
     @ 11, 60 get StUnM1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @ 12, 50 get bVoUnM1  picture REPLICATE('X',20) size 1,9
     @ 12, 60 get VoUnM1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @ 13, 50 get bCOMPR1  picture REPLICATE('X',20) size 1,9
     @ 13, 60 get COMPR1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @ 14, 50 GET bCOLL1   picture REPLICATE('X',20) size 1,9
     @ 14, 60 GET COLL1    picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @ 15, 50 GET BEIP1    picture REPLICATE('X',20) size 1,9
     @ 15, 60 GET EIP1     picture   '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
     @ 16, 60 SAY TOTAL1 PICTURE  '99999.9' COLOR  r+/b
else
      for i=4 to 40
          if covscreen[i,6]>0  && TRUE DATA HAVE SIZE
             if covscreen[i,8]=.t.   && not disabled
                if LEN(covscreen[i,10])>2
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         (covSCREEN[I,4]);
                                                     picture     covSCREEN[I,5] ;
                                                     valid       &covscreen[i,10];
                                                     size         1,covscreen[i,6];
                                                     COLOR        n/g,n/g
                else
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         (covSCREEN[I,4]);
                                                     picture     covSCREEN[I,5] ;
                                                     size         1,covscreen[i,6];
                                                     COLOR        gr+/b,n/w
                endif
             endif
          else
            if covscreen[i,8]=.t.   && not disabled
                @ covSCREEN[i,1],covSCREEN[i,2] SAY         covSCREEN[i,3] ;
                                              COLOR       gr+/b,w+/b
            endif
       endif
      endfor

endif
@ 18,20 get icompanyno  valid notused(icompanyno) error 'Please make new selection.Enter 0 for list'
read cycle

set color to gr+/b,N/W
unlock in policy
on key label f10 
deactivate window wcod
release window wcod
Return plocked



********************************************************************************
*                 put coverage data
********************************************************************************
procedure putcovdata

select coverage
replace  vin        with ALLTRIM(VEHICLE->VIN),;
         dvehid     with vehicle->dvehid,;
         acctno     with CLIENT->ACCTNO,;
         NONOWRPO   with nopol,;
         BDYINJL    with alltrim(bBodIn1),;
         BDYINJLPR  with bodIn1,;
         PROPDMGL   with alltrim(bPrpDm1),;
         PROPDMGLPR with PrpDm1,;
         PERINJ     with alltrim(bBaPIP1),;
         PERINJPR   with BaPIP1,;
         obelc      with alltrim(bObelc1),;
         obelcpr    with Obelc1,;
         ADPIP      with alltrim(bAdPIP1),;
         ADPIPPR    with AdPIP1,;
         FADDPIP    with alltrim(bFADPIP1),;
         FADDPIPPR  with FADPIP1,;
         MEDPCOV    with alltrim(bMedPa1),;
         MEDPCOVPR  with MedPa1,;
         STUNMOT    with alltrim(bStUnM1),;
         STUNMOTPR  with StUnM1,;
         VUNMOCO    with alltrim(bVoUnM1),;
         VUNMOCOpR  with VoUnM1,;
         COSUSI     with alltrim(bCOMPR1),;
         COSUSIPR   with COMPR1,;
         COLSION    with alltrim(bCOLL1),;
         COLSIONPR  with COLL1,;
         EXINDPO    with alltrim(BEIP1),;
         EXINDPOPR  with EIP1,;
         iidno    with alltrim(icompanyno),;
         LMTPROV    with alltrim(limits),;
         policyNO   with alltrim(policy),;
         EXPDT      with alltrim(expirdate),;
         POPTION1   WITH OPTION1,;
         POPTION2   WITH OPTION2,;
         DOWNPAY1   WITH DOWN1,;
         DOWNPAY2   WITH DOWN2,;
         TOTPREMIUM WITH TOTPRE,;
         FEE        WITH INSTALLMENT,;
         PREM       WITH PREMIUM,;
         FIN        WITH FINANCED,;
         FINCO      WITH FINCOMPANY,;
         dtotal     with total1,;
         dactive    with pactive,;
         drenewed   with .f.

*  replace COPRIMCO   with alltrim(icompany)
* Activity posting

             =POST_ACT(0,CLIENT->ACCTNO,3002,1,0,0,;
                       DATE(),'','cOVERAGE eDITED',.F.,.F.,'',VEHICLE->VIN )
select coverage
return




******************************************************************************
*                    Procedure coverage system Initialization
******************************************************************************
function initcovsystem

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         seek macctno
         set order to tag lastn

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif

if !used('coverage')
   select c
            use coverage index coverage alias coverage
else
   select coverage
endif
*LOCATE FOR vin=VEHICLE->VIN
LOCATE FOR DVEHID=VEHICLE->DVEHID
*seek alltrim(VEHICLE->VIN)
IF FOUND()
    set filter to dvehid=VEHICLE->dvehid
    go top
ELSE
    ?? chr(7)
    return .f.
endif

IF !USED('icompany')
   select d
   use icompany index icompany alias icompany
else
  select icompany
endif
set order to tag iidno


if !used('POLICY')
   select e
   use POLICY index POLICY alias POLICY
else
    select policy
endif
SET ORDER TO tag dpid

select coverage
set relation to dpid into policy
set relation to iidno into icompany additive
GO BOTTOM
return .t.




********************************************************************************
*                 Major coverage double check
********************************************************************************
function getnewmajor
parameter major
private tf,rec
select coverage
rec=recno()
if major=.t.
        locate for ( (vin=vehicle->vin)  and (dmajor=.t.) )
        if ( (found()) and (recno()<>rec) )
            tf=.f.
        else
            tf=.t.
        endif
else
    tf=.t.
endif
go (rec)
return tf


********************************************************************************
*                 Function not used
********************************************************************************
function notused
parameter icompanyno

if len(alltrim(icompanyno))=0
   tf=.t.
else
   select coverage
   if (!eof())
   rec=recno('coverage')
   locate for ((IIDNO=icompanyno) and (dvehid=VEHICLE->dvehid))
   if ( found() .and. (recno()<>rec) .and. (coverage->dactive=.t.);
                .and. (coverage->drenewed=.t.))
      tf=.f.
      ?? chr(7)
      wait window 'Company used in another Coverage'+chr(13)+str(recno()) timeout 1
   else
       tf=.t.
   endif
   go (rec)
   else
       tf=.t.
   endif
endif
return tf







********************************************************************************
*                 paint screen
********************************************************************************
PROCEDURE covpaint
parameter first
SET COLOR TO gr+/b
@ 2,0 to 24,79 Clear
set color to gr+/n
@ 0,0 say space(80)
=center(0,' PREMIUM INFORMATION ')
*@ 19,  1 Say Repl('Ä', 33) + '  PAY PLAN  ' + Repl ('Ä', 33)

if type('covscits')='U'
        sdesign=.f.
        a=fname("covscre.mem")
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

Set Color to gr+/b,w+/b
if sdesign=.f.
@  2,1  Say 'Customer :'
@  2,12 say alltrim(client->lastn)+','+alltrim(client->firstn)  color r+/b size 1,30
    @  2,47 say 'Vehicle :'
    @  2,60 say VEHICLE->VIN color r+/b size 1,20
    @  3, 1 Say 'Non - Owner Policy                            '
    @  4, 1 Say 'Bodily Injuiry Liability . . . . . . . . . . .'
    @  5, 1 Say 'Property Damage Liability  . . . . . . . . . .'
    @  6, 1 Say 'Mandatory Personal Injury Protection Coverage '
    @  7, 1 Say 'Optional Basic Economic Loss Coverage. . . . .'
    @  8, 1 Say "Addit'l PIP Cov. Opt.  * Guest Occup. OoS PIP "
    @  9, 1 Say '                       * Full Additional PIP  '
    @ 10, 1 Say 'Medical Payments Coverage  . . . . . . . . . .'
    @ 11, 1 Say 'Statutory Uninsured Motorists Coverage . . . .'
    @ 12, 1 Say 'Voluntary Uninsured Motorists Coverage . . . .'
    @ 13, 1 Say 'Comprehen. Submit Signed Auth. For Insp. Form '
    @ 14, 1 Say 'Collision  . . . . . . . . . . . . . . . . . .'
    @ 15, 1 Say 'Excess Indemnity Policy  . . . . . . . . . . .'
     @ 16, 1 Say '           Estimated Premium Includes $1 NY Law Enf. Fee'
    @ 18, 1 Say "Insurance Company:"
    @ 18,45 say "Name:"
*    @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :"
    *get major picture '@L Y,N' valid getnewmajor(major) error 'Major Coverage Already Exists'
    *@ 18,20 get icompanyno picture '99999999999999999999'
    @ 22, 5  SAY "Policy Number:"
    *get spolicy picture replicate ('X',30)
    @ 22, 51 say "Active Policy:"
    *get pactive picture '@L Y;N'
    @ 23,11 say "Policy From:"
    *@ 23,25 say policy->from color w+/b
    @ 23,36 say "To:"
    *@ 23,40 say policy->to color w+/b
    @  3, 51 Get NOPol Pict '!'
    clear gets
    @ 18,45 say "Name:"
    *icompanyno=iidno
    *select icompany
    *set order to tag iidno
    *seek icompanyno
    *@ 18,50 say left(icompany->iname,30) color w+/b
    select coverage
*    @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N'
else
    set color to gr+/b,w+/b
    @ 2,0 to 24,79 clear
    for i=1 to covscits
           if covscreen[i,8]=.t.   && not disabled
                   @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                   COLOR        gr+/b,w+/b
           endif
    endfor
    clear gets
endif
clear gets


if first=.t.
  save screen to sccov
  a=fname("sccov.mem")
  save all like sccov to &a
  set color to gr+/b,w+/b
else
  set color to n/w
  @1,0 to 1,79 clear
  save screen to sccov
  a=fname("sccov.mem")
  save all like sccov to &a
  set color to gr+/b,w+/b
endif

return



********************************************************************************
*                           Add Coverage
********************************************************************************
function ADDCOVER
PARAMETER VVID,MACCTNO,VEHID
STORE 0 TO BodIn1, PrpDm1, BaPIP1, AdPIP1, FADPIP1, Obelc1, MedPa1, StUnM1, VoUnM1
STORE 0 TO Total1, Depos1, Payms1, Compr1, Coll1, OldCl1, BscCl1,eip1

*STORE 0 TO BodIn2, PrpDm2, BaPIP2, AdPIP2, FADPIP2, Obelc2, MedPa2, StUnM2, VoUnM2
*STORE 0 TO Total2, Depos2, Payms2, Compr2, Coll2, OldCl2, BscCl2

STORE space(20) TO BBodIn1, BPrpDm1, BBaPIP1, BAdPIP1, BFADPIP1, BObelc1, BMedPa1, BStUnM1, BVoUnM1
STORE space(20) TO BDepos1, BPayms1, bCompr1, bColl1, BOldCl1, BBscCl1,BEIP1

*STORE space(20) TO BBodIn2, BPrpDm2, BBaPIP2, BAdPIP2, BFADPIP2, BObelc2, BMedPa2, BStUnM2, BVoUnM2
*STORE space(20) TO BDepos2, BPayms2, bCompr2, bColl2,  BOldCl2, BBscCl2,beip1
select client
if recused('client',recno())
   ?? chr(7)
   wait window "NO ADDING,Somebody is editing the Premium's owner!!" timeout 1
   return  .f.
endif

select vehicle
if recused('vehicle',recno())
   ?? chr(7)
   wait window "NO ADDING,Somebody is editing the Premium's vehicle!!" timeout 1
   return  .f.
endif

select coverage
IF !USED('icompany')
   select d
   use icompany index icompany alias icompany
else
  select icompany
endif

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif


set order to tag iidno
SELECT COVERAGE
icompanyno='999             '
limits =space(30)
temp=space(50)
policy=space(30)
pactive=.f.
expiRDATE='00/00/00'
ESTTOTPRE=0
ESTDEPRE=0
nopol='N'
vehicles=1
STORE .F. TO OPTION1,OPTION2
FINANCED=.F.
FINCOMPANY=SPACE(30)
PREMIUM=0
INSTALLMENT=0
TOTPRE=0
DOWN1=0
DOWN2=0
option1=.t.
option2=.f.
major=.t.

BBODIN1="$25/50,000"
BPRPDM1="$10,000"
BBAPIP1=space(30)
BADPIP1=space(30)
BMEDPA1=space(30)
if (alltrim(vehicle->dterritor)='19' .and. alltrim(vehicle->drateclass)='1A')
      BODIN1=523
      PRPDM1=196
      BAPIP1=312
      ADPIP1=0
      MEDPA1=0
      TOTAL1=1031
else
      BODIN1=0
      PRPDM1=0
      BAPIP1=0
      ADPIP1=0
      MEDPA1=0
      TOTAL1=0
endif

SELECT COVERAGE
SET RELATION TO

SET COLOR TO w+/b
CLEAR
REC=RECNO('COVERAGE')

		define window wcod at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Code Adding Window" font "FixedSys",9
		activate window wcod

        DO TRUEADDcoverage

set color to gr+/b,w+/b
tf=.f.
if lastkey() # 27
   TF=ACERTAIN('ACCEPT  THIS  ENTRY?',.t.)
   IF TF=.T.
      wait window "Now Adding new entry" timeout 1
      select coverage
      append blank
      rec=recno()
      if !lock(alltrim(str(rec)),'coverage')
          wait window 'Fatal: Cannot lock new record for Coverages' timeout 1
          ?? chr(7)
          cancel
          tf=.f.
          unlock in coverage
      endif
      DO PUT_COV_DATA
      unlock in coverage
      REC=RECNO('COVERAGE')
      select vehicle
      rec=recno()
*      do while (!lock(alltrim(str(rec)),'vehicle'))
*         ?? chr(7)
*          wait window 'Warning: Cannot lock VEHICLE for new coverage' timeout 1
*     enddo
      replace iidno with alltrim(icompanyno)
*      unlock in vehicle
      select coverage
   ENDIF
endif
SELECT POLICY
SET ORDER TO TAG DPID
SELECT ICOMPANY
SET ORDER TO TAG IIDNO
select coverage
unlock in coverage
set relation to dpid into policy
set relation to iidno into icompany additive
*goto rec  && voodoo magic , take it out and see what happens
wait clear
deactivate window wcod
release window wcod

RETURN tf





********************************************************************************
*                 add  coverage
********************************************************************************
PROCEDURE  TRUEaddcoverage

vehicles=1
rating_once=1

SET COLOR TO gr+/b
Clear
*set color to gr+/n
set color to w+/n
@ 0,0 say space(80)
=center(0,'  ADDING PREMIUM FOR VEHICLE '+alltrim(VEHICLE->VIN))
*@ 19,  1 Say Repl('Ä', 33) + '  PAY PLAN  ' + Repl ('Ä', 33)
set color to gr+/b,w+/b

Set Color to gr+/b

if type('covscits')='U'
        sdesign=.f.
        a=fname("covscre.mem")
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

if sdesign=.f.
@  2,1  Say 'Customer :'
@  2,12 say alltrim(client->lastn)+','+alltrim(client->firstn)  color r+/b size 1,30
      @  2,47 say 'Vehicle :'
      @  2,60 say VEHICLE->VIN color r+/b size 1,20
      @  3, 1 Say 'Non - Owner Policy                            '
      @  4, 1 Say 'Bodily Injuiry Liability . . . . . . . . . . .'
      @  5, 1 Say 'Property Damage Liability  . . . . . . . . . .'
      @  6, 1 Say 'Mandatory Personal Injury Protection Coverage '
      @  7, 1 Say 'Optional Basic Economic Loss Coverage. . . . .'
      @  8, 1 Say "Addit'l PIP Cov. Opt.  * Guest Occup. OoS PIP "
      @  9, 1 Say '                       * Full Additional PIP  '
      @ 10, 1 Say 'Medical Payments Coverage  . . . . . . . . . .'
      @ 11, 1 Say 'Statutory Uninsured Motorists Coverage . . . .'
      @ 12, 1 Say 'Voluntary Uninsured Motorists Coverage . . . .'
      @ 13, 1 Say 'Comprehen. Submit Signed Auth. For Insp. Form '
      @ 14, 1 Say 'Collision  . . . . . . . . . . . . . . . . . .'
      @ 15, 1 Say 'Excess Indemnity Policy  . . . . . . . . . . .'
     @ 16, 1 Say '           Estimated Premium Includes $1 NY Law Enf. Fee'
else
    set color to gr+/b,w+/b
    hidden=.f.
    for i=4 to 40
        if covscreen[i,8]=.t.   && not disabled
           if covscreen[i,6]>0
                    @ covSCREEN[I,1],covSCREEN[I,2] SAY          covSCREEN[I,3] ;
                                                    GET         (covSCREEN[I,4]);
                                                    picture     covSCREEN[I,5] ;
                                                    COLOR       w+/b,w+/b
           endif
        else
                if type(covscreen[i,4])="C" .and. len(alltrim(evaluate(covscreen[i,4])))>0
                   hidden=.t.
                endif
        endif
    endfor
endif
     CLEAR GETS
      @ 18, 1 Say "Insurance Company:"
      @ 18,45 say "Name:"
      @ 18,20 get icompanyno picture '99999999999999999999'
      *@ 22, 5  SAY "Policy Number:" get spolicy picture replicate ('X',30)
      *@ 22, 51 say "Active Policy:" get pactive picture '@L Y;N'
*      @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N' valid getmajor(major) error 'Major Coverage Already Exists'
      clear gets

      do pcoverval
      @ 23,0 say space(80)

      stillediting=.t.
      once=.t.
      on key label f10 keyboard "{ctrl+w}"
      

      
      set color to gr+/b
      tf=getautopol()
      if tf=.t.
         Save Screen to TempScrn
         NAME=FNAME("SCREEN.TXT")
          IF FILE (NAME)
            wait window "Please Wait I am Getting the prices" timeout 1
            Do GetPrices
         endif

         Restore Screen From TempScrn
         DO pcoverval
         RATING_ONCE=1
         NAME=FNAME("SCREEN.TXT")
         DELETE FILE &NAME
      ENDIF
      wait clear

*      ESTTOTPRE=TOTAL1+TOTAL2
      ESTTOTPRE=TOTAL1
      ESTDEPRE=ESTTOTPRE*0.4
if sdesign=.f.
set color to
      Set Color to ,w+/bg
      @  3, 51 Get NOPol Pict '@L Y;N'
      @  4, 50 get bBodIn1  picture REPLICATE('X',20) size 1,9
      @  4, 60 get BodIn1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @  5, 50 get bPrpDm1  picture REPLICATE('X',20) size 1,9
      @  5, 60 get PrpDm1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALiD ICALC_1_TOT()
      @  6, 50 get bBaPIP1  picture REPLICATE('X',20) size 1,9
      @  6, 60 get BaPIP1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @  7, 50 get bObelc1  picture REPLICATE('X',20) size 1,9
      @  7, 60 get Obelc1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @  8, 50 get bAdPIP1  picture REPLICATE('X',20) size 1,9
      @  8, 60 get AdPIP1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @  9, 50 GET bFADPIP1 picture REPLICATE('X',20) size 1,9
      @  9, 60 GET FADPIP1  picture '99999.9' COLOR GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @ 10, 50 get bMedPa1  picture REPLICATE('X',20) size 1,9
      @ 10, 60 get MedPa1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @ 11, 50 get bStUnM1  picture REPLICATE('X',20) size 1,9
      @ 11, 60 get StUnM1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @ 12, 50 get bVoUnM1  picture REPLICATE('X',20) size 1,9
      @ 12, 60 get VoUnM1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @ 13, 50 get bCOMPR1  picture REPLICATE('X',20) size 1,9
      @ 13, 60 get COMPR1   picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @ 14, 50 GET bCOLL1   picture REPLICATE('X',20) size 1,9
      @ 14, 60 GET COLL1    picture  '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @ 15, 50 GET BEIP1    picture REPLICATE('X',20) size 1,9
      @ 15, 60 GET EIP1     picture   '99999.9' COLOR  GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g,GR+/b,n/g VALID ICALC_1_TOT()
      @ 16, 60 SAY TOTAL1 PICTURE  '99999.9' COLOR  r+/b
else
      for i=4 to 40
          if covscreen[i,6]>0  && TRUE DATA HAVE SIZE
             if covscreen[i,8]=.t.   && not disabled
                if LEN(covscreen[i,10])>2
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         (covSCREEN[I,4]);
                                                     picture     covSCREEN[I,5] ;
                                                     valid       &covscreen[i,10];
                                                     size         1,covscreen[i,6];
                                                     COLOR        n/g,n/g
                else
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         (covSCREEN[I,4]);
                                                     picture     covSCREEN[I,5] ;
                                                     size         1,covscreen[i,6];
                                                     COLOR        gr+/b,n/w
                endif
             endif
          else
            if covscreen[i,8]=.t.   && not disabled
                @ covSCREEN[i,1],covSCREEN[i,2] SAY         covSCREEN[i,3] ;
                                              COLOR       gr+/b,w+/b
            endif
       endif
      endfor
endif
      @ 18,20 get icompanyno valid addnotused(icompanyno) error 'Please make new selection.Enter 0 for list'
      
      set color to gr+/b
      =center(24," Press F10 to Accept Entry ")

      read cycle
       
*        if major=.t.
        *   select vehicle
 *          replace vehicle->iidno with alltrim(icompanyno)
        *   select coverage
*        endif
     
        set color to gr+/b

on key label f10
set color to gr+/b
=center(24,"                         ")
Return


********************************************************************************
*                 put coverage data
********************************************************************************
procedure put_cov_data
select coverage
replace  vin        with ALLTRIM(VEHICLE->VIN),;
         dvehid     with vehicle->dvehid,;
         acctno     with CLIENT->ACCTNO,;
         NONOWRPO   with nopol,;
         BDYINJL    with alltrim(bBodIn1),;
         BDYINJLPR  with bodIn1,;
         PROPDMGL   with alltrim(bPrpDm1),;
         PROPDMGLPR with PrpDm1,;
         PERINJ     with alltrim(bBaPIP1),;
         PERINJPR   with BaPIP1,;
         obelc      with alltrim(bObelc1),;
         obelcpr    with Obelc1,;
         ADPIP      with alltrim(bAdPIP1),;
         ADPIPPR    with AdPIP1,;
         FADDPIP    with alltrim(bFADPIP1),;
         FADDPIPPR  with FADPIP1,;
         MEDPCOV    with alltrim(bMedPa1),;
         MEDPCOVPR  with MedPa1,;
         STUNMOT    with alltrim(bStUnM1),;
         STUNMOTPR  with StUnM1,;
         VUNMOCO    with alltrim(bVoUnM1),;
         VUNMOCOPR  with VoUnM1,;
         COSUSI     with alltrim(bCOMPR1),;
         COSUSIPR   with COMPR1,;
         COLSION    with alltrim(bCOLL1),;
         COLSIONPR  with COLL1,;
         EXINDPO    with alltrim(BEIP1),;
         EXINDPOPR  with EIP1,;
         iidno     with alltrim(icompanyno),;
         LMTPROV    with alltrim(limits),;
         POLICYNO   with alltrim(policy),;
         EXPDT      with alltrim(expirdate),;
         POPTION1   WITH OPTION1,;
         POPTION2   WITH OPTION2,;
         DOWNPAY1   WITH DOWN1,;
         DOWNPAY2   WITH DOWN2,;
         TOTPREMIUM WITH TOTPRE,;
         FEE        WITH INSTALLMENT,;
         PREM       WITH PREMIUM,;
         FIN        WITH FINANCED,;
         FINCO      WITH FINCOMPANY,;
         DTOTAL     with total1,;
         Dactive    with pactive,;
         dmajor     with major,;
         DPID       WITH 0,;
         drenewed   with .f.

=POST_ACT(0,CLIENT->ACCTNO,3001,1,0,0,date(),'','Premium added',.f.,.f.,'',vehicle->vin )
select coverage
return


********************************************************************************
*                 Major coverage double check
********************************************************************************
function getmajor
parameter major
private tf
if major=.t.
   locate for ( (vin=VEHICLE->VIN)  and (dmajor=.t.) )
   if found()
       tf=.f.
   else
       tf=.t.
   endif
else
    tf=.t.
endif
return tf


********************************************************************************
*                 Function not used
********************************************************************************
function addnotused
parameter icono
private num

SET EXACT ON
num=val(icono)

     select icompany
     set filter to itype='AUTO'
     set order to tag iidno
     locate for alltrim(iidno)=alltrim(icono)
     if ( (!found()) or (val(icono)=0))
        go top
        @ 24,0 say space(80)
        =center(24,"Press ENTER to Accept Entry")
       on key label enter keyboard "{ctrl+end}"
        set deleted on
        set order to tag iname
        go top
        define window browser at 1,3 size 26,70 Title "Pick a Company" in desktop float;
        	grow color scheme 10 Font "Arial",11
        browse fields iname:h="Company Name",iidno:h="Code #" nomodify color scheme 10 ;
        	font "Arial",11 window browser nomenu 
        release window browser
        set deleted off
        on key label enter
        SELECT COVERAGE
 	endif

icompanyno=alltrim(icompany->iidno)
show gets
@ 18,50 say left(icompany->iname,30) color w+/b
icono=icompanyno


   select coverage
   locate for ((alltrim(IIDNO)=alltrim(icono)) and (dvehid=VEHICLE->dvehid))
   *if (found() .AND. COVERAGE->DACTIVE=.T.)
   if found() and val(iidno)<>999
      tf=.f.
      ?? chr(7)
      wait window 'Company used in another Premium'+chr(13)+str(recno()) timeout 1
   else
       tf=.t.
   endif

@ 24,0 say space(80) 
=center(24,"Press F10 to Accept Coverage")
SET EXACT OFF
return tf




********************************************************************************
*                 display coverage
********************************************************************************
PROCEDURE pcoverval

if type('covscits')='U'
        sdesign=.f.
        a=fname("covscre.mem")
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

if sdesign=.f.
	set color to
     @  4, 50 SAY bBodIn1  picture REPLICATE('X',20) size 1,9 
     @  5, 50 SAY bPrpDm1  picture REPLICATE('X',20) size 1,9 
     @  6, 50 SAY bBaPIP1  picture REPLICATE('X',20) size 1,9 
     @  7, 50 SAY bObelc1  picture REPLICATE('X',20) size 1,9 
     @  8, 50 SAY bAdPIP1  picture REPLICATE('X',20) size 1,9 
     @  9, 50 SAY bFADPIP1 picture REPLICATE('X',20) size 1,9 
     @ 10, 50 SAY bMedPa1  picture REPLICATE('X',20) size 1,9 
     @ 11, 50 SAY bStUnM1  picture REPLICATE('X',20) size 1,9 
     @ 12, 50 SAY bVoUnM1  picture REPLICATE('X',20) size 1,9 
     @ 13, 50 SAY bCOMPR1  picture REPLICATE('X',20) size 1,9 
     @ 14, 50 SAY bCOLL1   picture REPLICATE('X',20) size 1,9 
     @ 15, 50 SAY BEIP1    picture REPLICATE('X',20) size 1,9 

     *@ 4,60 to 15,66 fill color n/r
     @  4, 60 SAY BodIn1  picture '99999.9' color n/g
     @  5, 60 SAY PrpDm1  picture '99999.9' color n/g
     @  6, 60 SAY BaPIP1  picture '99999.9' color n/g
     @  7, 60 SAY Obelc1  picture '99999.9' color n/g
     @  8, 60 SAY AdPIP1  picture '99999.9' color n/g
     @  9, 60 SAY FADPIP1 picture '99999.9' color n/g
     @ 10, 60 SAY MedPa1  picture '99999.9' color n/g
     @ 11, 60 SAY StUnM1  picture '99999.9' color n/g
     @ 12, 60 SAY VoUnM1  picture '99999.9' color n/g
     @ 13, 60 SAY COMPR1  picture '99999.9' color n/g
     @ 14, 60 SAY COLL1   picture '99999.9' color n/g
     @ 15, 60 SAY EIP1    picture '99999.9' color n/g
     @ 16, 60 SAY TOTAL1  PICTURE '99999.9' color r+/b
else
      for i=4 to 40
          if covscreen[i,6]>0  && TRUE DATA HAVE SIZE
             if covscreen[i,8]=.t.   && not disabled
                if LEN(covscreen[i,10])>2
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         (covSCREEN[I,4]);
                                                     picture     covSCREEN[I,5] ;
                                                     valid       &covscreen[i,10];
                                                     size         1,covscreen[i,6];
                                                     COLOR        n/g,n/g
                else
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         (covSCREEN[I,4]);
                                                     picture     covSCREEN[I,5] ;
                                                     size         1,covscreen[i,6];
                                                     COLOR        gr+/b,n/w
                endif
             endif
          else
            if covscreen[i,8]=.t.   && not disabled
                @ covSCREEN[i,1],covSCREEN[i,2] SAY         covSCREEN[i,3] ;
                                              COLOR       gr+/b,w+/b
            endif
       endif
      endfor
endif
clear gets
return



******************************************************************************
*                   call coverage edit screen
******************************************************************************
procedure covsced
          save screen to ed

          POP=POPUP()
          IF LEFT(POP,8)="COVPOPTI"
             hide popup covpoptions
          ENDIF
          MEN=MENU()
*          IF LEFT(MEN,8)="COVERAGE"
*             hide menu _msysmenu
*          ENDIF
          tf=covedit()
              release covscreen
              release covscits
              set color to gr+/b
              @ 2,0 to 24,79 clear
              do covpaint with .f.
              do covdisplay
          show popup covpoptions
*          show menu  _msysmenu
return

********************************************************************************
*                 new paint screen
********************************************************************************
PROCEDURE newcovpaint
parameter first
SET COLOR TO gr+/b
@ 2,0 to 24,79 Clear
set color to gr+/n
@ 0,0 say space(80)
=center(0,' PREMIUM INFORMATION ')
SET COLOR TO gr+/b
*@ 19,  1 Say Repl('Ä', 33) + '  PAY PLAN  ' + Repl ('Ä', 33)

if type('covscits')='U'
        sdesign=.f.
        a=fname("covscre.mem")
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
Set Color to gr+/b,w+/b
if sdesign=.f.
@  2,1  Say 'Customer :'
@  2,12 say alltrim(client->lastn)+','+alltrim(client->firstn)  color r+/b size 1,30
    @  2,47 say 'Vehicle :'
    @  2,60 say VEHICLE->VIN color r+/b size 1,20
    @  3, 1 Say 'Non - Owner Policy                            '
    @  4, 1 Say 'Bodily Injuiry Liability . . . . . . . . . . .'
    @  5, 1 Say 'Property Damage Liability  . . . . . . . . . .'
    @  6, 1 Say 'Mandatory Personal Injury Protection Coverage '
    @  7, 1 Say 'Optional Basic Economic Loss Coverage. . . . .'
    @  8, 1 Say "Addit'l PIP Cov. Opt.  * Guest Occup. OoS PIP "
    @  9, 1 Say '                       * Full Additional PIP  '
    @ 10, 1 Say 'Medical Payments Coverage  . . . . . . . . . .'
    @ 11, 1 Say 'Statutory Uninsured Motorists Coverage . . . .'
    @ 12, 1 Say 'Voluntary Uninsured Motorists Coverage . . . .'
    @ 13, 1 Say 'Comprehen. Submit Signed Auth. For Insp. Form '
    @ 14, 1 Say 'Collision  . . . . . . . . . . . . . . . . . .'
    @ 15, 1 Say 'Excess Indemnity Policy  . . . . . . . . . . .'
     @ 16, 1 Say '           Estimated Premium Includes $1 NY Law Enf. Fee'
    @ 18,  1 Say "Insurance Company:"
    @ 18,45 say "Name:"
*    @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :"
    *get major picture '@L Y,N' valid getnewmajor(major) error 'Major Coverage Already Exists'
    *@ 18,20 get icompanyno picture '99999999999999999999'
    @ 22, 5  SAY "Policy Number:"
    *get spolicy picture replicate ('X',30)
    @ 22, 51 say "Active Policy:"
    *get pactive picture '@L Y;N'
    @ 23,11 say "Policy From:"
    *@ 23,25 say policy->from color w+/b
    @ 23,36 say "To:"
    *@ 23,40 say policy->to color w+/b
    @  3, 51 Get NOPol Pict '!'
    clear gets
    @ 18,45 say "Name:"
    *icompanyno=iidno
    *select icompany
    *set order to tag iidno
    *seek icompanyno
    *@ 18,50 say left(icompany->iname,30) color w+/b
    select coverage
*    @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N'
else
    set color to gr+/b,w+/b
    @ 2,0 to 24,79 clear
    for i=1 to covscits
           if covscreen[i,8]=.t.   && not disabled
                   @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                   COLOR        gr+/b,w+/b
           endif
    endfor
    clear gets
endif
@  2,1  Say 'Customer :'
@  2,12 say alltrim(client->lastn)+','+alltrim(client->firstn)  color r+/b size 1,30
    @  2,47 say 'Vehicle :'
    @  2,60 say VEHICLE->VIN color r+/b size 1,20
    @  3, 1 Say 'Non - Owner Policy                            '
    @ 18,  1 Say "Insurance Company:"
    @ 18,45 say "Name:"
*    @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :"
    *get major picture '@L Y,N' valid getnewmajor(major) error 'Major Coverage Already Exists'
    *@ 18,20 get icompanyno picture '99999999999999999999'
    @ 22, 5  SAY "Policy Number:"
    *get spolicy picture replicate ('X',30)
    @ 22, 51 say "Active Policy:"
    *get pactive picture '@L Y;N'
    @ 23,11 say "Policy From:"
    *@ 23,25 say policy->from color w+/b
    @ 23,36 say "To:"
    *@ 23,40 say policy->to color w+/b
    @  3, 51 Get NOPol Pict '!'
    clear gets
    @ 18,45 say "Name:"
    *icompanyno=iidno
    *select icompany
    *set order to tag iidno
    *seek icompanyno
    *@ 18,50 say left(icompany->iname,30) color w+/b
    select coverage
*    @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N'
clear gets
return


********************************************************************************
*                 CALCULATE TOTAL
********************************************************************************
FUNCTION ICALC_1_TOT
TOTAL1=BodIn1+PrpDm1+BaPIP1+Obelc1+AdPIP1+FADPIP1+MedPa1+StUnM1+VoUnM1+COMPR1+COLL1+EIP1+1
@16,60 get TOTAL1 picture '99999.9' disabled color ,,,,,,,,r+/b,r+/b
clear gets
RETURN .T.



********************************************************************************
*                 get prices
********************************************************************************
PROCEDURE  GetPrices
PRIVATE DESCR1,DESCR2
Decla MyText[50]
A=FNAME('SCREEN.TXT')
OFILE=FOPEN(A,0)

IF OFILE=-1
   RETURN .F.
ENDIF

size=fseek(ofile,0,2)
=fseek(ofile,0,0)

vehicles=0

if size=2050 
   vehicles=1
endif

if size=4100 
   vehicles=2
endif

if vehicles=0
   ?     "invalid size for screen.txt:"
   ?? size
   =FCLOSE(OFILE)
   STORE 0 TO BodIn1, PrpDm1, BaPIP1, AdPIP1, FADPIP1, Obelc1, MedPa1, StUnM1, VoUnM1
   STORE 0 TO Total1, Depos1, Payms1, Compr1, Coll1, OldCl1, BscCl1

*   STORE 0 TO BodIn2, PrpDm2, BaPIP2, AdPIP2, FADPIP2, Obelc2, MedPa2, StUnM2, VoUnM2
*   STORE 0 TO Total2, Depos2, Payms2, Compr2, Coll2, OldCl2, BscCl2

   STORE space(20) TO BBodIn1, BPrpDm1, BBaPIP1, BAdPIP1, BFADPIP1, BObelc1, BMedPa1, BStUnM1, BVoUnM1
   STORE space(20) TO BDepos1, BPayms1, bCompr1, bColl1, BOldCl1, BBscCl1

*   STORE space(20) TO BBodIn2, BPrpDm2, BBaPIP2, BAdPIP2, BFADPIP2, BObelc2, BMedPa2, BStUnM2, BVoUnM2
*   STORE space(20) TO BDepos2, BPayms2, bCompr2, bColl2,  BOldCl2, BBscCl2

   RETURN .F.
ENDIF

tlines=25*vehicles
lis=1
terse=space(80)

FOR I=1 TO 50
    MYTEXT(I)=SPACE(82)
ENDFOR

do while ((lis) <= (tlines))
    terse = fgets(ofile,82)
    mytext(lis) = alltrim(terse)
    lis=lis+1
enddo
=fclose(ofile)
A=FNAME('SCREEN.TXT')
DELETE FILE A
TF=THESAME()
IF TF=.T.
   VEHICLES=1
*   STORE 0 TO BodIn2, PrpDm2, BaPIP2, AdPIP2, FADPIP2, Obelc2, MedPa2, StUnM2, VoUnM2
*   STORE 0 TO Total2, Depos2, Payms2, Compr2, Coll2, OldCl2, BscCl2
*   STORE space(20) TO BBodIn2, BPrpDm2, BBaPIP2, BAdPIP2, BFADPIP2, BObelc2, BMedPa2, BStUnM2, BVoUnM2
*   STORE space(20) TO BDepos2, BPayms2, bCompr2, bColl2,  BOldCl2, BBscCl2
ENDIF
Vehicles = 1

IF VEHICLES=1
  DO GET_VEH1 WITH 1,25
ENDIF


IF VEHICLES=2
   DESCr1=LEFT(MYTEXT(1),7)
   DESCR2=LEFT(MYTEXT(26),7)
   ? DESCR1
   ? DESCR2
   IF DESCR1=DESCR2
      RETURN .F.
   ENDIF

DO CASE
   CASE DESCR1='Veh # 1'
        DO GET_VEH1 WITH 1,25
*        DO GET_VEH2 WITH 26,50
   CASE DESCR1='Veh # 2'
        DO GET_VEH1 WITH 26,50
*        DO GET_VEH2 WITH 1,25
ENDCASE

ENDIF
a=fname('prices.mem')
DELETE FILE &a
SAVE TO &a
RETURN


********************************************************************************
*                 get vehicle 1
********************************************************************************
PROCEDURE GET_VEH1
PARAMETER BEGIN,END
PRIVATE J

for j=BEGIN to END
    DO CASE
       CASE FIND('BODILY INJURY',mytext(j))=.t.
                          bodIN1=extract_val(mytext(j))
                         BbodIN1=EXTRACT_PAREN(mytext(j))
       CASE FIND('PROPERTY DAMAGE',mytext(j))=.t.
                          PrpDm1=extract_val(mytext(j))
                         BPrpDm1=EXTRACT_PAREN(mytext(j))
       CASE FIND('BASIC PIP',mytext(j))=.t.
                          bapip1=extract_val(mytext(j))
                         Bbapip1=EXTRACT_PAREN(mytext(j))
       CASE FIND("ADD'L PIP",mytext(j) )=.t.
                          adpip1=extract_val(mytext(j))
                         Badpip1=EXTRACT_PAREN(mytext(j))
       CASE FIND('OPTIONAL BASIC ECONOMIC LOSS COV.',mytext(j))=.t.
                          obelc1=extract_val(mytext(j))
                         Bobelc1=EXTRACT_PAREN(mytext(j))
       CASE FIND("MEDICAL PAYMENTS",mytext(j) )=.t.
                         medpa1=extract_val(mytext(j))
                         Bmedpa1=EXTRACT_PAREN(mytext(j))
       CASE FIND('SUPPLEMENTARY U.M.',mytext(j))=.t.
                         stunm1=extract_val(mytext(j))
                         Bstunm1=EXTRACT_PAREN(mytext(j))
       CASE FIND('VOLUNTARY UNINSURED MOTORISTS',mytext(j))=.t.
                         vounm1=extract_val(mytext(j))
                         Bvounm1=EXTRACT_PAREN(mytext(j))
       CASE FIND('COMPREHENSIVE',mytext(j))=.t.
                          compr1=extract_val(mytext(j))
                         Bcompr1=EXTRACT_PAREN(mytext(j))
       CASE FIND('COLLISION',mytext(j))=.t.
                          coll1=extract_val(mytext(j))
                         Bcoll1=EXTRACT_PAREN(mytext(j))
       CASE FIND('TOTAL PREMIUM',mytext(j))=.t.
                         Total1=extract_val(mytext(j))
                         BTotal1=EXTRACT_PAREN(mytext(j))
endcase
endfor
RETURN





********************************************************************************
*                 get vehicle 2
********************************************************************************
PROCEDURE GET_VEH2
PARAMETER BEGIN,END
PRIVATE J
for j=BEGIN to END
    DO CASE
       CASE FIND('BODILY INJURY',mytext(j))=.t.
                         bodIN2=extract_val(mytext(j))
                         BbodIN2=EXTRACT_PAREN(mytext(j))
       CASE FIND('PROPERTY DAMAGE',mytext(j))=.t.
                         PrpDm2=extract_val(mytext(j))
                         BPrpDm2=EXTRACT_PAREN(mytext(j))
       CASE FIND('BASIC PIP',mytext(j))=.t.
                         bapip2=extract_val(mytext(j))
                         Bbapip2=EXTRACT_PAREN(mytext(j))
       CASE FIND("ADD'L PIP",mytext(j) )=.t.
                         adpip2=extract_val(mytext(j))
                         Badpip2=EXTRACT_PAREN(mytext(j))
       CASE FIND('OPTIONAL BASIC ECONOMIC LOSS COV.',mytext(j))=.t.
                         obelc2=extract_val(mytext(j))
                         Bobelc2=EXTRACT_PAREN(mytext(j))
       CASE FIND("MEDICAL PAYMENTS",mytext(j) )=.t.
                         medpa2=extract_val(mytext(j))
                         Bmedpa2=EXTRACT_PAREN(mytext(j))
       CASE FIND('SUPPLEMENTARY U.M.',mytext(j))=.t.
                         stunm2=extract_val(mytext(j))
                         Bstunm2=EXTRACT_PAREN(mytext(j))
       CASE FIND('VOLUNTARY UNINSURED MOTORISTS',mytext(j))=.t.
                         vounm2=extract_val(mytext(j))
                         Bvounm2=EXTRACT_PAREN(mytext(j))
       CASE FIND('COMPREHENSIVE',mytext(j))=.t.
                          compr2=extract_val(mytext(j))
                         Bcompr2=EXTRACT_PAREN(mytext(j))
       CASE FIND('COLLISION',mytext(j))=.t.
                          coll2=extract_val(mytext(j))
                         Bcoll2=EXTRACT_PAREN(mytext(j))
       CASE FIND('TOTAL PREMIUM',mytext(j))=.t.
                         Total2=extract_val(mytext(j))
                         BTotal2=EXTRACT_PAREN(mytext(j))
    endcase
 endfor
RETURN



*** instr function
********************************************************************************
*                 get instr
********************************************************************************
* Angelos Karageorgiou dec 10 1992
function find
parameter string1,string2
private length,tf,substring

length=len(string1)
substring=left(string2,length)
tf=.f.
if string1=substring
   tf=.t.
else
   tf=.f.
endif
if len(substring)=0
   tf=.f.
endif
return tf





********************************************************************************
*                 extract values
********************************************************************************
function extract_val
* Angelos Karageorgiou dec 10 1992
parameter string
private value,substring,length,i,j,start,char,SUBSTRING2

length=len(string)

start=length

i=length
do while i>=1
    char=substr(string,i,1)
    if char=' ' or char='$'
      start=i
      exit
    endif
    i=i-1
enddo

substring=substr(string,start+1,length-start)
SUBSTRING2=STRIP_COMMAS(SUBSTRING)
return val(substring2)


FUNCTION STRIP_COMMAS
PARAMETER INPUT
PRIVATE TEMP,I,J,K
J=0
FOR I=LEN(INPUT) TO 2 STEP -1
    IF (SUBSTR(INPUT,I,1)=',')
       J=I
    ENDIF
ENDFOR

IF J<>0
FOR K=J TO 2 STEP -1
    TEMP1=SUBSTR(INPUT,K-1,1)
    TEMP=STUFF(INPUT,K,1,TEMP1)
    INPUT=TEMP
ENDFOR
TEMP=STUFF(INPUT,1,1,' ')
INPUT=TEMP
ENDIF

RETURN ALLTRIM(INPUT)


function extract_paren
* Angelos Karageorgiou dec 10 1992
parameter string
private value,substring,length,i,j,start,char,leftparen,rightparen

length=len(string)

start=length

lonce=0
ronce=0
i=1
do while i<=length
    char=substr(string,i,1)
    if char=')' and ronce=0
      ronce=1
      rightparen=i
    endif
    if char='(' and lonce=0
      lonce=1
      leftparen=i
    endif
    i=i+1
enddo

substring=substr(string,leftparen+1,rightparen-leftparen-1)
return substring


********************************************************************************
*                 function the same
********************************************************************************
FUNCTION THESAME
PRIVATE I,J,K,L,TF
TF=.T.

J=0
FOR I = 1 TO 25 
    IF MYTEXT(I)=MYTEXT(I+25)
    J=J+1
    ENDIF
ENDFOR

IF J=25
   TF=.T.
ELSE
   TF=.F.
ENDIF

RETURN TF


