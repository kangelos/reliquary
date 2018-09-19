parameter macctno
set century oN
*Set Talk Off
set color to Gr+/b



apgetout=0
wait clear

formtype='NEW'
wait window "Please Wait, Setting up" nowait
rating_once=0
set procedure to "various"
*restore from "acctno"
credit=.f.

 if !used('client')
   select a
    use client index client alias client
else
     select client
endif

if !used('VEHICLE')
    select B
   use VEHICLE index VEHICLE alias VEHICLE
 else
    select vehicle
 endif
 *set order to tag vin
 set order to tag DVEHID

 IF !USED('coverage')
   select c
    use coverage index coverage alias coverage
else
   select coverage
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
set order to tag dpid

if !used('driver')
    select f
   use driver index driver alias driver
 else
    select driver
  endif

*select coverage
*set relation to iidno into icompany
*SET RELATION TO VIN INTO VEHICLE additive
*set relation to dpid into policy additive
*SET FILTER TO ACCTNO=MACCTNO
select client

dm=6
vh1='1'
drivers=4
Declare Drvr[4], Relt[4], Us1[4], Us2[4], BDt[4], Sex[4], MSts[4], LcNr[4]
Declare Stt[4],Durt3[4], DurtM[4],MainPrm[Dm],lines[66],screens[5]

Store Space(60) to EmAdr, OwAdr, FrAdr
Store Space(40) to EmpNm, CComp
Store Space(35) to OwnNm, GAdr1, GAdr2, RAdr1, RAdr2
Store Space(35) to DrNm1, DrNm2, DrNm3, DrNm4
Store Space(30) to LstNm, Strt, LpNm1, LpNm2, LStr1, LStr2
Store Space(25) to VhID1, VhID2
Store Space(20) to Modl1, Modl2
Store Space(18) to City, LCty1, LCty2
Store Space(16) to Occup
Store Space(15) to Cnty
Store Space(14) to Symb1, Symb2, MTML
Store Space(12) to Mk1, Mk2, RgSt1, RgSt2
Store Space(11) to DvMl1, DvMl2, DvBd1, Dvbd2
Store Space(10) to FstNm, ZipCd, Cost1, Cost2, LpZC1, LpZC2, Tery1, Tery2
Store Space(10) to A, B, C
Store Space (8) to TelHm, TelBs, MdlNm
Store Space( 7) to PlPt1, PlPt2
Store Space( 6) to Apt
Store Space( 5) to HP1, HP2, CMR
Store Space( 4) to Year1, Year2, Milt1, Milt2
Store Space (3) to TCdHm, TCdBs, RtCs1, RtCs2
Store Space (2) to State, PMo1, PMo2, Cyl1, Cyl2, LpSt1, LpSt2
PYR1='  '
PYR2='  '

Store 'Y' to New1, New2, AtDv1, AtDv2, LPy, NOPol
Store 'N' to mfs75
Store 'N' to mfs752
store space(20) to mfs75id
store space(20) to mfs752id
Store '1' to Vh1, New1, New2, AtDv1, AtDv2, LPy
Store 'N' to Vh2, Usd1, Usd2
Store 'A' to AcPs1, AcPs2
*Store 'W' to UsFr1, UsFr2
store .f. to lossp1,lossp2,less1,less2

For Elm=1 to 4
  Store Space(30) to Drvr[Elm]
  Store Space(10) to Relt[Elm]
  Store Space(3)  to Us1[Elm], Us2[Elm]
  Stt[Elm]=space(2)
  Store Space(10)  to DurtM[Elm]
  bdt[elm]={00/00/00}
  Store Space(1)  to Sex[Elm], MSts[Elm]
  Store Space(20) to LcNr[Elm]
EndFor
if vh1='1'
   Store 'I' to IRR1
   store 'Y' to POI1
else
   Store ' ' to IRR1
   store ' ' to POI1
endif

Store space(2) to str1,str2
STORE 0 TO BodIn1, PrpDm1, BaPIP1, AdPIP1, FADPIP1, Obelc1, MedPa1, StUnM1, VoUnM1
STORE 0 TO Total1, Depos1, Payms1, Compr1, Coll1, OldCl1, BscCl1

STORE 0 TO BodIn2, PrpDm2, BaPIP2, AdPIP2, FADPIP2, Obelc2, MedPa2, StUnM2, VoUnM2
STORE 0 TO Total2, Depos2, Payms2, Compr2, Coll2, OldCl2, BscCl2

STORE space(20) TO BBodIn1, BPrpDm1, BBaPIP1, BAdPIP1, BFADPIP1, BObelc1, BMedPa1, BStUnM1, BVoUnM1
STORE space(20) TO BDepos1, BPayms1, bCompr1, bColl1, BOldCl1, BBscCl1

STORE space(20) TO BBodIn2, BPrpDm2, BBaPIP2, BAdPIP2, BFADPIP2, BObelc2, BMedPa2, BStUnM2, BVoUnM2
STORE space(20) TO BDepos2, BPayms2, bCompr2, bColl2,  BOldCl2, BBscCl2

STORE 0 TO BodIn2, PrpDm2, BaPIP2, AdPIP2, FADPIP2, Obelc2, MedPa2, StUnM2, VoUnM2
STORE 0 TO Total2, Depos2, Payms2, Compr2, Coll2, OldCl2, BscCl2
STORE space(20) TO BBodIn2, BPrpDm2, BBaPIP2, BAdPIP2, BFADPIP2, BObelc2, BMedPa2, BStUnM2, BVoUnM2
STORE space(20) TO BDepos2, BPayms2, bCompr2, bColl2,  BOldCl2, BBscCl2
STORE 0 TO EIP1,EIP2,GTOTAL
STORE SPACE(30) TO BEIP1,BEIP2
Store '  /  /  ' to ExpirDate
STORE 0 TO ESTTOTPRE,ESTDEPRE,VEHICLES,PREMIUM,INSTALLMENT,TOTPRE
store space(20) to company,limits,policy,finCOMPANY
store .f. to option1,option2,financed
store 0 to pay1 ,pay2, pay3,down1,down2,install


DURT3[1]='Y'
DURT3[2]='Y'
DURT3[3]='Y'
DURT3[4]='Y'

select client   && fun starts here
select vehicle

For Elm=1 to 60
  Store ' ' to Lines[Elm]
EndFor
* Driver info
Drvr[1] = Alltrim(a.LastN) + ' ' + Alltrim(a.Firstn)
Relt[1] = 'APPLICANT'
Us1[1]  = '100'   && Angelos
Us2[1]  = '100'
BDt[1]  = a.Bdate
Sex[1]  = a.sex
MSts[1] = a.marstatus
LcNr[1] = a.dr_lic_no
Stt[1]  = a.dissstate

if alltrim(dtoc(a.dissdate))='/  /'
   Durt3[1]= 'Y'
else
    if (date()-a.dissdate)/365 >=3.00
       Durt3[1]= 'Y'
    else
        Durt3[1]= 'N'
    endif
endif

if durt3[1]='N'
   DurtM[1]= dtoc(a.dissdate)
else
   durtm[1]='  /  /  '
endif
* other info
LstNm = a.lastn
FstNm = a.firstn
MdlNm = a.mi
Strt  = a.appadress
Apt   = a.appaptno
City  = a.appcity
Cnty  = a.appcounty
State = a.appstate
ZipCd = a.appzip
TcdHm = substr(a.phoneh,2,3)
TelHm = substr(a.phoneh,7,8)
TcdBs = substr(a.phonew,2,3)
TelBs = substr(a.phonew,7,8)
Occup = a.occu
EmpNm = a.emp_name
EmAdr = a.emp_add

wait clear
insurnum1=0
insurnum2=0
macctno=a.acctno
*select vehicle                  && GET THE FIRST VEHICLE INFO
SELECT COVERAGE
count to many for acctno=macctno
      if many=0
         ?? chr (7)
         wait window "No Premiums Found for Application" Nowait
         return .f.
      endif
go top
SAVE SCREEN TO TEMP
SET COLOR TO gR+/b
@23,0 TO 23,79
=CENTER(24,"Press F10 to select the FIRST Premium     ESC to exit")
SET COLOR TO gr+/b
define window browsewin from 5,5 to 20,75 system FLOAT SHADOW COLOR SCHEME 10;
	in desktop Title "Select Vehicle" Font "Arial",11
*activate window browsewin in screen
on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"

if many>1
browse fields vehicle->year:h   = "Year"   ,;
              vehicle->make:h =" Car's Make ",;
              policy->policyno:h="Policy Number",;
              icompany->iname:h= "Insurance co",;
              coverage->dtotal:h="Premium";
             for (acctno=(macctno) and (coverage.dpid=policy->dpid)) nomodify width 15 nomenu window browsewin;
             title "First Premium Selection List";
             color SCHEME 10
else
    olorder=order()
    set order to tag acctno
    seek macctno
    set order to (olorder)
endif

on key label f10
on key label enter
if lastkey()=27
   RELEASE WINDOWS
   return
else
   arecveh=recno()
   vh1='1'
   VVID1=VIN
   PID=DPID
   firstnumber=iidno
endif

wait window "Churning please Wait" nowait

*select vehicle                  && GET THE Second VEHICLE INFO
select coverage
*set filter to (acctno=(macctno) AND (VIN # VVID1) and (dpid=pid) )
many=0
count to many for (acctno=(macctno) and (vin #vvid1) and (dpid=pid) and (iidno=firstnumber) )
if many <>0 
*deactivate window browsewin
SET COLOR TO Gr+/b
@24,0 say space(80)
=CENTER(24,"Press F10 to select the SECOND Vehicle     ESC if none")
SET COLOR TO gr+/b
*activate window browsewin
on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"
WAIT CLEAR
browse fields vehicle->year:h   = "Year"   ,;
              vehicle->make:h = "Car's Make",;
              policy->policyno:h="Policy Number",;
              icompany->iname:h= "Insurance co",;
              coverage->dtotal:h="Premium";
             for (acctno=(macctno) and (vin # vvid1) and (dpid=pid) and (iidno=firstnumber) );
             nomodify width 15 nomenu window browsewin;
             title "Second Premium Selection List";
             color SCHEME 10
*browse fields vin:h   = "Vehicle ID"   ,;
*              year:h  = "Year"         ,;
*              make:h  = "Make"         ,;
*              modst:h = "Model"        ,;
*              cost:h  = "Price"        ,;
*              purmo:h = "Month Bought" ,;
*              puryr:h = "Year Bought"  ;
*              for ((acctno=(macctno)) AND (VIN # VVID1) AND (dPID=PID)) nomodify width 15 nomenu in browsewin;
*              title "Second Vehicle Selection List";
*              color gr+/b,w+/gr,,,w+/gr,,w+/gr,,,,w+/gr
on key label f10
on key label enter
DEACTIVATE WINDOW BROWSEWIN
if lastkey()=27
   vh1='1'
   VVID2=' '
else
   vh1='2'
   bvehrec=recno()
   vvid2=vin
endif
endif
*if many=1
*   vh1='2'
*   BVEHREC=RECNO()
*endif
RESTORE SCREEN FROM TEMP
*SET FILTER TO
vehicles=val(vh1)
deactivate window browsewin
release window browsewin

select coverage
goto (arecveh)                  && get the contents of the first vehicle
select vehicle
*locate for vin=vvid1

Year1 = b.year
Mk1   = b.make
Modl1 = b.modst
VhId1 = b.vin
OwnNm = b.vivowner
OwAdr = b.vivaddr
*PMo1  = ' '+ALLTRIM(STR(b.purmo))
*PYr1  = ' '+ALLTRIM(STR(b.puryr))


PMo1  = ALLTRIM(STR(b.purmo))
PYr1  = RIGHT(ALLTRIM(STR(b.puryr)),2)
*if b.puryr >1900
*   PYr1  = ALLTRIM(STR(b.puryr-1900))
*endif
*if b.puryr > 2000
*   PYr1  = ALLTRIM(STR(b.puryr-2000))
*endif

if b.condpur='N'
      New1  ='Y'
else
    New1 = 'N'
endif
*Cost1 = ' '+' '+ALLTRIM(STR(b.cost))
*Cyl1  = ' '+ALLTRIM(STR(b.cyls))
Cost1 = ' '+' '+ALLTRIM((b.cost))
Cyl1  = ' '+ALLTRIM(str(b.cyls))
Hp1   = b.hpcu
if b.dantitheft
   AtDv1 ='Y'
else
   AtDv1 ='N'
endif
DvMl1 = b.damodel
if b.daactive
   AcPs1 = 'A'
endif
if b.dapassive
   AcPs1 = 'P'
endif
DvBd1 =  b.dabrand
sTR1  =  b.dstatereg
LpNm1 =  b.lname
LStr1 =  b.lstreet
LpSt1 =  b.lstate
LCty1 =  b.lcity
LpZC1 =  b.lzip
GAdr1 =  b.dgaragaddr
UsFr1 =  b.duse
RAdr1 =  b.Dappadress
Milt1 =  b.Dmilestow
Tery1 =  b.dterritor
RtCs1 =  b.drateclass
PlPt1 =  b.dpenalty
Symb1 =  b.dsymbol
lossp1=  b.losspayee
less1 =  b.lessor

 select coverage
 go (arecveh)
* set exact on
* locate for alltrim(vin)=alltrim(vvid1)
* set exact off
* if !found()
*    ?? chr(7)
*    ?? chr(7)
*   wait window "No Coverage Found for the First Vehicle" nowait
* else
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
if formtype='OLD'
   total1     =dtotal
else
    total1    =dtotal
endif

company=icompany->iname
expirdate=policy->to
*endif




*set filter to

if vh1='2'
select coverage
goto (bvehrec)
*locate for vin=vvid2
select vehicle
   vvid2 = b.vin
   Year2 = b.year
   Mk2   = b.make
   Modl2 = b.modst
   VhId2 = b.vin
*   PMo2  = ' '+ALLTRIM(STR(b.purmo))
*   PYr2  = ' '+ALLTRIM(STR(b.puryr))

PMo2  = ALLTRIM(STR(b.purmo))
PYr2  = RIGHT(ALLTRIM(STR(b.puryr)),2)
*if b.puryr >1900
*   PYr2  = ALLTRIM(STR(b.puryr-1900))
*endif
*if b.puryr > 2000
*   PYr2  = ALLTRIM(STR(b.puryr-2000))
*endif
   if b.condpur='N'
      new2='Y'
   else
       new2='N'
   endif
*   Cost2 = ' '+' '+ALLTRIM(STR(b.cost))
    Cost2 = ' '+' '+ALLTRIM((b.cost))
  Cyl2  = ' '+ALLTRIM(STR(b.cyls))
   Hp2   = b.hpcu
   if b.dantitheft
      AtDv2 ='Y'
   else
      AtDv2 ='N'
   endif
   DvMl2 = b.damodel
   if b.daactive
      AcPs2 = 'A'
   endif
   if b.dapassive
      AcPs2 = 'P'
   endif
   DvBd2 =  b.dabrand
   STR2  =  b.dstatereg
   LpNm2 =  b.lname
   LStr2 =  b.lstreet
   LpSt2 =  b.lstate
   LCty2 =  b.lcity
   LpZC2 =  b.lzip
   GAdr2 =  b.dgaragaddr
   UsFr2 =  b.duse
   RAdr2 =  b.Dappadress
   Milt2 =  b.Dmilestow
   Tery2 =  b.dterritor
   RtCs2 =  b.drateclass
   PlPt2 =  b.dpenalty
   Symb2 =  b.dsymbol
   lossp2=  b.losspayee
   less2 =  b.lessor

   select coverage
   go (bvehrec)
*   set filter to
*   set exact on
*   set exact off
*   locate for alltrim(vin)=alltrim(vvid2)
* if !found()
*    ?? chr(7)
*    ?? chr(7)
*   wait window "No Coverage Found for the Second Vehicle" nowait
* else
   bBodIn2    =BDYINJL
   bodIn2     =BDYINJLPR
   bPrpDm2    =PROPDMGL
   PrpDm2     =PROPDMGLPR
   bBaPIP2    =PERINJ
   BaPIP2     =PERINJPR
   bObelc2    =obelc
   Obelc2     =obelcpr
   bAdPIP2    =ADPIP
   AdPIP2     =ADPIPPR
   bFADPIP2   =FADDPIP
   FADPIP2    =FADDPIPPR
   bMedPa2    =MEDPCOV
   MedPa2     =MEDPCOVPR
   bStUnM2    =STUNMOT
   StUnM2     =STUNMOTPR
   bVoUnM2    =VUNMOCO
   VoUnM2     =VUNMOCOPR
   bCOMPR2    =COSUSI
   COMPR2     =COSUSIPR
   bCOLL2     =COLSION
   COLL2      =COLSIONPR
   BEIP2      =EXINDPO
   EIP2       =EXINDPOPR
if formtype='OLD'
   total2     =dtotal
else
   total2    =dtotal
endif
* endif
else
   Year2 = '    '
   Mk2   = '                '
   Modl2 = '       '
   VhId2 = '             '
   PMo2  = '  '
   PYr2  = '  '
   New2  = ' '
   Cost2 = '         '
   Cyl2  = '  '
   Hp2   = '     '
   AtDv2 = ' '
   DvMl2 = '     '
   AcPs2 = ' '
   DvBd2 = '       '
   STR2  = '  '
   GAdr2 =  space(25)
   UsFr2 =  'P'
   RAdr2 =  space(35)
   Milt2 =  space(10)
   Tery2 =  space(10)
   RtCs2 =  space(10)
   PlPt2 =  space(10)
   Symb2 =  space(25)
endif

if vh1='2'
   store 'I' to IRR2
   store 'Y' to POI2
else
   store ' ' to IRR2
   store ' ' to POI2
endif

select driver
set filter to dpid=pid
go top

i=2
do while ( !eof() and (i<=4))
     Drvr[i] = left(alltrim(dlastn)+' '+dmi+' '+alltrim(Dfirstn),17)
     Relt[i] = left(alltrim(drelation),14)
     Us1[i]  = str(duse,3,0)
     Us2[i]  = '100'
     BDt[i]  = dbdate
     Sex[i]  = dsex
     MSts[i] = dmarstatus
     LcNr[i] = ddr_lic_no
     Stt[i]  = dissstate
     if (date()-dissdate)/365 >=3.00
        Durt3[i]= 'Y'
      else
        Durt3[i]= 'N'
     endif
     if durt3[i]='N'
        DurtM[i]= dtoc(DRIVER.dissdate)
     else
        durtm[i]='  /  /  '
     endif
i=i+1
skip
enddo
*dRIVERS=I-1
*rivers=i
*Drvr[2] = 'Pantelopoulos Nikos'
*Relt[2] = 'Sister Nr 1'
*Us1[2]  = '25'
*Us2[2]  = '26'
*BDt[2]  = '21/21/82'
*Sex[2]  = 'f'
*MSts[2] = 's'
*LcNr[2] = '3452678'
*Stt[2]  = 'CT'
*Durt3[2]= 'N'
*DurtM[2]= '25/21/82'
*
*Drvr[3] = 'PASXALIS PATRINOS'
*Relt[3] = 'BROTHER Nr 1'
*Us1[3]  = '35'
*Us2[3]  = '36'
*BDt[3]  = '13/13/83'
*Sex[3]  = 'F'
*MSts[3] = 'S'
*LcNr[3] = '1098765'
*Stt[3]  = 'MI'
*Durt3[3]= 'Y'
*DurtM[3]= '13/03/83'
*
*Drvr[4] = 'LAST DRIVER PETROS'
*Relt[4] = 'COUSIN  Nr 1'
*Us1[4]  = '45'
*Us2[4]  = '46'
*BDt[4]  = '14/10/84'
*Sex[4]  = 'M'
*MSts[4] = 'S'
*LcNr[4] = '1054958959'
*Stt[4]  = 'NH'
*Durt3[4]= 'N'
*DurtM[4]= '18/08/88'

RATING_ONCE=0
Dm=6
Declar Drvr[4], Relt[4], Us1[4], Us2[4], BDt[4], Sex[4], MSts[4], LcNr[4]
Declar Stt[4],Durt3[4], DurtM[4]
Declar MainPrm[Dm]
declare lines[66],screens[5]


For Elm=1 to 60
  Store ' ' to Lines[Elm]
EndFor

*BscCl = "GR+/R+, N+/G+, W+, W+"
BscCl = "N/W+, W+*/R, N, N"

Set Cursor Off
Set color to GR+     && pYELLOW
Set color to w+/bg                     &&GR+/R  && RB/G  && I/N 
@ 24, 0 Say Space(80)

select policy

     option1    =doption1
     option2    =doption2
     FINANCED   =DFINANCED
     FINCOMPANY =DFINCOMPANY
     TOTPRE     =DTOTPRE
     PREMIUM    =DPREMIUM
     INSTALLMENT=DINSTALL
     DOWN1      =DDOWN1
     DOWN2      =DDOWN2
mfs75id=policy->fs75
if len(alltrim(mfs75id))=0
   mfs75='N'
else
   mfs75='Y'
endif

mfs752id=policy->fs752
if len(alltrim(mfs752id))=0
   mfs752='N'
else
   mfs752='Y'
endif
     if len(alltrim(tml))>0
        MTML=tml
     endif
PREMIUM=TOTAL1+TOTAL2
IF OPTION1=.F. AND OPTION2=.F.
   OPTION2=.T.
ENDIF
*   IF OPTION1=.T.
*      INSTALLMENT=3*3
*   ELSE
*       INSTALLMENT=6*4
*   ENDIF
installment=0
totpre=premium
IF OPTION1=.T.
   DOWN1=PREMIUM*0.3
   DOWN2=0
ENDIF
IF OPTION2=.T.
   DOWN2=TOTPRE*.25
   DOWN1=0
ENDIF

do menuset
Do Application

RELEASE WINDOWS all
WAIT CLEAR
Return



procedure application
*          IF MENU()="POLMENU"
*             hide menu polmenu
*          endif
          set color to Gr+/b
          clear
          do menuset
          do form1          
          lastk=27
         do while apgetout=0
          activate menu _msysmenu          
         enddo
         do quitapp
return

procedure menuset
  wait clear
  DEFINE MENU _msysmenu bar color scheme 3
  DEFINE PAD owner  OF _msysmenu  PROMPT ' \<Owner/Vehicle-Info ' 
  DEFINE PAD cover  OF _msysmenu  PROMPT ' P\<remiums-Info '      
  DEFINE PAD driver OF _msysmenu  PROMPT ' \<Driver-Info '        
  define pad print  of _msysmenu  prompt '\<Print-Application '   
  DEFINE PAD quit   OF _msysmenu  PROMPT '\<Quit '                

DEFINE POPUP whatprint margin relative shadow color scheme 4
DEFINE POPUP owners margin relative shadow color scheme 4
DEFINE POPUP premiums margin relative shadow color scheme 4
DEFINE POPUP drivers margin relative shadow color scheme 4
*DEFINE POPUP quits margin relative shadow color scheme 4

on pad print of _msysmenu activate popup whatprint
on pad owner of _msysmenu activate popup owners
on pad driver of _msysmenu activate popup drivers
on pad cover of _msysmenu activate popup premiums
*on pad quit of _msysmenu activate popup quits
on selection pad quit of _msysmenu do quitapp

define bar 1 of owners prompt '\<View Information'
define bar 2 of owners prompt '\<Edit Information'

define bar 1 of premiums prompt '\<View Information'
define bar 2 of premiums prompt '\<Edit Information'

define bar 1 of drivers prompt '\<View Information'
define bar 2 of drivers prompt '\<Edit Information'


on selection bar 1 of owners do screen1 with .f.
on selection bar 2 of owners do screen1 with .t.

on selection bar 1 of premiums do screen2 with .f.
on selection bar 2 of premiums do screen2 with .t.

on selection bar 1 of drivers do screen3 with .f.
on selection bar 2 of drivers do screen3 with .t.

*define bar 1 of quits prompt 'I insist'
*on selection bar 1 of  quits do quitapp

DEFINE BAR 1 OF whatprint   PROMPT  '\<Print New Form'
*DEFINE BAR 2 OF whatprint   PROMPT  '\<Utilities'
on selection bar 1 of whatprint do printit with 'new'
*on bar 2 of whatprint activate popup utils

return



procedure screen1
parameter tf
*HIDE MENU _msysmenu
if type('screens[1]')<>'S'
      Do Form1
      Save Screen to Screens[1]
endif
      Restore Screen from Screens[1]
*      tf=acertain("Edit this Information ?",.f.)
      if tf
              hide popup owners
              Do Read11
              if lastkey()<>27
                 Do Read12
              endif
              if vehicles>1 .and. lastkey()<>27
                    Do Read13
                  endif
              if lastkey()<>27
                 Do Read14
              endif
      endif
      Save Screen to Screens[1]
return

procedure screen2
parameter tf
*HIDE MENU _msysmenu
if type('screens[2]')<>'S'
      Do Form2
      Save Screen to Screens[2]
endif
      Restore Screen from Screens[2]
*     tf=acertain("Edit this Information ?",.f.)
      if tf
              hide popup premiums
              Do Read21
              if lastkey()<>27
                 Do Read22
              endif
      endif
      Save Screen to Screens[2]
return

procedure screen3
parameter tf
*HIDE MENU _msysmenu
if type('screens[3]')<>'S'
      Do Form3
      Save Screen to Screens[3]
      endif
      Restore Screen from Screens[3]

*     tf=acertain("Edit this Information ?",.f.)
      if tf
              hide popup drivers
              Do Read3 with 2, 17, 1
              if lastkey()<>27
                 Do Read3 with 2, 49, 2
              endif
              if lastkey()<>27
                 Do Read3 with 13, 17, 3
              endif
              if lastkey()<>27
                 Do Read3 with 13, 49, 4
              endif
      endif
      Save Screen to Screens[3]
return


procedure calibr
private cal
        cal=space(79)+"."+CHR(27)+'J'+CHR(0)
return

procedure printit
parameter formtype
private tf
*HIDE MENU _msysmenu
*      TF=ASKFOREXIT('Do you want a Printout?')
*      if tf
*         Return
*      ELSE
*      times=getprints()
*      IF TIMES>100
*         ??CHR(7)
*         WAIT WINDOW "YOU HAVE PRINTED TOO MANY FORMS" TIMEOUT 1
*         WAIT WINDOW "CALL COSMODATA AT (718) 626 1010" TIMEOUT 1
*         DO apgetout
*      ENDIF
      do OKINEWPRINT

MINVOICENO=0
MACCTNO   =client.acctno
MTRANCODE =0001
MQTY      =1
MPRICE    =premium
MTOTAL    =0
MDATE     =date()
MCLERK    =''
MDESCRIPT ="NY Application Printed"
MPOSTED   =.t.
MBILLED   =.f.
MCHECKNO  =''
DVID      =vvid1

             =POST_ACT(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )

*      tf=.t.
*      do while tf
*         tf=Acertain("Print application again ?",.f.)
*         IF TF
*            do OKIPRINT
*         ENDIF
*      enddo
*ENDIF
return

procedure quitapp
*          deactivate menu _msysmenu
*          release menu _msysmenu
*          clear memory
		apgetout=1
return


FUNCTION  AskForExit
********************

Param Quest
Private YesNo
set color to gr+/b,w+/bg

LenOfQuest = Len(Quest)
Lft = 36 - LenOfQuest/2 
Rgt = 43 + LenOfQuest/2 
YesNo = 'NO'
Define Window YesNoWin from 8, Lft to 14, Rgt double title ' ATTENTION ' float shadow
*       title ' ATTENTION !!!' float shadow
                    &&  The 3rd *Color pair affects the window frame
                    &&  W+/RB+
Activate Window YesNoWin
@ 1, 3 Say Quest
@ 3, (WCOLS()-29)/2   Get YesNo Pict '@*! NO ;YES' size 1,29
Read Cycle

Deactivate Window YesNoWin
If Alltrim(YesNo) = 'NO'
   Return .T.
 Else
   Return .F.
EndIf




FUNCTION  DoMenu
****************

Private What
Set Color to W+/RB+,w+/bg
@ 24, 21 Say Repl ('-', 40) COLOR gr+/b


Define Wind Lefty from 5,31 to 21,48 Double Title ' Select ' Float Shadow
Define Wind Msg from 12,15 to 14,64 Double Float SHADOW

Acti Wind Lefty
clear
Do While .T.
  InMsg = .T.
  What=0
  @  1, 3 prompt ' Window 1 '
  @  3, 3 prompt ' Window 2 '
  @  5, 3 prompt ' Window 3 '
  @  7, 3 prompt ' Window 4 '
  @  9, 3 prompt ' Prev Scr '
  @ 11, 3 prompt ' Next Scr '
  @ 13, 3 prompt '   Exit   '
  Menu to What
  If (Vh1='1') .And. (What=3) .And. (Scrn = 1) 
    Acti Wind Msg
    = Sys(2002,1)
    @ 0,0 Say ' There is NO Second Vehicle. Press any key . . . '
    = Inkey(2)
    Deact Wind Msg
    InMsg = .F.
  EndIf
  If InMsg
    Exit
  EndIf
EndDo
Deact Wind Lefty
Return What  
*****  End DoMenu






FUNCTION  FxL
*************

Param VarNm, L1
Private Blnk
blnk=0
*Blnk = L1 - Len(Alltrim(VarNm)) + 3
Blnk = L1 - Len(Alltrim(VarNm)) + 1
If Blnk < 1
   Blnk = 1
EndIf
Return Substr(Alltrim(VarNM),1,L1) + Space(Blnk)
*****   End FxL

FUNCTION  FxL1
*************

Param VarNm, L1
Private Blnk
blnk=0
*Blnk = L1 - Len(Alltrim(VarNm)) + 3
Blnk = L1 - Len(Alltrim(VarNm))
Return Substr(Alltrim(VarNM),1,L1) +space(blnk)
*****   End FxL1


****
****
****
function makeline
parameter PASS1,value1,PASS2,value2
private result,result1,STRING1,STRING2,GO,TEMP

STRING1=ALLTRIM(PASS1)
STRING2=ALLTRIM(PASS2)
GO=LEN(STRING2)

result=space(77)

if len(string1)>1
   result1=stuff(result,49,6,LEFT(string1,6))
   result=result1
endif

if value1<>0
   TEMP=ALLTRIM(STR(VALUE1))
   result1=stuff(result,63-LEN(TEMP),LEN(TEMP),TEMP)
   result=result1
endif

IF GO>1
   result1=stuff(result,66,6,LEFT(string2,6))
   result=result1
endif

if value2<>0
   TEMP=ALLTRIM(STR(VALUE2))
   result1=stuff(result,77-LEN(TEMP),LEN(TEMP),TEMP)
   result=result1
endif

return result








PROCEDURE  Read11
*****************

Set Cursor on
set color to w/bg+,w/bg+
@  1, 12 Get LstNm Pict '!'+REPLICATE('X',27)
@  1, 46 Get FstNm Pict '!xxxxxxxxxx'
@  1, 64 Get MdlNm Pict '!xxxxxxxx'
@  2, 12 Get Strt  Pict "@!S27"
@  2, 46 Get Apt   Pict '!xxxxxx'
@  2, 64 Get City  Pict "@!S15"
@  3, 12 Get Cnty  Pict "@!S15"
@  3, 36 Get State Pict '@!xx'
@  3, 46 Get ZipCd Pict "99999-9999"
@  3, 65 Get TCdHm Pict '999'
@  3, 70 Get TelHm Pict '999-9999'
@  4, 65 Get TCdBs Pict '999'
@  4, 70 Get TelBs Pict '999-9999'
@  4, 12 Get Occup Pict '@!S13'
@  4, 36 Get EmpNm Pict "@!S20"
@  5, 12 Get EmAdr Pict "@!S36"
@  5, 77 Get Vh1   Pict '@M 1, 2'
@  6, 12 Get OwnNm Pict "@!S27"
@  6, 46 Get OwAdr Pict "@!S33"
Read
Return   




PROCEDURE  Read12
*****************

Set Color to RB+/RB+, w+/bg+ &&W+/RB+         &&w+/bg, N/BG 
@  8,  7 Get Year1 Pict '9999'
@  8, 24 Get Mk1   Pict '!xxxxxxxxxxxx'
@  9,  7 Get Modl1 Pict "@!S10"
@  9, 24 Get VhId1 Pict '@!S16'
@ 10, 10 Get PMo1  Pict '99'
@ 11, 10 Get PYr1  Pict '99'
@ 10, 24 Get New1  Pict '@M Y, N'
@ 11, 24 Get Cost1 Pict 'XXXXXXXX'
@ 12, 10 Get Cyl1  Pict '99'
@ 12, 24 Get Hp1   Pict 'XXXXX'
@ 13, 10 Get AtDv1 Pict '@M Y, N'
@ 13, 24 Get DvMl1 Pict '!xxxxxxxxxxx'
@ 14, 10 Get AcPs1 Pict 'X'
@ 14, 24 Get DvBd1 Pict '!xxxxxxxxxxx'
*@ 11,  6 Get Lpy   Pict 'x'
IF ( LOSSP1=.T. OR LESS1=.T.)
  @ 15, 10 Get LpNm1 Pict '@!S30'       WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 16, 10 Get LStr1 Pict '@!S21'       WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 16, 38 Get LpSt1 Pict '!xx'         WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 17, 10 Get LCty1 Pict '@!S13'       WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 17, 30 Get LpZC1 Pict '99999-9999'  WHEN ( LOSSP1=.T. OR LESS1=.T.)
ENDIF
@ 18, 10 Get GAdr1 Pict '@!S21'
@ 18, 37 Get UsFr1 Pict '@M W, P, B, F'
@ 19, 10 Get RAdr1 Pict '@!S21'
@ 19, 37 Get Milt1 Pict '999'
@ 20, 10 Get Tery1 Pict 'xxxxxxxxxx'
@ 20, 37 Get RtCs1 Pict 'xxx'
@ 21, 10 Get PlPt1 Pict 'xxxxxxx'
@ 21, 24 Get Symb1 Pict 'xxxxxxxxxxxxxx' Size 1,5
@ 21, 37 Get StR1  Pict '!!'
Read
*ik=inkey(5)
Return   && Read12



PROCEDURE  Read13
*****************

Set Color to RB+/RB+, N/BG+ &&W+/RB+         &&w+/bg, N/BG 
@  8, 47 Get Year2 Pict '9999'
@  8, 64 Get Mk2   Pict '!xxxxxxxxxxxx'
@  9, 47 Get Modl2 Pict "@!S10"
@  9, 64 Get VhId2 Pict '@!S15'
@ 10, 50 Get PMo2  Pict '99'
@ 11, 50 Get PYr2  Pict '99'
@ 10, 64 Get New2  Pict '@M Y, N'
@ 11, 64 Get Cost2 Pict 'XXXXXXXX'
@ 12, 50 Get Cyl2  Pict '99'
@ 12, 64 Get Hp2   Pict 'XXXXX'
@ 13, 50 Get AtDv2 Pict '@M Y, N'
@ 13, 64 Get DvMl2 Pict '!xxxxxxxxxxx'
@ 14, 50 Get AcPs2 Pict 'X'
@ 14, 64 Get DvBd2 Pict '!xxxxxxxxxxx'
*@ 11,  6 Get Lpy   Pict 'x'
IF ( LOSSP2=.T. OR LESS2=.T.)
  @ 15, 50 Get LpNm2 Pict '@!S29'            WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 16, 50 Get LStr2 Pict '@!S20'            WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 16, 77 Get LpSt2 Pict '!xx'              WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 17, 50 Get LCty2 Pict '@!S13'            WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 17, 69 Get LpZC2 Pict '99999-9999'       WHEN ( LOSSP2=.T. OR LESS2=.T.)
ENDIF
@ 18, 50 Get GAdr2 Pict '@!S21'
@ 18, 77 Get UsFr2 Pict '@M W, P, B, F'
@ 19, 50 Get RAdr2 Pict '@!S21'
@ 19, 76 Get Milt2 Pict '999'
@ 20, 50 Get Tery2 Pict 'xxxxxxxxxx'
@ 20, 76 Get RtCs2 Pict 'xxx'
@ 21, 50 Get PlPt2 Pict 'xxxxxxx'
@ 21, 64 Get symb2 Pict 'xxxxxxxxxxxxxx' SIZE 1,5
@ 21, 77 Get StR2  Pict '!!'
Read
*ik=inkey(5)

Return




PROCEDURE  Read14
*****************

Set Color to , N/W+
@ 24, 14 Get IRR1  Pict '@M I, R,'
@ 24, 29 Get PoI1  Pict '@M Y, N,'
@ 24, 48 Get mfs75  Pict '@M Y, N,'
@ 24, 63 Get IRR2  Pict '@M I, R,'
@ 24, 78 Get PoI2  Pict '@M Y, N,'
Read 
*ik=inkey(5)
if mfs75='Y'
   do getid
endif
Return   && Read14




PROCEDURE  Read21
*****************

*return && angelos
Set Color to , w+/bg+

vehicles=val(vh1)

DO PRINT_VALUES

@  2, 48 Get NOPol Pict '!'
Read
If Lastkey() = 27
   Return
EndIf
*Ik = Inkey(1)


*IF bodin1=0
*   Delete File 'ABBY\SCREEN.TXT'    && HANDFULL.TXT'
*   Delete File 'SCREEN.TXT'   && HANDFULL.TXT'
*   Save Screen to TempScrn
*   Run NYAIP
*   Run Copy ABBY\SCREEN.TXT
*   CLEAR
*   @ 10,21 TO 12,59 DOUBLE
*   @ 11,22 SAY 'Please Wait I am getting the Prices'
*   Do GetPrices
*   Restore Screen From TempScrn
*   DO PRINT_VALUES
*   RATING_ONCE=1
*ENDIF

ESTTOTPRE=TOTAL1+TOTAL2
ESTDEPRE=ESTTOTPRE*0.4
set color to ,w+/bg
@  3, 47 get bBodIn1  picture REPLICATE('X',20) size 1,8
@  3, 55 get BodIn1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@  4, 47 get bPrpDm1  picture REPLICATE('X',20) size 1,8
@  4, 55 get PrpDm1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@  5, 47 get bBaPIP1  picture REPLICATE('X',20) size 1,8
@  5, 55 get BaPIP1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@  6, 47 get bObelc1  picture REPLICATE('X',20) size 1,8
@  6, 55 get Obelc1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@  7, 47 get bAdPIP1  picture REPLICATE('X',20) size 1,8
@  7, 55 get AdPIP1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@  8, 47 GET bFADPIP1 picture REPLICATE('X',20) size 1,8
@  8, 55 GET FADPIP1 picture '99999.9' COLOR ,gr+/w  valid calc1_tot()
@  9, 47 get bMedPa1  picture REPLICATE('X',20) size 1,8
@  9, 55 get MedPa1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@ 10, 47 get bStUnM1  picture REPLICATE('X',20) size 1,8
@ 10, 55 get StUnM1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@ 11, 47 get bVoUnM1  picture REPLICATE('X',20) size 1,8
@ 11, 55 get VoUnM1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@ 12, 47 get bCOMPR1  picture REPLICATE('X',20) size 1,8
@ 12, 55 get COMPR1 picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@ 13, 47 GET bCOLL1   picture REPLICATE('X',20) size 1,8
@ 13, 55 GET COLL1  picture  '99999.9' COLOR  ,gr+/w valid calc1_tot()
@ 14, 47 GET BEIP1   picture REPLICATE('X',20) size 1,8
@ 14, 55 GET EIP1  picture   '99999.9' COLOR  ,gr+/w valid calc1_tot()
@ 15, 55 GET TOTAL1 PICTURE  '99999.9' COLOR  ,gr+/w
READ
If Lastkey() = 27
   Return
EndIf

IF VEHICLES=2
set color to w+/bg
@  3, 64 get bBodIn2  picture REPLICATE('X',20) size 1,8
@  3, 72  get BodIn2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  4, 64 get bPrpDm2  picture REPLICATE('X',20) size 1,8
@  4, 72  get PrpDm2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  5, 64 get bBaPIP2  picture REPLICATE('X',20) size 1,8
@  5, 72  get BaPIP2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  6, 64 get bObelc2  picture REPLICATE('X',20) size 1,8
@  6, 72  get Obelc2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  7, 64 get bAdPIP2  picture REPLICATE('X',20) size 1,8
@  7, 72  get AdPIP2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  8, 64 GET bFADPIP2 picture REPLICATE('X',20) size 1,8
@  8, 72  GET FADPIP2 picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  9, 64 get bMedPa2  picture REPLICATE('X',20) size 1,8
@  9, 72  get MedPa2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 10, 64 get bStUnM2  picture REPLICATE('X',20) size 1,8
@ 10, 72  get StUnM2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 11, 64 get bVoUnM2  picture REPLICATE('X',20) size 1,8
@ 11, 72  get VoUnM2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 12, 64 get bCOMPR2  picture REPLICATE('X',20) size 1,8
@ 12, 72  get COMPR2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 13, 64 GET bCOLL2   picture REPLICATE('X',20) size 1,8
@ 13, 72  GET COLL2   picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 14, 64 GET BEIP2    picture REPLICATE('X',20) size 1,8
@ 14, 72  GET EIP2    picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 15, 72  GET TOTAL2  PICTURE '99999.9' COLOR  ,gr+/w
read
If Lastkey() = 27
   Return
EndIf
ENDIF

@ 16,36 get company picture replicate ('X',30) size 1,30
@ 17,16 get limits  picture replicate ('X',30) size 1,14
@ 17,41 get policy  picture replicate ('X',30) size 1,9
@ 17,68 get expiRDATE   picture '99/99/0099' SIZE 1,10
@ 18,30 GET ESTTOTPRE PICTURE '99999.9'
*@ 18,70 GET ESTDEPRE PICTURE '99999.9'
Read
If Lastkey() = 27
   Return
EndIf

GTOTAL=TOTAL1+TOTAL2

*@ 14, 50 Say Payms
*Ik = Inkey(5)

*ik=inkey(5)
*@ 16, 52 Get CComp Pict 'xxxxxxxxxxxxxxxxxxxxxxx'

Return




PROCEDURE  Read22
*****************

Set Color to , w+/bg+

* GRAB THE FINANCIAL INFORMATION
select policy
*go top
*locate for dpid=pid
*if !found()
*   ?? chr(7)
*   wait window 'Warning no policy found For Vehicle' timeout 1
*   wait window 'This Data is Unreliable' timeout 1
*else

*     option1    =doption1
*     option2    =doption2
*     FINANCED   =DFINANCED
*     FINCOMPANY =DFINCOMPANY
*     TOTPRE     =DTOTPRE
*     PREMIUM    =DPREMIUM
*     INSTALLMENT=DINSTALL
*     DOWN1      =DDOWN1
*     DOWN2      =DDOWN2
*endif

IF OPTION1=.F. AND OPTION2=.F.
   OPTION2=.T.
ENDIF
PREMIUM=TOTAL1+TOTAL2
*   IF OPTION1=.T.
*      INSTALLMENT=3*3
*   ELSE
*       INSTALLMENT=6*4
*   ENDIF
installment=0
IF OPTION1=.T.
   DOWN1=PREMIUM*0.3
   DOWN2=0
ENDIF
IF OPTION2=.T.
   DOWN2=TOTPRE*.25
   DOWN1=0
ENDIF
TOTPRE=PREMIUM
@ 20,12 get option1 picture '@L Y;N'
@ 20,25 get option2 picture '@L Y;N'

IF FINANCED=.F.
   FINCOMPANY=SPACE(30)
ENDIF
@ 22,13 GET FINANCED picture 'Y'
@ 23,13 GET FINCOMPANY PICTURE REPLICATE ('X',30) SIZE 1,15 WHEN FINANCED=.T.
read

PREMIUM=TOTAL1+TOTAL2
*   IF OPTION1=.T.
*      INSTALLMENT=3*3
*   ELSE
*       INSTALLMENT=6*4
*   ENDIF
*   IF OPTION1=.T.
*      INSTALLMENT=3*3
*   ELSE
*       INSTALLMENT=6*4
*   ENDIF
installment=0
IF OPTION1=.T.
   DOWN1=PREMIUM*0.3
   DOWN2=0
ENDIF
IF OPTION2=.T.
   DOWN2=TOTPRE*.25
   DOWN1=0
ENDIF

@ 20, 45 Get PREMIUM Pict '9999999.99'
*@ 21, 45 Get INSTALLMENT Pict '9999999.99'
READ
TOTPRE=PREMIUM
@ 22, 45 Get TOTPRE Pict '9999999.99'
READ
IF OPTION1=.F. AND OPTION2=.F.
   OPTION1=.T.
ENDIF
IF OPTION1=.T.
   DOWN1=PREMIUM*0.3
   DOWN2=0
ENDIF
IF OPTION2=.T.
   DOWN2=TOTPRE*.25
   DOWN1=0
ENDIF

@ 21,70 GET DOWN1 PICTURE '99999.9' when option1=.t.
@ 22,70 GET DOWN2 PICTURE '99999.9' when option2=.t.
Read
TOTPRE=PREMIUM

Return




PROCEDURE  Read3
****************

Param R, C, Elm

IF ELM>DRIVERS
   RETURN
endif
If (Elm = 1) .Or. (Elm = 4)
   Set Color to , N/bg+
 Else
   Set Color to , w+/bg+
EndIf
IF ELM =1
   @ 1,40 GET CREDIT PICTURE '@L Y;N'
ENDIF
@ R,   C   Get Drvr[Elm]  Pict REPLICATE('x',30) SIZE 1,30  &&2 16
@ R+1, C   Get Relt[Elm]  Pict '!xxxxxxxxxx' SIZE 1,11
@ R+2, C   Get Us1[Elm]   Pict '999'
@ R+2, C+7 Get Us2[Elm]   Pict '999'
@ R+3, C   Get BDt[Elm]   Pict '@D'
@ R+4, C   Get Sex[Elm]   Pict '@M , M, F'
@ R+5, C   Get MSts[Elm]  Pict '@M , S, R, D, M'
@ R+6, C   Get LcNr[Elm]  Pict '!xxxxxxxxxxxxxxxxxxxx'
@ R+7, C   Get Stt[Elm]   Pict 'AA'
@ R+8, C   Get Durt3[Elm] Pict '@M  ,Y, N'
@ R+9, C   Get DurtM[Elm] Pict '@D'
*Read
If Elm=4
  Set Color to GR+/B, w+/gr
  @ 24, 14 Get FrAdr Pict  '@!S28'
  @ 24, 52 Get MTML   Pict  '!'+ Replic('x',14)
  @ 24, 74 Get CMR   Pict  '!xxxxx'
*  Read
EndIf
Read
*ik=inkey(5)

Return   && Read3



PROCEDURE  Form1
****************

SET COLOR TO gr+/b
Clear
@  7,  1 Say Repl('-', 13) + '  VEHICLE 1  ' + Repl ('-', 13) +'-';
           + Repl('-', 13) + '  VEHICLE 2  ' + Repl ('-', 12) 
@ 23,  1 Say Repl('-', 28) + '  IDENTIFICATION CARD  ' + Repl('-', 27)
@  8, 40 to 21, 40
*ik=inkey(5)
*@  1,  1 Fill to  6, 78 Color W+/W+
*@  8,  1 Fill to 21, 39 Color BG+/BG+
*@  8, 41 Fill to 21, 78 Color BG+/BG+
*@ 23,  1 Fill to 23, 78 Color W+/W+
*@ 23, 40 Say '³' COLOR gr+/b
*@ 24, 40 Say 'Ï' COLOR gr+/b
*ik=inkey(5)
Set Color to gr+/b  &&GR+/RB+     && GR+/G+
@  1,  1 Say 'NAME :Last:'
@  1, 40 Say 'First:'
@  1, 57 Say 'Middle:'
@  2,  1 Say 'ADDR.:Strt:'  
@  2, 40 Say 'Apt.#:'
@  2, 57 Say 'City  :'
@  3,  1 Say '      Coun:'
@  3, 30 Say 'State:'
@  3, 40 Say 'ZipCd:'
@  3, 57 Say 'Tel.:Hm(   )'
@  4, 57 Say 'Tel.:Bs(   )'
@  4,  1 Say "Occup     :"
@  4, 26 Say "Empl.Name:"
@  5,  1 Say 'Emp. Addr :'
@  5, 73 Say 'Veh:'
@  6,  1 Say 'OWNR: Name:'
@  6, 40 Say 'Addrs:'

*ik=inkey(5)
*@ 8, 1 Fill to 11, 78 Color BG+/BG+ &&RB+/RB+
*ik=inkey(5)
@  8,  1 Say 'Year :'
@  8, 18 Say 'Make :'
@  9,  1 Say 'Model:'
@  9, 18 Say 'VhID#:'  
@ 10,  1 Say "PURCH:Mo:"
@ 10, 18 Say 'New  :'
@ 11,  1 Say '      Yr:'
@ 11, 18 Say "Cost :"
@ 12,  1 Say "     Cyl:"
@ 12, 18 Say "HP/cu:"
@ 13,  1 Say "A/T DEV.:"
@ 13, 18 Say "Model:"
@ 14, 18 Say "Brand:"
@ 14,  1 Say "Actv/Psv:"
@ 15,  1 Say 'LosP Nam:'
@ 16,  1 Say '    Strt:'
@ 16, 32 Say 'State:'
@ 17,  1 Say '    City:'
@ 17, 24 Say 'ZipCd:'
@ 18,  1 Say 'Garg Adr:'
@ 18, 32 Say 'Use:'
@ 19,  1 Say 'Appl.Adr:'
@ 19, 32 Say 'Mils:'
@ 20,  1 Say 'Territor:'
@ 20, 28 Say 'Rate Cls:'
@ 21,  1 Say 'Penalty :'
@ 21, 18 Say 'Symbl:'
@ 21, 30 Say 'St.Reg:' 
*ik=inkey(5)
@  8, 41 Say 'Year :'
@  8, 58 Say 'Make :'
@  9, 41 Say 'Model:'
@  9, 58 Say 'VhID#:'  
@ 10, 41 Say "PURCH:Mo:"
@ 10, 58 Say 'New  :'
@ 11, 41 Say '      Yr:'
@ 11, 58 Say "Cost :"
@ 12, 41 Say "     Cyl:"
@ 12, 58 Say "HP/cu:"
@ 13, 41 Say "A/T DEV.:"
@ 13, 58 Say "Model:"
@ 14, 58 Say "Brand:"
@ 14, 41 Say "Actv/Psv:"
@ 15, 41 Say 'LosP Nam:'
@ 16, 41 Say '    Strt:'
@ 16, 71 Say 'State:'
@ 17, 41 Say '    City:'
@ 17, 63 Say 'ZipCd:'
@ 18, 41 Say 'Garg Adr:'
@ 18, 71 Say 'Use:'
@ 19, 41 Say 'Appl.Adr:'
@ 19, 71 Say 'Mils:'
@ 20, 41 Say 'Territor:'
@ 20, 67 Say 'Rate Cls:'
@ 21, 41 Say 'Penalty :'
@ 21, 58 Say 'Symbl:' 
@ 21, 69 Say 'St.Reg:' 
@ 24,  1 Say 'Init/Ren Reg:'
@ 24, 16 Say 'Proof of Ins:'
@ 24, 31 Say 'Issued FS 75-6-7?'
@ 24, 50 Say 'Init/Ren Reg:'
@ 24, 65 Say 'Proof of Ins:'
Set Color to r+/b  && ANGELOS
DO GET11
DO GET12
DO GET13
DO GET14
Return



PROCEDURE  Form2
****************
SET COLOR TO gr+/b
@ 0, 0 Clear to 24, 79
Save Screen to TempScreen
SET COLOR TO gr+/b
@ 19,  1 Say Repl('-', 33) + '  PAY PLAN  ' + Repl ('-', 33) 

*@  3,  1 Fill to 14, 54 Color  W/W
*@  3,  55 Fill to 15, 61 Color G/R+
*@  3,  64 Fill to 14, 71 Color W/W
*@  3,  72 Fill to 15, 78 Color G/R+

SET COLOR TO gr+/b
@  1, 1 Say Repl(' ', 50) + 'Vehicle  1       Vehicle 2  '&& + Repl(' ',11)
@  2, 1 Say 'Non - Owner Policy                            '
@  3, 1 Say 'Bodily Injuiry Liability . . . . . . . . . . .'
@  4, 1 Say 'Property Damage Liability  . . . . . . . . . .'
@  5, 1 Say 'Mandatory Personal Injury Protection Coverage '
@  6, 1 Say 'Optional Basic Economic Loss Coverage. . . . .'
@  7, 1 Say "Addit'l PIP Cov. Opt.  * Guest Occup. OoS PIP "
@  8, 1 Say '                       * Full Additional PIP  '
@  9, 1 Say 'Medical Payments Coverage  . . . . . . . . . .'
@ 10, 1 Say 'Statutory Uninsured Motorists Coverage . . . .'
@ 11, 1 Say 'Voluntary Uninsured Motorists Coverage . . . .'
@ 12, 1 Say 'Comprehen. Submit Signed Auth. For Insp. Form ' 
@ 13, 1 Say 'Collision  . . . . . . . . . . . . . . . . . .'
@ 14, 1 Say 'Excess Indemnity Policy  . . . . . . . . . . .'
@ 15, 1 Say '                             Estimated Premium'
@ 16, 1 Say "Company Providing Primary Coverage:"
@ 17, 1 Say 'Limits Provided:'
@ 17,29 Say ' Policy No.:'
@ 17,50 Say 'Expiration Date:'
@ 18, 1 Say 'Estimated Premium All Units:' 
*@ 18,50 Say 'Deposit Premium:'
@ 20, 1 Say ' Option 1  '
@ 21, 1 Say '  30%-70%  '
@ 20,15 Say ' Option 2  '
@ 21,15 Say '25% + 5 x 15%'
@ 22, 1 Say 'Prem. Fin.:'
@ 23, 1 Say 'Fin. Comp.:'
@ 20,29 Say 'A Annual Prem.:'
@ 21,29 Say 'B Instalm. Fee:'
@ 22,29 Say 'C Total (A+B) :'
@ 20,55 Say 'Deposit      :'
@ 21,55 Say 'Opt 1 30% A  :'
@ 22,55 Say 'Opt 2 25% A+B:'

DO PRINT_VALUES
*ET COLOR TO r+/b  && ANGELOS
DO GET21
DO GET22
Return




PROCEDURE  Form3
****************

SET COLOR TO gr+/b
@ 0, 0 Clear to 24, 79
Save Screen to TempScreen
Set Color to gr+/b
Set Color to gr+/b
@  2, 47 to 22, 47  && '³'
@ 12, 1 Say Repl('-', 46) + '-' + Repl ('-', 31) 
Set Color to gr+/b
@  1, 1 Say 'Eligibility for Driver Training CREDIT:' + Repl(' ', 39)
@  2, 1 Say 'Driver Names  :'
@  3, 1 Say 'Relationship  :'
@  4, 1 Say '% Used Vh1/Vh2:'
@  5, 1 Say 'Birth Date    :'
@  6, 1 Say 'Sex           :'
@  7, 1 Say 'M/S           :'
@  8, 1 Say 'Lisence/Perm.#:'
@  9, 1 Say 'State         :'
@ 10, 1 Say 'Licen. 3 Years:' 
@ 11, 1 Say 'Lic. Dt Issued:'
@ 13, 1 Say 'Driver Names  :'
@ 14, 1 Say 'Relationship  :'
@ 15, 1 Say '% Used Vh1/vH2:'
@ 16, 1 Say 'Birth Date    :'
@ 17, 1 Say 'Sex           :'
@ 18, 1 Say 'M/S           :'
@ 19, 1 Say 'Lisence/Perm.#:'
@ 20, 1 Say 'State         :'
@ 21, 1 Say 'Licen. 3 Years:'
@ 22, 1 Say 'Lic. Dt Issued:'
Set Color to gr+/b
@ 24, 1 Say Space(78)
@ 24, 1 Say 'Former Addr.: '
@ 24,43 Say 'TML AIP#: '
@ 24,68 Say 'CMR#: '
Set Color to r+/b  && ANGELOS
              Do GET3 with 2, 17, 1
              Do GET3 with 2, 49, 2
              Do GET3 with 13, 17, 3
              Do GET3 with 13, 49, 4
Return





PROCEDURE PRINT_VALUES
***********************
IF VEHICLES>0
SET COLOR TO w+/bg
@  3, 47 SAY bBodIn1  picture REPLICATE('X',20) size 1,8
@  4, 47 SAY bPrpDm1  picture REPLICATE('X',20) size 1,8
@  5, 47 SAY bBaPIP1  picture REPLICATE('X',20) size 1,8
@  6, 47 SAY bObelc1  picture REPLICATE('X',20) size 1,8
@  7, 47 SAY bAdPIP1  picture REPLICATE('X',20) size 1,8
@  8, 47 SAY bFADPIP1 picture REPLICATE('X',20) size 1,8
@  9, 47 SAY bMedPa1  picture REPLICATE('X',20) size 1,8
@ 10, 47 SAY bStUnM1  picture REPLICATE('X',20) size 1,8
@ 11, 47 SAY bVoUnM1  picture REPLICATE('X',20) size 1,8
@ 12, 47 SAY bCOMPR1  picture REPLICATE('X',20) size 1,8
@ 13, 47 SAY bCOLL1   picture REPLICATE('X',20) size 1,8
@ 14, 47 SAY BEIP1   picture REPLICATE('X',20) size 1,8

SET COLOR TO gr+/w
@  3, 55 SAY BodIn1 picture '99999.9' 
@  4, 55 SAY PrpDm1 picture '99999.9' 
@  5, 55 SAY BaPIP1 picture '99999.9' 
@  6, 55 SAY Obelc1 picture '99999.9' 
@  7, 55 SAY AdPIP1 picture '99999.9' 
@  8, 55 SAY FADPIP1 picture '99999.9' 
@  9, 55 SAY MedPa1 picture '99999.9' 
@ 10, 55 SAY StUnM1 picture '99999.9' 
@ 11, 55 SAY VoUnM1 picture '99999.9' 
@ 12, 55 SAY COMPR1 picture '99999.9' 
@ 13, 55 SAY COLL1  picture '99999.9' 
@ 14, 55 SAY EIP1  picture '99999.9' 
@ 15, 55 SAY TOTAL1 PICTURE '99999.9' 
ENDIF

IF VEHICLES>1
SET COLOR TO w+/bg
@  3, 64 SAY bBodIn2  picture REPLICATE('X',20) size 1,8
@  4, 64 SAY bPrpDm2  picture REPLICATE('X',20) size 1,8
@  5, 64 SAY bBaPIP2  picture REPLICATE('X',20) size 1,8
@  6, 64 SAY bObelc2  picture REPLICATE('X',20) size 1,8
@  7, 64 SAY bAdPIP2  picture REPLICATE('X',20) size 1,8
@  8, 64 SAY bFADPIP2 picture REPLICATE('X',20) size 1,8
@  9, 64 SAY bMedPa2  picture REPLICATE('X',20) size 1,8
@ 10, 64 SAY bStUnM2  picture REPLICATE('X',20) size 1,8
@ 11, 64 SAY bVoUnM2  picture REPLICATE('X',20) size 1,8
@ 12, 64 SAY bCOMPR2  picture REPLICATE('X',20) size 1,8
@ 13, 64 SAY bCOLL2   picture REPLICATE('X',20) size 1,8
@ 14, 64 SAY BEIP2    picture REPLICATE('X',20) size 1,8

SET COLOR TO gr+/w
@  3, 72  SAY BodIn2  picture '99999.9' 
@  4, 72  SAY PrpDm2  picture '99999.9' 
@  5, 72  SAY BaPIP2  picture '99999.9' 
@  6, 72  SAY Obelc2  picture '99999.9' 
@  7, 72  SAY AdPIP2  picture '99999.9' 
@  8, 72  SAY FADPIP2 picture '99999.9' 
@  9, 72  SAY MedPa2  picture '99999.9' 
@ 10, 72  SAY StUnM2  picture '99999.9' 
@ 11, 72  SAY VoUnM2  picture '99999.9' 
@ 12, 72  SAY COMPR2  picture '99999.9' 
@ 13, 72  SAY COLL2   picture '99999.9' 
@ 14, 72  SAY EIP2    picture '99999.9' 
@ 15, 72  SAY TOTAL2  PICTURE '99999.9' 
ENDIF


SET COLOR TO w+/bg
@ 16,36 SAY company picture replicate ('X',30) size 1,30
@ 17,16 SAY  limits  picture replicate ('X',30) size 1,14
@ 17,41 SAY  policy  picture replicate ('X',30) size 1,9
@ 17,68 SAY  expiRDATE   picture '99/99/9999' SIZE 1,10
@ 18,30 SAY  ESTTOTPRE PICTURE '99999.9'
*@ 18,70 SAY  ESTDEPRE PICTURE '99999.9'
*wait window "Done"
RETURN
 





PROCEDURE  GET11
*****************
Set Cursor on
set color to w/bg+,w/bg+
@  1, 12 Get LstNm Pict '!'+REPLICATE('X',27)
@  1, 46 Get FstNm Pict '!xxxxxxxxxx'
@  1, 64 Get MdlNm Pict '!xxxxxxxx'
@  2, 12 Get Strt  Pict "@!S27"
@  2, 46 Get Apt   Pict '!xxxxxx'
@  2, 64 Get City  Pict "@!S15"
@  3, 12 Get Cnty  Pict "@!S15"
@  3, 36 Get State Pict '@!xx'
@  3, 46 Get ZipCd Pict "99999-9999"
@  3, 65 Get TCdHm Pict '999'
@  3, 70 Get TelHm Pict '999-9999'
@  4, 65 Get TCdBs Pict '999'
@  4, 70 Get TelBs Pict '999-9999'
@  4, 12 Get Occup Pict '@!S13'
@  4, 36 Get EmpNm Pict "@!S20"
@  5, 12 Get EmAdr Pict "@!S36"
@  5, 77 Get Vh1   Pict '@M 1, 2'
@  6, 12 Get OwnNm Pict "@!S27"
@  6, 46 Get OwAdr Pict "@!S33"
CLEAR GETS
Return





PROCEDURE  GET12
*****************
Set Color to RB+/RB+, w+/bg+ &&W+/RB+         &&w+/bg, N/BG
@  8,  7 Get Year1 Pict '9999'
@  8, 24 Get Mk1   Pict '!xxxxxxxxxxxx'
@  9,  7 Get Modl1 Pict "@!S10"
@  9, 24 Get VhId1 Pict '@!S16'
@ 10, 10 Get PMo1  Pict '99'
@ 11, 10 Get PYr1  Pict '99'
@ 10, 24 Get New1  Pict '@M Y, N'
@ 11, 24 Get Cost1 Pict 'XXXXXXXX'
@ 12, 10 Get Cyl1  Pict '99'
@ 12, 24 Get Hp1   Pict 'XXXXX'
@ 13, 10 Get AtDv1 Pict '@M Y, N'
@ 13, 24 Get DvMl1 Pict '!xxxxxxxxxxx'
@ 14, 10 Get AcPs1 Pict 'X'
@ 14, 24 Get DvBd1 Pict '!xxxxxxxxxxx'
*@ 11,  6 Get Lpy   Pict 'x'
IF ( LOSSP1=.T. OR LESS1=.T.)
  @ 15, 10 Get LpNm1 Pict '@!S30'       WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 16, 10 Get LStr1 Pict '@!S21'       WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 16, 38 Get LpSt1 Pict '!xx'         WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 17, 10 Get LCty1 Pict '@!S13'       WHEN ( LOSSP1=.T. OR LESS1=.T.)
  @ 17, 30 Get LpZC1 Pict '99999-9999'  WHEN ( LOSSP1=.T. OR LESS1=.T.)
ENDIF
@ 18, 10 Get GAdr1 Pict '@!S21'
@ 18, 37 Get UsFr1 Pict '@M W, P, B, F'
@ 19, 10 Get RAdr1 Pict '@!S21'
@ 19, 37 Get Milt1 Pict '999'
@ 20, 10 Get Tery1 Pict 'xxxxxxxxxx'
@ 20, 37 Get RtCs1 Pict 'xxx'
@ 21, 10 Get PlPt1 Pict 'xxxxxxx'
@ 21, 24 Get Symb1 Pict 'xxxxxxxxxxxxxx' Size 1,5
@ 21, 37 Get StR1  Pict '!!'
CLEAR GETS
Return



PROCEDURE  GET13
*****************
IF VH1='2'
Set Color to RB+/RB+, N/BG+ &&W+/RB+         &&w+/bg, N/BG
@  8, 47 Get Year2 Pict '9999'
@  8, 64 Get Mk2   Pict '!xxxxxxxxxxxx'
@  9, 47 Get Modl2 Pict "@!S10"
@  9, 64 Get VhId2 Pict '@!S15'
@ 10, 50 Get PMo2  Pict '99'
@ 11, 50 Get PYr2  Pict '99'
@ 10, 64 Get New2  Pict '@M Y, N'
@ 11, 64 Get Cost2 Pict 'XXXXXXXX'
@ 12, 50 Get Cyl2  Pict '99'
@ 12, 64 Get Hp2   Pict 'XXXXX'
@ 13, 50 Get AtDv2 Pict '@M Y, N'
@ 13, 64 Get DvMl2 Pict '!xxxxxxxxxxx'
@ 14, 50 Get AcPs2 Pict 'X'
@ 14, 64 Get DvBd2 Pict '!xxxxxxxxxxx'
*@ 11,  6 Get Lpy   Pict 'x'
IF ( LOSSP2=.T. OR LESS2=.T.)
  @ 15, 50 Get LpNm2 Pict '@!S29'            WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 16, 50 Get LStr2 Pict '@!S20'            WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 16, 77 Get LpSt2 Pict '!xx'              WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 17, 50 Get LCty2 Pict '@!S13'            WHEN ( LOSSP2=.T. OR LESS2=.T.)
  @ 17, 69 Get LpZC2 Pict '99999-9999'       WHEN ( LOSSP2=.T. OR LESS2=.T.)
ENDIF
@ 18, 50 Get GAdr2 Pict '@!S21'
@ 18, 77 Get UsFr2 Pict '@M W, P, B, F'
@ 19, 50 Get RAdr2 Pict '@!S21'
@ 19, 76 Get Milt2 Pict '999'
@ 20, 50 Get Tery2 Pict 'xxxxxxxxxx'
@ 20, 76 Get RtCs2 Pict 'xxx'
@ 21, 50 Get PlPt2 Pict 'xxxxxxx'
@ 21, 64 Get symb2 Pict 'xxxxxxxxxxxxxx' SIZE 1,5
@ 21, 77 Get StR2  Pict '!!'
CLEAR GETS
ENDIF
Return



PROCEDURE  GET14
*****************
Set Color to , N/W+
@ 24, 14 Get IRR1  Pict '@M I, R'
@ 24, 29 Get PoI1  Pict '@M Y, N'
@ 24, 48 Get mfs75  Pict '@M Y, N'
@ 24, 63 Get IRR2  Pict '@M I, R'
@ 24, 78 Get PoI2  Pict '@M Y, N'
CLEAR GETS
Return




PROCEDURE  GET21
*****************
vehicles=val(vh1)
DO PRINT_VALUES
@  2, 48 Get NOPol Pict '!'
CLEAR GETS
If Lastkey() = 27
   Return
EndIf
*Ik = Inkey(1)


ESTTOTPRE=TOTAL1+TOTAL2
ESTDEPRE=ESTTOTPRE*0.4
set color to ,w+/bg
@  3, 47 get bBodIn1  picture REPLICATE('X',20) size 1,8
@  3, 55 get BodIn1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@  4, 47 get bPrpDm1  picture REPLICATE('X',20) size 1,8
@  4, 55 get PrpDm1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@  5, 47 get bBaPIP1  picture REPLICATE('X',20) size 1,8
@  5, 55 get BaPIP1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@  6, 47 get bObelc1  picture REPLICATE('X',20) size 1,8
@  6, 55 get Obelc1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@  7, 47 get bAdPIP1  picture REPLICATE('X',20) size 1,8
@  7, 55 get AdPIP1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@  8, 47 GET bFADPIP1 picture REPLICATE('X',20) size 1,8
@  8, 55 GET FADPIP1 picture '99999.9' COLOR ,gr+/w   valid calc1_tot()
@  9, 47 get bMedPa1  picture REPLICATE('X',20) size 1,8
@  9, 55 get MedPa1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@ 10, 47 get bStUnM1  picture REPLICATE('X',20) size 1,8
@ 10, 55 get StUnM1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@ 11, 47 get bVoUnM1  picture REPLICATE('X',20) size 1,8
@ 11, 55 get VoUnM1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@ 12, 47 get bCOMPR1  picture REPLICATE('X',20) size 1,8
@ 12, 55 get COMPR1 picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@ 13, 47 GET bCOLL1   picture REPLICATE('X',20) size 1,8
@ 13, 55 GET COLL1  picture  '99999.9' COLOR  ,gr+/w  valid calc1_tot()
@ 14, 47 GET BEIP1   picture REPLICATE('X',20) size 1,8
@ 14, 55 GET EIP1  picture   '99999.9' COLOR  ,gr+/w  valid calc1_tot()

@ 15, 55 GET TOTAL1 PICTURE  '99999.9' COLOR  ,gr+/w
CLEAR GETS
If Lastkey() = 27
   Return
EndIf

IF VH1='2'
set color to ,w+/bg
@  3, 64 get bBodIn2  picture REPLICATE('X',20) size 1,8
@  3, 72  get BodIn2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  4, 64 get bPrpDm2  picture REPLICATE('X',20) size 1,8
@  4, 72  get PrpDm2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  5, 64 get bBaPIP2  picture REPLICATE('X',20) size 1,8
@  5, 72  get BaPIP2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  6, 64 get bObelc2  picture REPLICATE('X',20) size 1,8
@  6, 72  get Obelc2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  7, 64 get bAdPIP2  picture REPLICATE('X',20) size 1,8
@  7, 72  get AdPIP2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  8, 64 GET bFADPIP2 picture REPLICATE('X',20) size 1,8
@  8, 72  GET FADPIP2 picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@  9, 64 get bMedPa2  picture REPLICATE('X',20) size 1,8
@  9, 72  get MedPa2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 10, 64 get bStUnM2  picture REPLICATE('X',20) size 1,8
@ 10, 72  get StUnM2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 11, 64 get bVoUnM2  picture REPLICATE('X',20) size 1,8
@ 11, 72  get VoUnM2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 12, 64 get bCOMPR2  picture REPLICATE('X',20) size 1,8
@ 12, 72  get COMPR2  picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 13, 64 GET bCOLL2   picture REPLICATE('X',20) size 1,8
@ 13, 72  GET COLL2   picture '99999.9' COLOR  ,gr+/w valid calc2_tot()
@ 14, 64 GET BEIP2    picture REPLICATE('X',20) size 1,8
@ 14, 72  GET EIP2    picture '99999.9' COLOR  ,gr+/w valid calc2_tot()

@ 15, 72  GET TOTAL2  PICTURE '99999.9' COLOR  ,gr+/w
CLEAR GETS
If Lastkey() = 27
   Return
EndIf
ENDIF

set color to ,w+/bg
@ 16,36 get company picture replicate ('X',30) size 1,30
@ 17,16 get limits  picture replicate ('X',30) size 1,14
@ 17,41 get policy  picture replicate ('X',30) size 1,9
@ 17,68 get expiRDATE   picture '99/99/9999' SIZE 1,10
@ 18,30 GET ESTTOTPRE PICTURE '99999.9'
*@ 18,70 GET ESTDEPRE PICTURE '99999.9'
CLEAR GETS
If Lastkey() = 27
   Return
EndIf

GTOTAL=TOTAL1+TOTAL2

*@ 14, 50 Say Payms
*Ik = Inkey(5)

*@ 16, 52 Get CComp Pict 'xxxxxxxxxxxxxxxxxxxxxxx'
*ik=inkey(5)

Return




PROCEDURE  GET22
*****************
Set Color to , w+/bg+

select policy
     option1    =doption1
     option2    =doption2
     FINANCED   =DFINANCED
     FINCOMPANY =DFINCOMPANY
     TOTPRE     =DTOTPRE
     PREMIUM    =DPREMIUM
     INSTALLMENT=DINSTALL
     DOWN1      =DDOWN1
     DOWN2      =DDOWN2
IF FINANCED=.F.
   FINCOMPANY=SPACE(30)
ENDIF
PREMIUM=TOTAL1+TOTAL2
*IF OPTION1=.T.
*   INSTALLMENT=3*3
*ELSE
*   INSTALLMENT=6*4
*ENDIF
TOTPRE=PREMIUM
IF OPTION1=.T.
   DOWN1=PREMIUM*0.3
   DOWN2=0
ENDIF
IF OPTION2=.T.
   DOWN2=TOTPRE*.25
   DOWN1=0
ENDIF
@ 20,12 get option1 picture 'Y'
@ 20,25 get option2 picture 'Y'
*IF OPTION1=.T.
*   INSTALLMENT=3*3
*ELSE
*   INSTALLMENT=6*4
*ENDIF

@ 22,13 GET FINANCED picture 'Y'
@ 23,13 GET FINCOMPANY PICTURE REPLICATE ('X',30) SIZE 1,15 WHEN FINANCED=.T.


@ 20, 45 Get PREMIUM Pict '9999999.99'
*@ 21, 45 Get INSTALLMENT Pict '9999999.99'
*TOTPRE=PREMIUM+INSTALLMENT
TOTPRE=PREMIUM
@ 22, 45 Get TOTPRE Pict '9999999.99'

IF OPTION1=.T.
   DOWN1=PREMIUM*0.3
   DOWN2=0
ENDIF
IF OPTION2=.T.
   DOWN2=TOTPRE*.25
   DOWN1=0
ENDIF
@ 21,70 GET DOWN1 PICTURE '99999.9' WHEN OPTION1=.T.
@ 22,70 GET DOWN2 PICTURE '99999.9' WHEN OPTION2=.T.
CLEAR GETS
Return



PROCEDURE  GET3
****************
Param R, C, Elm
If (Elm = 1) .Or. (Elm = 4)
   Set Color to , N/bg+
 Else
   Set Color to , w+/bg+
EndIf
IF ELM =1
   @ 1,40 GET CREDIT PICTURE '@L Y;N'
ENDIF
@ R,   C   Get Drvr[Elm]  Pict REPLICATE('x',30) SIZE 1,30  &&2 16
@ R+1, C   Get Relt[Elm]  Pict '!xxxxxxxxxx' SIZE 1,11
@ R+2, C   Get Us1[Elm]   Pict '999'
@ R+2, C+7 Get Us2[Elm]   Pict '999'
@ R+3, C   Get BDt[Elm]   Pict '@D'
@ R+4, C   Get Sex[Elm]   Pict '@M M, F'
@ R+5, C   Get MSts[Elm]  Pict '@M S, R, D, M'
@ R+6, C   Get LcNr[Elm]  Pict '!xxxxxxxxxxxxxxxxxxxx'
@ R+7, C   Get Stt[Elm]   Pict 'AA'
@ R+8, C   Get Durt3[Elm] Pict '@M Y, N'
@ R+9, C   Get DurtM[Elm] Pict '@D'
*Read
If Elm=4
  Set Color to GR+/B, w+/gr
  @ 24, 14 Get FrAdr Pict  '@!S28'
  @ 24, 52 Get MTML   Pict  '!'+ Replic('x',14)
  @ 24, 74 Get CMR   Pict  '!xxxxx'
*  Read
EndIf
CLEAR GETS
Return


procedure getid
*******************
define window cinfo from 8,5 to 12,67 color scheme 5 double float shadow in screen
activate window cinfo
@ 1,9 say 'Please enter FS 75-76-77 ID number' get mfs75id picture replicate('X',10) size 1,10
read
deactivate window cinfo
release window cinfo
return




*****  PREPARING  OUTPUT  *****

PROCEDURE  OKINEWPRINT
************************

do prnchoic
set century off
*page length
??? chr(27)+"C"+chr(0)+chr(14)
CPI10 = Chr(27) + 'P'
CPI12 = Chr(27) + 'M'
Store ' ' to Lines[6],  Lines[10], Lines[12], Lines[17], Lines[18], Lines[19]
Store ' ' to Lines[20], Lines[27], Lines[28], Lines[29], Lines[30], lines[41], Lines[52]
Store ' ' to L151, L152, L212
Store Space(79) to L46, Lines[26], Lines[46], Lines[47], Lines[59], Lines[60]
Store 0 to LNr

Lines[1]  = FxL(LstNm,19) + FxL(FstNm,11) + FxL(MdlNm,10) + LEFT(ALLTRIM(Strt),20);
          + SPACE(1)+ALLTRIM(Apt)
*Lines[3]  = FxL(City,18) + FxL(Cnty,15) + '  '+ FxL(State,5) + FxL(ZipCd,9);
*          + FxL(TcdHm,3) + FxL(TelHm,8) + FxL(TcdBs,3) + FxL(TelBs,8)
Lines[3]  = FxL(City,18) + FxL(Cnty,15) + '  '+ FxL(State,5) + FxL(ZipCd,8);
          + FxL(TcdHm,3) + FxL(TelHm,9) + FxL(TcdBs,3) + FxL(TelBs,8)
Lines[5]  = FxL(Occup,15) + FxL(EmpNm,28) + FxL(EmAdr,34)
Lines[7]  = Space(12) + FxL(OwnNm,27) + FxL(OwAdr,35) + ' X'
Lines[9]  = '      '+ Fxl(Year1,4) + Fxl(Mk1,12) + Fxl(Modl1,15)
Lines[11] = Fxl(VhId1,39)
L131      = '  ' + FxL(PMo1,2) + Fxl(PYr1,2)
L132      = ' '+ FxL(Cost1,8) + Fxl(Cyl1,6) + FxL(Hp1,11)
L133      = ' '+ FxL(PMo2,2) + Fxl(PYr2,2)
L134      = ' '+ FxL(Cost2,8) + Fxl(Cyl2,5) + FxL(Hp2,11)
NUsd1     = '   X'
NUsd2     = '   X'
If New1 = 'Y'
   NUsd1 = 'X   '
EndIf
If New2 = 'Y'
   NUsd2 = 'X   '
EndIf
Lines[13] = L131 + NUsd1 + L132
L141      = Space(21) + 'X' + Space(18)
L142      = Space(21) + 'X'
If AtDv1 = 'Y'
   L141 = Space(17) + 'X' + Space(22)
   L151 = '    '+ Fxl(DvMl1,11) +'  '+ Fxl(DvBd1,10)
   AP   = '          X'     
   If AcPs1 = 'A'
      AP = 'X          '
   EndIf
   L151 = L151 + AP
EndIf
If AtDv2 = 'Y'
   L142 = Space(16) +'X '
   L152 = '   '+ Fxl(DvMl2,11) +'   '+ Fxl(DvBd2,10)
   AP   = '          X'     
   If AcPs2 = 'A'
      AP = 'X          '
   EndIf
   L152 = L152 + AP
EndIf
Lines[14] = L141 
Lines[15] = L151
if lossp1=.t. or lossp2=.t.
  LINES[16]='      x'
endif
if less1=.t. or less2=.t.
   lines[17]='      x '
else
   lines[17]='        '
endif
IF LOSSP1=.T. OR LESS1=.T.
  lines[17] = lines[17] + FxL(Substr(LpNm1,1,24), 24);
            + FxL(Substr(Lstr1,1,20),20) + FxL(Substr(LCty1,1,13), 13);
            + FxL(Substr(LpSt1,1,3), 3) + FxL(Substr(LpZC1,1,6), 6)
  Lines[18] = '   X    ' + FxL(Substr(LpNm1,25,24), 24);
            + FxL(Substr(LStr1,21,20),20) + FxL(Substr(LCty1,14,13), 13);
            + FxL(Substr(LpSt1,4,3), 3) + FxL(Substr(LpZC1,7,6), 6)
ENDIF
Do Case
  Case UsFr1 = 'P'
    Lines[21] = Space(12) + 'X' + Space(27)
  Case UsFr1 = 'W'
    Lines[21] = Space(20) + 'X' + Space(19)
  Case UsFr1 = 'B'
    Lines[21] = Space(26) + 'X' + Space(13)
  Case UsFr1 = 'F'
    Lines[21] = Space(33) + 'X' + Space(6)
EndCase

Lines[24] = FxL(GAdr1,31) + Fxl(Milt1,7)
Lines[26] = '  ' + FxL(StR1,10) + FxL(RAdr1,27)
Lines[27] = FxL(Tery1,9) + FxL(RtCs1,7) + FxL(PlPt1,7) + FxL(Symb1,13)
If NoPol = 'Y'
  Lines[28] = '  X'
EndIf


if BodIn1>0
   Lines[29] = Space(48) + FxL(BBodIn1,7) + Str(BodIn1,6)+'   '
else
   Lines[29] = Space(48) +SPACE(17)
endif
if PrpDm1>0
   Lines[30] = Space(48) + FxL(BPrpDm1,7) + Str(PrpDm1,6)+'   '
else
   Lines[30] = Space(48) +SPACE(17)
endif
*Lines[31] = Space(48) + FxL(BBaPIP1,7) + Str(BaPIP1,6)+'   '
if BaPIP1>0
   Lines[31] = Space(56) + Str(BaPIP1,6)+'   '
else
   Lines[31] = Space(56) +SPACE(17)
endif
Lines[32] = Space(19) + 'X'
If (Alltrim(BBaPIP1)='$ 0 DEDUCTIBLE') or (len(Alltrim(BBaPIP1))=0)
  Lines[32] = space(8)+'X'
EndIf
if OBELC1>0
   Lines[33] = Space(48) + FxL(BOBELC1,7) + Str(OBELC1,6)+'   '
else
   Lines[33] = Space(48) + space(17)
endif
if ADPIP1>0
   L35 = '   X '
     LINES[35] = L35 + Space(43) + FxL(BADPIP1,7) + Str(ADPIP1,6)+'   '
  else
     If FADPIP1 > 0
        l35=space(22)+'X'
       Lines[35] = l35+Space(25) + FxL(BFADPIP1,7) + Str(FADPIP1,6)+'   '
     Else
       Lines[35] = Space(48)+SPACE(17)
     EndIf
  endif

if MedPa1>0
   Lines[36] = Space(48) + FxL(BMedPa1,7) + Str(MedPa1,6)+'   '
else
   Lines[36] = Space(48)+SPACE(17)
endif
if StUnM1>0
   Lines[37] = Space(48) + FxL(BStUnM1,7) + Str(StUnM1,6)+'   '
else
   Lines[37] = Space(48)+SPACE(17)
endif
if VoUnM1>0
   Lines[38] = Space(48) + FxL(BVoUnM1,7) + Str(VoUnM1,6)+'   '
else
   Lines[38] = Space(48)+SPACE(17)
endif
if Compr1>0
   Lines[39] = Space(48) + FxL(BCompr1,7) + Str(Compr1,6)+'   '
else
   Lines[39] = Space(48)+SPACE(17)
endif
if Coll1>0
   Lines[40] = Space(48) + FxL(BColl1,7)  + Str(Coll1,6)+'   '
else
   Lines[40] = Space(48)+SPACE(17)
endif
if EIP1>0
   Lines[41] = Space(48) + FxL(BEIP1,7)   + Str(EIP1,6)+'   '
else
   Lines[41] = Space(48)+SPACE(17)
endif

Lines[42] = Space(21) + space(35)+Str(Total1,6)
*Lines[43] = Space(21) + FxL(Company,28) +'        '+ Str(Total1,8)
*Lines[44] = Space(9)  + FxL(Limits,16) +'    '+ FxL(Policy,20);
*          + '    '    + FxL(ExpirDate,10)
*Lines[45] = Space(51)  + Str(EstTotPre,9,2) +'          ';
*          + Str(estdepre,7,2)
*Lines[44] = Space(9)  + FxL(Limits,14) +'   '+ FxL(Policy,13);
*          + ' ' + FxL(ExpirDate,10)
Lines[44] = Space(9)
LINES[45]=SPACE(10)

If ((Upper(mfs75) = 'Y') or (Upper(mfs752) = 'Y'))
  fs=alltrim(mfs75id)
  temp=fs
  if (Upper(mfs752) = 'Y')
     fs=temp+','+mfs752id
  endif
  Lines[46] = Stuff(L46,36,1,'X')
  l46=lines[46]
  Lines[46] = Stuff(l46,58,len(fs),fs)
else
    Lines[46] = Stuff(L46,38,1,'X')
EndIf

l46=left(lines[46],79)
lines[46]=l46

If IRR1 = 'I'
  Lines[47] = Stuff(Lines[47],24,1,'X')
Else
  Lines[47] = Stuff(Lines[47],46,1,'X')
EndIf
IF VEHICLES>1
   If IRR2 = 'I'
     Lines[47] = Stuff(Lines[47],29,1,'X')
   Else
       Lines[47] = Stuff(Lines[47],52,1,'X')
   EndIf
ENDIF
If PoI1 = 'Y'
  Lines[47] = Stuff(Lines[47],68,1,'X')
EndIf
IF VEHICLES>1
  If PoI2 = 'Y'
    Lines[47] = Stuff(Lines[47],73,1,'X')
  EndIf
ENDIF


lines[48]=space(76)
Lines[48] = stuff(lines[48],28,len(Alltrim(Str(TOTPRE))),Alltrim(Str(TOTPre)))
if option1
   Lines[48] = stuff(lines[48],47,len(Alltrim(Str(down1))),Alltrim(Str(down1)))
else
   Lines[48] = stuff(lines[48],47,len(Alltrim(Str(down2))),Alltrim(Str(down2)))
endif

lines[49]=space(76)
if option1
   lines[49]=stuff(lines[49],7,1,'X')
endif
if financed=.f.
   lines[49]=stuff(lines[49],29,1,'X')
else
   lines[49]=stuff(lines[49],24,1,'X')
   lines[49]=stuff(lines[49],61,len(fincompany),fincompany)
endif


Lines[51] = Space(50) + 'x'
If Credit
  Lines[51] = Space(48) + 'x'
EndIf

If Vh1 = '2'
   Lines[6]  = Space(77) + 'X'
   Lines[9]  = Lines[9] + '      '+ Fxl(Year2,4) + Fxl(Mk2,12) + Fxl(Modl2,12)
   Lines[11] = Lines[11] + FxL(VhId2,39)
   Lines[13] = Lines[13] + L133 + NUsd2 + L134
   Lines[14] = Lines[14] + L142
   Lines[15] = Lines[15] + L152
   IF LOSSP2=.T. OR LESS2=.T.
   IF LESS2=.T.
     Lines[19] = '       ' + FxL(Substr(LpNm2,1,24), 24) + FxL(Substr(Lstr2,1,20),20);
               + FxL(Substr(LCty2,1,13), 13) + FxL(Substr(LpSt2,1,3), 3);
               + FxL(Substr(LpZC2,1,6), 6)
   ENDIF
     Lines[20] = '   X    '+ FxL(Substr(LpNm2,25,24), 24);
               + FxL(Substr(Lstr2,21,20),20) + FxL(Substr(LCty2,14,13), 13);
               + FxL(Substr(LpSt2,4,3), 3) + FxL(Substr(LpZC2,7,6), 6)
   ENDIF
   Do Case
     Case UsFr2 = 'P'
       L212 = Space(12) + 'X' + Space(27)
     Case UsFr2 = 'W'
       L212 = Space(20) + 'X' + Space(19)
     Case UsFr2 = 'B'
       L212 = Space(26) + 'X' + Space(13)
     Case UsFr2 = 'F'
       L212 = Space(33) + 'X' + Space(6)
   EndCase
   Lines[21] = Lines[21] + L212
   Lines[24] = Lines[24] + Fxl(GAdr2,31) + Fxl(Milt2,7)
   Lines[26] = Lines[26] + ' ' + Fxl(StR2,10) + Fxl(RAdr2,26)
   Lines[27] = Lines[27] + FxL(Tery2,9) + FxL(RtCs2,7) + FxL(PlPt2,7);
             + FxL(Symb1,12)
   if BodIn2>0
     Lines[29] = Lines[29] + Space(8) + Str(BodIn2,6)
   endif
   if PrpDm2>0
     Lines[30] = Lines[30] + Space(8) + Str(PrpDm2,6)
   endif
   if BaPIP2>0
     Lines[31] = Lines[31] + Space(8) + Str(BaPIP2,6)
   endif
   if OBELC2>0
     Lines[33] = Lines[33] + FxL(BOBELC2,7) + Str(OBELC2,6)
   endif
   if ADPIP2>0
     Lines[35] = Lines[35] + FxL(BADPIP2,7) + Str(ADPIP2,6)
   else
      if FADPIP2>0
        Lines[35] = Lines[35] + FxL(BFADPIP2,7) + Str(FADPIP2,6)
      endif
   endif
   if MedPa2>0
        Lines[36] = LINES[36] + FxL(BMedPa2,7) + Str(MedPa2,6)
   endif
   if StUnM2>0
     Lines[37] = Lines[37] + SPACE(8) + Str(StUnM2,6)
   endif
   if VoUnM2>0
     Lines[38] = Lines[38] + SPACE(8) + Str(VoUnM2,6)
   endif
   if Compr2>0
     Lines[39] = Lines[39] + FxL(BCompr2,7) + Str(Compr2,6)
   endif
   if Coll2>0
     Lines[40] = Lines[40] + FxL(BColl2,7)  + Str(Coll2,6)
   endif
   if EIP2>0
     Lines[41] = Lines[41] + FxL(BEIP2,7)   + Str(EIP2,5)
   endif
   if Total2>0
     Lines[42] = Lines[42] + Space(8) + Str(Total2,9)
   endif
EndIf

****  Printer Control Chartacters
Lines[2]  = Chr(27) + '3' + Chr(29)
Lines[4]  = Chr(27) + '3' + Chr(32)
Lines[6]  = Lines[6]+ Chr(27) + '3' + Chr(29)
Lines[8]  = Chr(27) + '3' + Chr(30)
Lines[15] = LINES[15] + Chr(27) + '3' + Chr(20)
Lines[16] = LINES[16] + Chr(27) + '3' + Chr(20)
Lines[17] = Lines[17] + Chr(27) + '3' + Chr(45)
Lines[18] = Lines[18] + Chr(27) + '3' + Chr(34)
Lines[19] = Lines[19] + Chr(27) + '3' + Chr(28)
Lines[20] = Lines[20] + Chr(27) + '3' + Chr(34)
Lines[22] = Chr(27) + '3' + Chr(28)
Lines[23] = Chr(27) + '3' + Chr(22)
Lines[24] = Lines[24] + Chr(27) + '3' + Chr(30)
Lines[25] = Chr(27) + '3' + Chr(31)
Lines[26] = Lines[26] + Chr(27) + '3' + Chr(50)
Lines[27] = Lines[27] + Chr(27) + '3' + Chr(82)
Lines[28] = Lines[28] + Chr(27) + '3' + Chr(23)
Lines[29] = Lines[29] + Chr(27) + '3' + Chr(30)

Lines[31] = Lines[31] + Chr(27) + '3' + Chr(35)
Lines[32] = Lines[32] + Chr(27) + '3' + Chr(25)
Lines[33] = Lines[33] + Chr(27) + '3' + Chr(30)

Lines[34] = Chr(27) + '3' + Chr(33)
Lines[35] = Lines[35] + Chr(27) + '3' + Chr(30)
Lines[42] = Lines[42] + Chr(27) + '3' + Chr(40)
Lines[43] = left(Lines[43],79) + Chr(27) + '3' + Chr(43)
Lines[44] = Lines[44] + Chr(27) + '3' + Chr(20)
Lines[45] = Lines[45] + Chr(27) + '3' + Chr(35)
*Lines[45] = Lines[45] + Chr(27) + '3' + Chr(50)
*Lines[45] = Lines[45] + Chr(27) + '3' + Chr(40)

Lines[46] = left(Lines[46],79) + Chr(27) + '3' + Chr(30)
Lines[47] = Lines[47] + Chr(27) + '3' + Chr(44)

Lines[48] = Lines[48] + Chr(27) + '3' + Chr(34)
Lines[49] = Lines[49] + Chr(27) + '3' + Chr(30)
Lines[50] = Lines[50] + Chr(27) + '3' + Chr(35)
Lines[51] = Lines[51] + Chr(27) + '3' + Chr(30)
Lines[52] = Lines[52] + Chr(27) + '3' + Chr(32)

Lines[53] = Lines[53] + Chr(27) + '3' + Chr(78)
Lines[54] = Chr(27) + '3' + Chr(30)


Set Printer On
wait window "Now Printing, Please Wait" nowait
set console off
*For i=1 to LNr
*  ? ' '
*EndFor

??? CPI10
*? " "
*? "  "+chr(27)+'3'+CHR(34)
*? " "
? " "
? " "
? " "
? " "
? " "
*? " "
*? " "
? " "+CHR(27)+'J'+CHR(30)
? chr(27)+'3'+CHR(35)
For i=1 to 41
  ? Lines[i]
EndFor 

? '            '
*? '            '

For i=42 to 53
  ? Lines[i]
EndFor 

elm=1
??? cpi12
if durt3[elm]="Y"
  TxtLn = space(29) + FxL1(Alltrim(Us1[Elm]),3) + fxl1(Alltrim(Us2[Elm]),3) + ;
        ' '+ dtoc(BDt[Elm]) + ' ' + Sex[Elm] +'  '+ ;
        MSts[Elm] + '  '+ FxL(LcNr[Elm],27) + Stt[Elm] + ;
        ' '+Fxl(Durt3[Elm],2)+chr(27)+'3'+chr(30)
 else
  TxtLn = space(29) +  FxL1(Alltrim(Us1[Elm]),3) + fxl1(Alltrim(Us2[Elm]),3) + ;
        ' '+ dtoc(BDt[Elm]) + ' ' + Sex[Elm] +'  '+ ;
        MSts[Elm] + '  '+ FxL(LcNr[Elm],27) + Stt[Elm] + ;
        ' '+ DurtM[Elm]+chr(27)+'3'+chr(30)
 endif
  ? TxtLn
For Elm = 2 to 4
if len(alltrim(drvr[elm])) >3
if durt3[elm]="Y"
  TxtLn = '   '+FxL(Drvr[Elm],17) + FxL(Relt[Elm],7) ;
        + FxL1(Alltrim(Us1[Elm]),3) + fxl1(Alltrim(Us2[Elm]),3) + ' '+dtoc(BDt[Elm]);
        + ' ' + Sex[Elm] +'  '+ MSts[Elm] + '  '+FxL(LcNr[Elm],27);
        + Stt[Elm] + ' '+Fxl(Durt3[Elm],2)+chr(27)+'3'+chr(30)
else
  TxtLn = '   '+FxL(Drvr[Elm],17) + FxL(Relt[Elm],7) ;
        + FxL1(Alltrim(Us1[Elm]),3) + fxl1(Alltrim(Us2[Elm]),3) + ' '+ dtoc(BDt[Elm]);
        + ' ' + Sex[Elm] +'  '+ MSts[Elm] + '  '+FxL(LcNr[Elm],27);
        + Stt[Elm] + ' '+DurtM[Elm]+chr(27)+'3'+chr(30)
endif
else
    txtln=space(20)
endif
  ? TxtLn
EndFor

Lines[59] = Stuff(Lines[59],35,33,Left (Alltrim(FrAdr),33))
Lines[60] = Stuff(Lines[60],17,14,Left(Alltrim(MTML),14))
Lines[60] = Stuff(Lines[60],70,9,Left(Alltrim(CMR),9))
? Chr(27) + '3' + Chr(7)
? Lines[59] + Chr(27) + '3' + Chr(23)
? Chr(27) + '3' + Chr(46)
? Lines[60]
? Chr(27) + '3' + Chr(30)
*??? CPI10
*??? chr(27)+'3'+CHR(50)
EJECT
??? CPI12
??? chr(27)+"C"+chr(0)+chr(11)
Set Printer Off
set console on
wait clear
*=Inkey(10)
set printer to lpt1:
set century on
Return




********************************************************************************
*                 CALCULATE TOTAL
********************************************************************************
FUNCTION CALC1_TOT
TOTAL1=BodIn1+PrpDm1+BaPIP1+Obelc1+AdPIP1+FADPIP1+MedPa1+StUnM1+VoUnM1+COMPR1+COLL1+EIP1+1
@15,55 get TOTAL1 picture '99999.9' disabled color ,,,,,,,,r+/b,r+/b
clear gets
do get22
RETURN .T.

********************************************************************************
*                 CALCULATE TOTAL
********************************************************************************
FUNCTION CALC2_TOT
TOTAL2=BodIn2+PrpDm2+BaPIP2+Obelc2+AdPIP2+FADPIP2+MedPa2+StUnM2+VoUnM2+COMPR2+COLL2+EIP2
@15,72 get TOTAL2 picture '99999.9' disabled color ,,,,,,,,r+/b,r+/b
do get22
clear gets
RETURN .T.
