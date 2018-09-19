

CLOSE DATABASES
set sysmenu off

*if upper(menu())='ROOTMENU'
*        hide menu'ROOTMENU'
*endif

    if wexist('browser')
      release window browser
    endif

set color to gr+/r
@ 23,0 to 24,79 clear
=center(23,'If you do not Understand this screen then')
=center(24,'please do not make any changes')

set color to
SET EXCLUSIVE ON
do printBRO
SET EXCLUSIVE OFF

if upper(menu())='ROOTMENU'
        Show menu'ROOTMENU'
endif
SELECT 20
use
return

*********************
* Printer Maintenance
*********************
procedure printBRO
define window browser from 6,3 to 16,77;
       Title "Printer List" color scheme 10 float system shadow;
              footer "Press <F10> to RETURN"


SET COLOR TO GR+/N
@ 0,0 to 0,79 clear
=center(0,"System's PRINTERS")
SET COLOR TO W+/G
@ 1,0 to 2,79 clear
=CENTER(1,'Press <F7> to Delete line , <F6>  to UNDO Deletions')
=center(2,'Press <F8> to Add a line  , <F10> to Accept Entries')


        select 20
        use PRINTERS alias PRINTERS


on key label f10 keyboard "{ctrl+w}"
on key label f7 do rmvitem
on key label f8 do newitem
on key label f6 recall all

TF=FLOCK()
IF TF=.F.
        WAIT WINDOW "LOCK FAILED" NOWAIT
ENDIF

    browse FIELDS PRNAME:H="Printer":p=replicate('!',15),;
                  PRLocation:55:H="Connection":p=replicate('!',80);
                  window browser

*        BROWSE WINDOW BROWSER

    deactivate window browser
    release window browser

on key label f10
on key label f7
on key label f8
on key label f6

return




procedure newitem
       append blank
return

procedure rmvitem
          delete
return

***************************************************************************
*                  center text on the screen
***************************************************************************
function center
parameter row,message
private column
        column=int( (wcols()-len(message)) /2 )
        @ row,column say message
return  .t.
