save screen to sc
set century on
set talk off
set procedure to "various"
*set deleted off
set deleted on
    if wexist('browser')
      release window browser
    endif

       define window browser at 1,1 size 20,95 in desktop;
       	  Title " PHONEBOOK " ;
       		color scheme 10 float system shadow grow font "Arial",11
on key label enter
*on key label f1 cancel

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         SET ORDER TO TAG LASTN

   SET TOPIC TO "PHONEBOOK"
   do getinstallments
   deactivate window browser
   release window browser
   deactivate window BROWSEWIN
   release window BROWSEWIN
   set deleted off
    restore screen from sc
    CLOSE DATABASES
    SET TOPIC TO "MAIN"
return


***************************************************************************
*                        get installments
***************************************************************************
procedure getinstallments
private tf,i,k,cdate,clerk,cod


set color to r+/b
@ 24,0 say space(80)
=center(24,"Press <F10> to Get Out")
cdate=date()
clerk=0

on key label f10 keyboard "{ctrl+w}"
tf=.f.
    on key label ctrl+d do rmvitem
    on key label ctrl+I do newitem
    on key label ctrl+U recall all
    browse fields LASTN:H="     LAST NAME":p=replicate('!',20):R,;
                  FIRSTN:H="     FIRST NAME":p=replicate('!',20):R,;
                  phoneH:p="(999) 999-9999":H="PHONE #",;
                  PHONEW:p="(999) 999-9999":H="BEEPER/WORK #";
                  window browser color scheme 10 nomenu
    deactivate window browser
    on key label ctrl+d
    on key label ctrl+I
    on key label ctrl+U
on key label f10

deactivate window BROWSEWIN
release window BROWSEWIN
return

