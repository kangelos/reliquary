parameter pid,MACCTNO


define window wcom at 1,1 size 25,81 in desktop system shadow float grow font "FixedSys",11;
	Title "Commission Payments"

activate window wcom

set talk off
set century on
set procedure to "various"
declare codarray[4]
declare cod[16]
DECLARE GOOD[16]
declare ref[16]
declare pri[16]
declare mydesc[16]
declare dates[16]
on key label enter
begin=0
ceiling=0
         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif
         set order to tag dpid

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

select comision
set filter to dpid=pid
* get the customer information
*acctno=getinfo()
SELECT CLIENT
SEEK MACCTNO

wait window 'Please wait I am gathering Code Information' nowait
for i=1 to 16
    store 0 to cod[i]
    STORE .F. TO GOOD[I]
    store space(16) to ref[i],mydesc[i]
    store 0 to pri[i]
    dates[i]=date()
endfor
TOT=0
clerk=0
do initpays
wait clear
TOT=getcomp()
select comision
*sum amount for dpid=pid to temp
release window wcom
return TOT


***************************************************************************
*                        get invoice
***************************************************************************
FUNCTION getcomp
private tf,i,k

set color to gr+/b
clear
set color to gr+/b
=center (0,'Commission Information')

cdate=date()
row=4
@ row-1,0 TO row-1,79 DOUBLE
@ row,0 say "Code     Date              Description                    Refference     Amount" color gr+/b
@ 21,0 TO 24,79 DOUBLE
SET COLOR TO gr+/b
=CENTER(22,'Press <F7> to Delete line   <F8>  to select code <TAB> to move over')
=center(23,'Press <F10> to Accept Entries    <Esc> to Cancel')
set color to gr+/b,w/r
set color to b/w
*=center(0,"Client:"+str(macctno,4,0)+' '+alltrim(left(a.lastn,20))+' '+left(a.firstn,20)+' '+a.mi+'. '+a.ss)
set color to gr+/b,w+/bg

    store '  ' to temp1
    temp2=space(12)
    temp3=space(7)
    temp4=space(10)
*                    get the codes
for i=1 to 16
if good[i]
   @ row+i,1 get cod[i] PICTURE '99'
   @ row+i,6 get dates[i] picture '@d'
   @ row+i,57 get ref[i] picture 'XXXXXXXXXXXX' &&   get the quantities
   @ row+i,72 get pri[i] picture '9999.99' &&    get the price
   =disp_code(row+i,cod[i])
else
   @ row+i,1 get temp1
   @ row+i,6 get temp4
   @ row+i,57 get temp2
   @ row+i,72 get temp3
endif
endfor
clear gets


*@ 2,23 say "Date:" get cdate picture "@D"
*@ 2,30 Say "Clerk:" get clerk size 1,4 picture '9999'
*read
*if lastkey()=27
*   tf=acertain("Really Quit ? ",.f.)

*set color to gr+/b,w+/bg
*   if tf
*        RETURN -1
*   endif	
*ENDIF

*                    get the codes
for i=1 to 16
if good[i]
   @ row+i,1 get cod[i] PICTURE '99'
   @ row+i,6 get dates[i] picture '@d'
   @ row+i,57 get ref[i] picture 'XXXXXXXXXXXX' &&   get the quantities
   @ row+i,72 get pri[i] picture '9999.99' &&    get the price
   =disp_code(row+i,cod[i])
else
   @ row+i,1 get temp1
   @ row+i,6 get temp4
   @ row+i,57 get temp2
   @ row+i,72 get temp3
endif
endfor
wait clear
clear gets

on key label f10 keyboard "{ctrl+w}"
on key label f7 keyboard "{ctrl+q}"
on key label f8 keyboard "{ctrl+pgdn}"
tf=.f.


ceiling=begin
j=1+begin
do while (  tf=.f.)
    wait window "Press F8 to Select" nowait
    @ row+j,1 get cod[j] PICTURE '99' ;
      VALID ( (cod[j]>=0 and cod[j]<=8) or (cod[j]>=11 and cod[j]<=36)) ;
      ERROR "Invalid entry,enter 0 to Select";
      color gr+/b,,,,,,,,gr+/b,gr+/b
    read
        gooddata=.t.
        lastk=lastkey()
        if  lastk<> 27 and lastk<>17 and lastk<>6 and lastk<>23 and lastk<>5 and lastk<>24 AND COD[J]<>0
                   mydesc[j]=disp_code(row+j,cod[j])
                   dates[j]=get_date(row+j,dates[j])
                   ref[j]=get_quantity(row+j,ref[j])
                   pri[j]=get_price(row+j,pri[j])
                   good[j]=.t.
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
              if j>ceiling
*                @ row+j,10 to row+j,45 clear
				@ row+i,10 say space(36)
                cod[j]=0
                ref[j]=SPACE(16)
                pri[j]=0
                dates[j]={  /  /    }
                @ row+j,1 get cod[j] PICTURE '99'
                @ row+j,6 get dates[j] picture '@d'
                @ row+j,57 get ref[j] picture 'XXXXXXXXXXXX' &&   get the quantities
                @ row+j,72 get pri[j] picture '9999999' &&    get the price
                clear gets
                gooddata=.f.
                GOOD[J]=.f.
              endif
             case lastk=30
                save screen to pre
                cod[j]=getcode()
                restore screen from pre
  *              @ row+j,10 to row+j,45 clear
   				@ row+i,10 say space(36)

                @ row+j,1 get cod[j] PICTURE '99'
                clear gets
                   mydesc[j]=disp_code(row+j,cod[j])
                   dates[j]=get_date(row+j,dates[j])
                   ref[j]=get_quantity(row+j,ref[j])
                   pri[j]=get_price(row+j,pri[j])
                   good[j]=.t.
                   lastk=0
             case lastk=23
                tf=acertain("Is this data Correct ?",.f.)
                if tf
                   exit
                endif
                set color to gr+/b,w+/bg
             endcase
             if ( (gooddata) and cod[j]<>0 )
                mydesc[j]=disp_code(row+j,cod[j])
                if lastk=9
                   ref[j]=get_quantity(row+j,ref[j])
                   pri[j]=get_price(row+j,pri[j])
                   dates[j]=get_date(row+j,dates[j])
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
             if ( (gooddata) and cod[j]<>0 )
                j=j+1
             endif
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


on key label f10
on key label f7
on key label f8


IF GOODDATA=.F.
   RETURN -1
ENDIF




tot=0
j=0
select comision
go top
wait window "Updating Please Wait" nowait
for i=1 to ceiling
 IF COD[I]=2
       tot=tot+pri[i]
 ELSE
       tot=tot-pri[i]
 ENDIF
       j=j+1
       replace dpid     with pid,;
               acctno   with macctno,;
               date     with  dates[i],;
               ACCTNO   WITH  MACCTNO,;
               CLERKNUM WITH  CLERK,;
               CODE     WITH  COD[I],;
               REFFER   WITH  REF[I],;
               amount   WITH  PRI[I],;
               comment  with  mydesc[i]
       skip
endfor
for i=1+ceiling to 16
    if ( GOOD[I] )

 IF COD[I]=2
       tot=tot+pri[i]
 ELSE
       tot=tot-pri[i]
 ENDIF

       j=j+1
       SELECT comision
       append blank
       replace dpid     with pid,;
               acctno   with macctno,;
               date     with  dates[i],;
               ACCTNO   WITH  MACCTNO,;
               CLERKNUM WITH  CLERK,;
               CODE     WITH  COD[I],;
               REFFER   WITH  REF[I],;
               amount   WITH  PRI[I],;
               comment  with  mydesc[i]
    endif
endfor
             MINVOICENO=0
             MACCTNO   =client->acctno
             MTRANCODE =8000
             MQTY      =1
             MPRICE    =tot/j
             MTOTAL    =tot
             MDATE     =date()
             MCLERK    =STR(clerk)
             MDESCRIPT ="Commission Payment Made"
             MPOSTED   =.t.
             MBILLED   =.t.
             MCHECKNO  =''
             MPRICE   =0
             DVID      ='      '

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
wait clear
return TOT


***************************************************************************
*                        Do initialization
***************************************************************************
procedure initpays
for i=1 to 4
    codarray[i]=space(30)
endfor

select paycode
go top
i=3
codarray[1]='Payment Codes'
codarray[2]=replicate('-',30)

select paycode
go top
I=3
do while !eof('paycode')
   if (upper(alltrim(dpayname))="CHECK" .OR. upper(alltrim(dpayname))="REFUND")
      codarray[I]=dtype+' '+dpayname
      I=I+1
   endif
   skip
enddo

SELECT COMISION
GO TOP

i=1
do while !eof('COMISION')
   if !lock(alltrim(str(recno())),"COMISION"))
      ?? chr(7)
      wait window "Somebody else is using these Comissions" timeout 1
      wait window "Please try again later" nowait
      unlock in comision
      return .f.
   endif
    cod[i]=code
    ref[i]=reffer
    mydesc[i]=comment
    pri[i]=amount
    dates[i]=comision.date
   skip
   good[i]=.t.
   i=i+1
enddo

begin=i-1
return



***************************************************************************
*                        Function getcode
***************************************************************************
function getcode
private t,temp
temp=0
do while temp=0
   t=codarray(3)
   t=3
   @ 5,15 get t from codarray size 6,34 color scheme 9
   read
   temp=int(val(left(codarray(t),2)))
enddo
if lastkey()=27
   temp=0
endif
return temp


***************************************************************************
*                        Function display code verbally
***************************************************************************
function disp_code
parameter row,cdnum
private string

*@ row,17 to row,52 clear
@ row,17 say space(52-17+1)
if cdnum<=8
  select paycode
  GO TOP
  seek ALLTRIM(str(cdnum))
  if !found()
     string=space(20)
  endif
  string=alltrim(dpayname)
endif

if cdnum>=11
   select adjustment
   GO TOP
   seek ALLTRIM(str(cdnum))
  if !found()
     string=space(20)
  endif
  string=alltrim(dadjname)
endif

@ row,22 say left(string,29) color w+/b
return string


***************************************************************************
*                        Function get quantity verbally
***************************************************************************
function get_quantity
parameter row,number
private q

q=number
@ row,57 get q picture 'XXXXXXXXXXXX' &&   get the quantities color gr+/b,,,,,,,,gr+/b,gr+/b
read
return q

***************************************************************************
*                        Function get date
***************************************************************************
function get_date
parameter row,oldate
private q

q=oldate
@ row,6 get q picture '@d'
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


