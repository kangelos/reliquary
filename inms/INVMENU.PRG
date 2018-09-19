parameter macctno,MDPID
set talk off
set procedure to "various"
SET UDFPARMS TO REFERENCE
declare codarray[10]
saved=0
printed=0
newbal=0

 select client
 if lock(alltrim(str(recno())),'client')=.f.
    ?? chr(7)
    wait window 'This CLIENT is edited by Another User' timeout 1
    wait window 'Try again later' nowait
    set udfparms to value
    return
 endif

*         if !used('POLICY')
*            select e
*            use POLICY index POLICY alias POLICY
*         else
*             select policy
*         endif
*SET ORDER TO TAG ACCTNO
*SELECT CLIENT
*SET RELATION TO ACCTNO INTO POLICY
*SET SKIP TO POLICY


mpolicyno=policy->policyno
*mdpid=policy->dpid
declare  acod[5]
DECLARE agood[5]
declare  aref[5]
declare  apri[5]
declare adesc[5]

declare  icod[20]
declare  idesc[20]
DECLARE igood[20]
declare  ipri[20]
declare  iqty[20]
declare  ilst[20]
declare  itax[20]
price=0

cdate=date()
row=15
invrow=6
tot=0

on key label f10 keyboard "{ctrl+w}"
*on key label enter keyboard "{ctrl+w}"
on key label f7 keyboard "{ctrl+q}"
on key label f8 keyboard "{ctrl+pgdn}"
on key label f9 keyboard "{ctrl+pgup}"

         if !used('codes')
            select g
            use codes index codenum alias codes
         else
             select codes
         endif

*         if !used('adj')
*            select h
*            use adj index adjnum alias adjustment
*         else
*             select adjustment
*         endif

         if !used('paycode')
            select i
            use paycode index paynum alias paycode
         else
             select paycode
         endif


         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
         endif

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag acctno
       set filter to policyno=policy->policyno

store .f. to adjust,pay


for i=1 to 5
    store ' ' to acod[i]
    STORE .F. TO agood[I]
    store space(20) to aref[i]
    store SPACE(9) to apri[i]
    store space(25) TO ADESC[I]
endfor
for i=1 to 20
    store '    ' to icod[i]
    STORE .F. TO igood[I]
    store SPACE(9) to ipri[i]
    store ' ' to iqty[i],ilst[i],itax[i]
    STORE SPACE(25) TO IDESC[I]
endfor

clerk=0
BALANCE=0
total=0
newbal=0
do initINVs
tf=getinvoice()  

if tf
set color to
define window sa at 4,5 size 10,30  title "What now" shadow float system grow font "TimesRoman" ,13 Style "B"
Activate window sa
lk=27
if lastkey()=27
   c=2
else
    c=3
endif
*if lk=27
*   @ 1,1 prompt "   Save and Exit   "
*   @ 3,1 prompt "Exit without Saving"
*   @ 5,1 prompt "  Save and  print  "
*   menu to c
   ok=1
   @ 1,3 get c function '*R Save and Exit;Exit without Saving;Save and  Print' size 2,20
   @ 8,7 get ok Function '* OK' size 2,14
   read cycle   
*endif
do case
   case c=1
        saved=1
        printed=0
   case c=2
        saved=0
        printed=0
   case c=3
        saved=1
        printed=1
endcase

deactivate window sa
release window sa


 if saved=1
         if !used('INVOICE')
            select 13
            use INVOICE index INVOICE alias INVOICE
         else
             select INVOICE
         endif
         set order to tag acctno
         

SELECT INVOICE
GO BOTTOM
* plug in the adjustments.
tot=0
j=0
lastprice=0
wait window "Please Wait, Updating" nowait
minvno=getinvno()
wait window "Invoice Number is:"+alltrim(str(minvno)) nowait
for i=1 to 20
    if ( igood[I] )
       tot=tot+val(Ipri[i])
       j=j+1
       select invoice
       append blank
       replace idate    with  CDATE,;
               DINVNO   WITH  MINVNO,;
               ACCTNO   WITH  client->ACCTNO,;
               CLERKNUM WITH  CLERK,;
               DCODE    WITH  val(Icod[I]),;
               DPRICE   WITH  val(Ipri[I]),;
               DQTY     WITH  IQTY[I],;
               DTAX     WITH  ITAX[I],;
               dLST     WITH  ILST[I],;
               DESCRIPT WITH  ALLTRIM(IDESC[I]),;
               posted   with  .f.,;
               billed   with  .f.,;
               policyno with mpolicyno,;
               dpid     with mdpid
*       lastprice=val(ipri[i])
       if val(icod[I])>=1000
          select installmen
          goto (val(icod[i])-1000)
          do while !lock(alltrim(str(val(icod[i])-1000)),'installmen')
             ?? chr(7)
             wait window "Somebody is editing those Installments" timeout 1
          enddo
          replace installmen.dtype     with 'P',;
                  INSTALLMEN.COMMENTS  WITH 'CHECK INVOICE #',;
                  installmen.receiptno with minvno,;
                  INSTALLMEN.PAYDATE   WITH CDATE
       endif
    endif
endfor
atot=0
j=0
for i=1 to 5
    if ( Agood[I] )
       atot=atot+val(apri[i])
       j=j+1
      select invoice
       append blank
       replace idate    with  CDATE,;
               DINVNO   WITH  MINVNO,;
               ACCTNO   WITH  client->ACCTNO,;
               CLERKNUM WITH  CLERK,;
               DCODE    WITH  val(acod[I]),;
               DREFFER  WITH  alltrim(aref[I]),;
               DPRICE   WITH  val(apri[I]),;
               DESCRIPT WITH  ALLTRIM(ADESC[I])+" "+alltrim(aref[i]),;
               posted   with  .f.,;
               billed   with  .f.,;
               policyno with mpolicyno,;
               dpid     with mdpid
               lastprice=lastprice+val(apri[i])
    endif
endfor

select client
replace dbalance   with  newbal,;
        lastpayday with  cdate,;
        lastamount with  lastprice
endif

if printed=1
   do printinvoice
endif

if tot>0
 MINVOICENO=minvno
 MACCTNO   =client->acctno
 MTRANCODE =7700
 MQTY      =1
 MPRICE    =tot/j
 MTOTAL    =tot
 MDATE     =date()
 MCLERK    =STR(clerk)
 MDESCRIPT ="Invoice Created"
 MPOSTED   =.t.
 MBILLED   =.t.
 MCHECKNO  =''
 MPRICE   =0
 DVID      ='      '

 =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
           MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
endif
ENDIF
select installmen
unlock in installmen
select invoice
on key label f10
on key label f9
on key label f8
on key label f7
*on key label enter
sET UDFPARMS TO VALUE
unlock in client
wait clear
return


***************************************************************************
*                        get invoice
***************************************************************************
function getinvoice
private tf,i,k

set color to gr+/b
clear
set color to gr+/b
@0,0 say space(80)
=center (0,'INVOICE ENTRY SCREEN')
set color to gr+/b
@ invrow,0 say "      Code           Description                 Qty  Lst               Amount " color gr+/b
@ 21,0 TO 24,79 DOUBLE
SET COLOR TO GR+/b,w+/bg
=CENTER(22,'Press <F7> to Delete line   <F8>  to select code <TAB> to move over')
=center(23,'Press <F9> to open Items   <F10> to Accept Entries <Esc> to Cancel')
set color to gr+/b,w+/bg
@ 1,0 to 4,79 double
@ 2,2 say "Client:"
@ 2,55 say "Account No:"
@ 2,9 say alltrim(left(client->lastn,20))+' '+left(client->firstn,20)+' '+a.mi
@ 2,68 SAY str(macctno,6,0)
BALANCE=client->DBALANCE
wait clear
clear gets

*@ 3,2 say "Invoice No:"
@ 3,25 say "Date:" get cdate picture "@D"
@ 3,43 Say "Clerk:" get clerk size 1,4 picture '9999'
*@ 3,13 say str(minvno,6,0) color w+/bg
@ 3,57 SAY "Balance:"
@ 3,65 say balance color
read
if lastkey()=27
   tf=acertain("Really Quit ? ",.f.)
   set color to gr+/b,w+/bg

set color to 
   if tf
        RETURN .f.
   endif	
ENDIF


*                    get the codes
for i=1 to 5
    @ invrow+i,5 get icod[i] PICTURE 'XXXX'
    @ invrow+i,49 get iqty[i] picture '9'
    @ invrow+i,55 get ilst[i] picture '9'
*   @ invrow+i,61 get itax[i] picture '9'
    @ invrow+i,70 get ipri[i] picture '999999999'
endfor
clear gets

tf=.f.
j=1
disp=0 && displacement

do while (  tf=.f.)
    wait window "Press F8 or F9 to Select" nowait
    @ invrow+j,5 get icod[j+disp] PICTURE 'XXXX'
    read
        gooddata=.t.
        lastk=lastkey()
*        if  lastk<>13 and lastk<>27 and lastk<>17 and lastk<>30 and lastk<>23 and lastk<>5 and lastk<>24 and lastk<>31 AND val(icod[J+disp])<>0
         if lastk<>27 and lastk<>17 and lastk<>30 and lastk<>23 and lastk<>5 and lastk<>24 and lastk<>31 AND val(icod[J+disp])<>0
                idesc[j+disp]=Disp_icode(invrow+j,icod[j+disp])
                   if iqty[j+disp]=' '
                      iqty[j+disp]='1'
                   endif
                   if ilst[j+disp]=' '
                      ilst[j+disp]='1'
                   endif
                   iqty[j+disp]=get_qty(invrow+j,iqty[j+disp])
                   ilst[j+disp]=get_lst(invrow+j,ilst[j+disp],icod[j+disp])
                   price=price*val(iqty[j+disp])
                   ipri[j+disp]=str(price,9,2)
                   ipri[j+disp]=get_price(invrow+j,ipri[j+disp])
                   igood[j+disp]=.t.
                lastk=0
        endif
          if lastkey()=27
             tf=acertain("Really Quit ?",.f.)
             set color to gr+/b,w+/bg
             if tf=.t.
                gooddata=.f.
                exit
             endif
          endif
          if gooddata
           do case
             case lastk=17
*                @ invrow+j,10 to invrow+j,45 clear
                 @ invrow+j,10 say space(36)
                icod[j+disp]='    '
                iqty[j+disp]=' '
                ilst[j+disp]=' '
*               itax[j+disp]=' '
                ipri[j+disp]=space(9)
                @ invrow+j, 5 get icod[j+disp] PICTURE 'XXXX'
                @ invrow+j,49 get iqty[j+disp] picture '9'
                @ invrow+j,55 get ilst[j+disp] picture '9'
*               @ invrow+j,61 get itax[j+disp] picture '!'
                @ invrow+j,70 get ipri[j+disp] picture '999999999' &&    get the price
                clear gets
                gooddata=.f.
                igood[J+disp]=.F.

             case lastk=31
                save screen to pre
                icod[j+disp]=getfrominst(j+disp)
                restore screen from pre
*                @ invrow+j,10 to invrow+j,45 clear
                 @ invrow+j,10 say space(36)

                @ invrow+j,5 get icod[j+disp] PICTURE 'XXXX'
                clear gets
                if val(icod[j+disp])<>0
                idesc[j+disp]=Disp_icode(invrow+j,icod[j+disp])
                   if iqty[j+disp]=' '
                      iqty[j+disp]='1'
                   endif
                   if ilst[j+disp]=' '
                      ilst[j+disp]='1'
                   endif
                   iqty[j+disp]=get_qty(invrow+j,iqty[j+disp])
                   ilst[j+disp]=get_lst(invrow+j,ilst[j+disp],icod[j+disp])
*                  if codes.dcdtaxable
*                     itax[j+disp]='Y'
*                  else
*                     itax[j+disp]='N'
*                  endif
*                  itax[j+disp]=get_tax(invrow+j,itax[j+disp])
*                  if itax[j+disp] ='Y'
*                     price=price*val(iqty[j+disp])*1.0825
*                  else
*                     price=price*val(iqty[j+disp])
*                  endif
                   price=price*val(iqty[j+disp])
*                   if ipri[j+disp]=space(9)
*                      ipri[j+disp]=str(price,9,2)
*                   endif
                   ipri[j+disp]=str(price,9,2)
                   ipri[j+disp]=get_price(invrow+j,ipri[j+disp])
                   igood[j+disp]=.t.
                endif
                lastk=0
             case lastk=30
                save screen to pre
                icod[j+disp]=getsvccode()
                restore screen from pre
*                @ invrow+j,10 to invrow+j,45 clear
                 @ invrow+j,10 say space(36)
                @ invrow+j,5 get icod[j+disp] PICTURE 'XXXX'
                clear gets
                if val(icod[j+disp])<>0
                idesc[j+disp]=Disp_icode(invrow+j,icod[j+disp])
                   if iqty[j+disp]=' '
                      iqty[j+disp]='1'
                   endif
                   if ilst[j+disp]=' '
                      ilst[j+disp]='1'
                   endif
                   iqty[j+disp]=get_qty(invrow+j,iqty[j+disp])
                   ilst[j+disp]=get_lst(invrow+j,ilst[j+disp],icod[j+disp])
*                  if codes.dcdtaxable
*                     itax[j+disp]='Y'
*                  else
*                     itax[j+disp]='N'
*                  endif
*                  itax[j+disp]=get_tax(invrow+j,itax[j+disp])
*                  if itax[j+disp] ='Y'
*                     price=price*val(iqty[j+disp])*1.0825
*                  else
*                     price=price*val(iqty[j+disp])
*                  endif
                   price=price*val(iqty[j+disp])
*                   if ipri[j+disp]=space(9)
*                      ipri[j+disp]=str(price,9,2)
*                   endif
                   ipri[j+disp]=str(price,9,2)
                   ipri[j+disp]=get_price(invrow+j,ipri[j+disp])
                endif
                lastk=0
                igood[j+disp]=.t.
             case lastk=23
                tf=acertain("Make Items Final ?",.f.)
                set color to gr+/b,w+/bg
                if tf
                   exit
                endif
             endcase
             if ( (gooddata) and val(icod[j+disp])<>0 )
                idesc[j+disp]=Disp_icode(invrow+j,icod[j+disp])
                if lastk=9
                   iqty[j+disp]=get_qty(invrow+j,iqty[j+disp])
                   ilst[j+disp]=get_lst(invrow+j,ilst[j+disp],icod[j+disp])
*                  itax[j+disp]=get_tax(invrow+j,itax[j+disp])
                   ipri[j+disp]=get_price(invrow+j,ipri[j+disp])
                   igood[J+disp]=.T.
                   j=j-1
                endif
             else
             endif
          endif
          do case
             case lastk=5
                j=j-1
             case lastk=24
*             if ( (gooddata) and icod[j+disp]<>0 )
                j=j+1
*             endif
*             otherwise
*                j=j+1
          endcase
          if j<1
             j=1
             disp=disp-1
             if disp<0
                disp=0
             endif

             for i=1 to 5
                 @ invrow+i,5 get icod[i+disp] PICTURE 'XXXX'
                idesc[i+disp]=Disp_icode(invrow+i,icod[i+disp])
                 @ invrow+i,49 get iqty[i+disp] picture '9'
                 @ invrow+i,55 get ilst[i+disp] picture '9'
*                @ invrow+i,61 get itax[i+disp] picture '!' valid (itax[i+disp]='Y' or itax[i+disp]='N') error "Yes or No please"
                 @ invrow+i,70 get ipri[i+disp] picture '999999999'
             endfor
             clear gets
          endif
          if j>5
             j=5
             disp=disp+1
             if disp>20
                disp=20
             endif

             for i=1 to 5
                 @ invrow+i,5 get icod[i+disp] PICTURE 'XXXX'
                 idesc[i+disp]=Disp_icode(invrow+i,icod[i+disp])
                 @ invrow+i,49 get iqty[i+disp] picture '9'
                 @ invrow+i,55 get ilst[i+disp] picture '9'
*                @ invrow+i,61 get itax[i+disp] picture '!' valid (itax[i+disp]='Y' or itax[i+disp]='N') error "Yes or No please"
                 @ invrow+i,70 get ipri[i+disp] picture '999999999'
             endfor
             clear gets
          endif
enddo


IF GOODDATA=.F.
   RETURN .F.
ENDIF
for i=1 to 20
*    IF VAL(ICOD[i])>=100
    IF VAL(ICOD[i])>100
       TOTAL=TOTAL+val(IPRI[i])
    ENDIF
ENDfor
newbal=balance+total
set color to gr+/b
@ 12,0 to 14,79 double
@ 13,5 say "Current Balance:"
@ 13,21 say str(balance,7,2)
@ 13,30 say "Outstanding:"
@ 13,42 say str(total,7,2)
@ 13,50 SAY "New Balance:"
@ 13,62 say str(newbal,7,2)
tf=getinvadjust()
return .t.


***************************************************************************
*                        get invadjust
***************************************************************************
function getinvadjust
private tf,i,k

on key label f10 keyboard "{ctrl+w}"
*on key label enter keyboard "{ctrl+w}"
on key label f7 keyboard "{ctrl+q}"
on key label f8 keyboard "{ctrl+pgdn}"
on key label f9 keyboard "{ctrl+pgup}"
set color to gr+/b,w+/bg
@ row,0 say "PAY CODE       Description                 Reference                   Amount " color gr+/b
*                    get the codes
for i=1 to 5
@ row+i,5 get acod[i] PICTURE 'X'
@ row+i,43 get aref[i] picture 'XXXXXXXXXXXXXXXXXXXX'
@ row+i,70 get apri[i] picture '999999999' &&    get the price
endfor
clear gets

tf=.f.

for i=1 to 5
    store ' ' to acod[i]
    store space(20) to aref[i]
    store space(9) to apri[i]
endfor

j=1
do while (  tf=.f.)
    wait window "Press F8 to Select" nowait
    @ row+j,5 get acod[j] PICTURE 'X' ;
      VALID ( (val(acod[j])>=0 and val(acod[j])<=7) or (val(acod[j])>=11 and val(acod[j])<=36)) ;
      ERROR "Invalid entry,enter 0 to Select";
      color gr+/b,,,,,,,,gr+/b,gr+/b
    read
        gooddata=.t.
        lastk=lastkey()
        if  lastk<> 27 and lastk<>17 and lastk<>30 and lastk<>23 and lastk<>5 and lastk<>24 AND val(acod[J])<>0
                adesc[j]=disp_code(row+j,acod[j])
                   aref[j]=get_quantity(row+j,aref[j])
                   apri[j]=get_price(row+j,apri[j])
                   agood[j]=.t.
                lastk=0
        endif
          if lastkey()=27
             tf=acertain("Really Quit ?",.f.)
             set color to gr+/b,w+/bg
             if tf=.t.
                gooddata=.f.
                exit
             endif
          endif
          if gooddata
           do case
             case lastk=17
*                @ row+j,10 to row+j,45 clear
                 @ row+j,10 say space(36)
                acod[j]=' '
                aref[j]=SPACE(20)
                apri[j]=space(9)
                @ row+j,5 get acod[j] PICTURE 'X'
                @ row+j,43 get aref[j] picture 'XXXXXXXXXXXXXXXXXXXX'
                @ row+j,70 get apri[j] picture '999999999' &&    get the price
                clear gets
                gooddata=.f.
                agood[J]=.F.

             case lastk=30
                save screen to pre
                acod[j]=getcode()
                restore screen from pre
*                @ row+j,10 to row+j,45 clear
                 @ row+j,10 say space(36)
                @ row+j,5 get acod[j] PICTURE 'X'
                clear gets
                if val(acod[j])<>0
                adesc[j]=disp_code(row+j,acod[j])
                   aref[j]=get_quantity(row+j,aref[j])
                   apri[j]=get_price(row+j,apri[j])
                   agood[j]=.t.
                endif
                lastk=0
             case lastk=23
                exit
             endcase
             if ( (gooddata) and val(acod[j])<>0 )
                adesc[j]=disp_code(row+j,acod[j])
                if lastk=9
                   aref[j]=get_quantity(row+j,aref[j])
                   apri[j]=get_price(row+j,apri[j])
                   agood[J]=.T.
                   j=j-1
                endif
             else
             endif
          endif
          do case
             case lastk=5
                j=j-1
             case lastk=24
*             if ( (gooddata) and acod[j]<>0 )
                j=j+1
*             endif
*             otherwise
*                j=j+1
          endcase
          if j<1
             j=1
          endif
          if j>5
             j=5
          endif
enddo

total=0
for l=1 to 5
       TOTAL=TOTAL+val(aPRI[l])
ENDfor
newbal=newbal-total

on key label f10
on key label  f7
on key label  f8
on key label  f9
IF GOODDATA=.F.
   RETURN .F.
ENDIF
return .t.

***************************************************************************
*                        Do initialization
***************************************************************************
procedure initINVs

for i=1 to 10
    codarray[i]=space(30)
endfor

select paycode
go top
codarray[1]='Payment Codes'
codarray[2]=replicate('-',30)
I=3
do while !eof('paycode')
   codarray[i]=dtype+' '+dpayname
   skip
*   wait window str(i-2)+' '+dpayname
   i=i+1
enddo


*i=i+1
*codarray[i]='Adjustment Codes'
*i=i+1
*codarray[i]=replicate('Ä',30)
*i=i+1
*select adjustment
*do while !eof('adjustment')
*   codarray[i]=str(dadjnum,2,0)+' '+dadjname
*   skip
*   i=i+1
*enddo
return



***************************************************************************
*                        Function getcode
***************************************************************************
function getcode
private t,temp

temp=0
lastk=27
do while temp=0 and lastk=27
   t=codarray(3)
   t=3
   @ 5,15 get t from codarray size 10,34 color scheme 9 font "Arial",11
   read
   temp=int(val(left(codarray(t),2)))
   lastk=lastkey()
enddo

c=alltrim(str(temp))
return c

***************************************************************************
*                        Function get service code
***************************************************************************
function getsvccode
private t,temp
select codes

on key label enter keyboard "{ctrl+w}"
lastk=27
   set color to gr+/b,w+/bg
   define window codes at 3,2 size 15,79 system color scheme 10 shadow float;
	title "Press <F10> to select" font "Arial",11   		
   
   set deleted on
   browse fields dcdnum:h='Number',dcdname:20:h='Name',;
              dcdprice1:6:h="List 1",dcdprice2:6:h="List 2",dcdprice3:6:h="List 3",;
              dcdprice4:6:h="List 4",dcdprice5:6:h="List 5",dcdprice6:6:h="List 6";
               window codes nomodify nomenu color scheme 10
   set deleted off
   on key label enter
   lastk=lastkey()
   if lastk<>27
      temp=dcdnum
   else
       temp=0
   endif
c=alltrim(str(temp))
if len(c)<4
   c=space(4-len(c))+c
endif
release window codes
*price=dcdprice1
return c

***************************************************************************
*                        Function display code verbally
***************************************************************************
function disp_code
parameter row,cdnumstring
private string,cdnum

STRING=' '
cdnum=val(cdnumstring)

@ row,10 say space(33)

if cdnum<=7
  select paycode
  seek alltrim(str(cdnum))
  if !found()
     wait window "Fatal code "+alltrim(str(cdnum))+" Not found"
     cancel
  endif
  string=alltrim(dpayname)
ELSE
  STRING="Invalid Code"
endif

*if cdnum>=11
*   select adjustment
*   seek cdnum
*  if !found()
*     wait window "Fatal code "+alltrim(str(cdnum))+" Not found"
*     cancel
*  endif
*  string=alltrim(dadjname)
*endif

@ row,15 say left(string,25)
return string


***************************************************************************
*                        Function display code verbally
***************************************************************************
function disp_icode
parameter row,cdnumstring
private string,cdnum,rec

STRING=space(33)
cdnum=val(cdnumstring)

*@ row,10 to row,45 clear
@ row,10 say space(36)

if cdnumstring<>'    '
 if cdnum<1000
     select codes
     go top
     seek alltrim(str(cdnum))
     if !found()
        string="Invalid Code, out of bounds"
        PRICE=0
     else
         string=alltrim(dcdname)
*         price=dcdprice1
     endif
 else
  select installmen
   rec =cdnum-1000
   go top
   first=recno()
   go bottom
   last=recno()
   if rec<first or rec>last
   		string="Out of Installments' Bounds"
   		price=0
   else
                COUNT TO MANY
                GO TOP
                IF MANY>0
                   go (rec)
                   string=dreason
                   price=dpayment
                ELSE
                   string="Out of Installments' Bounds"
                   price=0
                ENDIF
	endif		   
 endif
   @ row,15 say left(string,33)
endif
return string


***************************************************************************
*                        Function get quantity verbally
***************************************************************************
function get_quantity
parameter row,number
private q

q=number
@ row,43 get q picture 'XXXXXXXXXXXXXXXXXXXX' &&   get the quantities color gr+/b,,,,,,,,gr+/b,gr+/b
read
return q


***************************************************************************
*                        Function get quantity verbally
***************************************************************************
function get_qty
parameter row,number
private q

q=number
@ row,49 get q picture '9' &&   get the quantities color gr+/b,,,,,,,,gr+/b,gr+/b
read
return q


***************************************************************************
*                        Function get list
***************************************************************************
function get_lst
parameter row,number,code
private q

q=number
@ row,55 get q picture '9' valid (val(q)>=1 and val(q)<=6) error "Allowed Values are between 1 and 6" &&   get the quantities color gr+/b,,,,,,,,gr+/b,gr+/b
read
if val(code)>100 and val(code)<1000
      do case
          case q="1"
              price=codes->dcdprice1
          case q="2"
              price=codes->dcdprice2
          case q="3"
              price=codes->dcdprice3
          case q="4"
              price=codes->dcdprice4
          case q="5"
              price=codes->dcdprice5
          case q="6"
              price=codes->dcdprice6
          otherwise
              price=codes->dcdprice1
      endcase
ELSE
    if val(code)=100
       price=client->dbalance
    endif
endif
return q


***************************************************************************
*                        Function get tax
***************************************************************************
function get_tax
parameter row,log
private q

q=log
@ row,61 get q picture '!' valid (q='Y' or q='N') error "Yes or No please"
read
return q

***************************************************************************
*                        Function get price
***************************************************************************
function get_price
parameter row,number
private q
q=val(number)
@ row,70 get q picture '999999.99' &&    get the price color gr+/b,,,,,,,,gr+/b,gr+/b
read
return str(q,7,2)


***************************************************************************
*                        Function get from installments
***************************************************************************
function getfrominst
parameter index
private many

select installmen
   set color to gr+/b,w+/bg
   define window codes at 3,20 size 15,79 color scheme 8 shadow float font "Arial",11 ;
   		title "Press <F10> to select"
   count to many for dpid=policy->dpid
   if many>0
      go top
*      WAIT WINDOW "LOCKING" nowait
*      do while !eof('Installmen')
*         if !lock(alltrim(str(recno())),'INSTALLMEN')
*            ?? chr(7)
*            wait window "Installments are being edited, data unreliable!!" nowait
*         endif
*         skip
*      enddo
*      wait clear
      set deleted on
      on key label enter keyboard "{ctrl+w}"
      browse fields dpayment:h='Price',dreason:h='Reason' ;
             window codes nomodify nomenu color scheme 10 title "Press <F10> to select";
             for dpid=policy->dpid .and. len(alltrim(comments))=0
*             for dpid=policy->dpid .and. (dtype=' '  )
      set deleted off
      on key label enter
      lastk=lastkey()
      pid=policy->dpid
*         if !used('POLICY')
*            select e
*            use POLICY index POLICY alias POLICY
*         else
*             select policy
*         endif
*      locate for dpid=pid
*      if !found()
*         ?? chr(7)
*         wait window "WARNING! No policy For Installments" nowait
*      endif
*      mpolicyno[index]=policyno
*      select installmen
   else
       ?? chr(7)
       wait window "No Installments Found!"
       return '0'
       go top
   endif
   if lastk<>27
      c=alltrim(str(recno()+1000))
   else
       c=' '
   endif
if len(c)<4
   c=space(4-len(c))+c
endif
release window codes
price=dpayment
IF LASTKEY()=27
  C='0000'
  PRICE=0
ENDIF
return c


***************************************************************************
*                        Procedure printinvoice
***************************************************************************
procedure printinvoice
wait clear
do prnchoic

wait window "Now Printing" nowait

SELECT INSTALLMENT
         SUM DPAYMENT TO CURPAYM FOR (DTYPE=' ' AND DPID=MDPID and deleted()=.f. and len(alltrim(comments))=0)

SELECT INVOICE
restore from comem.mem additive
invno=0
REPORT FORM INVOICE FOR DINVNO=MINVNO TO PRINT NOCONSOLE
wait clear
RETURN
