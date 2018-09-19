parameter macctno
getout=0
temppay=0
tempdown=0
oldrec=0
SET DELETED Off
*set talk off
set safety off
set century on
policecharge=1
surcharge=0
*if menu()="MAINMENU"
*   hide menu MAINmenu
*endif
push menu _msysmenu
NOINSTS=0
DOWNPERCENT=0.0
REMAININGPERCENT=0.0
serviceCHARGE=0
UP=5
DOWN=24
NEXT=3
PREVIOUS=18
SELECTkey=13
DESELECT=13
ENDkey=23
QUITkey=27
gooddata=.t.
mname=space(30)
cancelvin=space(30)
cancelpid=0
meffdate={  /  /  }
set procedure to 'various'
set exclusive off
presult=1
mpolicyno=space(30)
mfs75=space(20)
mfs752=space(20)
mtml=space(20)
declare covselected[100],OLDSELECTED[100]  && number of selected vehicles
for i=1 to 100
    covselected[I]=0        && recno of selected vehs
    OLDSELECTED[I]=0
endfor
 mfrom='  /  /    '
 mto='  /  /    '
 mnumber =space(20)
 pid=0
 mdto={  /  /  }
 mdfrom={  /  /  }
option1=.f.
option2=.f.
financed=.f.
fincompany=space(30)
premium=0
installment=0
totpre=0
down1=0
down2=0
totcom=0
comrate=0
totcomrec=0
totcom=0
comchange=0
oldamount=0
percent=0

has=.f.
has=initpolsystem()
on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"
if has=.f.
     ?? CHR(7)
     wait window 'No Policy Found For this Customer' timeout 1
     ?? chr(7)
     wait window 'Press any key to ADD one'
   added=addpol()
   clear
   if added
      =initpolsystem()
      do spawninstalls
   else
      set printer to lpt1:
      return
   endif
endif
select policy
*go top
oldord=order()
set order to tag lastdate
do pickpolicy

*
* A selection was made
*
if oldrec<>0 then
   set order to tag &oldord
   set color to w/b
   clear
   select policy 
   go oldrec
   do poldisplay
   do poloptions
endif

select vehicle
set filter to
select coverage
set filter to
set relation to
select policy
set filter to
set relation to
on key label f10
on key label enter
set cursor on
set printer to lpt1:
pop menu _msysmenu
return


******************************************************************************
*                    Procedure policy system Initialization
******************************************************************************
function initpolsystem
tf=.t.

set color to gr+/b,N/W
clear
set color to w+/bg,w+/bg

*for i=24 to 0 step -1
*   @ i,0 say  replicate (chr(177),80)
*endfor



       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag acctno

       if !used('client')
          select a
          use client index client alias client
       else
           select client
       endif
       SET ORDER TO TAG ACCTNO
       set relation to acctno into invoice
       SEEK mACCTno


if !used('installm')
   select 11
   use installm index install alias installment
else
   select installment
endif

if !used('policy')
   select e
   use policy index policy alias policy
else
   select policy
endif
set filter to acctno=client->acctno

go top
LOCATE FOR policy.ACCTNO=int(macctno)
*seek macctno
*seek pid
IF FOUND()
   set filter to acctno=client->acctno
*   go top
   go bottom
   tf=.t.
ELSE
    tf=.f.
endif

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno
         
    select policy
    set order to tag iidno
    set relation to iidno into icompany


         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set order to tag dvehid
		
         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         set filter to (dpid=policy->dpid OR DPID=0)
*        select vehicle
         set relation to dvehid into vehicle
         set relation to iidno into icompany additive

*     define window browser from 6,0 to 22,79 none float shadow grow


*     define window browser from 6,2 to 16,77 none float shadow grow ; 
*     	Title "Press [enter] to Select a policy"

select policy     

return tf


procedure pickpolicy


*
* Select a policy
*
select policy

count to actives for policy->acctno=macctno .and.;
                policy->dcanceled=.f. .and. policy->renewed=.f.

if actives<=0
	?? chr(7)
	Wait window "No Active Policies Found" timeout 1              
else

on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"
  set color to gr+/r
  @ 0,0 say space(80)

  =center( 0,"Press <ENTER> to Select a Policy or <ESC> to see the Inactive Policies")
    wait window "Press <ENTER> to Select a Policy or <ESC> to see the Inactive Policies" nowait

  set color to w+/b,n/w

define window browser at 7,3 size 15,75 in desktop system float grow color scheme 10;
	title "Select from Active Policies" font "Arial",11

browse fields policy->from:w=.f.,policy->to:w=.f.,;
       POLICY->POLICYNO:25:H="Policy Number",;
       icompany->iname:25:h="Insurance Company";
       nomodify nomenu window browser;
       color scheme 10 title "Select from Active Policies";
       for policy->acctno=macctno .and. policy->dcanceled=.f. .and. policy->renewed=.f.;
                font "Arial",11
                
       release window browser
endif

oldrec=recno()
key=lastkey()
            if key=27
               oldrec=0
            else 
            	oldrec=recno()   
            endif

count to nonactives for (policy->acctno=macctno .and.;
                (policy->dcanceled=.t. .or. policy->renewed=.t.))
                
if ((actives<=0)  .or. (nonactives>0 .and. key=27) )
	?? chr(7) 
	wait window "Please choose an INACTIVE policy" Timeout 1
	
  	on key label f10 keyboard "{ctrl+w}"
	on key label enter keyboard "{ctrl+w}"

    set color to gr+/r
     @ 0,0 say space(80)

   =center(0,"Press <ENTER> to Select a Policy or <ESC> to Quit")
	Wait window "Press <ENTER> to Select a Policy or <ESC> to Quit" nowait

    define window browser at 7,3 size 15,70 in desktop system float grow color scheme 10;
    	title "Select from Active Policies" font "Arial",11

     browse fields policy->from:w=.f.,policy->to:w=.f.,;
            POLICY->POLICYNO:25:H="Policy Number",;
            icompany->iname:24:h="Insurance Company";
            nomodify nomenu window browser;
            color scheme 10 title "Select from Inactive Policies" ;
            for (policy->acctno=macctno .and.;
                (policy->dcanceled=.t. .or. policy->renewed=.t.));
                font "Arial",11
                
	release window browser

            key=lastkey()
            if key=27
               oldrec=0
            else 
            	oldrec=recno()   
            endif
endif           


on key label enter
on key label f10
RELEASE WINDOW BROWSER



return

******************************************************************************
*                    Procedure policy options
******************************************************************************
Procedure polOptions
*set color to w/w
*@ 1,0 to 1,79 clear
*  DEFINE MENU _msysmenu BAR AT LINE 1 COLOR SCHEME 4
  DEFINE MENU _msysmenu bar COLOR SCHEME 3
  DEFINE PAD First      OF _msysmenu  PROMPT '\<First '     
  DEFINE PAD Last       OF _msysmenu  PROMPT '\<Last'      
  DEFINE PAD Add        OF _msysmenu  PROMPT '\<Add '      
  DEFINE PAD Actions    OF _msysmenu  PROMPT 'A\<ctions'   
  DEFINE PAD Previous   OF _msysmenu  PROMPT '\<Previous'  
  DEFINE PAD Next       OF _msysmenu  PROMPT '\<Next'      
  DEFINE PAD Delete     OF _msysmenu  PROMPT '\<Delete'    
  DEFINE PAD Undelete   OF _msysmenu  PROMPT '\<UnDelete'  
  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit  '    


DEFINE POPUP memopop margin relative shadow color scheme 4

DEFINE BAR 1 OF memopop PROMPT  ' \<Edit '
DEFINE BAR 2 OF memopop PROMPT  '\<Import'
DEFINE BAR 3 OF memopop PROMPT  'E\<xport'
DEFINE BAR 4 OF memopop PROMPT  '\<Print '

ON SELECTION BAR 1 OF memopop do edtmemo
ON SELECTION BAR 2 of memopop do grabdata
ON SELECTION BAR 3 OF memopop do expdata
ON SELECTION BAR 4 OF memopop do prmemo


  on selection PAD First      OF _msysmenu  do firstpol
  on selection PAD Last       OF _msysmenu  do lastpol
  on selection PAD Add        OF _msysmenu  do addone
  on selection PAD Previous   OF _msysmenu  do prevpol
  on selection PAD Next       OF _msysmenu  do nextpol
  on pad Actions of _msysmenu activate popup pactions
  on selection PAD Delete     OF _msysmenu  do delpol
  on selection PAD Undelete   OF _msysmenu  do undelpol
  on selection PAD Quit       OF _msysmenu  do quitpol

DEFINE POPUP pactions margin relative shadow color scheme 4
*DEFINE BAR 1 OF pactions PROMPT "Drivers"

DEFINE POPUP invpop margin relative shadow color scheme 4

DEFINE BAR 1 OF invpop PROMPT  '\<Create Invoice'
DEFINE BAR 2 OF invpop PROMPT  '\<Update Invoice'

on selection bar 1 of invpop do INVOICE
on selection bar 2 of invpop do poedinv

if lock(alltrim(str(recno('client'))),'client')=.t.
   DEFINE BAR 1 OF pactions PROMPT  "\<A....Policy Installments"  skip for inactvplcy()
   DEFINE BAR 2 OF pactions PROMPT  "\<B....Adjust Ins. Premiums" skip for inactvplcy()
   DEFINE BAR 3 OF pactions PROMPT  "\<C....Edit Policy Informat." skip for inactvplcy()
   DEFINE BAR 4 OF pactions PROMPT  "\<D....Change Ins Company No" skip for inactvplcy()
   DEFINE BAR 5 OF pactions PROMPT  "\<E....Cancell / Reinstate" 
   DEFINE BAR 6 OF pactions PROMPT  "\<F....Renew Current Policy" 
   DEFINE BAR 7 OF pactions PROMPT  "\<G....Toggle Renewal Flag" 
   DEFINE BAR 8 OF pactions PROMPT  "\<H....Include New Vehicles" skip for inactvplcy()
   DEFINE BAR 9 OF pactions PROMPT  "\<I....Partial Policy Cancel" skip for inactvplcy()
 *  DEFINE BAR 10 OF pactions PROMPT "\<J....Report on this Policy" skip for inactvplcy()
   DEFINE BAR 11 OF pactions PROMPT "\<K....Commission Payments" 
   DEFINE BAR 12 OF pactions PROMPT "\<L....Documents' Processing" 
   DEFINE BAR 13 OF pactions PROMPT "\<M....Drivers' Processing" 
   DEFINE BAR 14 OF pactions PROMPT "\<N....Change of Policy Form" 
*   DEFINE BAR 14 OF pactions PROMPT "\<O...Installment Receipt" skip for inactvplcy()
   DEFINE BAR 15 OF pactions PROMPT "\<O....Assigned Risc Form" 
*   DEFINE BAR 15 OF pactions PROMPT "\<P...System Utilities" skip for inactvplcy()
   DEFINE BAR 16 OF pactions PROMPT "\<P....Free Form Data Menu" 
   DEFINE BAR 17 OF pactions PROMPT "\<Q....Invoice Processing" 
*   DEFINE BAR 17 OF pactions PROMPT "\R.TML #  " skip for inactvplcy()



   ON SELECTION BAR 1  OF pactions do spawninstalls
   ON SELECTION BAR 2  of Pactions do premadjust
   ON SELECTION BAR 3  OF pactions do preplpolno
   ON SELECTION BAR 4  OF pactions do replcono
   ON SELECTION BAR 5  of Pactions do can_pol
   ON SELECTION BAR 6  of Pactions do rpol
   ON SELECTION BAR 7  of Pactions do UNrenewpol
   ON SELECTION BAR 8  of Pactions do addnewvehs
   ON SELECTION BAR 9  of Pactions do parpolcancel
*   ON SELECTION BAR 10 of Pactions do polreport
   on selection bar 11 of Pactions do comisions &&with policy.pid,policy.acctno
   on selection bar 12 of Pactions do docs
   on selection bar 14 of Pactions do changpol
   on selection bar 13 of Pactions do drvpol
*   on selection bar 14 of Pactions do poinv
   on selection bar 15 of Pactions do poapp
*   on bar 16 of Pactions activate popup utils
   on BAR 16 of pactiOns activate popup memopop
   on bar 17 of Pactions activate popup invpop

*   on selection bar 16 of Pactions do idtml
else
    DEFINE BAR 1 OF pactions PROMPT  "No Actions Allowed"
    ON SELECTION BAR 1 OF pactions wait window "Client record used by other User !!!!" nowait
endif

*lastk=27
*do while lastk=27
do while getout=0
  ACTIVATE MENU _msysmenu
enddo  
*   lastk=lastkey()
*enddo
IF WEXIST('BROWSEWIN')
   RELEASE WINDOW BROWSEWIN
ENDIF
return

procedure prevpol
          select policy
          oldord=order()
          set order to tag lastdate
          skip -1
          disp=.t.
          if bof('policy')
             Wait window 'This is the FIRST policy' timeout 1
             go top
             disp=.f.
          endif
          if disp
             do poldisplay
          endif
          set order to tag &oldord
return

procedure nextpol
           select policy
          oldord=order()
          set order to tag lastdate
           skip
           disp=.t.
           if eof('policy')
              wait window 'This is the LAST policy' timeout 1
              go bottom
              disp=.f.
           endif
          if disp
             do poldisplay
          endif
          set order to tag &oldord
return

procedure drvpol
          select policy
           set filter to
               do drvmenu with dpid
           select policy
           set filter to acctno=client->acctno
           do poldisplay
return

procedure delpol
          do poldelete
          select policy
          do poldisplay
return

procedure undelpol
          do polundelete
          select policy
          do poldisplay
return

procedure firstpol
          select policy
          oldord=order()
          set order to tag lastdate
          go top
          do poldisplay
          set order to tag &oldord
return

procedure lastpol
          select policy
          oldord=order()
          set order to tag lastdate
          go bottom
          do poldisplay
          set order to tag &oldord
return

procedure addone
private rec
          select policy
          rec=recno()
                     tf=addpol()
          select policy
          set order to tag iidno
          set relation to iidno into icompany
          if tf
             do spawninstalls
             do poldisplay
          else
              go rec
              do poldisplay
          endif
return


procedure quitpol
*hide menu _msysmenu
*DEACTIVATE MENU _msysmenu
*RELEASE MENU _msysmenu
 getout=1
return






******************************************************************************
*                    Function addpolicy
******************************************************************************
Function Addpol
private tf
tf=.f.

*if menu()='_msysmenu'
*   hide menu _msysmenu
*endif

SELECT POLICY
SET RELATION TO

for i=1 to 100
    covselected[i]=0        && recno of selected vehs
endfor
mfs75=space(20)
mfs752=space(20)
 policecharge=1
 surcharge=0
 mfrom='  /  /    '
 mto='  /  /    '
 mnumber =space(20)
 pid=0
option1=.f.
option2=.t.
financed=.f.
fincompany=space(30)
premium=0
installment=0
totpre=0
down1=0
down2=0
totcom=0
totcomrec=0
percent=0
meffdate={  /  /  }
totcom=0
MTML=SPACE(20)
MPOLICYNO=SPACE(30)
set color to gr+/b,N/W
clear
set color to gr+/n,N/W
@ 0,0 say space(80)
=center(0,'ADDING new POLICY')
set color to w+/b,N/W
@23,15 say space(80)

on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"
ONCE=.T.
stillediting=.t.
do while stillediting=.t.
  set color to w+/b,n/w
  mdfrom=ctod(mfrom)
  mdto=ctod(mto)
ON KEY LABEL ENTER
set color to gr+/b
  @ 2,10 say '                       Policy Period'
  @ 3,10 say 'Policy No              From       To     Premium is Provided by'
set color to  
  @ 4,0  get mpolicyno picture replicate ('X',30) size 1,27 valid nosuchpol(mpolicyno)
  @ 4,29 get mdfrom picture '@d'
  @ 4,40 get mdto picture '@d'
  @ 4,51 get mnumber picture '99999999999999999999'
  read
  mfrom=dtoc(mdfrom)
  mto=dtoc(mdto)
    if lastkey()=27
       STILLEDITING=.F.
       EXIT
    endif
  if ( lastkey()=endkey and once=.f. )
     stillediting=.f.
     exit
  endif
  select icompany
  SET ORDER TO TAG iidno
  seek mnumber
  if !found()  	
     go top
     SELECT COVERAGE
     set color to gr+/b,w+/bg
     define window browser from 6,0 to 22,79 system float shadow font "Arial",11 ;
     	title "Choose a company" color scheme 10
     set color to gr+/r
     @ 24,0 say space(80)
     =center(24,"Press <F10> to Select Insurance Company")
     set color to w+/b,n/w
     go top
     on key label enter keyboard "{ctrl+w}"

     count to temp for icompany->itype="AUTO" .and.;
                alltrim(coverage->policyno)="" .and.;
                coverage->dactive=.f. .and. coverage->drenewed=.f. .and. ;
                coverage.dtotal>0 .and. coverage.acctno=client->acctno ;
                .and. deleted()=.f.
  if temp=0
     wait window "No Coverages Availlable" timeout 2
     on key label enter
     return .f.
  endif

     browse fields vehicle->vin:h="Avail. Vehicle",icompAny->iidno:h="ID Number",icompany->iname:h="Company Name" nomodify window browser;
            color scheme 8 title "Insurance Company Selector" ;
            for icompany->itype="AUTO" .and.;
                alltrim(coverage->policyno)="" .and.;
                coverage->dactive=.f. .and. coverage->drenewed=.f. .and. ;
                coverage.dtotal>0 .and. coverage.acctno=client->acctno ;
                .and. deleted()=.f. nomenu

     release window browser
     @ 24,0 say space(80)
set color to n/w
*@ 24,0 say space(80)
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
     on key label enter
  endif
     on key label enter
  set color to w+/b,n/w
  select policy
  set relation to
  *set filter to acctno=macctno
  go top
  locate for iidno=mnumber
*  if ( (found()) .and. alltrim(policy->iidno)<>'999')
*     ?? chr(7)
*     wait window 'Insurance company already Used in another policy' nowait
*     mname=space(20)
*     mnumber=space(20)
*  else
      mnumber=icompany->iidno
      mname=icompany->iname
      comrate=icompany->dcom
*  endif
  @ 4,51 get mnumber picture '99999999999999999999'
  clear gets
  set color to gr+/r
  @ 24,0 say space(80)
  =center(24,"Press <F10> to Accept Entry and Start Adding vehicles")
  set color to w+/b,n/w
* @ 5,51 say "Name:"
  @ 5,51 say LEFT(MNAME,30) color r+/b
*   wait window mname nowait
  ONCE=.F.
enddo
IF LASTKEY()=27
   TF=.F.
ELSE
   TF=.T.
ENDIF
if tf
      select coverage
      olfilter=filter()
      howmany=selectvehs(mnumber)
      policecharge=howmany
      if howmany>0

           totcom=0
           oldamount=0
           premium=gettotal()
*           PREMIUM=PREMIUM+POLICEcharge
           OLDPRE=PREMIUM
           percent=comrate

           DO DISPFIN
           do getfin

           on key label f10
           if lastkey()<>27
              wait window "Please Wait, Updating" nowait
              pid=getpolno()
              do copypolicies with mpolicyno,pid,mfrom,mto
              do firstinstallment with pid,macctno,premium,option1,option2,mfrom
              tf=.t.
            else
              tf=.f.
            endif
      else
          tf=.f.
      endif
endif
select policy
          set order to tag iidno
set relation to iidno into icompany
select coverage
if type('olflilter') <> 'U'
	set filter to &olfilter
endif
wait clear
return TF






******************************************************************************
*                    Procedure COPYPOLICIES
******************************************************************************
PROCEDURE COPYPOLICIES
parameter mpolicyno,pid,mfrom,mto
private i,j,k

select coverage
for i=1 to 100
    if covselected[i]<>0
       go covselected[i]
       do while lock(alltrim(str(recno())),'coverage')=.f.
          wait window 'Record '+alltrim(str(covselected[i]))+' in COVERAGES is locked' timeout 1
       enddo
       replace policyno with mpolicyno,;
               dpid with pid,;
               dactive with .T.,;
               dfrom with ctod(mfrom),;
               dto   with ctod(mto)
       UNLOCK IN COVERAGE
    endif
endfor

select policy
append blank
replace policyno with ALLTRIM(UPPER(mpolicyno)),;
        ACCTNO   WITH macctno,;
        to       WITH MTO,;
        FROM     WITH MFROM,;
        ACCTNO   WITH macctno,;
        DPID     WITH PID,;
        iidno  with alltrim(mnumber),;
        DOPTION1 WITH OPTION1,;
        DOPTION2 WITH OPTION2,;
        DFINANCED      WITH             FINANCED,;
        DFINCOMPANY    WITH             ALLTRIM(UPPER(FINCOMPANY)),;
        DTOTPRE        WITH             TOTPRE,;
        DPREMIUM   WITH            PREMIUM,;
        DINSTALL   WITH            INSTALLMENT,;
        DDOWN1     WITH            DOWN1,;
        DDOWN2     WITH            DOWN2,;
        dcomrate   with            comrate,;
        dtotcomrec with            totcomrec,;
        dtotcom    with            totcom,;
        tml        with            mtml,;
        FS752      WITH            alltrim(MFS752),;
        FS75       WITH            alltrim(MFS75),;
        DTYPE      WITH            'AUTO'

             MINVOICENO=0
             MACCTNO   =client->acctno
             MTRANCODE =8010
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MDESCRIPT ="Policy Added"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
*             DVID      =Coverage->VIN
             DVID      =Vehicle->VIN

             polno=policy.policyno
             cchange=.t.
             ccom=premium
             =ppost_act(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom,policy.dpid)
select policy
return


******************************************************************************
*                    Procedure select vehicles
******************************************************************************
function selectvehs
parameter mnumber
private howmany,i,j,k,totvehs,screens
declare temprecs[8]

on key label f10 keyboard "{ctrl+w}"
on key label enter
set color to gr+/b
@7,2 say 'Vehicle ID           Year Make                 Model and Style        Premium'
@8,0 to 8,79
set color to w+/b

@24,0 say space(80)
=center(24,'Use UP,DOWN,PGUP,PGDOWN to move, ENTER to De/Select, F10 to End')
for i=1 to 8
    temprecs[i]=0
endfor
  select coverage
  olfilter=filter()
  set filter to (iidno=mnumber and dpid=0 and acctno=client->acctno)
  count to totcovs

  if totcovs=0
     ?? chr(7)
     wait window "No Matching Premiums found" timeout 2
     if type('olfilter')<>'U'
     	set filter to &olfilter
     endif
     return 0
  endif

  go top
  screens=ceiling(totcovs/4)

  row=8
  i=0
  finished=.f.
  howmany=0
*wait window "Looking For Vehicles" nowait
  do while ( (finished=.f.) )
      @ row+1,0 to row+5,79 clear
      j=1
      do while ((j<=8) and (.not. eof('coverage')) )
       amount=coverage.dtotal
       if ((amount >0) and (coverage.dpid=0))
          @row+j,2 say vehicle->vin+' '+vehicle->year+' '+vehicle->make+' ';
                      +left(vehicle->modst,20)+str(amount)
          temprecs[j]=recno('coverage')
*          if coverage.dpid=policy.dpid
*             covselected[i*4+j]=recno('coverage')
*             @ row+j,1 say "*" color gr+/b
*          endif
          j=j+1
       endif
      skip
      enddo
      wait clear
      set cursor on
      j=j-1
      current=0
      going=.t.
      do while (going=.t.)
      @ row+1+current,0 say ">" color r+/b
        read
        lkey=lastkey()
        do case
           case lkey=DOWN
              if current<(j-1)
                @row+1+current,0 say " "
                current=current+1
              endif
           case lkey=UP
              if current>0
                @row+1+current,0 say " "
                current=current-1
              endif
           case lkey=SELECTkey
                if (covselected[i*4+current+1]=0)
                   @row+1+current,1 say "*" color gr+/b
                   covselected[i*4+current+1]=temprecs[current+1]
                   howmany=howmany+1
                else
                    @row+1+current,1 say ' '
                    covselected[i*4+current+1]=0
                    howmany=howmany-1
                endif
           case lkey=PREVIOUS
                if i>0
                   i=i-1
                   go i*4+1
                   going=.f.
                endif              
           case lkey=NEXT
                if i<(screens-1)
                   i=i+1
                   going=.f.
                endif
           case lkey=ENDKEY
             tf=acertain('Is this your Final Choice ?',.t.)
             if tf
               finished=.t.
               gooddata=.t.
*               do dispvehs with screens,mnumber
               exit
              endif
           case lkey=QUITKEY
                finished=.t.
                gooddata=.f.
                exit
           otherwise
                ?? chr(7)
        endcase
*        @ 24,0 say str(i)+str(current)+str(i*4+current+1)
      enddo
  enddo
  set cursor on
on key label f10
on key label enter
if lastkey()=27
   howmany=0
endif
return howmany




******************************************************************************
*                    procedure display vehicles
******************************************************************************

procedure dispvehs
parameter screens,mnumber
set color to gr+/b
@7,2 say 'Vehicle ID           Year Make                 Model and Style        Premium'
set color to w+/b

*wait window "Looking For Vehicles" nowait
select coverage
  go top
      K=0
      row=8
      do while ((!EOF('coverage')) and (k<9))
       amount=coverage->dtotal
       if ((amount >0)  and (coverage.dpid=pid))
          @row+K,2 say vehicle->vin+' '+vehicle->year+' '+vehicle->make+' '+left(vehicle->modst,20)+str(amount)
          K=K+1
          covselected[k]=recno('COVERAGE')
        endif
        skip
      enddo
wait clear
return


******************************************************************************
*                    function no such policy
******************************************************************************
function nosuchpol
parameter mpoli
select policy
if alltrim(mpoli)=''
  tf =.t.
else
locate for policyno=alltrim(upper(mpoli))
if found()
   tf=.f.
else
    tf=.t.
endif
endif
return tf





******************************************************************************
*                    Function display policy
******************************************************************************
Function poldisplay
private tf,string1,string2,thisdate
thisdate=ctod('1/1/1')

		

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set order to tag dvehid
		
         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         set filter to (dpid=policy->dpid OR DPID=0)
*        select vehicle
         set relation to dvehid into vehicle
         set relation to iidno into icompany additive

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno
         
    select policy
    set order to tag iidno
    set relation to iidno into icompany

select policy
on key label enter
select policy
*set relation to iidno into icompany additive
MPOLICYNO=SPACE(30)
mtml=space(20)
mpolicyno        =   stuff(mpolicyno,1,len(policyno),policyno)
MTO              =   to
mfrom            =   from
macctno          =   ACCTNO
PID              =   DPID
OPTION1          =   DOPTION1
OPTION2          =   DOPTION2
FINANCED         =    DFINANCED
fincompany=space(30)
FINCOMPANY       =    stuff(fincompany,1,len(dfincompany),dfincOMPANY)
TOTPRE           =    DTOTPRE
PREMIUM          =    DPREMIUM
INSTALLMENT      =    DINSTALL
DOWN1            =    DDOWN1
DOWn2            =    DDOWN2
mnumber          =    iidno
comrate          =    dcomrate
totcom           =    dtotcom
totcomrec        =    dtotcomrec
mtml            =    tml
MFS75           =    FS75
MFS752           =    FS752

tf=.f.


for i=1 to 100
    covselected[i]=0        && recno of selected vehs
endfor
*@ 0,0 to 0,79 clear
set color to
set color to gr+/b
@ 2,0 say space(80)
clear
set color to n/w
*@ 24,0 say space(80)
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
set color to gr+/n,N/W
@ 0,0 say space(80)
=center(0,'POLICY INFORMATION')
*@2,0 say space(80)
set color to w+/b,N/W
@23,0  say space(80)

set color to
set color to gr+/b
ONCE=.T.
stillediting=.t.
  set color to w+/b
  @ 2,10 say '                       Policy Period'
  @ 3,10 say 'Policy No              From       To     Coverage is Provided by'
  set color to
  @ 4,0  get mpolicyno picture replicate ('X',30) size 1,27 valid nosuchpol(mpolicyno)
wait clear
  @ 4,29 get mfrom picture '99/99/9999'
  @ 4,40 get mto picture '99/99/9999'
  clear gets
  mname=icompany->iname
  @ 4,51 say LEFT(MNAME,30) color r+/b

* disp client info
@ 5,10 say "Account #" color gr+/b
string1=alltrim(str(acctno))
@ 6,10+((9-len(string1))/2) say string1 color w+/b
@ 5,50 say "Client Name" color gr+/b
string2=left(alltrim(client.lastn)+','+alltrim(client.firstn)+','+client.MI,25)
if len(string2)<12
   @ 6,50+((11-len(string2))/2) say string2 color w+/b
else
   @ 6,50-((len(string2)-11)/2) say string2 color w+/b
endif
set color to gr+/b
@7,2 say 'Vehicle ID           Year Make                 Model and Style        Premium'
set color to w+/b

select policy
rec=recno()
*wait window "Looking For Vehicles" nowait
select coverage
  go top
      K=0
      row=8
      do while ((!EOF('coverage')) and (k<9))
       amount=coverage->dtotal
       if ((amount >0)  and (coverage.dpid=pid))
          @row+K,2 say vehicle->vin+' '+vehicle->year+' '+vehicle->make+' '+left(vehicle->modst,20)+str(amount)
          K=K+1
          covselected[k]=recno('COVERAGE')
        endif
        skip
      enddo
wait clear

select policy
go rec

SET COLOR TO N/R
@17,0 TO 17,79 CLEAR
SET COLOR TO w+/b
set color to w+/b,r+/b
DO DISPFIN
select policy
if deleted()
   set color to gr+/r+
   =center(23,'WARNING! This Record Is Marked For Deletion')
   ? chr(7)
   else
       set color to w+/b
   @ 23,15 say space(80)
endif

wait clear
if policy.dcanceled=.t.
   set color to gr+/r+
   @ 22,30 say 'WARNING! This Policy was cancelled on '
IF LEN(ALLTRIM(policy.canceldate))=0
   THIDATE=CANDATE()
   @ 22,68 say THISDATE
ELSE
   @ 22,68 say policy.canceldate
ENDIF
   ? chr(7)
   else
       set color to w+/b
   @ 22,30 to 22,79 clear
endif
if policy.renewed=.t.
   set color to w+/r
   =center(17,'WARNING! This Policy has been RENEWED')
endif
set color to gr+/n
@ 0,0 say space(80)
=center(0,'  POLICY INFORMATION  ')
select policy
set reprocess to 1
if lock(alltrim(str(recno())),'policy')=.f.
   @ 1,1 say ' '
   ? chr(7)
   wait window 'This POLICY is edited by Another User' timeout 1
   ? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in policy
set reprocess to 1
return TF





******************************************************************************
*                    put policy data in database
******************************************************************************
PROCEDURE putPOLdata
parameter rec
private i,j,k

wait window "Updating" nowait
* MARK THE SELECTED ONES FIRST
for i=1 to 100
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
set filter to
    if covselected[i]<>0
       go covselected[i]
       do while lock(alltrim(str(recno())),'vehicle')=.f.
          wait window 'Record '+alltrim(str(covselected[i]))+' in VEHICLE is locked' timeout 1
       enddo
       replace dpid with pid
       unlock in vehicle
       vvid=vin
           select coverage
       go top
      locate for ( (vvid=vin) and (iidno=policy.iidno) )
          do while ( !eof() )
             if found()
                do while lock(alltrim(str(recno())),'coverage')=.f.
                   WAIT WINDOW 'Record '+alltrim(str(recno))+' in COVERAGE is locked' timeout 1
                ENDDO
                replace policyno with mpolicyno,;
                        dpid with pid,;
                        dactive with .T.,;
                        dfrom with ctod(policy.from),;
                        dto with ctod(policy.to)
                UNLOCK IN COVERAGE
             ENDIF
             CONTINUE
          enddo
    endif
endfor



* UNMARK THE UNSELECTED ONES FIRST
i=0
for I=1 to 100
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
set filter to
    if ( (OLDselected[I]<>0) AND(!FOUNDVEH(OLDSELECTED[I])) )
       go OLDselected[I]
       do while lock(alltrim(str(recno())),'vehicle')=.f.
          wait window 'Record '+alltrim(str(OLDselected[i]))+' in VEHICLE is locked' timeout 1
       enddo
       replace dpid with 0
       unlock in vehicle
       vvid=vin
           select coverage
       go top
       locate for vvid=vin
          do while ( !eof() )
             if found()
                do while lock(alltrim(str(recno())),'coverage')=.f.
                   WAIT WINDOW 'Record '+alltrim(str(recno))+' in COVERAGE is locked' timeout 1
                ENDDO
                replace policyno with SPACE(30)
                UNLOCK IN COVERAGE
             ENDIF
             CONTINUE
          enddo
    endif
endfor

select policy
go (rec)
replace policyno with ALLTRIM(UPPER(mpolicyno)),;
        ACCTNO   WITH macctno,;
        to       WITH MTO,;
        FROM     WITH MFROM,;
        ACCTNO   WITH macctno,;
        DPID     WITH PID,;
        iidno  with alltrim(mnumber),;
        DOPTION1 WITH OPTION1,;
        DOPTION2 WITH OPTION2,;
        DFINANCED      WITH             FINANCED,;
        DFINCOMPANY    WITH             ALLTRIM(UPPER(FINCOMPANY)),;
        DTOTPRE        WITH             TOTPRE,;
        DPREMIUM       WITH             PREMIUM,;
        DINSTALL   WITH            INSTALLMENT,;
        DDOWN1     WITH            DOWN1,;
        DDOWN2     WITH            DOWN2,;
        dcomrate   with            comrate,;
        dtotcom    with           totcom,;
        dtotcomrec with            totcomrec,;
        tml        with            mtml,;
        FS752      WITH            ALLTRIM(MFS752),;
        FS75       WITH            ALLTRIM(MFS75)

wait clear
return






******************************************************************************
*                    FUNCTION FOUND
******************************************************************************
FUNCTION FOUNDVEH
PARAMETER WHAT,i,j,k
PRIVATE TF
TF=.F.
FOR I=1 TO 100
    IF covselected[I]=WHAT
      TF=.T.
      EXIT
    ENDIF
ENDFOR
RETURN TF

******************************************************************************
*                    PROCEDURE replace company numbers
******************************************************************************
Procedure replcono
private selection,tf
         hide popup pactions
select policy
if lock(alltrim(str(recno())),'policy')=.f.
   @ 1,1 say ' '
   ? chr(7)
   wait window 'This POLICY is edited by Another User' timeout 1
   ? chr(7)
   wait window 'Please try again later' timeout 1
   return
endif

if policy.dcanceled=.t.
   ?? chr (7)
      wait window "You cannot edit a cancelled Policy" timeout 3
      unlock in policy
      return
endif


if policy.renewed=.t.
   ?? chr (7)
      wait window "You cannot edit a RE-newed Policy" timeout 3
      unlock in policy
      return
endif


mnumber=iidno
oldnumber=iidno

tf=.f.
SET COLOR TO gr+/b
DEFINE WINDOW WARNiNG  at 8,9 size 13,70 in desktop DOUBLE FLOAT TITLE 'WARNING !' shadow;
	font "Arial",11

DEFINE WINDOW Browser  at 4,4 size 12,72 in desktop DOUBLE FLOAT TITLE 'WARNING !' shadow;
	font "Arial",11

*define window browser from 4,4 to 14,75 none float in desktop shadow

  set color to gr+/r
=center(24,'Press <F10> to accept New Number')
set color to w+/b
set color to gr+/b
activate window warning
=center(5,"Please provide the Insurance company Number that")
=center(6,"the current policy will switch to")
  set color to gr+/r
=center(8,"Press <F10> to Accept the New Number")
set color to w+/b
set color to gr+/b
good=.f.
data=.f.
lk=0
do while ((good=.f.) or (data=.f.)) .and. lk<>23
     on key label f10 keyboard "{ctrl+w}"
     *on key label enter keyboard "{ctrl+w}"
     on key label enter
              IF !USED('icompany')
                 select d
                 use icompany index icompany alias icompany
              else
                select icompany
              endif
              SET ORDER TO TAG iidno
     seek mnumber
     if found()
        set color to w+/b
        =center(3,space(30))
        =center(3,alltrim(icompany->iname))
        set color to gr+/b
     endif
     set color to gr+/b
     on key label f10 keyboard "{ctrl+w}"
*     on key label enter keyboard "{ctrl+w}"
     on key label enter
     set color to gr+/b,w+/bg
     @ 2,10 say 'New Insurance Company Number' get mnumber picture '99999999999999999999'
     read
     lk=lastkey()
*     if lastkey()=6
*        data=.t.
*     else
*         data=.f.
*     endif
              IF !USED('icompany')
                 select d
                 use icompany index icompany alias icompany
              else
                select icompany
              endif
       SET ORDER TO TAG iidno
     seek mnumber
     if found()
        set color to w+/b
        @ 3,0 to 3,scols()-2 clear
        =center(3,alltrim(icompany->iname))
        set color to gr+/b
        good=.t.
     endif
     if lastkey()=27
        deactivate window warning
        release window warning
        release window Browser
        on key label f10
        on key label enter
        return
     endif


              IF !USED('icompany')
                 select d
                 use icompany index icompany alias icompany
              else
                select icompany
              endif
       SET ORDER TO TAG iidno
     set filter to itype='AUTO'
     seek mnumber
     if ( (!found()) or (val(mnumber)=0))
        save screen to warnsc
        deactivate window warning
        go top
        set color to w+/b
        @ 24,0 say space(80)
        =center(24,"Press <ENTER> to Accept Entry")
        on key label enter keyboard "{ctrl+w}"
       SET ORDER TO TAG iname
        browse fields iname:h="Company Name",iidno:h="Number" nomodify nomenu 
       SET ORDER TO TAG iidno
        on key label enter
        =center(24,"                               ")
set color to n/w
*@ 24,0 say space(80)
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
        set color to gr+/b
        activate window warning
        restore screen from warnsc
        good=.t.
     endif
     set filter to
     mnumber=icompany->iidno
enddo

on key label f10
on key label enter
set filter to
select policy
deactivate window warning
set color to w+/b
@24,0 say space(80)
set color to n/w
*@ 24,0 say space(80)
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
set color to gr+/b

SET COLOR TO gr+/b
selection=1
tf=.f.
do while ((selection <3) and (tf=.f.))
     activate window warning
     clear
     =center(1,'Be advised that changing the Ins Company number will result')
     =center(2,'to changes to the Premiums and all the selected Vehicles')
     set color to gr+/b,w+/bg
     @ 4,13  prompt 'View Premiums in Current Policy '
     @ 6,13  prompt '      Change Unconditionaly     '
     @ 8,13  prompt 'Nope Not sure! Let me outa here!'
     menu to selection
     do case
        case selection=1
           select coverage
*                 save screen to warnsc
*                 deactivate window warning
*                 =center(24,'Press ESC to exit') color gr+/b
*                 activate window warning
*                 restore screen from warnsc
*                delete file temp.dbf
*                select distinct icompany.*;
*                       from    icompany icompany,coverage coverage;
*                       into    table temp;
*                       where   coverage.acctno=macctno;
*                         and   coverage.dactive=.f.;
*                         and   policy.iidno=coverage.iidno
*                select 25
*                use temp alias temp
*                 activate window browser
                 if (len(alltrim(mpolicyno))=0)
                 browse fields vin:h="Vehicle ID",;
                               iidno:h="Insurance Co# ",;
                               policyno:h="Policy Number",;
                               dtotal:h="Cov. Total";
                               for ( (iidno=oldnumber) and (dpid=pid) );
                               window browser NOMODIFY color scheme 8 nomenu 
                 else
                 browse fields vin:h="Vehicle ID",;
                               iidno:h="Insurance Co# ",;
                               policyno:h="Policy Number",;
                               dtotal:h="Cov. Total";
                               for( (iidno=oldnumber)  and (dpid=pid));
                               window browser NOMODIFY color scheme 8 nomenu
                 endif
 *                deactivate window browser
 *                save screen to warnsc
 *                deactivate window warning
 *                @ 24,0 to 24,79 fill color n/b
 *                activate window warning
 *                restore screen from warnsc
          select policy
        case selection=2
             TF=.T.
        case selection=3
             TF=.F.
     endcase
enddo

if tf=.t.
select policy
replace iidno with mnumber
SELECT COVERAGE
for i=1 to 100
    if covselected[i]<>0
       go covselected[i]
                      do while lock(alltrim(str(recno())),'coverage')=.f.
                         WAIT WINDOW 'Record '+alltrim(str(recno))+' in COVERAGE is locked' timeout 1
                      ENDDO
                replace iidno with alltrim(mnumber)
                UNLOCK IN COVERAGE
    endif
endfor
endif
deactivate window warning
release window warning
release window browser
presult=10
unlock in policy
do poldisplay
             MINVOICENO=0
             MACCTNO   =client->ACCTNO
             MTRANCODE =8002
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MDESCRIPT ="Insurance Company Changed"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
*             DVID      =coverage->VIN
             DVID      =vehicle->VIN
             
             polno=policy.policyno
             cchange=.f.
             ccom=0
             =ppost_act(MINVOICENo,client->acctno,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom,policy.dpid)
do post_polhistory
select policy
return


******************************************************************************
*                    PROCEDURE replace policy numbers
******************************************************************************
Procedure replpolno
         hide popup pactions
private selection,tf,oldno
select policy
if lock(alltrim(str(recno())),'policy')=.f.
   @ 1,1 say ' '
   ? chr(7)
   wait window 'This POLICY is edited by Another User' timeout 1
   ? chr(7)
   wait window 'Please try again later' timeout 1
   return
endif
set relation to

if policy.dcanceled=.t.
   ?? chr (7)
      wait window "You cannot edit a cancelled Policy" timeout 3
      unlock in policy
      return
endif


if policy.renewed=.t.
   ?? chr (7)
      wait window "You cannot edit a RE-newed Policy" timeout 3
      unlock in policy
      return
endif


rec=recno()
mpolicyno=space(30)
mtml=TML
mpolicyno=stuff(mpolicyno,1,len(alltrim(policyno)),alltrim(policyno))
mnumber=iidno
oldno=alltrim(mpolicyno)

set color to gr+/n
@ 0,0 say space(80)
=center(0,"Changing the Policy's Information")
  set color to gr+/r
=center(24,"Press <F10> to Accept, Use 0 in Ins. Company to see list")
set color to gr+/b,n/w


  mdfrom=ctod(from)
  mdto=ctod(to)
on key label f10 keyboard "{ctrl+w}"
ONCE=.T.
stillediting=.t.
do while stillediting=.t.
  set color to w+/b
  @ 4,51 to 4,79 clear
  @ 2,10 say '                       Policy Period'
  @ 3,10 say 'Policy No              From       To     Coverage is Provided by'
  set color to
  @ 4,0  get mpolicyno picture replicate ('X',30) size 1,27 valid nosuchpol(mpolicyno)
  @ 4,29 get mdfrom picture '@d'valid mdfrom>{01/01/1980}
  @ 4,40 get mdto picture '@d'
  @ 4,51 get mnumber picture '99999999999999999999'
  read
  mfrom=dtoc(mdfrom)
  mto=dtoc(mdto)
    if lastkey()=27
       STILLEDITING=.F.
       EXIT
    endif
  if ( lastkey()=23 and once=.f. )
     stillediting=.f.
     exit
  endif
  select icompany
  SET ORDER TO TAG iidno
  seek mnumber
  if !found()  	
     go top
     set color to gr+/b,w+/bg
     define window browser from 6,5 to 22,74 none float shadow
     on key label enter keyboard "{ctrl+w}"
  set color to gr+/r
     =center(24,"Press <F10> to Select Insurance Company")
     set color to w+/b,n/w
     on key label enter keyboard "{ctrl+w}"
     set order to tag iname
     browse fields iname:h="Company Name",iidno:h="ID Number" nomodify window browser;
            color scheme 8 title "Insurance Company Selector" ;
            for icompany->itype="AUTO" nomenu
            mnumber=iidno
       SET ORDER TO TAG iidno
     ON KEY LABEL ENTER
     release window browser
     @ 24,0 say space(80)
set color to n/w
*@ 24,0 say space(80)
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
     on key label enter
  endif
  on key label enter
  set color to w+/b,n/w
  mnumber=icompany->iidno
  mname=icompany->iname
  if policy->dcomrate=0
     comrate=icompany->dcom
  endif
  select policy
  goto (rec)
  @ 4,51 get mnumber picture '99999999999999999999'
  clear gets
  set color to gr+/r
  @ 24,0 say space(80)
  =center(24,"Press <F10> to Accept New Data")
  set color to w+/b,n/w
* @ 5,51 say "Name:"
*  @ 5,51 say LEFT(MNAME,25) color r+/b
 if mname<>space(20)
   wait window mname nowait
 endif
  ONCE=.F.
enddo
IF LASTKEY()=27
   TF=.F.
ELSE
   TF=.T.
ENDIF

     replace policyno    with ALLTRIM(UPPER(mpolicyno)),;
             iidno       with alltrim(mnumber),;
             from        with mfrom,;
             to          with mto,;
             DOPTION1    WITH OPTION1,;
             DOPTION2    WITH OPTION2,;
             DFINANCED   WITH FINANCED,;
             DFINCOMPANY WITH ALLTRIM(UPPER(FINCOMPANY)),;
             DPREMIUM    WITH PREMIUM,;
             dcomrate    with comrate,;
             dtotcomrec  with totcomrec,;
             dtotcom     with totcom,;
             TML         WITH MTML,;
             fs752       with alltrim(mfs752),;
             fs75        with alltrim(mfs75)

if tf=.t.
      select policy
      goto (rec)
      premium=dpremium
      oldpre=premium-24
      percent=comrate
      acceptance=.f.
      comrate=dcomrate
      totcomrec=dtotcomrec
      totcom=dtotcom

on key label f10 keyboard "{ctrl+w}"
do getfin
on key label f10



if lastkey()<>27
     SELECT POLICY
     goto (rec)
     replace DOPTION1    WITH OPTION1,;
             DOPTION2    WITH OPTION2,;
             DFINANCED   WITH FINANCED,;
             DFINCOMPANY WITH ALLTRIM(UPPER(FINCOMPANY)),;
             DPREMIUM    WITH PREMIUM,;
             dcomrate    with comrate,;
             dtotcomrec  with totcomrec,;
             dtotcom     with totcom,;
             TML         WITH MTML,;
             fs752       with alltrim(mfs752),;
             fs75        with alltrim(mfs75)
endif

     SELECT COVERAGE
     for i=1 to 100
         if covselected[i]<>0
            go covselected[i]
                     do while lock(alltrim(str(recno())),'coverage')=.f.
                        WAIT WINDOW 'Record '+alltrim(str(recno))+' in COVERAGE is locked' timeout 1
                     ENDDO
                     replace policyno with mpolicyno
                     replace iidno with alltrim(mnumber)
                     UNLOCK IN COVERAGE
         endif
      endfor
      select policy
      set relation to iidno into icompany
      goto (rec)
      do poldisplay
      unlock in policy

      MINVOICENO=0
      MACCTNO   =client->acctno
      MTRANCODE =8001
      MQTY      =1
      MPRICE    =0
      MTOTAL    =0
      MDATE     =DATE()
      MCLERK    =''
      MDESCRIPT ="Policy Numbers Changed"
      MPOSTED   =.f.
      MBILLED   =.f.
      MCHECKNO  =''
      DVID      ='  '
      polno=policy.policyno
      cchange=.f.
      ccom=0
      =ppost_act(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                policy.effdate,polno,cchange,ccom,policy.dpid)
      do post_polhistory
else
    set relation to iidno into icompany
    goto (rec)    
    do poldisplay
    unlock in policy
endif
select policy
return






******************************************************************************
*                    PROCEDURE all driver menu
******************************************************************************
procedure call_drvmenu
select policy
       do drvmenu with dpid
       select policy
       do poldisplay
       presult=10
*       do poloptions
return  && this is where this program exits from


******************************************************************************
*                    Procedure gettotal
******************************************************************************
function gettotal
private number

number=0
select coverage
go top
for i=1 to 100
    if covselected[i]<>0
       go covselected[i]
       number=number+coverage.dtotal
    endif
endfor
select coverage
go top
return number


******************************************************************************
*                    Procedure gettot
******************************************************************************
function gettot
parameter vvid,mnumber,pid
private number,temp
number=0
         select coverage
         locate for (VIN=vvid and iidno=mnumber and dpid=pid)
         if found()
            temp=dtotal
         else
             temp=0
         endif
*       SUM COVERAGE.DTOTAL FOR (VIN=vvid and iidno=mnumber and dpid=pid) TO TEMP
       number=number+TEMP
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
return number

******************************************************************************
*                    Procedure get no pid total
******************************************************************************
function getnopidtot
parameter vvid,mnumber
private number,temp
number=0
         select coverage
         locate for (VIN=vvid and iidno=mnumber)
         if found()
            number=dtotal
         else
             number=0
         endif
*       SUM COVERAGE.DTOTAL FOR (VIN=vvid and iidno=mnumber) TO TEMP
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
return number




******************************************************************************
*                    Procedure first installment
******************************************************************************
procedure firstinstallment
parameter pid,macctno,premium,option1,option2,fromdate
private payment

IF OPTION1=.T.
   NOINSTS=1
   DOWNPERCENT=30.0
   REMAININGPERCENT=70.0
   serviceCHARGE=0
ENDIF

IF OPTION2=.T.
   NOINSTS=5
   DOWNPERCENT=25.0
   REMAININGPERCENT=15.0
   serviceCHARGE=4
ENDIF

tempdown=((premium*DOWNPERCENT)/100.00)+SERVICECHARGE
temppay=(premium*REMAININGPERCENT)/100.00

*VOODOO
RELEASE WINDOW INSTS
define window INSTS from 6,13 to 18,65 system float shadow title "Installment Plan";
		color scheme 10 font "Arial",11
*             color w+/g,g/w,w+/g,g/w,w+/g,g/w,w+/g,g/w,w+/g
*             color w+/b,w+/bg,w+/b,w+/bg,w+/b,w+/bg,w+/b,w+/bg,w+/b
ACTIVATE WINDOW INSTS
on key label f10 keyboard "{ctrl+w}"

CONT=27
DO WHILE CONT=27
  SET COLOR TO w+/b,w+/bg	
   clear
   
   @ 1,1  SAY "Remaining Installments" get noinsts picture '99' valid svcchg()
   @ 2,2  say "Percent Downpayment" get downpercent   picture '999.99' valid calcpers() error      "Hey these numbers are wrong"
   @ 3,9  say "Service Charge" get servicecharge picture '99' valid calcpers()
   @ 5,6 say "Premium" get premium picture '9999.99' disabled
   @ 6,1  say "Down Payment" get tempdown picture '9999.99' disabled
   @ 6,25 say " Payments" get temppay picture '9999.99' disabled
   set color to gr+/r   
   =center(8,"Press F10 to accept")
   READ cycle
   CONT=LASTKEY()
ENDDO


DEACTIVATE WINDOW INSTS
RELEASE WINDOWS INSTS
   set color to

       if !used('installm')
          select 11
          use installm index install alias installment
       else
          select installment
       endif



  if noinsts=0
   append blank
   payment=premium
   replace dpid     with    pid,;
        acctno      with    macctno,;
        dreason     with    left("Full Payment",15),;
        ddate       with    ctod(fromdate),;
        dpayment    with    payment
   return .t.
  endif


*more than 1 installments
*
   append blank
   payment=premium*(downpercent/100)
   replace dpid     with    pid,;
        acctno      with    macctno,;
        dreason     with    left("Down Payment",15),;
        ddate       with    ctod(fromdate),;
        dpayment    with    round(payment+servicecharge,0)

  for i=1 to noinsts-1
   append blank
   payment=premium*(remainingpercent/100)
   replace dpid     with    pid,;
        acctno      with    macctno,;
        dreason     with    left("Payment #"+alltrim(str(i)),15),;
        dpayment    with    payment+servicecharge
*       dpayment    with    round(payment+servicecharge,0)
  endfor

*
*last INstallment
*
   append blank
   payment=premium*(remainingpercent/100)
   replace dpid     with    pid,;
        acctno      with    macctno,;
        dreason     with    left("Last Payment",15),;
        dpayment    with    payment+servicecharge
*        dpayment    with    round(payment+servicecharge,0)

return

*if option1=.t.
*   payment=premium*.3
*   append blank
**   replace dpid     with    pid,;
**        acctno  with    macctno,;
**        dreason  with    "First Installment/Down Payment",;
**        ddate    with    ctod(fromdate),;
**        dpayment with    payment
*   replace dpid     with    pid,;
*        acctno      with    macctno,;
*        dreason     with    left("Down Payment",10),;
*        ddate       with    ctod(fromdate),;
*        dpayment    with    round(payment+4,0)
*   payment=premium*.7+4
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Second/Final Installment",;
*        dpayment with    round(payment,0)
*endif
*
*if option2=.t.
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Down Payment",;
*        ddate    with    ctod(fromdate),;
*        dpayment with    round((premium*0.25)+4,0)
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "First Installment",;
*        dpayment with    round(premium*0.15+4,0)
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Second Installment",;
*        dpayment with    round(premium*0.15+4,0)
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Third Installment",;
*        dpayment with    round(premium*0.15+4,0)
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Fourth Installment",;
*        dpayment with    round(premium*0.15+4,0)
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Final Installment",;
*        dpayment with    round(premium*0.15+4,0)
*endif
*
*if option1=.f.  and option2=.f.  && assuming first selection
*   payment=premium*.3
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Down Payment",;
*        ddate    with    ctod(fromdate),;
*        dpayment with    round(payment,0)
*   payment=premium*.7
*   append blank
*   replace dpid     with    pid,;
*        acctno  with    macctno,;
*        dreason  with    "Final Installment",;
*        dpayment with    round(payment,0)
*endif
*return                           



******************************************************************************
*                    Function addnewvehs
******************************************************************************
Function addnewvehs
private tf
         hide popup pactions
*         hide menu _msysmenu
tf=.f.

SELECT POLICY
REC=RECNO()
PLOcked=.f.
if lock(alltrim(str(recno())),'policy')=.f.
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   return plocked
else
  plocked=.t.
endif

save screen to sc
for i=1 to 100
    covselected[i]=0        && recno of selected vehs
endfor
 mfrom='  /  /    '
 mto='  /  /    '
 mnumber =space(20)
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
meffdate    = effdate
totcom      = dtotcom
MTML        = TML
mfs75=fs75
mfs752=fs752

rec1=recno()

set color to gr+/b,N/W
clear
set color to gr+/n,N/W
@ 0,0 say space(80)
=center(0,'EDITING POLICY')
*@2,0 say space(80)
set color to w+/b,N/W
@23,15 say space(80)

  set color to w+/b,n/w
  @ 2,10 say '                       Policy Period'
  @ 3,10 say 'Policy No              From       To     Coverage is Provided by'
  set color to
  @ 4,0  get mpolicyno picture replicate ('X',30) size 1,27 valid nosuchpol(mpolicyno)

  mdfrom=ctod(mfrom)
  mdto=ctod(mto)
  @ 4,29 get mdfrom picture '@d'
  @ 4,40 get mdto picture '@d'
  @ 4,51 get mnumber picture '99999999999999999999'
 * read
   CLEAR GETS
  mfrom=dtoc(mdfrom)
  mto=dtoc(mdto)
         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
  SET ORDER TO TAG iidno
  seek mnumber
  @ 5,51 say LEFT(iname,20) color r+/b
  comrate=dcom
  oldamount=premium
  select policy
      select coverage
      olfilter=filter()
*      SET FILTER TO IIDNO=POLICY.IIDNO AND DACTIVE=.F.
      howmany=selectoldvehs(mnumber,policy->dpid)


IF HOWMANY=0
   unlock in policy
   go (rec)
   select coverage
 if type('olfilter')<>'U'
     	set filter to &olfilter
     endif
     *   DO POLDISPLAY
    restore screen from sc
   PRESULT=10
   RETURN
ENDIF

select coverage

if ( (plocked=.t.)  )
       select policy
       go (rec)
select coverage
unlock in coverage
newmoney=0
comchange=0
DVID=''
for i=1 to 100
select coverage
    if covselected[i]<>0
       go covselected[i]
       do while lock(alltrim(str(recno())),'coverage')=.f.
          wait window 'Record '+alltrim(str(covselected[i]))+' in COVERAGE is locked' timeout 1
       enddo
               newmoney=newmoney+coverage->dtotal
                replace policyno with mpolicyno,;
                        dpid with pid,;
                        dactive with .T.,;
                        dfrom with ctod(policy.from),;
                        dto with ctod(policy.to),;
                        effdate with meffdate
                UNLOCK IN COVERAGE
                IF DVID=''              && POLCHANG
*                   DVID=COVERAGE.VIN
                   DVID=vehicle.VIN
                ENDIF
            if oldselected[i]=0
             MINVOICENO=0
             MACCTNO   =client->ACCTNO
             MTRANCODE =8003
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MDESCRIPT ="New Vehicle in Insurance"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
*             DVID      =coverage->VIN
			dvid=vehicle->vin
             polno=policy.policyno
             cchange=.t.
             comchange=coverage.dtotal
             ccom=comchange
             =ppost_act(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom,policy.dpid)
           endif

    endif
endfor

select coverage
 if type('olfilter')<>'U'
     	set filter to &olfilter
     endif


acceptance=.f.
on key label f10 keyboard "{ctrl+w}"

premium=newmoney
*totcom=PREMIUM*(COMRATE/100)
                            set color to w+/b,w+/bg
if mto<>'  /  /    '
   meffdate=ctod(mto)
else
    meffdate=date()
endif
comchange=0
oldammount=policy->dpremium
oldpre=oldamount-24
comchange=calcom(CTOD(mfrom),CTOD(MTO),meffdate,oldamount,premium,4,percent)
set color to w+/b,w+/bg
totcom=totcom+comchange
comrate=policy.dcomrate

do getfin

           on key label f10

select policy
go (rec)
replace policyno with ALLTRIM(UPPER(mpolicyno)),;
        ACCTNO   WITH macctno,;
        to       WITH MTO,;
        FROM     WITH MFROM,;
        ACCTNO   WITH macctno,;
        DPID     WITH PID,;
        iidno  with mnumber,;
        DOPTION1 WITH OPTION1,;
        DOPTION2 WITH OPTION2,;
        DFINANCED      WITH             FINANCED,;
        DFINCOMPANY    WITH             ALLTRIM(UPPER(FINCOMPANY)),;
        DTOTPRE        WITH             TOTPRE,;
        DPREMIUM       WITH             PREMIUM,;
        DINSTALL   WITH            INSTALLMENT,;
        DDOWN1     WITH            DOWN1,;
        DDOWN2     WITH            DOWN2,;
        dcomrate   with            comrate,;
        dtotcom     with           totcom,;
        dtotcomrec with            totcomrec,;
        TML        WITH            MTML,;
        fs752     with             alltrim(mfs752),;
        fs75      with             alltrim(mfs75)

do post_polhistory

endif
select policy
unlock in policy
go (rec)
DO POLDISPLAY
PRESULT=10
return 



******************************************************************************
*                    Function adjust premiums
******************************************************************************
Function premadjust
private tf,arecveh,rec
tf=.f.

         hide popup pactions
SELECT COVERAGE
set filter to (dpid=policy->dpid)
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
@ 24,0 say space(80)
=center(24,"Please select the Vehicle whose Premiums you want to Adjust")
set color to w+/b
define window browsewin from 6,13 to 16,70 system;
       float shadow grow noclose font "Arial",11 color scheme 10;
       	title "Coverage Selection List"
       
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
             for ((coverage.dpid=policy.dpid) and (iidno=policy.iidno) );
             nomodify nomenu width 15 window browsewin;
             title "Coverage Selection List";
             color scheme 10 font "arial",11
COVrec=recno('coverage')
on key label f10
on key label enter
if lastkey()=27
   unlock in policy
*   go (rec)
*   DO POLDISPLAY
   presult=10
   return
endif
   RELEASE WINDOW browsewin

*hide menu _msysmenu
edited=pcovmenu(COVrec)

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

?? chr(7)
wait window "Now EDIT the PREMIUMS to certify their Values" timeout 2
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
          covselected[k]=recno('COVERAGE')
        endif
        skip
      enddo
wait clear
* get the new financial data
select policy

* JUST SHOW THE NEW VALUES
DO DISPFIN

     premium=newmoney
     policecharge=howmany
*     premium=premium+policecharge
     oldpre=premium-24

do getfin


on key label f10
if ( (plocked=.t.)  )
*       select policy
*       go (rec)
*       do putpoldata with recno()

*select policy
*go (rec)
replace policyno with ALLTRIM(UPPER(mpolicyno)),;
        ACCTNO   WITH macctno,;
        to       WITH MTO,;
        FROM     WITH MFROM,;
        ACCTNO   WITH macctno,;
        DPID     WITH PID,;
        iidno  with mnumber,;
        DOPTION1 WITH OPTION1,;
        DOPTION2 WITH OPTION2,;
        DFINANCED      WITH             FINANCED,;
        DFINCOMPANY    WITH             ALLTRIM(UPPER(FINCOMPANY)),;
        DTOTPRE        WITH             TOTPRE,;
        DPREMIUM       WITH             PREMIUM,;
        DINSTALL   WITH            INSTALLMENT,;
        DDOWN1     WITH            DOWN1,;
        DDOWN2     WITH            DOWN2,;
        dcomrate   with            comrate,;
        dtotcom     with           totcom,;
        dtotcomrec with            totcomrec,;
        TML        WITH            MTML,;
        fs752      with            alltrim(mfs752),;
        fs75       with            alltrim(mfs75)

             MINVOICENO=0
             MACCTNO   =client->ACCTNO
             MTRANCODE =8009
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MDESCRIPT ="Premiums changed"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
*             DVID      =coverage->VIN
             DVID      =vehicle->VIN
             
             polno=policy.policyno
             cchange=.t.
             ccom=comchange
             =ppost_act(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom,policy.dpid)
do post_polhistory

endif
SELECT COVERAGE
set filter to (dpid=policy->dpid OR DPID=0)
select policy
unlock in policy
go (rec)
DO POLDISPLAY
presult=10
return


******************************************************************************
*                    Function history of policies
******************************************************************************
procedure post_polhistory
private id,many,newnum

id=policy.dpid
if !used('polhist')
   select 23
   use polhist
else
    select polhist
endif
set filter to dpid=id
count to many
newnum=many+1
append blank
replace policyno       with policy.policyno,;
        ACCTNO         WITH policy.ACCTNO,;
        to             WITH policy.to,;
        FROM           WITH policy.FROM,;
        DPID           WITH policy.DPID,;
        iidno        with policy.iidno,;
        DOPTION1       WITH policy.DOPTION1,;
        DOPTION2       WITH policy.DOPTION2,;
        DFINANCED      WITH policy.DFINANCED,;
        DFINCOMPANY    WITH policy.DFINCOMPANY,;
        DTOTPRE        WITH policy.DTOTPRE,;
        DPREMIUM       WITH policy.DPREMIUM,;
        DINSTALL       WITH policy.DINSTALL,;
        DDOWN1         WITH policy.DDOWN1,;
        DDOWN2         WITH policy.DDOWN2,;
        dcanceled      with policy.dcanceled,;
        dcomrate       with policy.dcomrate,;
        dtotcom        with policy.dtotcom,;
        dtotcomrec     with policy.dtotcomrec,;
        effdate        with policy.effdate,;
        occurence      WITH newnum
set filter to
select policy
return


******************************************************************************
*                    Function cancel policy
******************************************************************************
procedure can_pol
private thisdate
thisdate=ctod('1/1/1')
         hide popup pactions
select policy
rec=recno()
if (  recused('policy',recno()) )
   wait window "Somebody is editing this policy,Try Later" nowait
   return
endif

   tf=acertain("Really Change the Cancellation Flag ?",.f.)
   if tf=.f.
      return
   endif
      do post_polhistory

      IF POLICY.DCANCELED=.F.
      dateCANCEL=candate()
*      temp=dtoc(dateCANCEL)
      temp=dateCANCEL
      if len(alltrim(temp))<=4 && no date
           DATECANCEL=DTOC(date())
           message="No cancellation Letter in file"
      ELSE
          message="Date from Cancellation Letter"
      endif
      TEMP=DATECANCEL
      dateCANCEL=get1date(TEMP)
         replace policy.dcanceled with .t.,;
                 POLICY.CANCELDATE WITH dateCANCEL && UPDATE CANCELDATE
         MDESCRIPT ="Policy has been Canceled"
      ELSE
         replace policy.dcanceled with .f.,;
                 POLICY.CANCELDATE WITH SPACE(10)
         MDESCRIPT ="Policy has been Reinstated"
      ENDIF

unlock in policy


if policy.dcanceled=.t.
   set color to gr+/r+
   @ 22,30 say 'WARNING! This Policy was cancelled on '
   @ 22,68 say POLICY.CANCELDATE
   ? chr(7)
else
   set color to w+/b
   @ 22,30 to 22,79 clear
endif

             MINVOICENO=0
             MACCTNO   =client->ACCTNO
             MTRANCODE =9909
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
*             DVID      =coverage->VIN
             DVID      =vehicle->VIN

             polno=policy.policyno
             cchange=.f.
             ccom=0
             =ppost_act(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom,policy.dpid)
PRESULT=10
select policy
return




******************************************************************************
*                    Function partial policy cancelation
******************************************************************************
procedure parpolcancel
private tf,arecveh,rec
         hide popup pactions
tf=.f.


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
totcom      = dtotcom
percent     = dcomrate
meffdate    = effdate
totcom      = dtotcom
MTML        = TML
mfs752=fs752
mfs75=fs75

rec1=recno()

save screen to polsc
set color to gr+/b
=center(24,"Please select the Vehicle to Remove from Policy")
set color to w+/b
define window browsewin from 11,1 to 23,82 system;
       float shadow grow font "Arial",11 title "Coverage Selection List"    
on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"

select coverage
*browse fields vin:h   = "Vehicle ID"   ,;
*             year:h  = "Year"         ,;
*             make:h  = "Make"         ,;
*             modst:h = "Model"        ,;
*             cost:h  = "Price"        ,;
*             purmo:h = "Month Bought" ,;
*             puryr:h = "Year Bought"  ;
*             for ( acctno=macctno and coverage.dpid=policy.dpid ) nomodify width 15 nomenu window browsewin;
*             title "Vehicle Selection List";
*             color gr+/b,w+/bg,,,w+/bg,,w+/bg,,,,w+/bg
*             for ((dpid=pid) and (iidno=mnumber) ) nomodify width 15 nomenu window browsewin;

browse fields vehicle->vin:h   = "Vehicle ID"   ,;
              vehicle->year:h="Year",;              
              vehicle->make:h="Make",;
              vehicle->modst:h="Model",;              
              coverage->dtotal:h="Premium",;              
              icompany->iname:h= "Insurance co";
             for ((coverage.dpid=policy.dpid) and (coverage.iidno=policy.iidno) ) ;
             nomodify width 15 nomenu window browsewin;
             title "Coverage Selection List" color scheme 10
*             color gr+/b,w+/bg,,,w+/bg,,w+/bg,,,,w+/bg
newrec=recno('coverage')
newmoney=coverage->dtotal
unlock in coverage
on key label f10
on key label enter
if lastkey()=27
   RELEASE WINDOWS
   unlock in policy
   go (rec)
   DO POLDISPLAY
   presult=10
   return
endif
*hide menu _msysmenu

edited=acertain("Remove this vehicle ?",.f.)
restore screen from polsc
if edited=.F.
   unlock in policy
   go (rec)
   presult=10
   RETURN
else
    vvid=coverage.vin
    DVID=VVID
    cancelvin=vvid
    cancelpid=policy->dpid
    select coverage
    go (newrec)
    do while lock(alltrim(str(recno())),'coverage')=.f.
       WAIT WINDOW 'Record '+alltrim(str(recno))+' in COVERAGE is locked' timeout 1
    ENDDO
    replace policyno with space(20),;
            dpid with 0  ,;
            dactive with .f.,;
            effdate with date(),;
            dfrom with {  /  /    },;
            dto with   {  /  /    }
    UNLOCK IN COVERAGE
endif
do poldisplay
acceptance=.f.
on key label f10 keyboard "{ctrl+w}"

premium=policy->dpremium
comrate=policy->dcomrate
oldamount=premium
premium=oldamount-newmoney
oldpre=premium-24
meffdate=ctod(policy.to)
comchange=calcom(CTOD(mfrom),CTOD(MTO),meffdate,oldamount,premium,3,percent)
totcom=totcom+comchange

do getfin

on key label f10

select policy


select policy
go (rec)
replace DPREMIUM       WITH             PREMIUM,;
        dcomrate   with            comrate,;
        dtotcom     with           totcom,;
        dtotcomrec with            totcomrec

MINVOICENO=0
MACCTNO   =MACCTNO
MTRANCODE =8009
MQTY      =1
MPRICE    =0
MTOTAL    =0
MDATE     =DATE()
MCLERK    =''
MDESCRIPT ="Vehicle Deleted In Policy"
MPOSTED   =.f.
MBILLED   =.f.
MCHECKNO  =''
*DVID      =coverage->VIN
             polno=policy.policyno
             cchange=.t.
             ccom=comchange
             =ppost_act(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom,policy.dpid)
select policy
unlock in policy
go (rec)
DO POLDISPLAY
presult=10
return



******************************************************************************
*                    comision
******************************************************************************
procedure Comisions

         hide popup pactions
PLOcked=.f.
select policy
if lock(alltrim(str(recno())),'policy')=.f.
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   return plocked
else
  plocked=.t.
endif

*wait window "Not implemented yet"
*return
*hide menu _msysmenu
save screen to sc
newtotcom=comis(policy.dpid,policy.acctno)

select policy
if ((NEWTOTCOM>-1) .AND. (dtotcomrec <> newtotcom))
   replace dtotcomrec with newtotcom
   do poldisplay
else
    restore screen from sc
endif

presult=10
unlock in policy
*show menu _msysmenu
return


******************************************************************************
*                    Documents
******************************************************************************
procedure docs

         hide popup pactions
PLOcked=.f.
if lock(alltrim(str(recno())),'policy')=.f.
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   return plocked
else
  plocked=.t.
endif

*wait window "Not implemented yet"
*return
save screen to sc
*hide menu _msysmenu
     do docmenu with policy.dpid
select policy
restore screen from sc
presult=10
unlock in policy
return

******************************************************************************
*                    calculate comision change
******************************************************************************
function calcom
parameter mfrom,mto,meffdate,oldamount,newamount,type,percent
private number,fdate

on key label enter
option=type
*type can be
*               Effective dates
*1 premium adjustment
*2 policy cancellation
*3 partial policy cancelation
*4 add new vehicles
*5 add new policy
*6 policy renewal

if len(alltrim(policy->from))<=4
   meffdate=date()
ELSE
    meffdate=ctod(policy->from)
ENDIF

period=0
if ((len(alltrim(policy->from))<=4) .or. (len(alltrim(policy->from))<=4))
   period=365 && one year
endif


do case
   case option=1
      clear gets
      set color to
      define window getcur from 5,5 to 13,45 system float shadow in desktop;
      		title "New Active Date" font "Arial",11
      save screen to sc
      set color to w+/b
      @ 24,0 say space(80)
	  on key label f10 keyboard "{ctrl+w}"
      set color to
      activate window getcur
         set color to 
         lastk=0
         @ 1,8 say "Effective date:" get meffdate picture "@d"
         @ 3,20 get lastk function '* OK' size 2,10
      read cycle
      deactivate window getcur
      release window getcur
      restore screen from sc
      if period=0
         period=((mto-meffdate)+1)
      endif
*        number=(newamount-oldamount) * ((((mto-meffdate)+1)/365)*(percent/100))
        number=(newamount-oldamount) * ((period/365)*(percent/100))
        replace coverage.effdate with meffdate
   case option=2
      clear gets
      set color to
      define window getcur at 5,5 size 4,38 in desktop system float shadow ;
      	title "New Values" 	font "Arial",11
      save screen to sc
      set color w/b
      @ 24,0 say space(80)
*      set color to r+/b
*      =center(24,"Press <F10> to Accept new Effective Date for this Coverage")
      set color to
 *     activate window getcur
 *     lastk=0
 *     on key label f10 keyboard "{ctrl+w}"
 *     do while lastk<>23
         set color to w+/b,w+/bg
         clear
         @ 1,4 say "Effective date:" get meffdate picture "@d"
      *   @ 3,1 say "Commission Rate:        %  "
      *   @ 3,19 get percent picture '99'
      read
  *    lastk=lastkey()
  *    enddo
      deactivate window getcur
      release window getcur
      restore screen from sc
        replace policy.effdate with meffdate
*        number=oldamount*(((meffdate-mfrom)+1)/365)*(percent/100)*(-1)
         if period=0
            period=(meffdate-mfrom)+1
         endif
        number=oldamount*(period/365)*(percent/100)*(-1)
   case option=3
      clear gets
      set color to
*      define window getcur from 5,5 to 9,38 shadow Double title "New Values" ;
*             color w+/b,w+/bg,w+/b,w+/bg,w+/b,w+/bg,w+/b,w+/bg,w+/b
      define window getcur at 5,5 size 4,28 in desktop system float shadow ;
      	title "New Values" 	font "Arial",11

      save screen to sc
      set color to w/b
      @ 24,0 say space(80)
*      set color to r+/b
*      =center(24,"Press <F10> to Accept new Effective Date for this Coverage")
      set color to
      activate window getcur
*      lastk=0
*      on key label f10 keyboard "{ctrl+w}"
*      do while lastk<>23		
         set color to w+/b,w+/bg
         clear
         @ 1,4 say "Effective date:" get meffdate picture "@d"
      *   @ 3,1 say "Commission Rate:        %  "
      *   @ 3,19 get percent picture '99'
      read
*      lastk=lastkey()
*      enddo
      deactivate window getcur
      release window getcur
      restore screen from sc
*        replace policy.effdate with meffdate
         select coverage
*         replace coverage.effdate with meffdate for vin=cancelvin and dpid=cancelpid
         replace coverage.effdate with meffdate
*        number=oldamount*((meffdate-mfrom)/365)*(percent/100)*(-1)
         if period=0
            period=((meffdate-mfrom)+1)
         endif
*        number=(oldamount-newamount)*(((meffdate-mfrom)+1)/365)*(percent/100)*(-1)
        number=(oldamount-newamount)*(period/365)*(percent/100)*(-1)
   case option=4
      clear gets
      set color to
*      define window getcur from 5,5 to 9,38 shadow Double title "New Values" ;
*             color w+/b,w+/bg,w+/b,w+/bg,w+/b,w+/bg,w+/b,w+/bg,w+/b
      define window getcur at 5,5 size 4,38 in desktop system float shadow ;
      	title "New Values" 	font "Arial",11

      save screen to sc
      set color to w/b
      @ 24,0 say space(80)
*      set color to r+/b
*      =center(24,"Press <F10> to Accept new Effective Date for this Coverage")
      set color to
      activate window getcur
*      lastk=0
*      on key label f10 keyboard "{ctrl+w}"
*      do while lastk<>23
         set color to w+/b,w+/bg
         clear
         @ 1,4 say "Effective date:" get meffdate picture "@d"
      *   @ 3,1 say "Commission Rate:        %  "
      *   @ 3,19 get percent picture '99'
      read
 *     lastk=lastkey()
 *     enddo
      deactivate window getcur
      release window getcur
      restore screen from sc
         if period=0
            period=((meffdate-mfrom)+1)
         endif
*        number=(newamount-oldamount)*(((meffdate-mfrom)+1)/365)*(percent/100)
        number=(newamount-oldamount)*(period/365)*(percent/100)
*        replace coverage.effdate with meffdate
   case option=5
        number=0
   case option=6
         if period=0
            period=((meffdate-mfrom)+1)
         endif
*        number=oldamount*(((meffdate-mfrom)+1)/365)*(percent/100)
        number=oldamount*(period/365)*(percent/100)
endcase

*number=(((mto-meffdate)/365)*percent)*(newamount-oldamount)
return number



***************************************************************************
*                     do a report on policy
***************************************************************************
procedure polreport
         hide popup pactions

if !used('installm')
   select 11
   use installm index install alias installment
else
   select installment
endif
select 22
pid=policy.dpid
name=fname("temp.dbf")
if file(name)
   ?? chr(7)
    wait window "A report is being produced by somebody else" timeout 1
    wait window "Please try again later" nowait
   return
endif

if val(sys(12))<150000
   ?? chr(7)
    wait window "This machine does not have enough memory for this report" timeout 1
    wait window "Try it on the SERVER" nowait
   return
endif

size=diskspace()
if size<500000
   ?? chr(7)
   wait window "Server Disk is almost full" timeout 1
   ?? chr(7)
   wait window "If you continue you might run into problems" nowait
   tf =acertain("Continue with program ?",.f.)
   if tf=.f.
      do getout
   endif
endif

WAIT WINDOW "Setting things up" NOWAIT
select vehicle
*set relation to
*select coverage
*set relation to vin into vehicle
*select a.vin,a.dtotal,a.bdyinjl,a.propdmgl,a.medpcov,a.stunmot,a.lmtprov,;
*       b.year,b.make,b.condpur,b.purmo,b.puryr,b.cost,b.dterritor,b.drateclass,;
*       c.doption1,c.doption2,c.to,c.from,;
*       c.dinst1,c.dinst2,c.dinst3,c.dinst4,;
*       c.ddate1,c.ddate2,c.ddate3,c.ddate4;
*       from coverage a, vehicle b ,policy c ;
*       where a.dpid=pid and b.vin=a.vin and c.dpid=a.dpid and c.iidno=a.iidno;
*       into dbf &name
select a.vin,a.dtotal,a.bdyinjl,a.propdmgl,a.medpcov,a.stunmot,a.lmtprov,;
       b.year,b.make,b.condpur,b.purmo,b.puryr,b.cost,b.dterritor,b.drateclass,;
       c.doption1,c.doption2,c.to,c.from,c.dpid,c.acctno;
       from coverage a, vehicle b ,policy c ;
       where a.dpid=pid and b.vin=a.vin and c.dpid=a.dpid and c.iidno=a.iidno;
       into dbf &name

*browse
wait clear
go top
*rowse
*do while !eof('temp')
*   if temp.doption1=.t.
*      replace temp.dinst1 with temp.dtotal*0.3
*      replace temp.dinst2 with temp.dtotal*0.7
*      time=ctod(temp.from)+90
*      replace temp.ddate1 with ctod(temp.from)
*      replace temp.ddate2 with time
*   endif
*   if temp.doption2=.t.
*      replace temp.dinst1 with temp.dtotal*0.25
*      replace temp.dinst2 with temp.dtotal*0.25
*      replace temp.dinst3 with temp.dtotal*0.25
*      replace temp.dinst4 with temp.dtotal*0.25
*      time=(ctod(temp.to)-ctod(temp.from))/4
*      replace temp.ddate1 with ctod(temp.from)+time
*      replace temp.ddate2 with ctod(temp.from)+(time*2)
*      replace temp.ddate3 with ctod(temp.from)+(time*3)
*      replace temp.ddate4 with ctod(temp.from)+(time*4)
*   endif
*   if temp.doption1=.f. and temp.doption2=.f. && assume option 1
*      replace temp.dinst1 with temp.dtotal*0.3
*      replace temp.dinst2 with temp.dtotal*0.7
*      time=ctod(temp.from)+90
*      replace temp.ddate1 with ctod(temp.from)
*      replace temp.ddate2 with time
*   endif
*   skip
*enddo
*browse

select temp
go top


     selection=spf()
     restore from "comem.mem" additive
     do case
        case selection=1

            if temp.doption1=.t.
               =setpglen()
               SELECT TEMP
               GO TOP
                A=FNAME("POL.REP")
                REPORT FORM POLSUM11 TO FILE &A NOCONSOLE
               SELECT INSTALLMEN
               GO TOP
               report form installm for INSTALLMEN->dpid=POLICY->DPID TO FILE &A ADDITIVE NOCONSOLE
                save screen to q

        set topic to "EDITOR"
        if wexist('editor')
           release window editor
        endif
        set color to
*        set color of scheme 8 to gr+/b,gr+/b,n/w
        on key label f10 keyboard "{ctrl+w}"
        define window editor at 1,1 size 25,80 in desktop system shadow float grow;
          color scheme 8 font "FizedSys",11;
          Title 'Report Viewer Screen';
          footer "Press  to Move , <PGUP> <PGDN> to Move Fast, <ESC> to Exit"
        save screen to sc

*        set color of scheme 8 to gr+/b,gr+/b,n/w
*       activate window editor
                        modify file (a) noedit
       deactivate window editor
       release window editor
       restore screen from sc
       on key label f10
               DELETE FILE &A
            else
            if temp.doption2=.t.
               =setpglen()
               SELECT TEMP
               GO TOP
               A=FNAME("POL.REP")
               report form polsum21 TO FILE &A NOCONSOLE

               SELECT INSTALLMEN
               GO TOP
               report form installm for INSTALLMEN->dpid=POLICY->DPID TO FILE &A ADDITIVE  NOCONSOLE
        set topic to "EDITOR"
        if wexist('editor')
           release window editor
        endif
        set color to
*        set color of scheme 8 to gr+/b,gr+/b,n/w
        on key label f10 keyboard "{ctrl+w}"
        define window editor at 1,1 size 25,80 in desktop system shadow float ;
          color scheme 8 font "FizedSys",11;
          Title 'Report Viewer Screen';
          footer "Press  to Move , <PGUP> <PGDN> to Move Fast, <ESC> to Exit"
        save screen to sc

*        set color of scheme 8 to gr+/b,gr+/b,n/w
*       activate window editor
                        modify file (a) noedit
       deactivate window editor
       release window editor
       restore screen from sc
       on key label f10
               DELETE FILE &A
            else
               =setpglen()
               SELECT TEMP
               GO TOP
                A=FNAME("POL.REP")
                REPORT FORM POLSUM11 TO FILE &A NOCONSOLE
               SELECT INSTALLMEN
               GO TOP
               report form installm for INSTALLMEN->dpid=POLICY->DPID TO FILE &A ADDITIVE NOCONSOLE
        set topic to "EDITOR"
        if wexist('editor')
           release window editor
        endif
        set color to
*        set color of scheme 8 to gr+/b,gr+/b,n/w
        on key label f10 keyboard "{ctrl+w}"
        define window editor at 1,1 size 25,80 in desktop system shadow float ;
          color scheme 8 font "Fixedsys",11;
          Title 'Report Viewer Screen';
          footer "Press  to Move , <PGUP> <PGDN> to Move Fast, <ESC> to Exit"
        save screen to sc

*        set color of scheme 8 to gr+/b,gr+/b,n/w
*       activate window editor
*                        modify file (a) window editor noedit
                        modify file (a) noedit

       deactivate window editor
       release window editor
       restore screen from sc
       on key label f10
               DELETE FILE &A
           ENDIF
          ENDIF
        case selection=2
            do prnchoic
            wait window "Now Printing Report. Please Wait" nowait
            if temp.doption1=.t.
               =setpglen()
               SELECT TEMP
               GO TOP
               report form polsum1 to print noconsole
               SELECT INSTALLMEN
               GO TOP
               report form installm FOR INSTALLMEN->dpid=POLICY->DPID  to print noconsole
            else
            if temp.doption2=.t.
               =setpglen()
               SELECT TEMP
               GO TOP
               report form polsum2 to print noconsole
               SELECT INSTALLMEN
               GO TOP
               report form installm FOR INSTALLMEN->dpid=POLICY->DPID  to print noconsole
            else
               =setpglen()
               SELECT TEMP
               GO TOP
               report form polsum1 to print noconsole
               SELECT INSTALLMEN
               GO TOP
               report form installm FOR INSTALLMEN->dpid=POLICY->DPID  to print noconsole
            endif
            ENDIF
            wait clear
      case selection=3
           do laser with "polsum","policy->dpid="+alltrim(str(policy->dpid))
      endcase
SELECT TEMP
USE
select coverage
*set relation to
*select vehicle
*set relation to vin into coverage
name=fname("temp.dbf")
delete file &name
select policy
presult=10
return




******************************************************************************
*                    Procedure select old vehicles
******************************************************************************
function selectoldvehs
parameter mnumber,pid
private howmany,i,j,k,totvehs,screens
declare temprecs[8]

set color to gr+/b
@7,2 say 'Vehicle ID           Year Make                 Model and Style        Premium'
@8,0 to 8,79
set color to w+/b

on key label f10 keyboard "{ctrl+w}"
on key label enter
@24,0 say space(80)
=center(24,'Use UP,DOWN,PGUP,PGDOWN to move, ENTER to De/Select, F10 to End')
for i=1 to 8
    temprecs[i]=0
endfor
  select coverage
  olfilter=filter()
* set filter to
*  set filter to  ( (acctno=client->acctno)  and ( iidno=mnumber) and (DACTIVE=.F. OR DACTIVE=.T.) )
 set filter to  ( (acctno=client->acctno)  and ( iidno=mnumber) and ((dpid=0) or (dpid=pid)) )
  count to totvehs
  go top
  screens=ceiling(totvehs/4)

  row=8
  i=0
  finished=.f.
  howmany=0
  set cursor off
  do while ( (finished=.f.) )
      @ row+1,0 to row+9,79 clear
      j=1
      do while ((j<=8) and (.not. eof()) )
       amount=coverage.dtotal
       if (Amount >0 )
       @row+j,2 say vehicle->vin+' '+vehicle->year+' '+vehicle->make+' '+left(vehicle->modst,20)+str(amount)
       if DPID=POLICY.DPID
          covselected[i*4+j]=RECNO('coverage')
          oldselected[i*4+j]=RECNO('coverage')
       endif
       temprecs[j]=recno('coverage')
       if covselected[i*4+j] <>0
          @ row+j,1 say "*" color gr+/b
       endif
       j=j+1
       endif
       skip
      enddo
      clear gets
      j=j-1
      current=0
      going=.t.
      do while (going=.t.)
      @ row+1+current,0 say ">" color r+/b
        read
        lkey=lastkey()
        do case
           case lkey=DOWN
              if current<(j-1)
                @row+1+current,0 say " "
                current=current+1
              endif
           case lkey=UP
              if current>0
                @row+1+current,0 say " "
                current=current-1
              endif
           case lkey=SELECTkey
                if (covselected[i*4+current+1]=0)
                   @row+1+current,1 say "*" color gr+/b
                   covselected[i*4+current+1]=temprecs[current+1]
                   howmany=howmany+1
                else
                    if (oldselected[i*4+current+1]=0)
                       @row+1+current,1 say ' '
                       covselected[i*4+current+1]=0
                       howmany=howmany-1
                    endif
                endif
           case lkey=PREVIOUS
                if i>0
                   i=i-1
                   go i*4+1
                   going=.f.
                endif              
           case lkey=NEXT
                if i<(screens-1)
                   i=i+1
                   going=.f.
                endif
           case lkey=ENDKEY
             tf=acertain('Is this your Final Choice ?',.t.)
             if tf
               finished=.t.
               gooddata=.t.
*               do dispvehs with screens,mnumber
               exit
              endif
           case lkey=QUITKEY
                finished=.t.
                gooddata=.f.
                exit
           otherwise
                ?? chr(7)
        endcase
*        @ 24,0 say str(i)+str(current)+str(i*4+current+1)
      enddo
  enddo
  set cursor on
  on key label f10
  on key label enter
return howmany



***************************************************************************
*                     post activity
***************************************************************************
function ppost_act
PARAMETER INVOICE,dACCTNO,TRANCD,QTY,PRICE,TOTAL,DATE,CLERK,DECRIPTION,POSTED,;
          BILLED,CHECKNO,VVID,efdate,polno,cchange,ccom,pid


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
                comchange    with      cchange,;
                chamount    with       ccom,;
                dpid        with       pid

RETURN


*****************
procedure changpol
private mrec
hide popup pactions
*hide menu _msysmenu
save screen to w
select policy
mrec=recno('policy')
	do polchang with client.acctno
close databases	
=initpolsystem()
select policy
goto (mrec)
*clear
*do poldisplay
restore screen from w
*show menu _msysmenu
return


*****************
procedure grabdata
private plocked
PLOcked=.f.
if lock(alltrim(str(recno())),'policy')=.f.
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   return plocked
else
  plocked=.t.
endif
a=fname("data.ins")
if file( a )
   wait window "Retrieving" nowait
   append memo policy.dmemo from &a
   DELETE FILE &A
   do edtmemo
else
    wait window "No external data found !" nowait
    a=getfile('???','Please Select Text File to Import','IMPORT',0)
    if len(a)>0 .and. lastkey()<>27
        append memo policy.dmemo from &a
        do edtmemo
    endif
endif
    unlock in policy
return

*****************
procedure edtmemo
private sc,plocked
PLOcked=.f.
if lock(alltrim(str(recno())),'policy')=.f.
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   return plocked
else
  plocked=.t.
endif
        set topic to "EDITOR"
        if wexist('editor')
           release window editor
        endif
        set color to
        on key label f10 keyboard "{ctrl+w}"
        define window editor from 4,0 to 19,79 system shadow float ;
                      color scheme 10 ;
                      footer "Press <F10> to Save, <ESC> to Abort"
on key label f10 keyboard "{ctrl+w}"

        save screen to sc
        set color to gr+/b
        on key label f10 keyboard "{ctrl+w}"
        modify memo policy.dmemo nomenu in screen
        restore screen from sc
        on key label f10
        unlock in policy
             * Activity posting
             MINVOICENO=0
             MACCTNO   =client->acctno
             MTRANCODE =6604
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MDESCRIPT ="Policy Free Data Edited"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
             DVID      =Coverage->VIN
             polno=policy.policyno
             cchange=.t.
             ccom=premium
             =ppost_act(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID,;
                       policy.effdate,polno,cchange,ccom,policy.dpid)
             select policy
return

*****************
procedure expdata
          b=sys(5)+"\memo.txt"
          copy memo policy.dmemo to (b)
          wait window "File '"+upper(b)+"' created"
return


*****************
procedure prmemo
DO PRNCHOIC
wait window "Now printing" nowait
rec=recno('POLICY')
a=fname('comem')
restore from &a additive
report form PLmemo for recno('POLICY')=rec to print noconsole
wait clear
return

*******************************************************************
* delete policy
*******************************************************************
procedure poldelete
          SELECT POLICY
          if deleted()
             return
          endif
          tf=warn()
          if tf
               select policy
               tf=acertain('DELETE REALLY?',.f.)
               if ( (tf=.t.) and !recused('policy',recno()) )
                  delete
*                 replace coverage.dactive with .f. for ((coverage.dpid=policy.dpid) and (coverage.iidno=policy.iidno) )
                  select coverage
                  count to many
                  if many<1
                     return
                  endif
                  go top
                  wait window "Please Wait, deactivating Coverages" nowait
                  do while !eof('coverage')
                   do WHILE lock(alltrim(str(recno())),'coverage')=.f.
                      wait window 'Premium Edited by Another User,Trying to lock again' NOWAIT
                   enddo
                   replace coverage.dactive with .f.,;
                           COVERAGE.DPID WITH 0
                   unlock in coverage
                  skip
                  enddo
                 wait clear
               endif
          endif
          unlock in policy
return




*******************************************************************
*        procedure undelete policy
*******************************************************************
procedure polundelete
          SELECT POLICY
          if !deleted()
             return
          endif
          recall
          unlock in policy
          wait window "Please Wait, Reactivating Coverages" nowait
          tf=acertain('UNDELETE REALLY?',.t.)
         if ( (tf=.t.) and !recused('policy',recno()) )
          select coverage
          count to many
          if many<1
             return
          endif
          go top
          do while !eof('coverage')
*          replace coverage.dactive with .t. for ((coverage.dpid=policy.dpid) and (coverage.iidno=policy.iidno) )
           do WHILE lock(alltrim(str(recno())),'coverage')=.f.
              wait window 'Premium Edited by Another User,Trying to lock again' NOWAIT
           enddo
           replace coverage.dactive with .t.
           unlock in coverage
          skip
          enddo
        endif
          wait clear
          unlock in policy
return


******************************************************************************
*                        Invoice
******************************************************************************
procedure poinv

 ?? chr(7)
 ?? chr(7)

wait window "Please Create an invoice for the installments" timeout 3
return

MENUDEF=.F.
         if popup()='PACTIONS'
            menudef=.t.
         endif
         if menudef
            hide popup pactions
         endif

         SAVE SCREEN TO OPTSC
         a=fname('opt1sc.mem')
         delete file &a
         SAVE all like optsc* TO &a

         if menudef
            hide popup memopop
         endif
*         if menudef
*            hide menu _msysmenu
*         endif
*              do invmenu WITH client->acctno
SET COLOR TO n/n
@ 0,0 say space(80)
SET COLOR TO GR+/n
=center(0,'Receipt Processing')
SET COLOR TO GR+/R
@ 24,0 say space(80)
on key label f10 keyboard "{ctrl+w}"
=CENTER(24,"Press <F10> to Select an Installment")
               do instselect
         a=fname('opt1sc.mem')
         RESTORE from &a additive
         RESTORE SCREEN FROM OPTSC
*         result=1
         select invoice
        set order to tag acctno
         set filter to
return

procedure instselect
         if !used('paycode')
            select i
            use paycode index paynum alias paycode
         else
             select paycode
         endif


         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
         endif
         set relation to dtype into paycode

many=0
count to many for dtype<>' ' and dpid=policy->dpid
if many<1
   ?? chr(7)
   wait window "None of this policy's Installments were Paid" timeout 3
   return
endif

    if wexist('browser')
      release window browser
    endif


       define window browser from 6,0 to 15,77;
              Title "Press <F10> to select Installment,<ESC> to Exit" color scheme 10 float system shadow in desktop
on key label f10 keyboard "{ctrl+w}"

on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"

    browse fields ddate:h=" Date", ;
                  Dreason:h="Reason",;
                  dpayment:h="Amount",;
                  DTYPE:H="T":V=( ((val(dtype)>=1).and.(val(dtype)<=8)) .or. (dtype=' ') ),;
                  PAYDATE:H="Date Paid":W=DTYPE<>' ',;
                  Comments:10:h=" Comments ":W=DTYPE<>' ',;
                  paycode->dpayname:10:h="Way of Payment",;
                  receiptno:5:r:h="Recpt";
				  for (dpid=policy->dpid .and. dtype<>' ' ) ;
				  window browser color scheme 10;
                  nomenu nomodify ;
                  Title "Press <F10> to select Installment,<ESC> to Exit"
on key label f10 keyboard "{ctrl+w}"
on key label f10
on key label enter
release window browser
if lastkey()=27
   return
else


*   outp=spf()


   select installmen
   rec=recno()
   if receiptno=0
      mreceipt=getrecno()
      replace receiptno with mreceipt
   endif
   restore from comem.mem additive

   do prnchoic
   wait window "Now Printing" nowait
   Report form receipt for recno('installmen')=rec to print noconsole
   wait clear

endif
select policy
unlock in policy
return




procedure spawninstalls
          if popup()='PACTIONS'
             hide popup pactions
          endif
do instlmen with client.acctno,policy.dpid
return





******************************************************************************
*                        application
******************************************************************************
procedure oldpoapp
private rec
         hide popup pactions
         save screen to sc1
              a=fname('opt1sc.mem')
         delete file &a
         save all like sc* to &a
*         release all like sc*
         a=fname('autoins.mem')
         delete file &a
         rec=recno('policy')
         mdpid=policy->dpid
         wait window str(policy->dpid)
         save to &a
*         release all like sc*
         wait window "Coming up" nowait
*         clear memory
                           set deleted on
                             if lock(alltrim(str(recno())),'Policy')=.f.
                                ?? chr(7)
                                wait window 'This Policy is edited by Another User' timeout 1
                                wait window 'The Information might Change' timeout 1
                             endif
                           do applicat
close databases

*        SET FILTER TO
*         select policy
*         unlock in policy
*         set relation to acctno into invoice
         a=fname('autoins.mem')
         restore from &a additive
         a=fname('opt1sc.mem')
         restore from &a additive
*         RESTORE SCREEN FROM SC1
         =initpolsystem()
         select policy
         locate for dpid=mdpid
                  wait window str(policy->dpid)
         do poldisplay
return



******************************************************************************
*                        application
******************************************************************************
procedure poapp
         hide popup pactions
         save screen to sc1
         rec=recno('policy')
         wait window "Coming up" nowait
                           set deleted on
                           push menu _msysmenu
                             if lock(alltrim(str(recno())),'Policy')=.f.
                                ?? chr(7)
                                wait window 'This Policy is edited by Another User' timeout 1
                                wait window 'The Information might Change' timeout 1
                             endif
                           do applicat
		              
		              pop menu _msysmenu             
		close databases
		set deleted off
		
         tf=initpolsystem()
         select policy
         goto (rec)
         do poldisplay
return

******************************************************************************
*                        tml
******************************************************************************
procedure idtml
hide popup pactions
?? chr(7)
wait window "Not implemented yet" Nowait
return


******************************************************************************
*                       Reinstate
******************************************************************************
PROCEDURE UNRENEWPOL
tf=.f.
TF=ACERTAIN("Toggle Policy Renewal flag ?",.F.)
if tf
     if policy.renewed=.t.
        REPLACE POLICY.RENEWED WITH .F.
     else
        REPLACE POLICY.RENEWED WITH .t.
     endif
        do poldisplay
endif
RETURN

******************************************************************************
*                     Display the financial info
******************************************************************************
PROCEDURE DISPFIN
set color to
set color to gr+/b
     @18,0 SAY 'Premium includes $1 per vehicle for enforcement' color gr+/b
     @ 19, 2 Say 'Option  1'
     @ 20, 2 Say '30% - 70%'
     @ 19,16 Say 'Option 2  '
     @ 20,15 Say '25% + 5 x 15%'
     @ 19,12 get option1 picture 'Y' when option2=.f.
     @ 19,25 get option2 picture 'Y' when option1=.f.
     @ 21,2 say "Commission Rate:" get comrate picture '99.9'
     @ 21,24 say "%"
     @ 19,44 say "Total Policy Premium:" get premium picture '99999999.99'
     @ 20,40 say "Total Commission Premium:" get totcom picture '99999999.99'
     @ 21,39 say "Total Commission Received:" get totcomrec picture '99999999.99'
     @ 22,0 SAY 'FS75:' GET MFS75  SIZE 1,8
     @ 23,0 SAY 'FS75:' GET MFS752 SIZE 1,8
     @ 22,14 say "TML#:" get mtml SIZE 1,12
 clear gets
RETURN



******************************************************************************
*                       get the financial info
******************************************************************************
procedure getfin

     set color to gr+/r
     @ 24,0 say space(80)
     =center(24,"Press <F10> to Accept or <ESC> to get out")

      acceptance=.f.
      on key label f10 keyboard "{ctrl+w}"
      do while acceptance=.f.


		    set color to 
           set color to gr+/b

@18,0 SAY 'Premium includes $1 per vehicle for enforcement' color gr+/b
@ 19, 2 Say 'Option  1'
@ 20, 2 Say '30% - 70%'
@ 19,16 Say 'Option 2  '
@ 20,15 Say '25% + 5 x 15%'
@ 19,12 get option1 picture 'Y' when option2=.f.
@ 19,25 get option2 picture 'Y' when option1=.f. VALID CPRE(OPTION2)
@ 21,2 say "Commission Rate:" get comrate picture '99.9' valid ccom (premium,comrate)
@ 21,24 say "%"
@ 19,44 say "Total Policy Premium:" get premium picture '99999999.99' valid ccom(premium,comrate)
@ 20,40 say "Total Commission Premium:" get totcom picture '99999999.99'
@ 21,39 say "Total Commission Received:" get totcomrec picture '99999999.99' disabled color ,,,,,,,,r+/b,r+/b
@ 22,0 SAY 'FS75:' GET MFS75  SIZE 1,8
@ 23,0 SAY 'FS75:' GET MFS752 SIZE 1,8
@ 22,14 say "TML#:" get mtml SIZE 1,12

           read cycle

           if lastkey()=27
              exit
           endif
           IF LASTKEY()=23   && CONTROL W
                ACCEPTANCE=.T.
           ENDIF
 enddo
return


******************************************************************************
*                      calculate new commision
******************************************************************************
function ccom
parameter premium,comrate
 totcom=premium*(comrate/100)  && calcom
 oldpre=premium-24
 show get totcom
return .t.

******************************************************************************
*                      calculate new premium
******************************************************************************
FUNCTION   CPRE
parameter option2
*if option2=.t.
*        premium=oldpre+24
*else
*        premium=oldpre
*endif
show get premium
return .t.



*******************************************************************************
*                        Update Invoice
*******************************************************************************
procedure poedinv
*          hide menu _msysmenu
          hide popup pactions
          hide popup invpop
         SAVE SCREEN TO OPTSC
              a=fname('opt1sc.mem')
         delete file &a
         SAVE all like optsc* TO &a
*         hide menu mainmenu
*                             hide popup poptions
*                             hide popup poins
              do edinv WITH client->acctno,policy->dpid
         a=fname('opt1sc.mem')
         RESTORE from &a additive
         RESTORE SCREEN FROM OPTSC
         select invoice
        set order to tag acctno
         set filter to
         select policy
*show popup invpop
*show popup pactions
*show menu _msysmenu
return





*******************************************************************************
*                        cREATE INVOICE
*******************************************************************************
procedure INVOICE
*          hide menu _msysmenu
          hide popup pactions
*         hide popup invpop
         SAVE SCREEN TO OPTSC
              a=fname('opt1sc.mem')
         delete file &a
         SAVE all like optsc* TO &a
*         hide menu mainmenu
*        hide popup poptions
*        hide popup poins
             do invMENU WITH client->acctno,POLICY->DPID
         a=fname('opt1sc.mem')
         RESTORE from &a additive
         RESTORE SCREEN FROM OPTSC
         select invoice
         set order to tag acctno
         set filter to

         select policy
*show popup invpop
show popup pactions
*show menu _msysmenu
return



*******************************************************************************
*                        get cancellation date
*******************************************************************************
function candate
if !used('document')
   select 14
   use document index polid alias document
else
   select document
endif
set order to tag dpid
set filter to "CANCEL" $ document.doctype .and. dpid=policy->dpid
count to howmany
if howmany>0
   go bottom
   mdate=recdate
else
   mdate={  /  /  }
endif
set filter to
use
select policy
return dtoc(mdate)



*******************************************************************************
*                        get 1 date
*******************************************************************************
function get1date
parameter when
save screen to wm
release window dates
define window dates from 3,20 to 6,70 Title '[ DATE ]' shadow float COLOR SCHEME 10
activate window dates

lk=27
SET COLOR TO N/W,W/BG+
CLEAR
start=CTOD(when)
do while lk = 27
      =center(0,message)
      @1,19 get start picture '@d'
      read
      lk=lastkey()
enddo
deactivate window dates
release window dates
restore screen from wm
return DTOC(start)



***************************************************************************
* Calculate correct percentages
***************************************************************************
function calcpers
result=.t.


if downpercent>100 .or. downpercent<=0 .or. noinsts<0
   return .f.
endif

if downpercent=100 and noinsts>0
   return .f.
endif

if downpercent=100
   noinsts=0
   remainingPERCENT=0
   servicecharge=0
   tempdown=(premium*DOWNPERCENT)/100.00
   temppay=(premium*REMAININGPERCENT)/100.00
   show gets
   return .t.
endif

remainingPERCENT=(100-downpercent)/noinsts

tempdown=((premium*DOWNPERCENT)/100.00)+SERVICECHARGE
temppay=((premium*REMAININGPERCENT)/100.00)+SERVICECHARGE
*wait window alltrim(str(downpercent))+" "+alltrim(str(noinsts))
wait window "Percent per remaining payment "+alltrim(str(remainingPERCENT))+"% for "+;
     alltrim(str(noinsts))+" Installments" nowait
show gets
return .t.



function svcchg
if noinsts=0
   servicecharge=0
   downpercent=100
endif
show gets
return .t.


procedure rpol
do renewpol
do poldisplay
return



*
* This function looks like it returns the values backwards 
* but it is only used by the menus
*
function inactvplcy
if policy->renewed=.t. .or. policy->dcanceled=.t.
	return .t.
else 
	return 	.f.
endif
	
endif

return



procedure preplpolno
define window wpol at 1,1 size 25,80 in desktop system nogrow noclose title "Policy Editing Window" font "FixedSys",9 color scheme 4
activate window wpol

	do poldisplay
	set color to
	set color to gr+/b
	do replpolno
	
deactivate window wpol
release window wpol

return