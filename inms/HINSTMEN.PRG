parameter macctno,pid
if menu()='POLMENU'
   hide menu polmenu
ENDIF
save screen to sc
set century on
set talk off
set procedure to "various"
*set deleted off
set deleted on
    if wexist('browser')
      release window browser
    endif

       define window browser from 3,1 to 15,77;
              Title "Installments List" color scheme 10 float system shadow IN SCREEN
on key label enter
*on key label f1 cancel
select policy
PLOcked=.f.
if lock(alltrim(str(recno())),'policy')=.f.
   ?? chr(7)
   wait window 'This Policy is edited by Another User Try Again Later'
   plocked =.f.
   deactivate window browser
   release window browser
   deactivate window BROWSEWIN
   release window BROWSEWIN
   IF menu()="POLMENU"
      show menu polmenu
   endif
   set deleted off
   restore screen from sc
   return plocked
else
  plocked=.t.
endif



       if !used('installm')
          select 11
          use installm index install alias installment
       else
          select installment
       endif


tf=initinstallments()
if tf
   *wait window 'Done.' timeout 1
    do getinstallments
ENDIF
   select installment
   unlock in installmen
*   do poldisplay
    select policy
   presult=10
   unlock in policy
   deactivate window browser
   release window browser
   deactivate window BROWSEWIN
   release window BROWSEWIN
   set deleted off
    restore screen from sc
    if menu()='POLMENU'
       show menu polmenu
    endif
return


***************************************************************************
*                        get installments
***************************************************************************
procedure getinstallments
private tf,i,k,cdate,clerk,cod


cdate=date()
clerk=0
set color to w+/n
@ 0,0 to 0,79 clear
SET COLOR TO GR+/N
=center(0,"Installments' Database ")
SET COLOR TO W+/G
@ 1,0 to 2,79 clear
=CENTER(1,'Press <F7> to Delete line , <F6>  to UNDO Deletions')
=center(2,'Press <F8> to Add a line  , <F10> to Accept Entries')

*DO INITINVS
select installmen

on key label f10 keyboard "{ctrl+w}"
on key label f7 do rmvitem
on key label f8 do newitem
on key label f6 recall all
tf=.f.
    on key label ctrl+d do rmvitem
    on key label ctrl+I do newitem
    on key label ctrl+U recall all
*    browse fields ddate:h=" Date", ;
*                  Dreason:h="Reason",;
*                  dpayment:8:h="Amount",;
*                  DTYPE:H="T":V=( ((val(dtype)>=1).and.(val(dtype)<=8)) .or. (dtype=' ') ),;
*                  PAYDATE:H="Date Paid":W=DTYPE<>' ',;
*                  Comments:h=" Comments ":W=DTYPE<>' ',;
*                  receiptno:5:r:h="Recpt";
*                  for (dpid=pid) window browser color scheme 10

    browse fields ddate:h=" Date", ;
                  Dreason:h="Reason",;
                  dpayment:8:h="Amount",;
                  PAYDATE:H="Date Paid":r,;
                  Comments:h=" Comments ",;
                  receiptno:5:r:h="Invc#";
                  for (dpid=pid) window browser color scheme 10
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

             MINVOICENO=pid
             MACCTNO   =client->acctno
             MTRANCODE =7000
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =date()
             MCLERK    =STR(clerk)
             MDESCRIPT ="Payment Record Updated"
             MPOSTED   =.t.
             MBILLED   =.t.
             MCHECKNO  =''
             DVID      =' '

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )

return


***************************************************************************
*                        Do initialization
***************************************************************************
function initinstallments

   select installment

go top
set order to tag dpid
seek pid
IF !FOUND()
   append blank
    replace dpid     with    pid,;
            acctno  with    macctno,;
            ddate    with    date()
   ?? chr(7)
   wait window "No Installments Found" timeout 2
   wait window "Blank Installment Added" timeout 3
endif

   if !lock(alltrim(str(recno())),"installmen"))
      ?? chr(7)
      wait window "Somebody else is using these Installments" timeout 1
      wait window "Please try again later" nowait
      unlock in installmen
      return .f.
   endif
select installmen
return .t.

******************************************************************************
*                    Procedure first installment
******************************************************************************
procedure firstinstallment
parameter pid,macctno,down1,down2
private payment
if down1=0
   payment=down2
else
   payment=down1
endif
       if !used('installm')
          select 11
          use installm index install alias installment
       else
          select installment
       endif

append blank
replace dpid     with    pid,;
        acctno  with    macctno,;
        dclerk   with    clerk,;
        ddate    with    date()
*        dpayment with    prices[i]
return


procedure newitem
       append blank
replace dpid     with    pid,;
        acctno  with    macctno,;
        dclerk   with    clerk
return

procedure rmvitem
          delete
*    browse fields ddate:h=" Date", ;
*                  Dreason:h="Reason",;
*                  dpayment:h=" Amount ",;
*                  DTYPE:H="T":V=( ((val(dtype)>=1).and.(val(dtype)<=8)) .or. (dtype=' ') ),;
*                  PAYDATE:H="Date Paid":W=DTYPE<>' ',;
*                  Comments:h=" Comments ":W=DTYPE<>' ';
*                  for (dpid=pid) window browser color scheme 10
return



***************************************************************************
*                        Do initialization
***************************************************************************
procedure initINVs
         if !used('paycode')
            select i
            use paycode index paynum alias paycode
         else
             select paycode
         endif

    if wexist('browsewin')
      release window browsewin
    endif

       define window browsewin from 14,25 to 24,55;
              Title "Valid Payment Types List" color scheme 10 float system shadow

*       ACTIVATE WINDOW BROWSEWIN
*       go top
*       i=1
*       @ 0,0 say '  Type       Code Name' COLOR GR+/BG+
*       do while !eof('paycode')
*          @ i,0 say '    '+dtype+'        '+dpaynAmE
*          i=i+1
*          SKIP
*       enddo
return



