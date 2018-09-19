
parameter macctno

define window wchange at 1,1 size 25,81 in desktop shadow float grow noclose font "FixedSys",9;
	color scheme 10 Title "Change of Policy Forms Processing"

activate window wchange


set color to gr+/bg,w+/b
clear
set color to
@ 1,0 say space(80)
set color to gr+/bg,w+/b


wait window "Counting Please Wait" nowait

set procedure to various

  if !used('activity')
     SELECT 24
     USE ACTIVITY index activity,DATE ALIAS ACTIVITY
  ELSE
     SELECT ACTIVITY
  ENDIF
  set order to tag acctno
  changes=0
  count to changes for (acctno=macctno and (dtrancode=8003 or dtrancode=8009) and dpid=policy.dpid)
  if changes=0
  	 wait clear
         ?? chr(7)
         wait window "Nothing to do! No Changes" timeout 2
*         wait window str(changes)
         release window wchange
  return
  endif
  wait clear
*set filter to (acctno=macctno and (dtrancode=8003 or dtrancode=8009) )

**set color to gr+/n
=center(24,"Press F10 or Enter to Select Change")
on key label Enter keyboard "{ctrl+w}"
on key label f10 keyboard "{ctrl+w}"
*browse fields      DDESCRIPT:h="Description",;
*                   ACCTNO:h="Act#",;
*                   client.lastn:h="Last Name",;
*                   DTRANCODE:h="Code",;
*                   DDATE:h=" Date ",;
*                   DDESCRIPT:h="Description",;
*                   DVIN:h="Vehicle ID",;
*                   POLICYNO:H="Policy No",;
*                   EFFDATE:h="E Date" noMODIFY
go bottom
define window browser at 5,5 size 15,71 in desktop shadow float nogrow noclose font "Arial",11;
	color scheme 10 Title "Select a Change Order"

browse fields      DDESCRIPT:h="Description",;
                   DTRANCODE:h="Code",;
                   DDATE:h=" Date ",;
                   DDESCRIPT:h="Description",;
                   DVIN:h="Vehicle ID",;
                   POLICYNO:H="Policy No",;
                   EFFDATE:h="E Date" ;
                   for (acctno=macctno and (dtrancode=8003 or dtrancode=8009) and dpid=policy.dpid);
                   noedit nomenu title "Select Change" window browser 

release window browser
                   
on key label enter
@ 24,0 say space(80)
record=recno("activity")
*set filter to

if lastkey()=27
   on key label f10
   return
endif

*******************************************************************************
*                                       get all the data
*******************************************************************************
if activity.dtrancode=8003
   vadded=.t.
   vremoved=.f.
else
    vadded=.f.
    vremoved=.t.
endif
mpolno=policy.policyno
miname=icompany->iname
mlastn=alltrim(client.lastn)+' '+alltrim(client.firstn)+' '+alltrim(client.mi)
temp=mlastn
mlastn=temp+space(30-len(temp))
mvin=activity.dvin

select vehicle
*vrec=recno('vehicle')
seek mvin
mmake=vehicle.make
myear=vehicle.year
mmodel=vehicle.modst
*mmodel="SEDAN"
mmtow=0
mregst='NY'
muse='PLEASURE'
select activity

IF FILE("comem.mem")
   RESTORE FROM comem ADDITIVE
   coconame=SUBSTR(coconame+SPACE(30),1,20) && Pad coany name to 35 chars
   coaddr1=SUBSTR(coaddr1+SPACE(30),1,20)       && Pad addr. line 1 to 35 chars
   coaddr2=SUBSTR(coaddr2+SPACE(30),1,20)       && Pad addr. line 2 to 35 chars
   cophone=SUBSTR(cophone+SPACE(13),1,11)       && Pad phone num. to 13 chars
ELSE
    ?? chr(7)
    wait window "No Company Info Availlable" timeout 1
    wait window "Please go To Maintenance and Fix" nowait
    on key label f10
    return
endif
clear
set color to
@ 1,0 say space(80)
set color to gr+/bg,w+/b
do dispdata
do change with record
on key label f10
release window wchange
return



***************************************************************************
*                     Print Change Form
***************************************************************************
procedure printform
do prnchoic
wait window "Printing" nowait
set printer on
set console off
temp=space(80)
temp=stuff(temp,1,len(miname),miname)
temp=stuff(temp,40,len(coconame),coconame)
? temp
? '  '
temp=space(80)
temp=stuff(temp,40,len(coaddr1),coaddr1)
? temp
? '  '
temp=space(80)
temp=stuff(temp,40,len(coaddr2),coaddr2)
? temp
? '  '
temp=space(80)
temp=stuff(temp,1,len(mpolno),mpolno)
marcode=left(cophone,3)
mphone=substr(cophone,4,8)
temp=stuff(temp,49,3,marcode)
temp=stuff(temp,54,8,mphone)
? temp
? '  '
temp=space(80)
temp=stuff(temp,1,len(mlastn),mlastn)
?temp
? ' '
if vadded=.F.
   temp=space(80)
   temp=stuff(temp,20,4,myear)
   temp=stuff(temp,40,20,left(mmake,20))
   temp=stuff(temp,51,29,left(mvin,29))
   ?temp
   ? space(11)+'X'
for i=1 to 28
    ? ' '
endfor
? space(17)+"X"
else
    ? ' '
    ? ' '
    ? ' '
    ? ' '
   temp=space(80)
   temp=stuff(temp,17,4,myear)
   temp=stuff(temp,22,10,left(mmake,10))
   temp=stuff(temp,40,15,left(mmodel,15))
   temp=stuff(temp,65,14,left(mvin,14))
   ??? chr(27)+"M"  && 12 CPI
   ?temp
   ? ' '
   temp=space(80)
   temp=stuff(temp,42,len("RESIDENCE"),"RESIDENCE")
   temp=stuff(temp,77,2,mregst)
*   ? space(11)+'X'
    ? TEMP
    ? space(13)+'X'
    ? SPACE(17)+'X'+space(18)+ALLTRIM(STR(mmtow))
*   mmtow
    ??? chr(27)+'P'  && 10 CPI
    for i=1 to 21
        ? ' '
    endfor
    ? space(17)+"X"
endif
set console on
set printer off
wait clear
return


procedure chquit
	lastk=1
return

***************************************************************************
*                     Change of policy menu
***************************************************************************
procedure change
parameter record

DEFINE MENU chmenu bar at line 0 COLOR SCHEME 10
DEFINE PAD Edit  OF chmenu  PROMPT '\<Edit'  
DEFINE PAD Print OF chmenu  PROMPT '\<Print'
DEFINE PAD Quit  OF chmenu  PROMPT '\<Quit' 

on selection pad edit of chmenu do eddata
on selection pad print of chmenu do printform
on selection pad quit of chmenu do chquit

lastk=27
do while lastk=27
  ACTIVATE MENU chMENU
enddo
return


***************************************************************************
*                         Edit of Change data
***************************************************************************
procedure eddata
wait window "Editing" nowait
**set color to g/n,w+/n
@ 2,0 to  24,79 clear
@ 23,0 to 23,79
**set color to gr+/n
=center(24,"Press F10 to Accept the Data")
*set color to g/n,b/w

@ 3,01 say "Insurance Company:" get miname picture replicate('X',30)
@ 4,05 say "Policy Number:" get mpolno picture replicate('X',30)
@ 5,03 say "Name of Insured:" get mlastn picture replicate('X',30)
@ 3,50 say "Company:" get coconame picture replicate('X',20)
@ 4,51 say "Street:" get coaddr1 picture replicate('X',20)
@ 5,53 say "City:" get coaddr2 picture replicate('X',20)
marcode=left(cophone,3)
mphone=substr(cophone,4,8)
@ 6,52 say "Phone: (   )"
@ 6,60 get marcode picture "999"
@ 6,65 get mphone picture "999-9999"
*set color to rb+/n
if vadded=.t.
   =center(7,"Vehicle Addition")
else
   =center(7,"Vehicle Deletion")
endif
*set color to g/n,b/w
@ 10,16 say "Year:" get myear picture '9999'
@ 11,16 say "Make:" get mmake picture replicate('X',20)
@ 12,15 say "Model:" get mmodel picture replicate('X',20)
@ 13,10 say "Vehicle ID:" get mvin picture replicate('X',20)
@ 14,01 say "State Registered In:" get mregst picture 'AA'
*@ 15,1 say "Use"
@ 15,7 say  "Miles To Work:" get mmtow picture '9999'
read cycle
*mmake=upper(mmake)
*mmodel=upper(mmodel)
*mlastn=upper(mlastn)
select activity

cophone=marcode+mphone
do dispdata
return


***************************************************************************
*                         Edit of Change data
***************************************************************************
procedure dispdata
wait window "Editing" nowait
*set color to g/n,w+/n
@ 2,0 to  24,79 clear
@ 23,0 to 23,79
*set color to gr+/n
=center(24,"Press F10 to Accept the Data")
*set color to g/n,w+/n

@ 3,01 say "Insurance Company:" get miname picture replicate('X',30)
@ 4,05 say "Policy Number:" get mpolno picture replicate('X',30)
@ 5,03 say "Name of Insured:" get mlastn picture replicate('X',30)
@ 3,50 say "Company:" get coconame picture replicate('X',20)
@ 4,51 say "Street:" get coaddr1 picture replicate('X',20)
@ 5,53 say "City:" get coaddr2 picture replicate('X',20)
marcode=left(cophone,3)
mphone=substr(cophone,4,8)
@ 6,52 say "Phone: (   )"
@ 6,60 get marcode picture "999"
@ 6,65 get mphone picture "999-9999"
*set color to rb+/n
if vadded=.t.
   =center(7,"Vehicle Addition")
else
   =center(7,"Vehicle Deletion")
endif
*set color to g/n,w+/n
@ 10,16 say "Year:" get myear picture '9999'
@ 11,16 say "Make:" get mmake picture replicate('X',20)
@ 12,15 say "Model:" get mmodel picture replicate('X',20)
@ 13,10 say "Vehicle ID:" get mvin picture replicate('X',20)
@ 14,01 say "State Registered In:" get mregst picture 'AA'
*@ 15,1 say "Use"
@ 15,7 say  "Miles To Work:" get mmtow picture '9999'
select activity

cophone=marcode+mphone
clear gets
return

