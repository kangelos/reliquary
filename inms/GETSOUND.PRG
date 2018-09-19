
private number
set color to w/rb+,w/bg+
define window cinfo from 9,5 to 14,67 color scheme 10 double  shadow in desktop grow ;
	font "Arial",11 Title "Sound the name please"
number=gettheinfo()
release window cinfo
release window cdata
return int(number)


***************************************************************************
*                        Do getinfo
***************************************************************************
function GETtheINFO
private test,indata,number,continue

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
select client
indata=space(25)
test=0
number=0
set color to w/rb+,w/bg+
*go bottom
*last=recno()
*go top

continue=.t.

clear gets
indata=space(25)
do while number=0 and continue=.t.
     test=0
     activate window cinfo
     @ 1,8 say "Client's Last Name" get indata picture replicate('X',25) size 1,15
     read
     deactivate window cinfo
     continue=.t.
     if lastkey()=27
        continue=.f.
        number=0
        exit
     endif
     if continue=.t.
          set exact off
          test=val(alltrim(indata))
          number=0
          if test <= 0
             number=selectsound((alltrim(upper(indata))))
          endif
          if number=0
              do repaintclient
              ?? chr(7)
              wait window 'Account Number or Customer Name not Found' nowait
          endif
     endif
enddo
RETURN number




***************************************************************************
*                        selectdata
***************************************************************************
function oldselectdata
parameter value
private arr,accnumbers,i,j,name,number,START,alldata


@ 23,0 to 23,79
=center(24,79) 'Highlight the Client's Account AND Press F10 to Select')
go top
number=0
   set order to tag lastn
*   locate for lastn=value
    seek value
if found() =.f.
   return 0
   set order to tag acctno
endif
SET COLOR TO B/W
define window WAIT_PL from 4,19 to 8,59 title ' ASSEMBLING MATCH LIST' DOUBLE shadow
activate window WAIT_PL
=CENTER(1,'PLEASE BE PATIENT')

count to elements for lastn=(value)

if elements > 100
   wait window 'Found more than 100 Matches' timeout 1
   wait window 'Displaying only the first 100' nowait
   elements=100
endif

dimension arr[elements]
dimension alldata[elements,32]
copy to array alldata for lastn=(value)

for i=1 to elements
   arr[i]=right(str(alldata[i,1]),6)+' '+left(alldata[i,2],15)+' '+left(alldata[i,3],15)+;
          +' '+alldata[1,4]+alltrim(alldata[i,5])+alltrim(alldata[i,7])+' '+;
          +alltrim(alldata[i,8])+' '+alltrim(alldata[i,9])
endfor

set color to w/rb+

START =21-elements
IF START<0
   START=0
ENDIF
deactivate window WAIT_PL
release window WAIT_PL
SET COLOR TO W/RB+
define window cdata from START,0 to 24,79 title ' CLIENT MATCH LIST ' none
activate window cdata IN SCREEN
name=arr[1]
set color to w/rb+,w/bg+
@ 0,0 get name from arr size 1,78
read

if lastkey()=27
 number=0
else
 number=val(left(name,6))
endif

deactivate window cdata
release arr
release alldata
return number



***************************************************************************
*                        selectdata
***************************************************************************
function selectsound
parameter value
private arr,accnumbers,i,j,name,number,START,alldata
select client
go top
number=0
   locate for like(soundex(lastn),soundex(value))
if found() =.f.
   return 0
endif

  **
******
  **
count for like(soundex(lastn),soundex(value)) to mcount

if mcount=1
    go top
    locate for like(soundex(lastn),soundex(value))
    number=acctno
    wait window "Selection:"+str(acctno,4,0)+' '+alltrim(left(lastn,10))+'. '+left(firstn,10)+' '+mi+'. '+ss nowait
    return number
endif

set color to w/n
*clear
*@ 23,0 to 23,79
*=center(24,'Press F10 to Select Client')
wait window 'Press F10 to Select Client' nowait
set color to gr+/b

if mcount >= 20
   define window cdata from 0,0 to 24,79 title ' CLIENT MATCH LIST ' none
else
    temp=int((24-(mcount+3))/2)
   define window cdata from temp,0 to temp+mcount+3,79 title ' CLIENT MATCH LIST ' none
endif

  **
******
  **

on key label enter keyboard "{ctrl+w}"
on key label f10 keyboard "{ctrl+w}"
*activate window cdata IN SCREEN

browse  fields acctno:h='CUSTOMER #',;
              lastn:h='  LAST NAME',;
              firstn:h='  FIRST NAME',;
              mi:h='MI',;
              phoneh:h=' PHONE NUMBER',;
              add:h='    ADDRESS',;
              city:h='     CITY',;
              state:h='ST',;
              zip:h='  ZIPCODE';
       for like(soundex(lastn),soundex(value)) nomodify width 15;
       Title 'CLIENT MATCH LIST' nomenu window cdata;
       color gr+/b,b/w,,,b/w,,b/w,,,,b/w
*on key label enter keyboard "{enter}"

on key label enter

if lastkey()=27
 number=0
else
 number=acctno
endif
deactivate window cdata
release window cdata
if lastkey()<>27
   wait window "Selection:"+str(acctno,4,0)+' '+alltrim(left(lastn,10))+'. '+left(firstn,10)+' '+mi+'. '+ss nowait
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


