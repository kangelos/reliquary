set talk off
boxes=27
numbers=29*13
elements=19
* good one 27 * 19
* good one 31 * 17
set escape on
declare digits(12,7)
workkey=space(14)
clear
PROGNAME='FAIR NUMBER GENERATOR'
digits( 1, 1)='  Ö·   '
digits( 1, 2)='  ½º   '
digits( 1, 3)='   º   '
digits( 1, 4)='   º   '
digits( 1, 5)='   º   '
digits( 1, 6)='   º   '
digits( 1, 7)='ÄÄÄĞÄÄÄ'

digits( 2, 1)='ÖÄÄÄÄÄ·'
digits( 2, 2)='      º'
digits( 2, 3)='      º'
digits( 2, 4)='ÖÄÄÄÄÄ½'
digits( 2, 5)='º      '
digits( 2, 6)='º      '
digits( 2, 7)='ÓÄÄÄÄÄÄ'

digits( 3, 1)='ÄÄÄÄÄÄ·'
digits( 3, 2)='      º'
digits( 3, 3)='      º'
digits( 3, 4)='  ÄÄÄÄ¶'
digits( 3, 5)='      º'
digits( 3, 6)='      º'
digits( 3, 7)='ÄÄÄÄÄÄ½'

digits( 4, 1)='Ö     ·'
digits( 4, 2)='º     º'
digits( 4, 3)='º     º'
digits( 4, 4)='ÓÄÄÄÄÄ¶'
digits( 4, 5)='      º'
digits( 4, 6)='      º'
digits( 4, 7)='      ½'

digits( 5, 1)='ÖÄÄÄÄÄÄ'
digits( 5, 2)='º      '
digits( 5, 3)='º      '
digits( 5, 4)='ÓÄÄÄÄÄ·'
digits( 5, 5)='      º'
digits( 5, 6)='      º'
digits( 5, 7)='ÄÄÄÄÄÄ½'

digits( 6, 1)='ÖÄÄÄÄÄ '
digits( 6, 2)='º      '
digits( 6, 3)='º      '
digits( 6, 4)='ÇÄÄÄÄÄ·'
digits( 6, 5)='º     º'
digits( 6, 6)='º     º'
digits( 6, 7)='ÓÄÄÄÄÄ½'

digits( 7, 1)='ÖÄÄÄÄÄ·'
digits( 7, 2)='      º'
digits( 7, 3)='      º'
digits( 7, 4)='      º'
digits( 7, 5)='      º'
digits( 7, 6)='      º'
digits( 7, 7)='      ½'

digits( 8, 1)='ÖÄÄÄÄÄ·'
digits( 8, 2)='º     º'
digits( 8, 3)='º     º'
digits( 8, 4)='ÇÄÄÄÄÄ¶'
digits( 8, 5)='º     º'
digits( 8, 6)='º     º'
digits( 8, 7)='ÓÄÄÄÄÄ½'

digits( 9, 1)='ÖÄÄÄÄÄ·'
digits( 9, 2)='º     º'
digits( 9, 3)='º     º'
digits( 9, 4)='ÓÄÄÄÄÄ¶'
digits( 9, 5)='      º'
digits( 9, 6)='      º'
digits( 9, 7)='ÄÄÄÄÄÄ½'

digits(10, 1)='ÖÄÄÄÄÄ·'
digits(10, 2)='º     º'
digits(10, 3)='º     º'
digits(10, 4)='º     º'
digits(10, 5)='º     º'
digits(10, 6)='º     º'
digits(10, 7)='ÓÄÄÄÄÄ½'


set talk off
* int(numbers/boxes)
number=0
=rand(-1)
declare result(boxes,elements)
declare boxused(boxes)


LASTK=34
DO WHILE LASTK<>27
for i=1 to boxes               && initialize everything
    boxused(i)=.f.
    FOR J=1 TO ELEMENTS
        RESULT(i,j)=-1
    endfor
endfor

K=INT(BOXES/2)
IF MOD(K,2)<>0
        L=K+1
ELSE
        L=K
ENDIF
number=0                         && fill in the boxes
for j=1 to elements
    for i=L TO 1 STEP -1
        result(i,j)=number
        number=number+1
    endfor
    for i=L+1 TO BOXES
        result(i,j)=number
        number=number+1
    endfor
endfor
do listnum
return

lastk=23
for i=1 to boxes          && Show the numbers
      boxnum=pickbox()
        for j=1 to elements
           if lastk<>27
              el=pickelement(boxnum)
              do numprint with result(boxnum,el)
              result(boxnum,el)=-1
           else
              TF=ACERTAIN(.F.,"Quit this program ")
              if tf
                 return
              endif
           endif
           wait window "Press a key for the next number" nowait
           set color to w+/g
           @ 0,0 to 0,79 clear
           =center(0,'Fair Number Generator')
           @ 23,0 to 24,79 clear
           =center(23,'Copyright (co) 1994-2004 Angelos Karageorgiou, all Rights Reserved')
           =center(24,'Product Serial Number:'+workkey)
           set color to
           =inkey(0)
           lastk=lastkey()
    endfor
endfor
LASTK=LASTKEY()
ENDDO
return


procedure listnum
set print on
PRIVATE NUM
NUM=0
?  '---------------- NUMBERS FROM 0 TO 499 FOR AN  8  HOUR PERIOD ---------------'
                        ?    '              '
for i=1 to boxes          && Show the numbers
      boxnum=pickbox()
*        boxnum=i
        for j=1 to elements
                el=pickelement(boxnum)
*               el=j
            if result(boxnum,el)<=499
                ?? str(result(boxnum,el),5)
                NUM=NUM+1
                IF MOD(NUM,10)=0
                        NUM=0
                        ?    '              '
                ENDIF
            endif
            result(boxnum,el)=-1
        endfor
endfor
SET PRINT OFF
return


FUNCTION irand
PARAMETER i, j
RETURN int((j-i+1)*rand()+i)


function pickbox
private boxnum
    boxnum=irand(1,boxes)
    do while boxused(boxnum)=.t.
       boxnum=irand(1,boxes)
    enddo
    boxused(boxnum)=.t.
return boxnum


function pickelement
parameter box
private sel
    sel=irand(1,elements)
    do while result(boxnum,sel)=-1
       sel=irand(1,elements)
    enddo
return sel



procedure numprint
parameter num
private number,numstring,colsoffset,nums,i,j

numstring=str(num,3)

colsoffset=25
row=9
if row>16
    for l=1 to 8
            ? '     '
    endfor
    row=row-8
    number=12
    myrow=row-8
    for j=1 to 7
        @ myrow,50 say '        '
        myrow=myrow+1
    endfor
endif
for nums=1 to len(numstring)
    IF substr(numstring,nums,1)=' '
       colsoffset=colsoffset+10
    ELSE
    number=val(substr(numstring,nums,1))
    if number=0
       number=10
    endif
    myrow=row
    for j=1 to 7
        @ myrow,colsoffset say digits(number,j)
        myrow=myrow+1
    endfor
    colsoffset=colsoffset+10
    ENDIF
endfor
return

****************************************************************************
** acertainer
****************************************************************************
procedure acertain
parameter tru,string

if tru=.T.
   tf=1
else
    tf=2
endif
if !wexist('acer')
   release window acer
endif
set color to
define window acer from 2,7 to 7,71 none float shadow title "[ Are You Sure ? ]";
color scheme 2
activate window acer
set color to r/w
=center(1,"Are you Positive ?")
=center(0,"You Want to:"+string)
SPACES=(WCOLS()/2)-1
set color to
@ 3,0 prompt SPACE(SPACES)+'YES'+SPACE(SPACES)
@ 4,0 prompt SPACE(SPACES+1)+'NO'+SPACE(SPACES)
menu to tf
deactivate window acer
if lastkey()=27
   return .f.
endif
IF TF=1
   return .T.
ELSE
    RETURN .F.
ENDIF

********************************************************************************
** Screen Centering tool
********************************************************************************
function center
parameter row,string
column=int((wcols()-len(string))/2)
@ row,column say string
return


procedure check
if file("c:\\dos\\ext2ems.sys")
        handle=fopen("c:\\dos\\ext2ems.sys")
        if handle<0
                ?? chr(7)
                wait window "No Workstation Key" timeout 5
                do comem
                cancel
        else
                for i=1 to 12
                        c=fread(handle,1024)
                endfor
                workkey=fgets(handle,14)
                =fclose(handle)
                =fclose(handle)
                mkey3=sechash()
                if mkey3<>workkey
                        ?? chr(7)
                        wait window "No Workstation Key" timeout 5
                        do comem
                        cancel
                endif
        endif
else
        ?? chr(7)
        wait window "No Workstation Key" timeout 5
        do comem
        cancel
endif
return


*****************************************************************
*            Procedure Comem
*****************************************************************
procedure comem
SET TALK OFF
?? chr(7)
?? chr(7)
?? chr(7)
?? chr(7)
?? chr(7)
define window comem from 2,2 to 22,76 ;
       title "System Information";
       float shadow system;
       Footer "Press <F10> to Accept new data, <ESC> to Quit";
       color scheme 10
if file("c:\\dos\\ext2ems.sys")
        handle=fopen("c:\\dos\\ext2ems.sys")
        if handle<0
                ?? chr(7)
                wait window "Cannot Read Customer key" timeout 5
                workkey=space(14)
        else
                workkey=fgets(handle,14)
                =fclose(handle)
        endif
else
        workkey=space(14)
endif

* get new values
mok=.F.
mok1=.F.
activate window comem
on key label f10 keyboard "{ctrl+w}"
   CLEAR

DO WHILE .not.mok
   @ 0,0 say '         1         2         3         4         5         6         7  '
   @ 1,0 say '1234567890123456789012345678901234567890123456789012345678901234567890123'
   =center(2,"'"+sys(0)+"',"+sys(2020)+","+sys(2022)+","+sys(17)+","+sys(1001))
   @ 3,0 say replicate (' ',73) color w/w
   =centerc(3," Installation Information ",'gr+/w')
   @   13,9 say 'Customer KEY:' get workkey size 1,14 picture '99999999999999'
   READ
    lastk=lastkey()
    if lastk=23 or lastk=27
       mok=.t.
    endif
ENDDO

if lastk=27
   on key label f10
   deactivate window comem
   release window comem
   return
endif

     tf=acertain(.t.,"Accept this Number ?")

* If ok, Save new memory file
IF tf
      handle=fcreate("c:\\dos\\ext2ems.sys")
      if handle<0
         ?? chr(7)
         wait window "Cannot Open/Create Workstation key file"
      else
         for i=1 to 12
                c=replicate(str(irand(1024,2048),4),256)
                =fwrite(handle,c,1024)
         endfor
         =fwrite(handle,workkey,14)
         for i=1 to 16
                c=replicate(str(irand(1024,2048),4),256)
                =fwrite(handle,c,1024)
         endfor
         =fclose(handle)
      endif


        deactivate window comem
        release window comem
        on key label f10
        set exclusive off
      ?? chr(7)
      ?? chr(7)
      wait window "Please Restart This program" TIMEOUT 3
      cancel       
ENDIF
deactivate window comem
release window comem
on key label f10
set exclusive off
RETURN


***************************************************************************
*                  center text on the screen with color
***************************************************************************
function centerc
parameter row,message,mycolor
private column
        column=int( (wcols()-len(message)) /2 )
        @ row,column say message color &mycolor
return  .t.





***************************************************************************
*                        Second HASH GENERATOR
***************************************************************************
FUNCTION SECHASH
S='FAIR NUMBER GENERATOR'
R=0.0
L=LEN(S)
FOR I=1 TO L
        C=SUBSTR(S,I,1)
        R=16*R+ASC(C)
ENDFOR
r=r+val(sys(2020))+val(sys(2022))*val(sys(17))+val(sys(1001))

NUMBER=ALLTRIM(SUBSTR(ALLTRIM(STR(R,20)),2,14))
L=LEN(NUMBER)
IF L<14
        if mod(l,2)=0
                NUMBER=REPLICATE('6',INT((14-L)/2))+NUMBER+REPLICATE('6',INT((14-L)/2))
        ELSE
                NUMBER=REPLICATE('6',INT((14-L)/2)+1)+NUMBER+REPLICATE('6',INT((14-L)/2))
        ENDIF
ENDIF
RETURN NUMBER
RETURN
