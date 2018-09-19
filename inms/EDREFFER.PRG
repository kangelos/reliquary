save screen to sc
set talk off
set procedure to "various"
*set deleted off
set deleted on
    if wexist('browser')
      release window browser
    endif

define window browser at 3,18 size 18,40 Title "Refferals list" color scheme 10 ;
	float system shadow grow close IN screen ;
	footer "Press <F10> to Save, <ESC> to Abort" font "Arial",11

on key label enter
*on key label f1 cancel

       if !used('reffer')
          select 15
          use reffer index reffer alias refferance
       else
          select refferance
       endif
       set order to tag ref_no

   do getreffers
   deactivate window browser
   release window browser
   deactivate window BROWSEWIN
   release window BROWSEWIN
   set deleted off
   restore screen from sc
return





procedure getreffers
private tf,i,k,cdate,clerk,cod
cdate=date()
clerk=0
set color to w+/n
@ 0,0 to 0,79 clear
SET COLOR TO GR+/N
=center(0,"Referrals' Database ")
set color to
clear
SET COLOR TO W+/G
@ 1,0 say space(80)
=CENTER(1,'Press <F7> to Delete line , <F6>  to UNDO Deletions')
@ 2,0 say space(80)
=center(2,'Press <F8> to Add a line  , <F10> to Accept Entries')


on key label f10 keyboard "{ctrl+w}"
on key label f7 do rmvitem
on key label f8 do newitem
on key label f6 recall all
tf=.f.
    on key label ctrl+d do rmvitem
    on key label ctrl+I do newitem
    on key label ctrl+U recall all
           browse fields ref_no:h="##",;
                         ref_name:h="Refferal" ;
                         window browser nomenu
    deactivate window browser
    on key label ctrl+d
    on key label ctrl+I
    on key label ctrl+U
on key label f10
on key label f7
on key label f8
on key label f6

deactivate window BROWSEWIN
release window BROWSEWIN

return




procedure newitem
       append blank
return

procedure rmvitem
          delete
return



******************************************************************************
*                    Function check for double code
******************************************************************************
function checkfordouble
parameter refnum
private rec,tf
select codes
rec=recno()
seek refnum
if ((found()) and (recno()<>rec))
   tf=.f.
else
   tf=.t.
endif
go (rec)
if tf=.t.
   if (refnum<100) .or. (refnum>=1000)
   ?? chr(7)
   	wait window "Valid numbers must be greater than 100 and less than 1000"
      tf=.f.
   endif
endif

if (refnum<>codes->dcdnum) .and. tf=.t.
       if !used('client')
          select a
          use client index client alias client
       else
           select client
       endif


	set exact on
	temp=reffer->ref_no
locate for client->ref_no=temp
wait window str(refnum)+chr(13)+str(codes->dcdnum)
browse
	set exact off
	if found()=.t. 
		tf=.f.
		?? chr(7)
		Wait window "You cannot change this number ("+alltrim(str(codes->dcdnum))+")"+chr(13)+"There are inoices using it"	
	endif
endif

return tf
