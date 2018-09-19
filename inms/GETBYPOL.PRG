

private number
set color to w/rb+,w/bg+
define window cpinfo from 9,5 to 15,67 color scheme 10 ;
       double float shadow in desktop font "Arial",11 ;
       Title "Look Up Request"
       
number=getthepinfo()
release window cpinfo
release window cpdata
select policy
set relation to
return int(number)


***************************************************************************
*                        Do getpinfo
***************************************************************************
function GETthepinfo
private test,inpdata,number,continue

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
select policy
inpdata=space(25)
test=0
number=0
set color to w/rb+,w/bg+
*go bottom
*last=recno()
*go top

continue=.t.

clear gets
inpdata=space(25)
do while number=0 and continue=.t.
     test=0
     activate window cpinfo
     @ 1,10 say 'Please enter Policy Number' get inpdata picture replicate('X',25) size 1,20
     read
     deactivate window cpinfo
     continue=.t.
     lastk=lastkey()
     if lastk=27
        continue=.f.
        number=0
        exit
     endif
     if continue=.t.
          number=selectpdata(UPPER(ALLTRIM(inpdata)))
          if number=0
              do repaintclient
              ?? chr(7)
              wait window 'Account Number or Customer Name not Found' nowait
          endif
     endif
enddo
RETURN number




***************************************************************************
*                        selectpdata
***************************************************************************
function oldselectpdata
parameter value
private arr,accnumbers,i,j,name,number,START,allpdata


@ 23,0 to 23,79
=center(24,79) 'Highlight the Client's Account AND Press F10 to Select')
go top
SET EXACT OFF
number=0
*   locate for POLICYNO=value
   set order to tag policyno
   seek (value)
if found() =.f.
   return 0
endif
SET COLOR TO B/W
define window WAIT_PL from 4,19 to 8,59 title ' ASSEMBLING MATCH LIST' DOUBLE shadow
activate window WAIT_PL
=CENTER(1,'PLEASE BE PATIENT')

count to elements for POLICYNO=(value)

if elements > 100
   wait window 'Found more than 100 Matches' timeout 1
   wait window 'Displaying only the first 100' nowait
   elements=100
endif

dimension arr[elements]
dimension allpdata[elements,32]
copy to array allpdata for POLICYNO=(value)

for i=1 to elements
   arr[i]=right(str(allpdata[i,1]),6)+' '+left(allpdata[i,2],15)+' '+left(allpdata[i,3],15)+;
          +' '+allpdata[1,4]+alltrim(allpdata[i,5])+alltrim(allpdata[i,7])+' '+;
          +alltrim(allpdata[i,8])+' '+alltrim(allpdata[i,9])
endfor

set color to w/rb+

START =21-elements
IF START<0
   START=0
ENDIF
deactivate window WAIT_PL
release window WAIT_PL
SET COLOR TO W/RB+
define window cpdata from START,0 to 24,79 title ' CLIENT MATCH LIST ' ;
	color scheme 10 system float shadow in desktop font "Arial",11
      
       
activate window cpdata IN SCREEN
name=arr[1]
set color to w/rb+,w/bg+
@ 0,0 get name from arr size 1,78
read

if lastkey()=27
 number=0
else
 number=val(left(name,6))
endif

deactivate window cpdata
release arr
release allpdata
return number



***************************************************************************
*                        selectpdata
***************************************************************************
function selectpdata
parameter value
private arr,accnumbers,i,j,name,number,START,allpdata

select policy 
go top
SET EXACT OFF
number=0
*   locate for policyno=value
    set order to tag policyno
    seek (value)
if found() =.f.
   return 0
endif

  **
******
  **
count for policyno=(value) to mcount

if mcount=1
    go top
*    locate for POLICYNO=(value)
     set order to tag policyno
     seek (value)
    number=acctno
    select client
    set order to tag acctno
    seek number
    if !found()
       ?? chr(7)
       wait window "Fatal: No corresponding Customer" nowait
       number=0
    else
        wait window "Selection:"+str(acctno,4,0)+' '+alltrim(left(lastn,10))+;
        '. '+left(firstn,10)+' '+mi+'. '+ss nowait
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
   define window cpdata from 0,1 size 25,80 title ' CLIENT MATCH LIST ';
       color scheme 10 ;
       double float shadow in desktop font "Arial",11
       
else
    temp=int((24-(mcount+3))/2)
   define window cpdata from temp,0 to temp+mcount+3,79 ;
          title ' CLIENT MATCH LIST ' none;
          float shadow color scheme 10 in desktop font "Arial",11
endif

  **
******
  **

select client
set order to tag acctno
select policy
set order to tag acctno
set relation to acctno into client
on key label enter keyboard "{ctrl+w}"
on key label f10 keyboard "{ctrl+w}"
*activate window cpdata IN SCREEN

browse  fields policyno:H="Policy Number":w=(.t.=.f.),;
               from:h="From":w=(.t.=.f.),;
               to:h="to":w=(.t.=.f.),;
              client.lastn:h='  LAST NAME',;
              client.firstn:h='  FIRST NAME',;
              client.mi:h='MI',;
              client.phoneh:h=' PHONE NUMBER';
       for policyno=(value) nomodify width 15;
       Title 'POLICY MATCH LIST' nomenu window cpdata
*      color gr+/b,b/w,,,b/w,,b/w,,,,b/w
*on key label enter keyboard "{enter}"

on key label enter

if lastkey()=27
 number=0
else
 number=acctno
endif
deactivate window cpdata
release window cpdata
select client
*locate for acctno=policy.acctno
set order to tag acctno
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


