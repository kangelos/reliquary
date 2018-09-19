
set procedure to 'various'
set color to
save screen to q

if !used('client')
   select a
   use client index client alias client
else
    select client
endif
set order to tag lastn

do labelsx
restore screen from q
close databases
return


***************************************************************************
*                  procedure do labels
***************************************************************************
procedure labelsx
*parameter lblfname
private i,selection,k,filename,lblfname,value

lblfname=space(25)
lblfname=getlabelsize()
selection=space(25)
filename=space(25)


if len(alltrim(lblfname))>0

String="Where do you want the output to go ?"
   yesno=1
set color to w+/b,w+/b
*define window sure from 7,19 to 13,59  NONE float shadow in screen ;
*       title ' OUTPUT GOES WHERE ' color SCHEME 4
*       w+/b,w+/b, w+/b , w+/b, w+/b, w+/b, w+/b, w+/b, w+/b, w+/b

*activate window sure


yesno=spf()

     do case
        case yesno=1
             label form (lblfname) preview
        case yesno=2
*             value=doprint()             
*                activate window wait
                wait window 'Please wait I am printing '+LBLFNAME NOWAIT
                label form (lblfname) to printer noconsole
                eject
*                deactivate window wait
*        case selection="FIle"
*             activate window filenames
*             @ 0,0 say "Filename : " get filename picture "!!!!!!!!!!!!!!!!!!!!!!!!!"
*             read
*             if len(alltrim(filename)) > 0
*               if file(filename) = .T.
*                    activate window exists
*                    @ 0,0 say "Trying to create File : "+(filename)
*                    label form (lblfname) noconsole to file (filename)
*                    deactivate window exists
*                else
*                    label form (lblfname) noconsole to file (filename)
*                endif
*              endif
*              deactivate window filenames
		WAIT CLEAR
        otherwise
             selection=''
        endcase
     deactivate window getlabels
endif
return


***************************************************************************
*                  function get label size
***************************************************************************
function getlabelsize
private filename,select

define window getlabel from 5,40 to 21,70 SYSTEM float;
       shadow Title "Please Select Label Size" COLOR SCHEME 10

set color to W+/BG+,b/w
filename=space(50)
lk=27
do while lk=27
activate window getlabel
clear
@ 1,2 prompt  '3 1/2" x 15/16"  1 across'
@ 3,2 prompt  '3 1/2" x 15/16"  2 across'
@ 5,2 prompt  '3 1/2" x 15/16"  3 across'
@ 7,2 prompt  '3 2/10" x 11/12" 3 across'
@ 9,2 prompt  '    3" x 5" (Rolodex)    '
@ 11,2 prompt '   2 5/8" x 1" 3 across  '
@ 13,2 prompt '  4" x 2 1/4" (Rolodex)  '
menu to select
lk=lastkey()
enddo
do case
   case select=1
        filename='mail'
   case select=2
        filename='mail1'
   case select=3
        filename='mail2'
  case select=4
        filename='mail3'
   case select=5
        filename='mail4'
   case select=6
        filename='mail5'
   case select=7
        filename='mail6'
   otherwise
        filename=''
 endcase
deactivate window getlabel
return filename
