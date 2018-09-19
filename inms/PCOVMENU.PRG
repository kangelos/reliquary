parameter rec
SET PROCEDURE TO 'VARIOUS'
set exclusive off

declare covscreen[50 , 11]
covscits=0
EDITED=.F.
push menu _msysmenu
*public pfilename,cresult,plocked

STORE 0 TO BodIn1, PrpDm1, BaPIP1, AdPIP1, FADPIP1, Obelc1, MedPa1, StUnM1, VoUnM1
STORE 0 TO Total1, Depos1, Payms1, Compr1, Coll1, OldCl1, BscCl1,eip1


STORE space(20) TO BBodIn1, BPrpDm1, BBaPIP1, BAdPIP1, BFADPIP1, BObelc1, BMedPa1, BStUnM1, BVoUnM1
STORE space(20) TO BDepos1, BPayms1, bCompr1, bColl1, BOldCl1, BBscCl1,beip1


icompanyno=0
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
major=.f.

set exclusive off
select coverage
VVID=VIN
go (rec)
DO COVPAINT WITH .T.
do pcovdisplay
do pcovmenu
select coverage
pop menu _msysmenu
RETURN EDITED







********************************************************************************
*                 display pcoverage
********************************************************************************
PROCEDURE pcovdisplay
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
*if type('sccov')='U'
if covscits=0
        a=fname("psccov.mem")
	if file(a)
   		restore from &a additive
                restore screen from psccov
        else
                do covpaint with .f.
	endif

else
    restore screen from psccov
endif

if policy->dcanceled=.t.
   ?? chr(7)
   wait window "This Premium's policy has been canceled" nowait
endif

*if type('covscreen[1,1]')='U'
if covscits=0
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

if sdesign=.f.
*   set color to rb+/n
   @ 18,20 say icompanyno picture '99999999999999999999' color w+/b
   @ 22,20 say spolicy picture replicate ('X',30)        color w+/b
   @ 22,66 say pactive picture '@L Y;N'                  color w+/b
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
   @ 16, 60 SAY TOTAL1  PICTURE '99999.9' color w+/b


   @ 18,45 say "Name:"
   icompanyno=iidno
   *select icompany
   *set order to icompany
   *seek icompanyno
   @ 18,50 say left(icompany->iname,30) color w+/b
   *select coverage
*   @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N'
else
    set color to gr+/b,w+/b
    hidden=.f.
    for i=1 to covscits
        if covscreen[i,8]=.t.   && not disabled
           if covscreen[i,6]>0
                   @ covSCREEN[I,1],(covSCREEN[I,2]+len(covSCREEN[I,3])+1) get (covscreen[I,4]);
                                                   picture     covSCREEN[I,5] ;
                                                   size         1,covscreen[i,6];
                                                   COLOR        gr+/b,w+/b
*            else
*                   @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
*                                                   COLOR       gr+/b,w+/b
           endif
        else
                if type(covscreen[i,4])="C" .and. len(alltrim(evaluate(covscreen[i,4])))>0
                   hidden=.t.
                endif
        endif
    endfor
    clear gets
    if hidden
       wait window "There is Hidden Data that you do not see!" nowait
    endif
 endif
    clear gets
    set color to gr+/b
    select coverage
    If DELETED()
       SET COLOR TO GR+/R
   =CENTER(24,'WARNING! This Record is marked for DELETION')
      ?? chr(7)
    else
     set color to n/b
     =center(24,space(70))
   endif
select coverage
set reprocess to 1
if lock(alltrim(str(recno())),'coverage')=.f.
   ?? chr(7)
   wait window 'This coverage is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
 endif
 unlock in coverage
 set reprocess to 1
 return


********************************************************************************
*                 edit pcoverage
********************************************************************************
function pcovdataedit
private plocked
vehicles=1

plocked=.f.
if lock(alltrim(str(recno())),'coverage')=.f.
   wait window 'This Account is edited by Another User Try Again Later' timeout 1
   plocked =.f.
   return plocked
else
   plocked=.t.
endif


vehicles=1
rating_once=1

SET COLOR TO gr+/b
Clear
set color to gr+/b
@ 0,0 to 0 ,79 clear
@  0, 34 Say '  EDITING PREMIUM  '
*@ 19,  1 Say Repl('Ä', 33) + '  PAY PLAN  ' + Repl ('Ä', 33)

*if type('covscreen[1,1]')='U'
if covscits=0
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

Set Color to gr+/b,N/W
@  2,47 say 'Vehicle :'
@  2,60 say VEHICLE->VIN color w+/b size 1,20
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
     @ 16, 1 Say '                             Estimated Premium'
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

     @ 18, 1 Say "Insurance Company:"
     @ 18,45 say "Name:"
*     @ 19,1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture '@L Y,N' valid getnewmajor(major) error 'Major Coverage Already Exists'

@ 18,20 get icompanyno picture '99999999999999999999'
@ 18,45 say "Name:"
icompanyno=iidno
*select icompany
*set order to icompany
*seek icompanyno
@ 18,50 say left(icompany->iname,30) color w+/b
*select coverage
*@ 22, 5  SAY "Policy Number:" get spolicy picture replicate('X',30) disabled color ,,,,,,,,w+/b,w+/b
*@ 22, 51 say "Active Policy:" get pactive picture '@L Y;N'         disabled color ,,,,,,,,w+/b,w+/b
clear gets

do ppcoverval
@ 23,0 to 23,79

on key label f10 keyboard "{ctrl+w}"

Set Color to gr+/b, N/W
@  3, 51 Get NOPol Pict '!'
set color to gr+/b,N/W
   DO ppcoverval
   RATING_ONCE=1
WAIT CLEAR

ESTTOTPRE=TOTAL1
ESTDEPRE=ESTTOTPRE*0.4
if sdesign=.f.
set color to
     @  4, 50 get bBodIn1  picture REPLICATE('X',20) size 1,9
     @  4, 60 get BodIn1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @  5, 50 get bPrpDm1  picture REPLICATE('X',20) size 1,9
     @  5, 60 get PrpDm1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALiD ICALC_1_TOT()
     @  6, 50 get bBaPIP1  picture REPLICATE('X',20) size 1,9
     @  6, 60 get BaPIP1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @  7, 50 get bObelc1  picture REPLICATE('X',20) size 1,9
     @  7, 60 get Obelc1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @  8, 50 get bAdPIP1  picture REPLICATE('X',20) size 1,9
     @  8, 60 get AdPIP1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @  9, 50 GET bFADPIP1 picture REPLICATE('X',20) size 1,9
     @  9, 60 GET FADPIP1  picture '99999.9' COLOR GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @ 10, 50 get bMedPa1  picture REPLICATE('X',20) size 1,9
     @ 10, 60 get MedPa1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @ 11, 50 get bStUnM1  picture REPLICATE('X',20) size 1,9
     @ 11, 60 get StUnM1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @ 12, 50 get bVoUnM1  picture REPLICATE('X',20) size 1,9
     @ 12, 60 get VoUnM1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @ 13, 50 get bCOMPR1  picture REPLICATE('X',20) size 1,9
     @ 13, 60 get COMPR1   picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @ 14, 50 GET bCOLL1   picture REPLICATE('X',20) size 1,9
     @ 14, 60 GET COLL1    picture  '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @ 15, 50 GET BEIP1    picture REPLICATE('X',20) size 1,9
     @ 15, 60 GET EIP1     picture   '99999.9' COLOR  GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g,GR+/b,b/g VALID ICALC_1_TOT()
     @ 16, 60 SAY TOTAL1 PICTURE  '99999.9' COLOR  w+/b
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
                                                     COLOR        gr+/b,n/w
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
set color to gr+/b,N/W
=center(24,"Press F10 to Accept Entry")
read cycle

on key label f10
set color to gr+/b,N/W
=center(24,"                         ")
unlock in policy



********************************************************************************
*                 put coverage data
********************************************************************************
procedure putpcovdata

select coverage
replace  vin        with ALLTRIM(VVID),;
         acctno     with macctno,;
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
         MEDPcov    with alltrim(bMedPa1),;
         MEDPcovPR  with MedPa1,;
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
         iidno    with icompanyno,;
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
         dtotal    with total1,;
         dactive    with pactive
*  replace COPRIMCO   with alltrim(icompany)
* Activity posting
             MINVOICENO=0
             MACCTNO   =client->ACCTNO
             MTRANCODE =3033
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MDESCRIPT ="Premium Changed"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
             DVID      =VEHICLE.VIN
             polno=policy.policyno
             cchange=.t.
             ccom=comchange
             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom)
          do post_covhistory
          select coverage
          do pcovdisplay
select coverage
return





********************************************************************************
*                 Major pcoverage double check
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
select coverage
if (!eof())
rec=recno()
locate for ((iidno=icompanyno) and (vin=vvid))
if (found() and (recno()<>rec) )
   tf=.f.
   ?? chr(7)
   wait window 'Company used in another Premium' nowait
else
    tf=.t.
endif
go (rec)
else
    tf=.t.
endif
return tf




********************************************************************************
*                 display pcoverage
********************************************************************************
PROCEDURE ppcoverval

*if type('covscreen[1,1]')='U'
if covscits=0
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

if sdesign=.f.
     @  4, 50 SAY bBodIn1  picture REPLICATE('X',20) size 1,9 color b/w
     @  5, 50 SAY bPrpDm1  picture REPLICATE('X',20) size 1,9 color b/w
     @  6, 50 SAY bBaPIP1  picture REPLICATE('X',20) size 1,9 color b/w
     @  7, 50 SAY bObelc1  picture REPLICATE('X',20) size 1,9 color b/w
     @  8, 50 SAY bAdPIP1  picture REPLICATE('X',20) size 1,9 color b/w
     @  9, 50 SAY bFADPIP1 picture REPLICATE('X',20) size 1,9 color b/w
     @ 10, 50 SAY bMedPa1  picture REPLICATE('X',20) size 1,9 color b/w
     @ 11, 50 SAY bStUnM1  picture REPLICATE('X',20) size 1,9 color b/w
     @ 12, 50 SAY bVoUnM1  picture REPLICATE('X',20) size 1,9 color b/w
     @ 13, 50 SAY bCOMPR1  picture REPLICATE('X',20) size 1,9 color b/w
     @ 14, 50 SAY bCOLL1   picture REPLICATE('X',20) size 1,9 color b/w
     @ 15, 50 SAY BEIP1    picture REPLICATE('X',20) size 1,9 color b/w

     *@ 4,60 to 15,66 fill color n/r
     @  4, 60 SAY BodIn1  picture '99999.9' color b/g
     @  5, 60 SAY PrpDm1  picture '99999.9' color b/g
     @  6, 60 SAY BaPIP1  picture '99999.9' color b/g
     @  7, 60 SAY Obelc1  picture '99999.9' color b/g
     @  8, 60 SAY AdPIP1  picture '99999.9' color b/g
     @  9, 60 SAY FADPIP1 picture '99999.9' color b/g
     @ 10, 60 SAY MedPa1  picture '99999.9' color b/g
     @ 11, 60 SAY StUnM1  picture '99999.9' color b/g
     @ 12, 60 SAY VoUnM1  picture '99999.9' color b/g
     @ 13, 60 SAY COMPR1  picture '99999.9' color b/g
     @ 14, 60 SAY COLL1   picture '99999.9' color b/g
     @ 15, 60 SAY EIP1    picture '99999.9' color b/g
     @ 16, 60 SAY TOTAL1  PICTURE '99999.9' color b/g
else
           for i=4 to 40 && the rest are done manually
          if covscreen[i,6]>0
             if covscreen[i,8]=.t.   && not disabled
                     @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                                     GET         (covSCREEN[I,4]);
                                                     picture     covSCREEN[I,5] ;
                                                     size         1,covscreen[i,6];
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
clear gets
return



******************************************************************************
*                    Function history of coverages
******************************************************************************
procedure post_covhistory
private id,act,pid,inum,pno,actv

if !used('covhist')
   select 23
   use covhist
else
    select covhist
endif

id=coverage.vin
act=coverage.acctno
pid=coverage.dpid
inum=coverage.iidno
pno=coverage.policyno
actv=coverage.dactive

select covhist
set filter to ( vin=id and acctno=act and dpid=pid and iidno=inum and policyno=pno and dactive=actv)
count to many
newnum=many+1
append blank

replace  vin        with  coverage.vin,;
         acctno     with  coverage.acctno,;
         dpid       with  coverage.dpid,;
         NONOWRPO   with  coverage.NONOWRPO,;
         BDYINJL    with  coverage.BDYINJL,;
         BDYINJLPR  with  coverage.BDYINJLPR,;
         PROPDMGL   with  coverage.PROPDMGL,;
         PROPDMGLPR with  coverage.PROPDMGLPR,;
         PERINJ     with  coverage.PERINJ,;
         PERINJPR   with  coverage.PERINJPR,;
         obelc      with  coverage.obelc,;
         obelcpr    with  coverage.obelcpr,;
         ADPIP      with  coverage.ADPIP,;
         ADPIPPR    with  coverage.ADPIPPR,;
         FADDPIP    with  coverage.FADDPIP,;
         FADDPIPPR  with  coverage.FADDPIPPR,;
         MEDPcov    with  coverage.MEDPcov,;
         MEDPcovPR  with  coverage.MEDPcovPR,;
         STUNMOT    with  coverage.STUNMOT,;
         STUNMOTPR  with  coverage.STUNMOTPR,;
         VUNMOCO    with  coverage.VUNMOCO,;
         VUNMOCOpR  with  coverage.VUNMOCOpR,;
         COSUSI     with  coverage.COSUSI,;
         COSUSIPR   with  coverage.COSUSIPR,;
         COLSION    with  coverage.COLSION,;
         COLSIONPR  with  coverage.COLSIONPR,;
         EXINDPO    with  coverage.EXINDPO,;
         EXINDPOPR  with  coverage.EXINDPOPR,;
         iidno    with  coverage.iidno,;
         LMTPROV    with  coverage.LMTPROV,;
         policyNO   with  coverage.policyNO,;
         EXPDT      with  coverage.EXPDT,;
         POPTION1   WITH  coverage.POPTION1,;
         POPTION2   WITH  coverage.POPTION2,;
         DOWNPAY1   WITH  coverage.DOWNPAY1,;
         DOWNPAY2   WITH  coverage.DOWNPAY2,;
         TOTPREMIUM WITH  coverage.TOTPREMIUM,;
         FEE        WITH  coverage.FEE,;
         PREM       WITH  coverage.PREM,;
         FIN        WITH  coverage.FIN,;
         FINCO      WITH  coverage.FINCO,;
         dtotal     with  coverage.dtotal,;
         dactive    with  coverage.dactive,;
         effdate    with  coverage.effdate,;
         occurence  with  newnum
set filter to
select coverage
return

***************************************************************************
*                     post activity
***************************************************************************
function post_act
PARAMETER INVOICE,ACCTNO,TRANCD,QTY,PRICE,TOTAL,DATE,CLERK,DECRIPTION,POSTED,;
          BILLED,CHECKNO,VVID,efdate,polno,cchange,ccom



  if !used('activity')
     SELECT 24
     USE ACTIVITY ALIAS ACTIVITY
  ELSE
     SELECT ACTIVITY
  ENDIF

APPEND BLANK
       REPLACE  DINVOICENO  WITH       INVOICE,;
                ACCTNO     WITH       ACCTNO,;
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
                DVIN        WITH       ALLTRIM(VVID),;
                effdate     with       efdate,;
                policyno    with       polno,;
                comchange    with       cchange,;
                chamount    with       ccom

RETURN


********************************************************************************
*                 CALCULATE TOTAL
********************************************************************************
FUNCTION ICALC_1_TOT
TOTAL1=BodIn1+PrpDm1+BaPIP1+Obelc1+AdPIP1+FADPIP1+MedPa1+StUnM1+VoUnM1+COMPR1+COLL1+EIP1
@16,60 get TOTAL1 picture '99999.9' disabled color ,,,,,,,,r+/b,r+/b
clear gets
RETURN .T.



********************************************************************************
*                 paint screen
********************************************************************************
PROCEDURE covpaint
parameter first
SET COLOR TO gr+/b
@ 2,0 to 24,79 Clear
set color to gr+/n
@ 0,0 to 0,79 clear
=center(0,' PREMIUM INFORMATION ')
*@ 19,  1 Say Repl('Ä', 33) + '  PAY PLAN  ' + Repl ('Ä', 33)

*if type('covscreen[1,1]')='U'
if covscits=0
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

Set Color to gr+/b,w+/b
if sdesign=.f.
    @  2,47 say 'Vehicle :'
    @  2,60 say VEHICLE->VIN color w+/b size 1,20
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
    @ 16, 1 Say '                             Estimated Premium'
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
*  DEFINE MENU _msysmenu BAR AT LINE 1 COLOR SCHEME 4
*  DEFINE PAD Edit       OF _msysmenu  PROMPT '\<Edit'
*  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit'

  DEFINE MENU _msysmenu color scheme 3
*  DEFINE PAD Utilities    OF _msysmenu  PROMPT '\<Utilities'  at 1,1
  DEFINE PAD Edit       OF _msysmenu  PROMPT '\<Edit'     
  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit'     
  set color to n/w
  @1,0 to 1,79 clear
  show menu _msysmenu
  save screen to psccov
  a=fname("psccov.mem")
  save all like psccov to &a
*  DEACTIVATE MENU _msysmenu
  release menu _msysmenu
  set color to gr+/b,w+/b
else
  set color to n/w
  @1,0 to 1,79 clear
  show menu _msysmenu
  save screen to psccov
  a=fname("psccov.mem")
  save all like psccov to &a
  set color to gr+/b,w+/b
endif

return



*******************************************************************************
*                 get coverage selection
********************************************************************************
procedure pcovmenu
private optopt

  DEFINE MENU _msysmenu color scheme 3
*  DEFINE PAD Utilities    OF _msysmenu  PROMPT '\<Utilities'  
  DEFINE PAD Edit       OF _msysmenu  PROMPT '\<Edit'     
  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit'     

*on           pad  utilities  of _msysmenu  activate popup utils
on selection pad  Edit     of _msysmenu  do pedit
on selection pad  Quit     of _msysmenu  do pQuit

pvquit=0
do while pvquit=0
   activate menu _msysmenu
enddo
return

procedure pedit
*         hide menu _msysmenu
          oldamount=dtotal
          plocked=pcovdataedit()
          select coverage
          if ( (plocked=.t.) and (lastkey() # 27) )
                 do putpcovdata
*                 select vehicle
*                 replace iidno with icompanyno
                 select coverage
                 newamount=dtotal
                 comchange=calcom(CTOD('00/00/00'),CTOD(policy.TO),date(),;
                                   oldamount,newamount,1,policy.dcomrate)
                 commision=policy.dtotcom
                 commision=commision+comchange
                 SUM COVERAGE.DTOTAL TO PREMIUM
                 GO (REC)
                 replace policy.dtotcom with commision,;
                         policy.dpremium with premium
                 EDITED=.T.
          endif
          select coverage
          unlock in coverage
          do pcovdisplay
*         show menu _msysmenu
return

procedure pquit
*ide menu _msysmenu
*EACTIVATE MENU _msysmenu
*ELEASE MENU _msysmenu
        pvquit=1
return
