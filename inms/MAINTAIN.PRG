

set procedure to "various"
?? chr(7)
wait window "To run this section, you have to be alone on the network" timeout 1
tf=acertain("Is everybody else off ?",.f.)
if tf=.f.
   return
endif
tf=acertain("Are you Positive ?",.f.)
if tf=.f.
  return
endif
set procedure to 'various'
close databases
set exclusive on
set color to gr+/b
define window maininfo from 5,19 to 7,59 title '[ CURRENTLY ]' shadow float
set safety off
set talk on
set talk window
set notify on
do MAINTENANCEmenu
set talk off
set notify off
release window maininfo
CLOSE DATABASES
set exclusive off
if !used('SYSTEM')
   SELECT 25
   USE SYSTEM ALIAS SYSTEM
ELSE
   SELECT SYSTEM
ENDIF
return


***************************************************************************
*                  MAINTENANCE menu
***************************************************************************
procedure MAINTENANCEmenu
private cont

cont=.t.
* remeber bar menus reside in main in function mmenu

set color to w+/g,b/w
define window MAINTENANCE from 3,29 to 20,55 Title '[ MAINTENANCE ]' shadow float
activate window MAINTENANCE

do while cont=.t.
set color to w+/g,b/w
@ 1, 3  PROMPT  '  Rebuild Indexes  '
@ 3, 3  prompt  '  Pack Databases   '
@ 5, 3  prompt  '  Choose Printer   '
@ 7, 3  Prompt  '  Company Inform.  '
*@ 8, 3  Prompt  '  Backup Database  '
*@ 10,3  Prompt  ' Restore  Database '
@ 9,3  Prompt  ' Remove Tmp Files  '
@ 11,3  Prompt  '  Warn all  Users  '
@ 13,3  Prompt  'Prune Activity Log '
@ 15,3  prompt  '        Quit       '
menu to selection
cont=.t.
SET TALK ON
SET TALK WINDOW
do case
   case selection =1
*        tf=warnem()
*        if tf
           do rebuildidx
           WAIT WINDOW "Done" nowait
*        endif
   case selection=2
        tf=warnem()
        if tf
           do packdatabases
           WAIT WINDOW "Done" nowait
        ENDIF
   case selection=3
        do prnchoic
   case selection=4
        deactivate window maintenance
        save screen to sc
        do comem
*        do all
*         cont=.f.
        restore screen from sc
        activate window maintenance
   case selection=5
        DO REMOVETEMP
        wait window "Done" Nowait
   case selection=6
       if len(alltrim(substr(sys(0),1,4)))>0
          a=getenv("imsnet")
          if upper(alltrim(a))="LANTASTIC" or upper(alltrim(a))=""
             ! net send * "Please Logout From INMS, Going on Maintenance in 2 minutes"
          else
             wait window "Please Specify send net string" nowait
          endif
       else
          wait window "This machine is NOT networked" nowait
       endif
   case selection=7
        do prune
   otherwise
        cont=.f.
endcase
SET TALK OFF
enddo
deactivate window MAINTENANCE
release window MAINTENANCE
return





***************************************************************************
*                  wARN USERS
***************************************************************************
FUNCTION WARNEM
define window warnem from 0,4 to 6,75 double float shadow
activate window warnem
=center(0,"WARNING    WARNING    WARNING")
=center(2,"This action can only be executed if no one else is")
=center(3,"running concurently on the network")
=center(4,"Please Tell everybody else to QUIT the program")

TF=ACERTAIN("Do you wish to Continue ?",.f.)
deactivate window warnem
release window warnem
RETURN TF


