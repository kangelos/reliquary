set procedure to 'various'
set topic to "SEARCH"
public isname,isnumber,facctno,last
store .f. to isname,isnumber
on key label f10 keyboard "{CTRL+w}"

save screen to sscreen
deactivate window what
release window what
*set color to
define window what from 2,10 to 12,45 title "What Search" float shadow
activate window what

moptopt=0
*do while  (moptopt#5)
deactivate window what
release window what
*set color to
set color to w+/g,b/w
define window what from 2,10 to 16,45 title " ? What kind of Search ? " ;
       float shadow
*color gr+/b,gr+/b, gr+/b , gr+/b, gr+/b, gr+/b, gr+/b, gr+/b, gr+/b, gr+/b
activate window what
clear
set color to w+/g,b/w
@ 1,4 prompt ' By Name / Account Number '
@ 3,4 prompt 'By Insurance Policy Number'
@ 5,4 PROMPT ' By Vehicle Plate Numbers '
@ 7,4 prompt '   By Vehicle ID Number   '
@ 9,4 prompt '  Phonetic Search (Slow)  '
@11,4 prompt '     Quit Options Menu    '

menu to moptopt

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
do case
   case moptopt=1
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set relation to
         set filter to
         set order to tag acctno
*     deactivate window what
     facctno=getinfo()
   case moptopt=2
         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag acctno
         set relation to acctno into client
*         deactivate window what
         facctno=getbypol()
         select policy
         set relation to
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif

   case moptopt=3
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set relation to acctno into client
*         deactivate window what
         facctno=getplate()
         select vehicle
         set relation to
         select client
   case moptopt=4
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set relation to acctno into client
*         deactivate window what
         facctno=getbyveh()
         select vehicle
         set relation to
         select client
   case moptopt=5
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
        facctno=getsound()
  otherwise 
     deactivate window what
  		facctno=0       
endcase
*enddo

deactivate window what
release window what

*restore screen from sscreen
if facctno<>0
   a=getenv('name')
   a=a+'\findcli.mem'
   delete file &a
   a=getenv('name')
   a=a+'\findcli.mem'
   save to &a
   do climenu with facctno
   a=getenv('name')
   a=a+'\findcli.mem'
   restore from &a
endif
on key label f10
set topic to "FILING"
return

