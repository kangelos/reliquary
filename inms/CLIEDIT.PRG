
declare cliscreen[31,11]
CLISCITS=30
* 1 row ,
* 2 column ,
* 3 message ,
* 4 variable ,
* 5 picture ,
* 6 size ,
* 7 color ,
* 8 enabled ,
* 9 real-data
* 10 valid clause
* 11 error clause
saved=.f.
set procedure to "various"
UP=5
DOWN=24
LEFT=19
RIGHT=4
ENTER=13
set color to w/b
clear
set color to gr+/n
@ 0,0 to 0,79 clear
=center(0,"Client Screen Designer")
set color to w/b

index=1
oldindex=1

   clnamesize =25
   cfnamesize =25
   cadrsize   =35
   captsize   =8
   csalsize   =10
   cdlicsize  =20
   coccsize   =30
   cempsize   =30
   cempadsize =30
   cempcszsize=30
   crefsize   =30
   cnotesize  =50
   cvarsize   =70
   ccitysize  =20
   ccountysize=20
   mbalance=0

 **
****  Initialize the variables now.
 **
   macctno=0
   clname=replicate("X",clnamesize)
   cfname=replicate("X",cfnamesize)
   cmi="X"
   caddress=replicate("X",cadrsize)
   captno=replicate("X",captsize)
   csalutation=replicate("X",csalsize)
   cbdate={11/11/1111}
   csex="M"
   cssc="999-99-9999"
   cdrivlic=replicate("X",cdlicsize)
   chomephone="(999)-999-9999"
   cworkphone="(999)-999-9999"
   coccupation=replicate("X",coccsize)
   cemployer=replicate("X",cempsize)
   cempadress=replicate("X",cempadsize)
   cempcsz=replicate("X",cempcszsize)
   cemphone="(999)-999-9999"
   cmarstat="S"
   creffered=0
   crefferal=replicate("X",crefsize)
   cnotes=replicate("X",cnotesize)
   cthirty=0
   csixty=0
   cninety=0
   conetwenty=0
   ctotal=0
   cvar=replicate("X",cvarsize)
   ccity=replicate("X",ccitysize)
   cstate="XX"
   IssstaTE="XX"
   Issdate={11/11/1111}
   czip=replicate("X",11)
   ccounty=replicate("X",ccountysize)
   cvar=replicate("X",cvarsize)
   paydate={11/11/11111}
   payamount=0
      
fn=fname("cliscre.mem")
if !file(fn)
   do initcli
   CLISCITS=30
else
    restore from &fn additive
endif

do showcli


index=1
oldindex=1
do showel

set color to n/w
@ 24,0 to 24,79 clear
myname='Angelos Karageorgiou'
=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
set color to w/b

do movecli
*release CLISCITS
*release  cliscreen
cliscits=0
return saved

***************************************************************************
*                   Initialize client screen
***************************************************************************
procedure movecli
define menu edclmenu color scheme 3

  DEFINE PAD First      OF edclmenu  PROMPT '\<First'     at 1,01
  DEFINE PAD Previous   OF edclmenu  PROMPT '\<Previous'  at 1,10
  DEFINE PAD Next       OF edclmenu  PROMPT '\<Next'      at 1,20
  DEFINE PAD Last       OF edclmenu  PROMPT '\<Last'      at 1,27
  DEFINE PAD Move       OF edclmenu  PROMPT '\<Move'      at 1,35
  DEFINE PAD Hide       OF edclmenu  PROMPT '\<Hide'      at 1,42
  DEFINE PAD Show       OF edclmenu  PROMPT 'Sh\<ow'      at 1,50
  DEFINE PAD Revert     OF edclmenu  PROMPT '\<Revert'    at 1,58
  DEFINE PAD Save       OF edclmenu  PROMPT '\<Save'      at 1,67
  DEFINE PAD Quit       OF edclmenu  PROMPT '\<Quit'      at 1,74

on selection pad First      of edclmenu do first
on selection pad Previous   of edclmenu do prev
on selection pad Next       of edclmenu do next
on selection pad Last       of edclmenu do last
on selection pad Move       of edclmenu do Move
on selection pad Hide       of edclmenu do Hide
on selection pad Show       of edclmenu do CShow
on selection pad Revert     of edclmenu do revert
on selection pad Save       of edclmenu do saveall
on selection pad Quit       of edclmenu do quit
SET COLOR TO N/W
@1,0 to 1,79 clear
set color to gr+/b,w/b
lastk=27
do while lastk=27
   activate menu edclmenu
   lastk=lastkey()
enddo
return

***************************************************************************
*                   Initialize client screen
***************************************************************************
procedure initcli
for i=1 to CLISCITS
    cliscreen[i,1]=0
    cliscreen[i,2]=0
    cliscreen[i,3]=" "
    cliscreen[i,4]=" "
    cliscreen[i,5]=" "
    cliscreen[i,6]=0
    cliscreen[i,7]=" "
    cliscreen[i,8]=.t.
    cliscreen[i,9]=.t.
    cliscreen[i,10]=" "
    cliscreen[i,11]=" "
endfor


*@4,1 SAY "Account No:" get macctno disabled color ,,,,,,,,w+/b,w+/b
cliscreen[01,01]=4
cliscreen[01,02]=1
cliscreen[01,03]="Account No:"
cliscreen[01,04]="macctno"
cliscreen[01 ,5]="9999"
cliscreen[01,6]=4
cliscreen[01,7]=",,,,,,,,w+/b,w+/b "
cliscreen[01,9]=.f.


*@5,2 say  "Last Name:" get clname picture "!"+replicate("X",(clnamesize)-1) size 1,25
cliscreen[02,01]=5
cliscreen[02,02]=2
cliscreen[02,03]="Last Name:"
cliscreen[02,04]="clname"
cliscreen[02,5]="!"+replicate("X",(clnamesize))
cliscreen[02,6]=25
cliscreen[02,7]=" "

*@5,40 say "First Name:" get cfname picture "!"+replicate("X",(cfnamesize)-1) size 1,20
cliscreen[03,01]=5
cliscreen[03,02]=40
cliscreen[03,03]="First Name:"
cliscreen[03,04]="cfname"
cliscreen[03 ,5]="!"+replicate("X",(cfnamesize))
cliscreen[03,6]=20
cliscreen[03,7]=" "

*@5,73 say "MI:" get cmi picture "!"
cliscreen[04,01]=5
cliscreen[04,02]=73
cliscreen[04,03]="MI:"
cliscreen[04,04]="cmi"
cliscreen[04 ,5]="!"
cliscreen[04,6]=1
cliscreen[04,7]=" "

*@ 6,4 say "Address:" get caddress  picture "!"+replicate("X",(cadrsize)-1) size 1,30
cliscreen[05,01]=6
cliscreen[05,02]=4
cliscreen[05,03]="Address:"
cliscreen[05,04]="caddress"
cliscreen[05 ,5]="!"+replicate("X",(cadrsize))
cliscreen[05,6]=30
cliscreen[05,7]=" "

*@ 6,44 SAY "Apt No:" get captno picture replicate("X",(captsize)-1) size 1,8
cliscreen[06,01]=6
cliscreen[06,02]=44
cliscreen[06,03]="Apt No:"
cliscreen[06,04]="captno"
cliscreen[06 ,5]=replicate("X",(captsize))
cliscreen[06,6]=8
cliscreen[06,7]=" "

*@ 7,7 say "City:" get ccity picture replicate("X",ccitysize) size 1,15
cliscreen[07,01]=7
cliscreen[07,02]=7
cliscreen[07,03]="City:"
cliscreen[07,04]="CCITY"
cliscreen[07 ,5]=replicate("X",ccitysize)
cliscreen[07,6]=15
cliscreen[07,7]=" "

*@ 7,29 say "County:" get ccounty picture replicate("X",ccountysize) size 1,14
cliscreen[08,01]=7
cliscreen[08,02]=29
cliscreen[08,03]="County:"
cliscreen[08,04]="ccounty"
cliscreen[08 ,5]=replicate("X",ccountysize)
cliscreen[08,6]=14
cliscreen[08,7]=" "

*@ 7,52 say "State:" get cstate picture "!!"
cliscreen[09,01]=7
cliscreen[09,02]=52
cliscreen[09,03]="State:"
cliscreen[09,04]="cstate"
cliscreen[09 ,5]="!!"
cliscreen[09,6]=2
cliscreen[09,7]=" "

*@ 7,62 say "Zip:" get czip picture "99999-9999"
cliscreen[10,1]=7
cliscreen[10,2]=62
cliscreen[10,3]="Zip:"
cliscreen[10,4]="CZip"
cliscreen[10 ,5]="99999-9999"
cliscreen[10,6]=10
cliscreen[10,7]=" "

*@8,27 say "Sex:" get csex picture "!" valid (csex="M" or csex="F" )
cliscreen[11,1]=8
cliscreen[11,2]=27
cliscreen[11,3]="Sex:"
cliscreen[11,4]="csex"
cliscreen[11 ,5]="!"
cliscreen[11,6]=1
cliscreen[11,7]=" "

*@ 9,1 say "Salutation:" get csalutation  picture replicate("X",(csalsize)-1) size 1,10
cliscreen[12,1]=9
cliscreen[12,2]=1
cliscreen[12,3]="Salutation:"
cliscreen[12,4]="csalutation"
cliscreen[12 ,5]=replicate("X",(csalsize))
cliscreen[12,6]=10
cliscreen[12,7]=" "

*@10,1 say "Birth Date:" get cbdate picture "*@d"
cliscreen[13,1]=10
cliscreen[13,2]=1
cliscreen[13,3]="Birth Date:"
cliscreen[13,4]="cbdate"
cliscreen[13 ,5]="*@d"
cliscreen[13,6]=10
cliscreen[13,7]=" "


*@11,1 say "Soci6al Sec:" get cssc picture "999-99-9999"
cliscreen[14,1]=11
cliscreen[14,2]=1
cliscreen[14,3]="Social Sec:"
cliscreen[14,4]="cssc"
cliscreen[14 ,5]="999-99-9999"
cliscreen[14,6]=11
cliscreen[14,7]=" "

*@12,1 say "Driv Lic #:" get cdrivlic picture replicate("X",(cdlicsize)) size 1,20
cliscreen[15,1]=12
cliscreen[15,2]=1
cliscreen[15,3]="Driv Lic #:"
cliscreen[15,4]="cdrivlic"
cliscreen[15 ,5]=replicate("X",(cdlicsize))
cliscreen[15,6]=20
cliscreen[15,7]=" "

*@13,1 say "State Issd:" get issstate picture "aa"
cliscreen[16,1]=13
cliscreen[16,2]=1
cliscreen[16,3]="State Issd:"
cliscreen[16,4]="issstate"
cliscreen[16 ,5]="XX"
cliscreen[16,6]=2
cliscreen[16,7]=" "

*@13,17 say "Date Issd:"  get issdate picture "*@d"
cliscreen[17,1]=13
cliscreen[17,2]=17
cliscreen[17,3]="Date Issd:"
cliscreen[17,4]="issdate"
cliscreen[17 ,5]="@d"
cliscreen[17,6]=10
cliscreen[17,7]=" "

*@ 14,1 say "Mar Status:" get cmarstat picture "!" valid (cmarstat="M" or cmarstat="S" or cmarstat="W" )
cliscreen[18,1]=14
cliscreen[18,2]=1
cliscreen[18,3]="Mar Status:"
cliscreen[18,4]="cmarstat"
cliscreen[18 ,5]="!"
cliscreen[18,6]=1
cliscreen[18,7]=" "

*@ 9,40  say "Home phone:" get chomephone picture "(999)-999-9999"
cliscreen[19,1]=9
cliscreen[19,2]=40
cliscreen[19,3]="Home phone:"
cliscreen[19,4]="chomephone"
cliscreen[19 ,5]="(999)-999-9999"
cliscreen[19,6]=14
cliscreen[19,7]=" "

*@ 10,40 say "Work phone:" get cworkphone picture "(999)-999-9999"
cliscreen[20,1]=10
cliscreen[20,2]=40
cliscreen[20,3]="Work phone:"
cliscreen[20,4]="cworkphone"
cliscreen[20 ,5]="(999)-999-9999"
cliscreen[20,6]=14
cliscreen[20,7]=" "

*@ 11,40 say "Occupation:" get coccupation picture "!"+replicate("X",(coccsize)-1) size 1,26
cliscreen[21,1]=11
cliscreen[21,2]=40
cliscreen[21,3]="Occupation:"
cliscreen[21,4]="coccupation"
cliscreen[21 ,5]="!"+replicate("X",(coccsize))
cliscreen[21,6]=26
cliscreen[21,7]=" "

*@ 12,42 say "Employer:" get cemployer picture "!"+replicate("X",(cempsize)-1) size 1,26
cliscreen[22,1]=12
cliscreen[22,2]=42
cliscreen[22,3]="Employer:"
cliscreen[22,4]="cemployer"
cliscreen[22 ,5]="!"+replicate("X",(cempsize))
cliscreen[22,6]=26
cliscreen[22,7]=" "

*@ 13,39 say "Emp Address:" get cempadress picture "!"+replicate("X",(cempadsize)-1) size 1,26
cliscreen[23,1]=13
cliscreen[23,2]=39
cliscreen[23,3]="Emp Address:"
cliscreen[23,4]="cempadress"
cliscreen[23 ,5]="!"+replicate("X",(cempadsize))
cliscreen[23,6]=26
cliscreen[23,7]=" "

*@ 14,43 say "Emp CSZ:" get cempcsz picture "!"+replicate("X",(cempcszsize)-1) size 1,26
cliscreen[24,1]=14
cliscreen[24,2]=43
cliscreen[24,3]="Emp CSZ:"
cliscreen[24,4]="cempcsz"
cliscreen[24 ,5]="!"+replicate("X",(cempcszsize))
cliscreen[24,6]=26
cliscreen[24,7]=" "

*@ 15,41 say "Emp Phone:" get cemphone picture "(999)-999-9999"
cliscreen[25,1]=15
cliscreen[25,2]=41
cliscreen[25,3]="Emp Phone:"
cliscreen[25,4]="cemphone"
cliscreen[25 ,5]="(999)-999-9999"
cliscreen[25,6]=14
cliscreen[25,7]=" "

*@ 16,1  say "Referred by:" get creffered picture "9999"
cliscreen[26,1]=16
cliscreen[26,2]=1
cliscreen[26,3]="Referred by:"
cliscreen[26,4]="creffered"
cliscreen[26 ,5]="9999"
cliscreen[26,6]=4
cliscreen[26,7]=" "
cliscreen[26,10]="getreffer(creffered)"

*@ 16,21 say "Referral name:" get crefferal picture "!"+replicate("X",(crefsize)-1) size 1,30
cliscreen[27,1]=16
cliscreen[27,2]=21
cliscreen[27,3]="Referral name:"
cliscreen[27,4]="crefferal"
cliscreen[27 ,5]="!"+replicate("X",(crefsize))
cliscreen[27,6]=30
cliscreen[27,7]=" "

*@ 17,7  say "Notes:" get cnotes picture "!"+replicate("X",(cnotesize)-1) size 1,60
cliscreen[28,1]=17
cliscreen[28,2]=7
cliscreen[28,3]="Notes:"
cliscreen[28,4]="cnotes"
cliscreen[28 ,5]="!"+replicate("X",(cnotesize))
cliscreen[28,6]=60
cliscreen[28,7]=" "

*@ 18,36  SAY 'Balance:' get mbalance picture '999,999.99'
cliscreen[29,1]=18
cliscreen[29,2]=29
cliscreen[29,3]="Balance:"
cliscreen[29,4]="mbalance"
cliscreen[29,5]="999,999.99"
cliscreen[29,6]=10
cliscreen[29,7]=" "

*@ 19,5   get cvar picture replicate("X",cvarsize) size 1,(cvarsize)
cliscreen[30,1]=19
cliscreen[30,2]=5
cliscreen[30,3]=' '
cliscreen[30,4]="CVAR"
cliscreen[30,5]=replicate("X",cvarsize)
cliscreen[30,6]=70
cliscreen[30,7]=" "

*   @ 21,45 say "Amount:"
*cliscreen[31,1]=21
*cliscreen[31,2]=45
*cliscreen[31,3]="Amount:"
*cliscreen[31,4]="payamount"
*cliscreen[31 ,5]="9999999.99"
*cliscreen[31,6]=9
*cliscreen[31,7]="rb+/b,w+/b "
*cliscreen[31,9]=.f.   && Display Only


*for i=1 to 50
*    if cliscreen[i,1]<>0 and cliscreen[i,2]<>0
*       if cliscreen[i,6]>0
*          cliscreen[i,5]=left(cliscreen[i,5],cliscreen[i,6])
*       endif
*    endif
*endfor
return



***************************************************************************
*                  Display client screen
***************************************************************************
procedure dispcli
clear
set color to gr+/b,w/bg
FOR I=1 TO 50
if cliscreen[i,1]<>0 and cliscreen[i,2]<>0
if cliscreen[i,6]>0
 if cliscreen[i,5]<>" "
       if cliscreen[i,7]=" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3];
                                           GET         (CLISCREEN[I,4]);
                                           picture      CLISCREEN[I,5];
                                           size         1,cliscreen[i,6]
       endif
       if cliscreen[i,7]<>" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           color       (clISCREEN[I,7]);
                                           size         1,cliscreen[i,6]
       endif
  else
       if cliscreen[i,7]=" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY          CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           size         1,cliscreen[i,6]
       endif
       * both color and size
       if cliscreen[i,7]<>" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY          CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           color       (CLISCREEN[I,7]);
                                           size         1,cliscreen[i,6]
       endif
   endif
 else
 if cliscreen[i,5]<>" "
       if cliscreen[i,7]=" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3];
                                           GET         (CLISCREEN[I,4]);
                                           picture      CLISCREEN[I,5]
       endif
       if cliscreen[i,7]<>" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           color       (clISCREEN[I,7])
       endif
  else
       if cliscreen[i,7]=" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY          CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4])
       endif
       * both color and size
       if cliscreen[i,7]<>" "
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY          CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           color       (CLISCREEN[I,7])
       endif
   endif
 endif
endif
ENDFOR
clear gets
return


***************************************************************************
*                   first
***************************************************************************
procedure first
oldindex=index
index=1
       do showel
return

***************************************************************************
*                   last
***************************************************************************
procedure last
oldindex=index
index=cliscITS
       do showel
return

***************************************************************************
*                   next
***************************************************************************
procedure next
oldindex=index
index=index+1
if index>=CLISCITS
   index=CLISCITS
endif
       do showel
return

***************************************************************************
*                   previous
***************************************************************************
procedure prev
oldindex=index
index=index-1
if index<=1
   index=1
endif
       do showel
return

***************************************************************************
*                   quit
***************************************************************************
pROCEDURE QUIT
tf=.t.
          if saved=.f.
             ?? chr(7)
             tf=acertain("Nothing Saved, Really Quit?",.f.)
          endif
          if tf
             hide menu edclmenu
             DEACTIVATE MENU edclmenu
             RELEASE MENU edclmenu
          endif
RETURN


***************************************************************************
*                   hide
***************************************************************************
procedure hide
          if index <> 2
            oldindex=index
            cliscreen[index,8]=.f.
            do showel
            saved=.f.
          else
            ?? chr(7)
            Wait window "Cannot disable this, It is Necessary" nowait
          endif
return


***************************************************************************
*                   show
***************************************************************************
procedure Cshow
          oldindex=index
          cliscreen[index,8]=.t.
          do showel
          saved=.f.
return

***************************************************************************
*                   save data
***************************************************************************
procedure saveall
      fn=fname("cliscre.mem")
      save all like clisc* to &fn
      wait window "Screen Design is Saved" nowait
      saved=.t.
return



***************************************************************************
*                   show
***************************************************************************
procedure show
          oldindex=index
          if index>=CLISCITS
             index=CLISCITS
          endif
          cliscreen[index,8]=.t.
          do showel
return


***************************************************************************
*                   show element
***************************************************************************
procedure showel

i=oldindex
set color to w/b
if cliscreen[i,6]>0
   if cliscreen[i,8]=.f.   && disabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           size         1,cliscreen[i,6];
                                           color        r/b,r/b
   else  &&

           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           size         1,cliscreen[i,6];
                                           COLOR        gr+/b,w/b
   endif
   clear gets
i=index
   if cliscreen[i,8]=.f.   && disabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           size         1,cliscreen[i,6];
                                           color        r+/b,r+/b
   else  && enabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           size         1,cliscreen[i,6];
                                           COLOR        bg+/b,w+/b
   endif
   clear gets
else
i=oldindex
   if cliscreen[i,8]=.f.   && disabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5];
                                           color       r/b,r/b
   else  && enabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5];
                                           color       gr+/b,w/b
   endif
   clear gets
i=index
   if cliscreen[i,8]=.f.   && disabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5];
                                           color       r+/b,r+/b
   else  && enabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5];
                                           COLOR       bg+/b,w+/b
   endif
endif

clear gets
return


***************************************************************************
*                   move
***************************************************************************
procedure move
set cursor off
set console off
i=index
SET COLOR TO GR+/b
@ 23,0 to 23,79
@ 24,0 to 24,79 clear
=CENTER(24,"Use the cursor keys to move, Press Enter to Drop, Esc to Abort")
FIRST =0
SAVE SCREEN TO SCedit
LK=0
DUMMY=' '
ORR=CLISCREEN[I,1]
ORC=CLISCREEN[I,2]
DO WHILE LK<>ENTER AND LK<>27
set color to n/n,n/n
@ 0,0 SAY " " GET DUMMY color n/n,n/n
READ
set color to gr+/b,gr+/b
LK=LASTKEY()
    IF FIRST=0
       FIRST=1
       IF CLIscreen[I,6]=0
           itemlen=LEN(CLISCREEN[I,3])+CLISCREEN[I,7]
       ELSE
           itemlen=LEN(CLISCREEN[I,3])+CLISCREEN[I,6]+1
       ENDIF
       @ CLISCREEN[I,1],CLISCREEN[I,2] SAY SPACE(itemlen)
       SAVE SCREEN TO SCedit
    ENDIF
    DO CASE
       CASE LK=UP
            CLISCREEN[I,1]=CLISCREEN[I,1]-1
            IF CLISCREEN[I,1]<2
               ?? CHR(7)
               CLISCREEN[I,1]=2
            ENDIF
       CASE LK=DOWN
            CLISCREEN[I,1]=CLISCREEN[I,1]+1
            IF CLISCREEN[I,1]>22
               ?? CHR(7)
               CLISCREEN[I,1]=22
            ENDIF
       CASE LK=LEFT
            CLISCREEN[I,2]=CLISCREEN[I,2]-1
            IF CLISCREEN[I,2]<0
               ?? CHR(7)
               CLISCREEN[I,2]=0
            ENDIF
       CASE LK=RIGHT
            CLISCREEN[I,2]=CLISCREEN[I,2]+1
            IF (CLISCREEN[I,2]+itemlen)>79
               ?? CHR(7)
               CLISCREEN[I,2]=79-itemlen
            ENDIF
    ENDCASE
    RESTORE SCREEN FROM SCedit
DO SHOWEL
ENDDO
IF LK=27
   restore screen from scedit
   CLISCREEN[I,1]=ORR
   CLISCREEN[I,2]=ORC
   DO SHOWEL
ENDIF
      @ 23,0 to 24,79 clear
      saved=.f.
      set color to n/n
      @ 0,0 to 0,4 clear
      set color to gr+/b
set cursor on
set console on
set color to n/w
@ 24,0 to 24,79 clear
myname='Angelos Karageorgiou'
=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif
return


***************************************************************************
*                   revert
***************************************************************************
procedure revert
for i=1 to CLISCITS
    cliscreen[i,1]=0
    cliscreen[i,2]=0
    cliscreen[i,3]=" "
    cliscreen[i,4]=" "
    cliscreen[i,5]=" "
    cliscreen[i,6]=0
    cliscreen[i,7]=" "
    cliscreen[i,8]=.t.
    cliscreen[i,9]=.t.
endfor
do initcli
@ 2,0 to 24,79 clear
      fn=fname("cliscre.mem")
      delete file &fn
      wait window "Screen is Restored to its defaults" nowait
      saved=.f.
do showcli
index=1
oldindex=1
do showel
return



***************************************************************************
*                   Show the screen
***************************************************************************
procedure showcli

set color to w/b
for i=1 to cliscITS
if cliscreen[i,6]>0
   if cliscreen[i,8]=.f.   && disabled
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           size         1,cliscreen[i,6];
                                           color r/b,r/b
   else  && enabled           
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5] ;
                                           size         1,cliscreen[i,6];
                                           COLOR        gr+/b,w/b
   endif
else
   if cliscreen[i,8]=.f.   && disabled          
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5];
                                           color       r/b,r/b
   else  && enabled           
           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                           GET         (CLISCREEN[I,4]);
                                           picture     CLISCREEN[I,5];
                                           COLOR       gr+/b,w/b
   endif
endif
endfor
clear gets
return
