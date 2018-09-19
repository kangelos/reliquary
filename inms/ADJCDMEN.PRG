
set procedure to 'various'
set exclusive off
*set talk off
if menu()="ROOTMENU"
	hide menu rootmenu
endif
set color to w/b
clear
         if !used('adj')
            select h
            use adj index adjnum alias adjustment
         else
             select adjustment
         endif
go top
activerow=0
oldbegin=0
madjnum=0
madjname=space(25)
madjtype=' '
declare adjcodes[26]
*for i=1 to 26
*    ADJCODES[I]=.F.
*ENDfor
*
*GO TOP
*do WHILE !EOF('ADJUSTMENT')
*   ADJCODES[DADJNUM-10]=.t.
*   SKIP
*ENDDO
on key label uparrow keyboard "P"
on key label dnarrow keyboard "N"
on key label f10 keyboard "E"
do menuofAdjustments
on key label uparrow
on key label dnarrow
on key label f10
return

******************************************************************************
*                    Procedure Adjustment menu
******************************************************************************
procedure menuofAdjustments
private rec,cdpad
select adjustment
go bottom
go top
*locate for acctno=acct
do adjcddisplay
adjresult=-1
DEACTIVATE MENU adjmenu
do while adjresult<>0
  DEFINE MENU adjmenu BAR AT LINE 1 COLOR SCHEME 3
*  DEFINE PAD ADD        OF adjmenu   PROMPT ' \<Add'
*  DEFINE PAD Search     OF adjmenu  PROMPT '\<Search'
  DEFINE PAD First      OF adjmenu  PROMPT '\<First'
  DEFINE PAD Previous   OF adjmenu  PROMPT '\<Previous'
  DEFINE PAD Next       OF adjmenu  PROMPT '\<Next '
  DEFINE PAD Last       OF adjmenu  PROMPT '\<Last'
  DEFINE PAD Edit       OF adjmenu  PROMPT '\<Edit'
*  DEFINE PAD Delete     OF adjmenu  PROMPT '\<Delete'
*  DEFINE PAD Undelete   OF adjmenu  PROMPT '\<UnDelete'
  DEFINE PAD Quit       OF adjmenu  PROMPT '\<Quit'

  ON SELECTION MENU adjmenu DO adjmenu with adjresult
  cdpad=adjcurrentpad(adjresult)
  ACTIVATE MENU adjmenu pad (cdpad)
  cdpad=adjcurrentpad(adjresult)
  show MENU adjmenu pad (cdpad)
  if lastkey()=27
     adjresult=-1
  endif
    do case
     case adjresult=1
     if recno()>=2
          skip -1
          do adjcddisplay
     else
        wait window 'This is the First Record' nowait
     endif
     case adjresult=2
          skip
          if eof('adjustment')
                   wait window 'This is the Last Record' nowait
                   go bottom
          endif
          do adjcddisplay
     case adjresult=3
          adjlocked=adjdataedit()
          select adjustment
          if  ( (adjlocked=.t.) and (lastkey() # 27) )
                 do adjcdputdata
          endif
          unlock in adjustment
          do adjcddisplay
*     case adjresult=4
*          rec=recno()
*          temp=.f.
*          temp=findcode()
*          if temp=.f.
*             go (rec)
*          endif
*          do adjcddisplay
*     case adjresult=5
*          tf=acertain('DELETE REALLY?',.f.)
*          if tf=.t.
*             delete
*          endif
*          do adjcddisplay
*     case adjresult=6
*          recall
*          do adjcddisplay
     case adjresult=7
          go top
          do adjcddisplay
     case adjresult=8
          go bottom
          do adjcddisplay
*     case adjresult=9
*          rec= recno()
*          temp=addadjcode()
*          if temp=.f.
*             go (rec)
*          endif
*          do adjcddisplay
     case adjresult=-1
*	   wait window 'Watch It' nowait
  endcase
enddo
hide menu adjmenu
DEACTIVATE MENU adjmenu
RELEASE MENU adjmenu
return







******************************************************************************
*                    Procedure adjcddisplay
******************************************************************************
procedure adjcddisplay
PRIVATE REC,I,J,BEGIN,ENDing

I=0
J=0
ending=1
set color to gr+/n
@ 0,0 to 0,79 clear
=center(0,'ADJUSTMENT CODE INFORMATION')
set color to gr+/b
@ 2,0 say '       Code #   Code Name                        Code Type  ' color g+/b
select ADJUSTMENT
REC=RECNO()
madjnum=dadjnum
madjname=space(25)
madjname=stuff(madjname,1,len(dadjname),dadjname)
madjtype=dadjtype

IF REC<11
   BEGIN=1
else
    begin=rec-10
endif

ending=begin+19
if ending>26
   begin=7
   ending=26
endif

if begin<>oldbegin
*   @3,0 to 22,79 clear
   oldbegin=begin
endif

go begin

row=3
for i=(begin) to (ending) 
   madjnum=dadjnum
   madjname=space(25)
   madjname=stuff(madjname,1,len(dadjname),dadjname)
   madjtype=dadjtype
    if recno()=rec
       @ row,2 say  madjnum color gr+/b
       @ row,16 say  madjname color gr+/b
       @ row,51 say madjtype color gr+/b
       activerow=row
    else
       @ row,2 say  madjnum  color w/b
       @ row,16 say  madjname color w/b
       @ row,51 say madjtype color w/b
    endif
    row=row+1
    skip
endfor

@ 23,0 to  23,79 color g+/b
@ 24,0 to 24,79 clear
set color to gr+/b
=Center(24,"Use arrow Keys to Move.Use F10 to Edit Highlighted Selection")
go ( rec)
set color to gr+/b
set reprocess to 1
if lock(alltrim(str(recno())),'adjustment')=.f.
   ?? chr(7)
   wait window 'This CODE is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in adjustment
set reprocess to 1
return






******************************************************************************
*                    Procedure add Adjustment code
******************************************************************************
function addadjcode
private tf
set color to gr+/b
@ 0,0 to 0,79 clear
=center(0,'ADDING NEW ADJUSTMENT CODE')

@2,0 to 24,79 clear
select adjustment

madjtaxable=.f.
madjnotes=space(40)
madjnum=NEWADJCODE()
madjname=space(25)
madjtype=' '

IF MADJNUM=0
   ?? chr(7)
   WAIT WINDOW 'No more Adjustment codes are availlable' timeout 1
   return .f.
endif

set color to gr+/b,n/w
@ 23,0 to 23,79
@ 24,0 to 24,79 clear
=center(24,'Press F10 to accept new code')
on key label f10 keyboard '{ctrl+w}'
@ 4,4 TO 8,32 double color gr+/b
@ 4,45 TO 8,75   double color b/b
@ 11,25 TO 15,56 double color g/b
@ 5,7 SAY "Adjustment code Number"
@ 5,51 SAY "Adjustment code Name"
@ 12,30 SAY "Adjustment code Type"
@ 7,17 GET  madjnum SIZE 1,2  disabled color ,,,,,,,,,w/b
@ 7,48 GET  madjname SIZE 1,25  DEFAULT " " picture "@!"
@ 14,40 GET madjtype   SIZE 1,1  DEFAULT " " picture "@!"
read cycle
on key label f10 keyboard "E"
if lastkey()=27
   return .f.
endif

set color to gr+/b
madjnum=newadjcode()
select adjustment
if madjnum<>0
append blank
if lock(alltrim(str(recno())),'adjustment')=.f.
   ?? chr(7)
   wait window 'Fatal Cannot lock New record' timeout 1
   cancel
endif
replace dadjnum    with  madjnum,;
        dadjname   with  alltrim(upper(madjname)),;
        dadjtype  with  madjtype
unlock in adjustment
endif
return .t.





******************************************************************************
*                    Procedure adjdataedit
******************************************************************************
function adjdataedit
private tf,locked

on key label uparrow
on key label dnarrow
locked=.f.
if lock(alltrim(str(recno())),'ADJUSTMENT')=.f.
   wait window 'This CODE is edited by Another User Try Again Later'
   locked =.f.
   return locked
else
   locked=.t.
endif
set color to gr+/n,w/bg+
@ 0,0 to 0,79 clear
=center(0,'EDITING HIGHLIGHTED ADJUSTMENT CODE')
set color to gr+/b,w/bg+

select adjustment
madjnum=dadjnum
madjname=space(25)
madjname=stuff(madjname,1,len(dadjname),dadjname)
madjtype=dadjtype

@24,0 to 24,79 clear
set color to gr+/b
=center(24,'Press F10 to accept new code')
on key label f10 keyboard '{ctrl+w}'

@ activerow,10 get  madjnum  SIZE 1,2 disabled color ,,,,,,,,,g+/b
@ activerow,16 GET  madjname SIZE 1,25  DEFAULT " " picture "@!"
@ activerow,51 GET madjtype   SIZE 1,1  DEFAULT " " picture "@!"
read cycle
on key label f10 keyboard "E"
on key label uparrow keyboard "P"
on key label dnarrow keyboard "N"
return locked


******************************************************************************
*                    function CurrentPad
******************************************************************************
Function adjcurrentpad
parameter adjresult
private cdpad,tf

do case
   case      adjresult=1
             cdpad='PREVIOUS'
   case      adjresult=2
             cdpad='NEXT'
   case      adjresult=3
             cdpad='EDIT'
*  case      adjresult=4
*            cdpad='SEARCH'
   case      adjresult=5
             cdpad='DELETE'
   case      adjresult=6
             cdpad='UNDELETE'
   case      adjresult=0
             cdpad='QUIT'
   case      adjresult=7
             cdpad='FIRST'
   case      adjresult=8
             cdpad='LAST'
   case      adjresult=9
             cdpad='ADD'
   case      adjresult=-1
             cdpad='Repeat'
endcase
RETURN cdpad


******************************************************************************
*                    Procedure tmenu
******************************************************************************
Procedure adjmenu
parameter adjresult
private cdpad,tf

   cdpad=space(4)
   cdpad=pad()
     adjresult=-1
   if cdpad='PREVIOUS'
           adjresult=1
   endif
   if cdpad='NEXT'
           adjresult=2
   endif
   if cdpad='EDIT'
           adjresult=3
   endif

*  if cdpad='SEARCH'
*          adjresult=4
*  endif
   if cdpad='DELETE'
           adjresult=5
   endif
   if cdpad='UNDELETE'
           adjresult=6
   endif
   if cdpad='QUIT'
           adjresult=0
   endif
   if cdpad='FIRST'
           adjresult=7
   endif
   if cdpad='LAST'
           adjresult=8
   endif
   if cdpad='ADD'
           adjresult=9
   endif
   if lastkey()=27
      adjresult=-1
   endif
RETURN



wait window 'Adjustment codes'



******************************************************************************
*                    procedure put Adjustment code data
******************************************************************************
procedure adjcdputdata
replace dadjnum    with  madjnum,;
        dadjname   with  alltrim(upper(madjname)),;
        dadjtype  with  madjtype
return


******************************************************************************
*                    FUNCTION GET NEW Adjustment code NUMBER
******************************************************************************
FUNCTION NEWADJCODE
PRIVATE NUMBER
for i=1 to 26
    ADJCODES[I]=.F.
ENDfor

GO TOP
do WHILE !EOF('ADJUSTMENT')
   ADJCODES[DADJNUM-10]=.T.
   SKIP
ENDDO
NUMBER=0
FOR I=1 TO 26
  IF ADJCODES[I]=.F.
     NUMBER=I+10
     EXIT
  ENDIF
ENDfor
GO TOP
RETURN NUMBER
