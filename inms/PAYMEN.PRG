

parameter macctno
set talk off
set procedure to "various"
declare codarray[40]
declare cod[16]
DECLARE GOOD[16]
declare ref[16]
declare pri[16]
declare mydesc[16]

select client
if lock(alltrim(str(recno())),'client')=.f.
   ?? chr(7)
   wait window 'This CLIENT is edited by Another User' timeout 1
   wait window 'Try again later' nowait
   return
endif

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
            set filter to
            set order to tag acctno

         if !used('adj')
            select h
            use adj index adjnum alias adjustment
         else
             select adjustment
         endif


         if !used('paycode')
            select i
            use paycode index paynum alias paycode
         else
             select paycode
         endif
         


       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif

store .f. to adjust,pay


* get the customer information
*acctno=getinfo()
SELECT CLIENT
SEEK MACCTNO

wait window 'Please wait I am gathering Code Information' nowait
for i=1 to 16
    store '  ' to cod[i]
    STORE .F. TO GOOD[I]
    store space(16) to ref[i],mydesc[i]
    store SPACE(7) to pri[i]
endfor
clerk=0
do initpays
do getinvoice
select client
unlock in client
return


***************************************************************************
*                        get invoice
***************************************************************************
procedure getinvoice
private tf,i,k

set color to gr+/b
clear
set color to gr+/b
=center (0,'Payments')

cdate=date()
row=4
@ row-1,0 TO row-1,79 DOUBLE
@ row,0 say "Payment Code              Description              Refference           Amount" color gr+/b
@ 21,0 TO 24,79 DOUBLE
SET COLOR TO GR+/b
=CENTER(22,'Press <F7> to Delete line   <F8>  to select code <TAB> to move over')
=center(23,'Press <F10> to Accept Entries    <Esc> to Cancel')
set color to gr+/n
@ 0,0 to 0,79 clear
=center(0,"PAYMENT ENTRY SCREEN")
set color to gr+/b
=center(2,"Client:"+str(macctno,4,0)+' '+alltrim(left(a.lastn,20))+' '+left(a.firstn,20)+' '+a.mi+'. '+a.ss)
set color to gr+/b,b/w
for i=1 to 16
    @ row+i,5 get cod[i] PICTURE '99'
    @ row+i,51 get ref[i] picture 'XXXXXXXXXXXX' &&   get the quantities
    @ row+i,72 get pri[i] picture '9999999' &&    get the price
endfor

wait clear
clear gets
@ 1,23 say "Date:" get cdate picture "@D"
@ 1,45 Say "Clerk:" get clerk size 1,4 picture '9999'
read
if lastkey()=27
   tf=acertain("Really Quit ? ",.f.)

set color to gr+/b,b/w
   if tf
   	RETURN
   endif	
ENDIF


*                    get the codes
for i=1 to 16
@ row+i,5 get cod[i] PICTURE '99'
@ row+i,51 get ref[i] picture 'XXXXXXXXXXXX' &&   get the quantities
@ row+i,72 get pri[i] picture '9999999' &&    get the price
endfor
clear gets

on key label f10 keyboard "{ctrl+w}"
on key label f7 keyboard "{ctrl+q}"
on key label f8 keyboard "{ctrl+i}"
tf=.f.

for i=1 to 16
    store '  ' to cod[i]
    store space(16) to ref[i]
    store 0 to pri[i]
endfor

j=1
do while (  tf=.f.)
    wait window "Press F8 to Select" nowait
    @ row+j,5 get cod[j] PICTURE '99' ;
      VALID ( (val(cod[j])>=0 and val(cod[j])<=8) or (val(cod[j])>=11 and val(cod[j])<=36)) ;
      ERROR "Invalid entry,enter 0 to Select";
      color gr+/b,,,,,,,,gr+/b,gr+/b
    read
        gooddata=.t.
        lastk=lastkey()
        if  lastk<> 27 and lastk<>17 and lastk<>9 and lastk<>23 and lastk<>24 and lastk<>5 AND val(COD[J])<>0
                mydesc[j]=disp_code(row+j,cod[j])
                   ref[j]=get_quantity(row+j,ref[j])
                   pri[j]=get_price(row+j,pri[j])
                   good[j]=.t.
                lastk=0
        endif
          if lastkey()=27
             tf=acertain("Really Quit ?",.f.)
set color to gr+/b,b/w
             set color to gr+/b,b/w
             if tf=.t.
                gooddata=.f.
                exit
             endif
          endif
          if gooddata
           do case
             case lastk=17
                @ row+j,10 to row+j,45 clear
                cod[j]='  '
                ref[j]=SPACE(16)
                pri[j]=0
                @ row+j,5 get cod[j] PICTURE '99'
                @ row+j,51 get ref[j] picture 'XXXXXXXXXXXX' &&   get the quantities
                @ row+j,72 get pri[j] picture '9999999' &&    get the price
                clear gets
                gooddata=.f.
                GOOD[J]=.F.

             case lastk=9
                save screen to pre
                cod[j]=getcode()
                restore screen from pre
                @ row+j,10 to row+j,45 clear
                @ row+j,5 get cod[j] PICTURE '99'
                clear gets
                if val(cod[j])<>0
                   mydesc[j]=disp_code(row+j,cod[j])
                   ref[j]=get_quantity(row+j,ref[j])
                   pri[j]=get_price(row+j,pri[j])
                   good[j]=.t.
                endif
                   lastk=0
             case lastk=23
                tfx=acertain("Are these the Final Payments ?",.f.)
set color to gr+/b,b/w
                if tfx=.t.
                  exit
                endif
             endcase
             if ( (gooddata) and val(cod[j])<>0 )
                mydesc[j]=disp_code(row+j,cod[j])
                if lastk=9
                   ref[j]=get_quantity(row+j,ref[j])
                   pri[j]=get_price(row+j,pri[j])
                   GOOD[J]=.T.
                   j=j-1
                endif
             else
             endif
          endif
          do case
             case lastk=5
                j=j-1
             case lastk=24
*             if ( (gooddata) and cod[j]<>0 )
                j=j+1
*             endif
*             otherwise
*                j=j+1
          endcase
          if j<1
             j=1
          endif
          if j>16
             j=16
          endif
enddo

*if lastkey()=27
*   set color to gr+/b,b/w
*  return .f.
*endif

*   wait window "Press F8 to Select" nowait
*   @ row+1,0 get cod[2] &&valid ( (cod[2]>=1 and cod[2]<=8) or (cod[2]>=11 and cod[2]<=36)) error "Invalid entry, Press F8 to select"
*   read
*          if lastkey()=27
*             exit
*          endif
*          if lastkey()=17
*             @ row+1,10 to row+1,79 clear
*             cod[2]=0
*             @ row+1,0 get cod[2]
*             clear gets
*          endif
*          if lastkey()=6
*             save screen to pre
*             cod[2]=getcode()
*             restore screen from pre
*             @ row+1,0 get cod[2]
*             clear gets
*          endif
*
*
*  wait window "Press F8 to Select" nowait
*  @ row+2,0 get cod[3] &&valid ( (cod[3]>=1 and cod[3]<=8) or (cod[3]>=11 and cod[3]<=36)) error "Invalid entry, Press F8 to select"
*  read
*          if lastkey()=27
*             exit
*          endif
*          if lastkey()=17
*             @ row+2,10 to row+2,79 clear
*             cod[3]=0
*             @ row+2,0 get cod[3]
*             clear gets
*          endif
*          if lastkey()=6
*             save screen to pre
*             cod[3]=getcode()
*             restore screen from pre
*             @ row+2,0 get cod[3]
*             clear gets
*          endif
*
*
*  wait window "Press F8 to Select" nowait
*  @ row+3,0 get cod[4] &&valid ( (cod[4]>=1 and cod[4]<=8) or (cod[4]>=11 and cod[4]<=36)) error "Invalid entry, Press F8 to select"
*  read
*          if lastkey()=27
*             exit
*          endif
*          if lastkey()=17
*             @ row+3,10 to row+3,79 clear
*             cod[4]=0
*             @ row+3,0 get cod[4]
*             clear gets
*          endif
*          if lastkey()=6
*             save screen to pre
*             cod[4]=getcode()
*             restore screen from pre
*             @ row+3,0 get cod[4]
*             clear gets
*          endif
*

on key label f10
on key label f7
on key label f8
*value=getcode()
*value=0
*if (value > 0)
*     if  (value <11)
*        pay=.t.
*        adjust=.f.
*     else
*         adjust=.T.
*         pay=.f.
*     endif
*else
*    pay=.f.
*    adjust=.f.
*endif
*if value=0
*   return
*endif


IF GOODDATA=.F.
   RETURN .F.
ENDIF


       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif

minvno=0
tot=0
j=0
select invoice
GO BOTTOM
lastprice=0
for i=1 to 16
    if ( GOOD[I] )
       tot=tot+pri[i]
       j=j+1
*       select payments
*       append blank
*       replace idate    with  CDATE,;
*               DINVNO   WITH  MINVNO,;
*               ACCTNO   WITH  MACCTNO,;
*               CLERKNUM WITH  CLERK,;
*               DCODE    WITH  val(COD[I]),;
*               DREFFER  WITH  REF[I],;
*               DPRICE   WITH  PRI[I],;
*               descript with  mydesc[i]

       append blank
       replace idate    with  CDATE,;
               DINVNO   WITH  MINVNO,;
               ACCTNO   WITH  client->ACCTNO,;
               CLERKNUM WITH  CLERK,;
               DCODE    WITH  val(COD[I]),;
               DREFFER  WITH  REF[I],;
               DPRICE   WITH  PRI[I],;
               posted   with  .f.,;
               billed   with  .f.,;
               descript with mydesc[i]
         lastprice=lastprice+pri[i]
    endif
endfor

* Update the balance field
newbal=client.dbalance-tot
select client
replace dbalance with newbal,;
        lastpayday with cdate,;
        lastamount with lastprice
unlock in client

             MINVOICENO=minvno
             MACCTNO   =client->acctno
             MTRANCODE =8000
             MQTY      =1
             MPRICE    =tot/j
             MTOTAL    =tot
             MDATE     =cdate
             MCLERK    =STR(clerk)
             MDESCRIPT ="Payments Made"
             MPOSTED   =.t.
             MBILLED   =.t.
             MCHECKNO  =''
             MPRICE   =0
             DVID      ='      '

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )


return


***************************************************************************
*                        Do initialization
***************************************************************************
procedure initpays
for i=1 to 39
    codarray[i]=space(30)
endfor

select paycode
go top
i=3
codarray[1]='Payment Codes'
codarray[2]=replicate('Ä',30)

do while !eof('paycode')
   codarray[i]=str(dpaynum,2,0)+' '+dpayname
   skip
   i=i+1
enddo

i=i+1
codarray[i]='Adjustment Codes'
i=i+1
codarray[i]=replicate('Ä',30)
i=i+1
select adjustment
do while !eof('adjustment')
   codarray[i]=str(dadjnum,2,0)+' '+dadjname
   skip
   i=i+1
enddo
return



***************************************************************************
*                        Function getcode
***************************************************************************
function getcode
private t,temp
temp=0
do while temp=0
   t=codarray(3)
   @ 5,15 get t from codarray size 20,34 color scheme 9
   read
   temp=int(val(left(t,2)))
enddo
if lastkey()=27
   temp=0
endif
c=alltrim(str(temp))
if len(c)=1
   c=' '+c
endif
return c


***************************************************************************
*                        Function display code verbally
***************************************************************************
function disp_code
parameter row,cdnumstr
private string

cdnum=val(cdnumstr)
@ row,10 to row,45 clear

if cdnum<=8
  select paycode
  seek int(cdnum)
  if !found()
     wait window "Fatal code "+alltrim(str(cdnum))+" Not found"
     cancel
  endif
  string=alltrim(dpayname)
endif

if cdnum>=11
   select adjustment
   seek cdnum
  if !found()
     wait window "Fatal code "+alltrim(str(cdnum))+" Not found"
     cancel
  endif
  string=alltrim(dadjname)
endif

@ row,15 say left(string,33) color w+/b
return string


***************************************************************************
*                        Function get quantity verbally
***************************************************************************
function get_quantity
parameter row,number
private q

q=number
@ row,51 get q picture 'XXXXXXXXXXXX' &&   get the quantities color gr+/b,,,,,,,,gr+/b,gr+/b
read
return q


***************************************************************************
*                        Function get quantity verbally
***************************************************************************
function get_price
parameter row,number
private q
q=number
@ row,72 get q picture '9999.99' &&    get the price color gr+/b,,,,,,,,gr+/b,gr+/b
read
return q


