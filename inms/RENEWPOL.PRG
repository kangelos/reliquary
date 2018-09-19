set procedure to "various"
   hide popup pactions
on key label f10 keyboard "{ctrl+w}"

set talk window
mdfrom={  /  /    }
mdto={  /  /    }
mpno=space(30)
do renew_pol
select coverage
select policy
unlock in policy
wait clear

if !used('installm')
   select 11
   use installm index install alias installment
else
   select installment
endif

set filter to
set filter to acctno=client->acctno

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
    select policy
    set relation to iidno into icompany

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif


         if !used('driver')
            select f
            use driver index driver alias driver
         else
             select driver
         endif
         set filter to dpid=policy->dpid
*         select policy
*         set relation to dpid into driver


         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         set filter to dpid=policy->dpid
*        select vehicle
         set relation to DVEHID into vehicle
return


******************************************************************************
*                    Function renew
******************************************************************************
procedure renew_pol
private getin,plocked

IF POLICY.RENEWED=.T.
   ?? CHR(7)
   WAIT WINDOW "This policy has already been renewed" timeout 1
   return
endif
if policy.dcanceled=.t.
   ?? chr(7)
   wait Window "Cannot RENEW a CANCELED policy" nowait
   return
endif
if policy.dtotcom<>policy.dtotcomrec
   ?? chr(7)
   wait window "You still have unpaid commissions from this policy" nowait
   tf =acertain("Really Renew ?",.f.)
   IF TF=.F.
      return
   ENDIF
endif
name=fname("temp3.dbf")
if file( name )
   ?? chr(7)
   wait window "Somebody else is doing this right now" nowait
   return
endif

getin=.f.
PLOcked=.f.
select policy
if lock(alltrim(str(recno())),'policy')=.f.
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   return plocked
else
  plocked=.t.
endif

?? chr(7)
wait window "If you proceed, A new policy will be created"
tf=acertain("Do you really wish to continue ?",.f.)
if tf=.f.
   unlock in policy
   return
endif
         if !used('driver')
            select f
            use driver index driver alias driver
         else
             select driver
         endif
         set filter to dpid=policy->dpid

select policy
oldrec=recno()

      set color to gr+/n
      @ 24,0 say space(80)
      =center(24,"Press F10 to Accept new Dates")
      set color to
lastk=27
set color to ,w+/bg
do while lastk=27
  mdfrom=ctod(policy->to)
  mdto=ctod(policy->to)+365
  mpNo=policy->policyno
  ?? chr(7)
	wait window "The Policy has been Renewed"+chr(13)+"Please Verify the new Policy's Information" nowait
  @ 4,0  get mpno picture replicate ('X',30) size 1,27
  @ 4,29 get mdfrom picture '@d'
  @ 4,40 get mdto picture '@d'
*  @ 4,51 get mnumber picture '9999'
*  read
read CYCLE
    mfrom=dtoc(mdfrom)
    mto=dtoc(mdto)
    lastk=lastkey()
enddo

wait window "Processing, Please wait" nowait
*tf=acertain("Really Renew ?",.f.)
*if tf=.f.
*   return plocked
*endif
wait Window "Wait a second" nowait
oMPOLICYNO  =  mpno
oMACCTNO    =  ACCTNO
oMDPID      =  DPID
oMiidno   =  iidno
oMFROM      =  FROM
oMTO        =  TO
oMDOPTION1  =  DOPTION1
oMDOPTION2  =  DOPTION2
oMDFINANCED =  DFINANCED
oMDFINCOMPAN=  DFINCOMPAN
oMDPREMIUM  =  DPREMIUM
oMDINSTALL  =  DINSTALL
oMDDOWN1    =  DDOWN1
oMDDOWN2    =  DDOWN2
oMDTOTPRE   =  DTOTPRE
oMDCANCELED =  DCANCELED
oMDCOMRATE  =  DCOMRATE
oMDTOTCOM   =  DTOTCOM
*oMDTOTCOMREC=  DTOTCOMREC
oMDTOTCOMREC=  0
oMEFFDATE   =  EFFDATE
oMDINST1    =  DINST1
oMDINST2    =  DINST2
oMDINST3    =  DINST3
oMDINST4    =  DINST4
oMDDATE1    =  DDATE1
oMDDATE2    =  DDATE2
oMDDATE3    =  DDATE3
oMDDATE4    =  DDATE4
*skip
rec=recno()

do post_polhistory
go (rec)
select policy
append blank
newpid=getpolno()
replace POLICYNO     with oMPOLICYNO,;
 ACCTNO       with oMACCTNO,;
 DPID         with newpid,;
 iidno        with oMiidno,;
 FROM         with dtoc(mdfrom),;
 TO           with dtoc(mdto),;
 DOPTION1     with oMDOPTION1,;
 DOPTION2     with oMDOPTION2,;
 DFINANCED    with oMDFINANCED,;
 DFINCOMPAN   with oMDFINCOMPAN,;
 DPREMIUM     with oMDPREMIUM,;
 DINSTALL     with oMDINSTALL,;
 DDOWN1       with oMDDOWN1,;
 DDOWN2       with oMDDOWN2,;
 DTOTPRE      with oMDTOTPRE,;
 DCANCELED    with oMDCANCELED,;
 DCOMRATE     with oMDCOMRATE,;
 DTOTCOM      with oMDTOTCOM,;
 DTOTCOMREC   with oMDTOTCOMREC,;
 EFFDATE      with mdfrom,;
 DINST1       with oMDINST1,;
 DINST2       with oMDINST2,;
 DINST3       with oMDINST3,;
 DINST4       with oMDINST4,;
 DDATE1       with oMDDATE1,;
 DDATE2       with oMDDATE2,;
 DDATE3       with oMDDATE3,;
 DDATE4       with oMDDATE4
newrec=recno()
*now copy over all the coverages


     select driver
     SET FILTER TO DPID=OMDPID
   name2=fname("temp4.dbf")
   if file( name )
      ?? chr(7)
      wait window "Somebody else is doing this right now" nowait
      return
   endif
   select * FROM DRIVER F  INTO DBF &NAME2 WHERE F.DPID=OMDPID
   GO TOP
   REPLACE DPID WITH NEWPID FOR .T.
   USE
   SELECT DRIVER
     name2=fname("temp4.dbf")
     append from &name2
     name=fname("temp4.dbf")
     delete file &name2

     select coverage
     set filter to dpid=omdpid
     name=fname("temp3.dbf")
     select * from coverage a into dbf &name where a.dpid=omdpid
     go top
     replace dpid with newpid for .t.
     go top
     replace dfrom with mdfrom for .t.
     go top
     replace dto with   mdto   for .t.
****** get the effective date
     meffdate=dtoc(mdfrom)
     go top
     replace effdate with ctod(meffdate) for .t.

       go top
       SUM temp3.DTOTAL TO newpremium
     use
     select coverage   && set up the old coverages do be blocked
     go top
     replace drenewed with .t. for dpid=omdpid
     go top
     replace dactive with .f. for dpid=omdpid

     set filter to
     name=fname("temp3.dbf")
     append from &name
     name=fname("temp3.dbf")
     delete file &name
****** get the new prices
select policy
go (newrec)
totcom=newpremium*(policy->dcomrate/100)  && change this for inscompany
replace DPREMIUM     with newpremium,;
        DTOTCOM      with totcom,;
        DTOTCOMREC   with 0

go (oldrec)
REPLACE POLICY.RENEWED WITH .T.

        getin=.t.
       if policy.dcanceled=.t.
          replace policy.dcanceled with .f.
       endif

         MINVOICENO=0
         MACCTNO   =client->ACCTNO
         MTRANCODE =9909
         MQTY      =1
         MPRICE    =0
         MTOTAL    =0
         MDATE     =DATE()
         MCLERK    =''
         MDESCRIPT ="Policy Renewed"
         MPOSTED   =.f.
         MBILLED   =.f.
         MCHECKNO  =''
         DVID      =VEHICLE.VIN
         percent   =dcomrate
                      polno=policy.policyno
                      cchange=.t.
                      ccom=newpremium
                     =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                                 MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                                 policy.effdate,polno,cchange,ccom)
select policy
GO (NEWREC)
* magic here
cont=.t.
cont=acertain("Adjust The Premiums ?",.t.)
if cont=.t.
   do premadjust
endif
do while cont=.t.
   cont=acertain("Adjust More Premiums ?",.t.)
   if cont
      do premadjust
   endif
enddo
SELECT POLICY
GO (NEWREC)
do firstinstallment with newpid,omacctno,policy->dpremium,omdoption1,omdoption2,MFROM
SELECT POLICY
GO (NEWREC)

totcom=(dpremium*dcomrate)/100
replace dtotcom with totcom

unlock in policy
go (NEWrec)
*DO POLDISPLAY
presult=10
*endif
return



***************************************************************************
*                     post activity
***************************************************************************
function post_act
PARAMETER INVOICE,dACCTNO,TRANCD,QTY,PRICE,TOTAL,DATE,CLERK,DECRIPTION,POSTED,;
          BILLED,CHECKNO,VVID,efdate,polno,cchange,ccom



  if !used('activity')
     SELECT 24
     USE ACTIVITY index activity,DATE ALIAS ACTIVITY
  ELSE
     SELECT ACTIVITY
  ENDIF
  set order to tag acctno

APPEND BLANK
       REPLACE  DINVOICENO  WITH       INVOICE,;
                ACCTNO      WITH       dACCTNO,;
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



******************************************************************************
*                    Function adjust premiums
******************************************************************************
Function premadjust
private tf,arecveh,rec
tf=.f.

         hide popup pactions

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif

         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         set filter to dpid=policy->dpid
*        select vehicle
         set relation to DVEHID into vehicle

*set filter to (dpid=newpid)
select policy
REC=RECNO()
PLOcked=.f.
if lock(alltrim(str(recno())),'policy')=.f.
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   return plocked
else
  plocked=.t.
endif

pid=0
option1=.f.
option2=.f.
financed=.f.
fincompany=space(30)
premium=0
installment=0
totpre=0
down1=0
down2=0
MPOLICYNO=SPACE(30)
mtml=space(20)
mpolicyno   = policyno
macctno     = ACCTNO
MTO         = to
MFROM       = FROM
macctno     = ACCTNO
PID         = DPID
mnumber     = iidno
OPTION1     = DOPTION1
OPTION2     = DOPTION2
FINANCED    = DFINANCED
FINCOMPANY  = DFINCOMPANY
TOTPRE      = DTOTPRE
PREMIUM     = DPREMIUM
INSTALLMENT = DINSTALL
DOWN1       = DDOWN1
DOWN2       = DDOWN2
percent     = dcomrate
totcom      = dtotcom
meffdate    = effdate
totcomrec   = dtotcomrec
MTML        = TML
mfs75=fs75
mfs752=fs752

rec1=recno()

save screen to polsc
set color to gr+/b
=center(24,"Please select the Vehicle whose Premiums you want to Adjust")
set color to w+/b

define window browsewin at 5,13 size 10,50 system float shadow grow in desktop;
	title "Select a Coverage" font "Arial",11 color scheme 10
	
on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"
select coverage

count to totalcovs for ((coverage.dpid=policy.dpid) and (iidno=policy.iidno) )
if totalcovs = 0
   ?? chr(7)
   wait window "No Premiums Found" timeout 1
   return
endif
browse fields vehicle->vin:h    = "Vehicle ID #":R,;
              vehicle->year:h   = "Year"   :r,;
              vehicle->make:h   = "Make"   :r,;
              coverage->dtotal:h="Premium":R;
             for ((coverage.dpid=policy->dpid) and (iidno=policy.iidno) );
             nomodify width 15 nomenu window browsewin;
             title "Coverage Selection List";
             color scheme 10
COVrec=recno('coverage')
on key label f10
on key label enter
if lastkey()=27
   RELEASE WINDOWS
   unlock in policy
*   go (rec)
*   DO POLDISPLAY
   presult=10
   return
endif
*hide menu polmenu
edited=ncovmenu(COVrec)

select policy
mpolicyno   = policyno
macctno     = ACCTNO
MTO         = to
MFROM       = FROM
macctno     = ACCTNO
PID         = DPID
mnumber     = iidno
OPTION1     = DOPTION1
OPTION2     = DOPTION2
FINANCED    = DFINANCED
FINCOMPANY  = DFINCOMPANY
TOTPRE      = DTOTPRE
PREMIUM     = DPREMIUM
INSTALLMENT = DINSTALL
DOWN1       = DDOWN1
DOWN2       = DDOWN2
percent     = dcomrate
totcom      = dtotcom
meffdate    = effdate
MTML        = TML
mfs75=fs75
mfs752=fs752

restore screen from polsc
if edited=.F.
   unlock in policy
   go (rec)
*   DO POLDISPLAY	
   presult=10
   RETURN
endif

set color to gr+/b
@7,2 say 'Vehicle ID           Year Make                 Model and Style        Premium'
set color to w+/b

*wait window "Looking For Vehicles" nowait
newmoney=0
howmany=0
select coverage
  go top
      K=0
      row=8
      do while ((!EOF('coverage')) and (k<9))
       amount=coverage->dtotal
       newmoney=newmoney+amount
       howmany=howmany+1
       if ((amount >0)  and (coverage.dpid=pid))
          @row+K,2 say vehicle->vin+' '+vehicle->year+' '+vehicle->make+' '+left(vehicle->modst,20)+str(amount)
          K=K+1
*          covselected[k]=recno('COVERAGE')
        endif
        skip
      enddo
wait clear
* get the new financial data
select policy

* JUST SHOW THE NEW VALUES
*DO DISPFIN

     premium=newmoney
     policecharge=howmany
*     premium=premium+policecharge
     oldpre=premium-24


on key label f10
SELECT COVERAGE
set filter to (dpid=policy->dpid OR DPID=0)
select policy
unlock in policy
go (rec)
return

