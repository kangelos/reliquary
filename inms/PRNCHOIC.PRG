SET PROCEDURE TO VARIOUS
return 


*this is totally screwed


net=left(sys(0),15)
if len(alltrim(net))=0
        set printer to lpt1: && no network attached
else
        OLDALIAS=ALIAS()

        SAVE SCREEN TO SC
         do datach
         RESTORE SCREEN FROM SC

        if len(alltrim(oldalias))>0
           select &oldalias
        endif
endif
RETURN



procedure datach

if !used('PRINTERS')
        select 20
        use PRINTERS alias PRINTERS
else
        select PRINTERS
endif

define window browser from 3,30 to 15,48;
       Title "PRINTER List" color scheme 10 float system shadow


SET COLOR TO GR+/N
@ 0,0 to 0,79 clear
=center(0,"System's PRINTERS")
SET COLOR TO W+/G
@ 24,0 to 24,79 clear
=center(24,'Press <F10> to Select a Printer')

on key label enter keyboard "{ctrl+w}"
tf=.f.
    browse fields prname:h='Printer' window browser for deleted()=.f. NOMODIFY
on key label f10
on key label enter
    rec=recno('PRINTERS')
if lastkey()=27
        set printer to nul:
else
     goto rec
     loc=prlocation
      if upper(alltrim(loc))='FILENAME'
        define window net from 8,15 to 12,75 TItle ' File Name ' ;
               color gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b ;
               float shadow
        activate window net
        pname=space(30)
        set color to gr+/b,b/w
        =center(0,'Please enter the Fully Quallified Filename')
        =center(1,'Example: c:\files\test.txt')
        @ 2,14 get pname
        read
        pname=alltrim(pname)
        if lastkey() = 13
           set printer to (pname)=prn:
        endif
        deactivate window net
        release window net
      else
        set printer to (&loc)=prn:
      endif
endif

deactivate window browser
release window browser

use
return




