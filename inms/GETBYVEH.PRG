
private number
set color to w/rb+,w/bg+
define window cVINFO from 9,5 to 14,67 color scheme 10 shadow in desktop;
	float grow system title "Look Up by Vehicle Info" font "Arial",11
number=gettheVINFO()
release window cVINFO
release window cVDATA
select vehicle
set relation to
return int(number)


***************************************************************************
*                        Do getVINFO
***************************************************************************
function GETtheVINFO
private test,inVDATA,number,continue

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif

select VEHICLE
inVDATA=space(25)
test=0
number=0
set color to w/rb+,w/bg+
*go bottom
*last=recno()
*go top

continue=.t.

clear gets
inVDATA=space(25)
do while number=0 and continue=.t.
     test=0
     activate window cVINFO
     @ 1,8 say 'Please enter Vehicle ID Number' get inVDATA picture replicate('X',25) size 1,20
     read
     deactivate window cVINFO
     continue=.t.
     if lastkey()=27
        continue=.f.
        number=0
        exit
     endif
     if continue=.t.
          number=selectVDATA(UPPER(ALLTRIM(inVDATA)))
          if number=0
              do repaintclient
              ?? chr(7)
              wait window 'Account Number or Customer Name not Found' nowait
          endif
     endif
enddo
RETURN number




***************************************************************************
*                        selectVDATA
***************************************************************************
function oldselectVDATA
parameter value
private arr,accnumbers,i,j,name,number,START,allVDATA


@ 23,0 to 23,79
=center(24,79) 'Highlight the Client's Account AND Press F10 to Select')
go top
SET EXACT OFF
number=0
*   locate for vin=value
    set order to tag vin
    seek (value)
if found() =.f.
   return 0
endif
SET COLOR TO B/W
define window WAIT_PL from 4,19 to 8,59 title ' ASSEMBLING MATCH LIST' ;
       DOUBLE shadow float font "Arial",11
activate window WAIT_PL
=CENTER(1,'PLEASE BE PATIENT')

count to elements for vin=(value)

if elements > 100
   wait window 'Found more than 100 Matches' timeout 1
   wait window 'Displaying only the first 100' nowait
   elements=100
endif

dimension arr[elements]
dimension allVDATA[elements,32]
copy to array allVDATA for vin=(value)

for i=1 to elements
   arr[i]=right(str(allVDATA[i,1]),6)+' '+left(allVDATA[i,2],15)+' '+left(allVDATA[i,3],15)+;
          +' '+allVDATA[1,4]+alltrim(allVDATA[i,5])+alltrim(allVDATA[i,7])+' '+;
          +alltrim(allVDATA[i,8])+' '+alltrim(allVDATA[i,9])
endfor

set color to w/rb+

START =21-elements
IF START<0
   START=0
ENDIF
deactivate window WAIT_PL
release window WAIT_PL
SET COLOR TO W/RB+
define window cVDATA from START,0 size 25,80 title ' CLIENT MATCH LIST ';
       shadow float grow system font "Arial",11 color scheme 10
activate window cVDATA IN SCREEN
name=arr[1]
set color to w/rb+,w/bg+
@ 0,0 get name from arr size 1,78
read

if lastkey()=27
 number=0
else
 number=val(left(name,6))
endif

deactivate window cVDATA
release arr
release allVDATA
return number



***************************************************************************
*                        selectVDATA
***************************************************************************
function selectVDATA
parameter value
private arr,accnumbers,i,j,name,number,START,allVDATA

select vehicle
go top
SET EXACT OFF
number=0
*   locate for vin=value
    SET ORDER TO tag vin
    seek (value)
if found() =.f.
   return 0
endif

  **
******
  **
count for vin=(value) to mcount

if mcount=1
    go top
*    locate for vin=(value)
     SET ORDER TO tag vin
     SEEK (VALUE)
    number=acctno
    select client
    set order to tag acctno
    seek number
if !found()
   ?? chr(7)
   wait window "Fatal: No corresponding Customer" nowait
   number=0
else
    wait window "Selection:"+str(acctno,4,0)+' '+alltrim(left(client->lastn,10))+;
    '. '+left(client->firstn,10)+' '+mi+'. '+ss nowait
endif
    return number
endif

set color to w/n
*clear
*@ 23,0 to 23,79
*=center(24,'Press F10 to Select Client')
wait window 'Press F10 to Select Client' nowait
set color to gr+/b

if mcount >= 20
   define window cVDATA from 1,1 to 25,80 title ' CLIENT MATCH LIST ' system;
          shadow float grow in desktop font "Arial",11 color scheme 10
else
    temp=int((24-(mcount+3))/2)
   define window cVDATA from temp,1 to temp+mcount+3,80 title ' CLIENT MATCH LIST ' system;
          shadow float grow in desktop font "Arial",11 color scheme 10
endif

  **
******
  **

on key label enter keyboard "{ctrl+w}"
on key label f10 keyboard "{ctrl+w}"
*activate window cVDATA IN SCREEN

select client
set order to tag acctno
select vehicle
set order to tag acctno
set relation to acctno into client
*browse  fields vin:h="Vehicle ID",;
*               year:h="Year",;
*               Make:h="Make",;
*               acctno:h='ACT. NO',;
*              client.lastn:h='  LAST NAME',;
*              client.firstn:h='  FIRST NAME',;
*              client.mi:h='MI',;
*              client.phoneh:h=' PHONE NUMBER';
*       for vin=(value) nomodify width 15;
*       Title 'POLICY MATCH LIST' nomenu window cVDATA;
*       color gr+/b,b/w,,,b/w,,b/w,,,,b/w
browse  fields vin:h="Vehicle ID":w=(.t.=.f.),;
               year:h="Year":w=(.t.=.f.),;
               Make:h="Make":w=(.t.=.f.),;
               acctno:h='ACT. NO':w=(.t.=.f.),;
              client.lastn:h='  LAST NAME',;
              client.firstn:h='  FIRST NAME';
       for vin=(value) nomodify width 15;
       Title 'VEHICLE MATCH LIST' nomenu window cVDATA
*       color gr+/b,b/w,,,b/w,,b/w,,,,b/w
*on key label enter keyboard "{enter}"

on key label enter

if lastkey()=27
 number=0
else
 number=acctno
endif
deactivate window cVDATA
release window cVDATA
select client
set order to tag acctno
*locate for acctno=policy.acctno
*wait window "Selection:"+str(acctno,4,0)+' '+alltrim(left(lastn,10))+'. '+left(firstn,10)+' '+mi+'. '+ss nowait
seek acctno
if !found()
   ?? chr(7)
   wait window "Fatal: No corresponding Customer" nowait
   number=0
else
    if lastkey()<>27
      wait window "Selection:"+str(acctno,4,0)+' '+alltrim(left(lastn,10))+;
         '. '+left(firstn,10)+' '+mi+'. '+ss nowait
    endif
endif
return number


***************************************************************************
*                     Repaintclient
***************************************************************************
procedure repaintclient
   return
   set color to W+/N
   clear
   set color to W+/N
   @ 0,19 to 5,59
   SET COLOR TO W+/B
   @ 5,0 TO 24,79 FILL COLOR W+/B
   @ 5,0 to 24,79
   @ 5,19 say'Á'
   @ 5,59 say 'Á'
   set color to w+/rB+
   =center(0,'Clients Menu')
   =center(2,alltrim(system->companynam))
   set color to W+/B
   @ 7,3 to 20,35
   @ 7,43 to 20,75
   set color to W+/GB+
   @ 7,12 say 'Insurance v 1.0'
   @ 7,53 say 'Date:'
   mydate=date()
   @ 7,58 say dtoc(mydate)
   set color to w+/b,w+/rb+
   @ 9,11 say  'A. Clients    '
   @ 11,11 say 'B. Add  Client'
   @ 13,11 say 'C. Selection C'
   @ 15,11 say 'D. Selection D'
   @ 22,52 say '    Q Exit    '
return


