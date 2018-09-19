set procedure to 'various'
push menu _msysmenu
set exclusive off
*set talk off
if menu()="ROOTMENU"
	hide menu rootmenu
endif
set color to gr+/b
clear
declare paycodes[26]
         if !used('paycode')
            select i
            use paycode index paynum alias paycode
         else
             select paycode
         endif
go top
activerow=0
oldbegin=0
mtype='0'
mpayname=space(25)
mpaytype=' '
*for i=1 to 26
*    payCODES[I]=.F.
*ENDfor
*
*GO TOP
*do WHILE !EOF('PAYcode')
*   payCODES[DpayNUM-10]=.t.
*   SKIP
*ENDDO
*on key label uparrow keyboard "P"
*on key label dnarrow keyboard "N"
*on key label f10 keyboard "E"
do menuofpayments

svcquit=0
do while svcquit=0
	activate menu _msysmenu
enddo	

*on key label uparrow
*on key label dnarrow
*on key label f10
pop menu _msysmenu
return

******************************************************************************
*                    Procedure PAYMENT menu
******************************************************************************
procedure menuofpayments
private rec,paypad
select paycode
go bottom
go top
*locate for acctno=acct
do paycddisplay
payresult=-1

  DEFINE MENU _msysmenu BAR AT LINE 1 COLOR SCHEME 3
  DEFINE PAD First      OF _msysmenu  PROMPT '\<First'
  DEFINE PAD Previous   OF _msysmenu  PROMPT '\<Previous'
  DEFINE PAD Next       OF _msysmenu  PROMPT '\<Next '
  DEFINE PAD Last       OF _msysmenu  PROMPT '\<Last'
  DEFINE PAD Edit       OF _msysmenu  PROMPT '\<Edit'
  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit'
  
  on selection pad first    of _msysmenu do cfirst
  on selection pad previous of _msysmenu do cprevious
  on selection pad next     of _msysmenu do cnext
  on selection pad last     of _msysmenu do clast
  on selection pad edit     of _msysmenu do cedit
  on selection pad quit     of _msysmenu do cquit
  

return


procedure cprevious
     if recno()>=2
          skip -1
          do paycddisplay
     else
        wait window 'This is the First Record' nowait
     endif
return 
     

procedure cnext
		 skip
          if eof('PAYcode')
                   wait window 'This is the Last Record' nowait
                   go bottom
          endif
          do paycddisplay
return

procedure  cedit
*          define window wcod at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Code Editing Window" font "FixedSys",9
*		  activate window wcod
 hide menu _msysmenu
          paylocked=paydataedit()
          select paycode

          if  ( (paylocked=.t.) and (lastkey() # 27) )
                 do paycdputdata
          endif
*          deactivate window wcod
*          release window wcod
show menu _msysmenu
          unlock in PAYcode
          do paycddisplay
return          


procedure cfirst
          go top
          do paycddisplay
return


procedure         clast
          go bottom
          do paycddisplay
return
          


procedure cquit
	svcquit=1
return	





******************************************************************************
*                    Procedure paycddisplay
******************************************************************************
procedure paycddisplay
PRIVATE REC,I,J,BEGIN,ENDing

I=0
J=0
ending=1
set color to gr+/n
@ 0,0 say space(80)
=center(0,'PAYMENT CODE INFORMATION')
set color to gr+/b
@ 5,0 say '              Code #    Code Name                       Code Type  ' color gr+/b
@ 6,7 to 16,72 double color gr+/b
*@ 4,0 to 4,79 color gr+/b
select paycode
REC=RECNO()
mtype=dtype
mpayname=space(25)
mpayname=stuff(mpayname,1,len(dpayname),dpayname)
mpaytype=dpaytype

go top

row=7
for i=1 to 8
   mtype=dtype
   mpayname=space(25)
   mpayname=stuff(mpayname,1,len(dpayname),dpayname)
   mpaytype=dpaytype
    if recno()=rec
       @ row,17 say  mtype color gr+/b
       @ row,25 say  mpayname color gr+/b
       @ row,58 say mpaytype color gr+/b
       activerow=row
    else
       @ row,17 say  mtype  color w/b
       @ row,25 say  mpayname color w/b
       @ row,58 say mpaytype color  w/b

    endif
    row=row+1
    skip
endfor

@ 23,0 to  23,79 color gr+/b
@ 24,0 say space(80)
*=Center(24,"Use arrow Keys to Move.Use F10 to Edit Highlighted Selection")
go ( rec)
set color to gr+/b
set reprocess to 1
if lock(alltrim(str(recno())),'PAYCODE')=.f.
   ?? chr(7)
   wait window 'This CODE is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in PAYcode
set reprocess to 1
return






******************************************************************************
*                    Procedure add PAYMENT code
******************************************************************************
function addpaycode
private tf
set color to gr+/b
@ 0,0 say space(80)
=center(0,'ADDING NEW PAYMENT CODE')

@2,0 say space(80)
select paycode

mpaytaxable=.f.
mpaynotes=space(40)
mtype=NEWpayCODE()
mpayname=space(25)
mpaytype=' '

IF Mtype='0'
   ?? chr(7)
   WAIT WINDOW 'No more PAYMENT codes are availlable' nowait
   return .f.
endif

set color to gr+/b,n/w
@ 23,0 to 23,79
@ 24,0 say space(80)
=center(24,'Press <F10> to accept code,or <ESC> to exit')
on key label f10 keyboard '{ctrl+w}'
@ 4,4 TO 8,32 double color rb+/n
@ 4,45 TO 8,75   double color b/n
@ 11,25 TO 15,56 double color g/n
@ 5,7 SAY "PAYMENT code Number"
@ 5,51 SAY "PAYMENT code Name"
@ 12,30 SAY "PAYMENT code Type"
@ 7,17 GET  mtype SIZE 1,2  disabled color ,,,,,,,,,r+/n
@ 7,48 GET  mpayname SIZE 1,25  DEFAULT " " picture "@!"
@ 14,40 GET mpaytype   SIZE 1,1  DEFAULT " " picture "@!"
read cycle
on key label f10 keyboard "E"
if lastkey()=27
   return .f.
endif

set color to gr+/b
mtype=newpaycode()
select paycode
if mtype<>0
append blank
if lock(alltrim(str(recno())),'PAYcode')=.f.
   ?? chr(7)
   wait window 'Fatal Cannot lock New record' timeout 1
   cancel
endif
replace dtype    with  mtype,;
        dpayname   with  alltrim(upper(mpayname)),;
        dpaytype  with  mpaytype
unlock in PAYcode
endif
return .t.





******************************************************************************
*                    Procedure paydataedit
******************************************************************************
function paydataedit
private tf,locked

locked=.f.
if lock(alltrim(str(recno())),'PAYcode')=.f.
   wait window 'This CODE is edited by Another User Try Again Later'
   locked =.f.
   return locked
else
   locked=.t.
endif
set color to gr+/n
@ 0,0 say space(80)
=center(0,'EDITING HIGHLIGHTED PAYMENT CODE')
set color to gr+/b,w/bg+

select paycode
mtype=dtype
mpayname=space(25)
mpayname=stuff(mpayname,1,len(dpayname),dpayname)
mpaytype=dpaytype

*on key label uparrow
*on key label dnarrow

@24,0 say space(80)
=center(24,'Press <F10> to accept new code,or <ESC> to exit')
on key label f10 keyboard '{ctrl+w}'

@ activerow,17 get  mtype  SIZE 1,2 disabled color ,,,,,,,,,gr+/b
@ activerow,25 GET  mpayname SIZE 1,25  DEFAULT " " picture "@!"
@ activerow,58 GET mpaytype   SIZE 1,1  DEFAULT " " picture "@!"
read cycle
*on key label f10 keyboard "E"
*on key label uparrow keyboard "P"
*on key label dnarrow keyboard "N"
return locked






******************************************************************************
*                    procedure put PAYMENT code data
******************************************************************************
procedure paycdputdata
replace dtype    with  mtype,;
        dpayname   with  alltrim(upper(mpayname)),;
        dpaytype  with  mpaytype
return


******************************************************************************
*                    FUNCTION GET NEW PAYMENT code NUMBER
******************************************************************************
FUNCTION NEWpayCODE
PRIVATE NUMBER
for i=1 to 26
    payCODES[I]=.F.
ENDfor

GO TOP
do WHILE !EOF('PAYcode')
   payCODES[Dtype-10]=.T.
   SKIP
ENDDO
NUMBER=0
FOR I=1 TO 26
  IF payCODES[I]=.F.
     NUMBER=I+10
     EXIT
  ENDIF
ENDfor
GO TOP
RETURN NUMBER
