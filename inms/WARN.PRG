
parameter par
private what
what=warning(par)
return what

******************************************************************************
*                    PROCEDURE WARN
******************************************************************************
function WARNing
PARAMETER PAR
private selection,tf
tf=.f.
SET COLOR TO W/BG+
DEFINE WINDOW WARNiNG  FROM 8,9 TO 22,69 DOUBLE FLOAT TITLE '[ WARNING ]' shadow

set color to w/bg+
define window browser from 4,4 to 14,75 none float in screen shadow

SET COLOR TO W/BG+,b/w
selection=1
cont=.t.
do while cont=.t.
     activate window warning
     clear
     =center(1,'Be advised that deleting an insurance policy will')
     =center(2,'Remove the Premiums from under it.')
     =center(4,'The Premiums will become Free Floating')
     =center(5,'You will have to UNDELETE and Include-New-Vehicles')
     =center(5,'to Recreate the policy ')
     @ 11,13  prompt '      Delete Unconditionaly     '
     @ 12,13  prompt 'Nope Not sure! Let me outa here!'
     menu to selection
     do case
        case selection=1
             TF=.T.
             cont=.f.
        case selection=2
             TF=.F.
             cont=.f.
        otherwise
             cont=.t.
     endcase

     *=center(7,'Press ESC to stop , any other key to proceed')
     *=center(8,'')
     *=inkey(0)
enddo
deactivate window warning
release window warning
release window browser
RETURN tf
