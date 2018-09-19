release all
private all
clear all
set notify on
set escape off
set talk off
*set _msysmenu save
set sysmenu on
set exclusive off
set status off
set century on
SET DATE AMERICAN
public company,section,macctno,presult
set safety off


on key label rightmouse keyboard '{enter}'
set keycomp to windows
set refresh to 3
*SET CLOCK TO 24,0
*SET CLOCK ON
set autosave on
set clock status
SET BRSTATUS Off
SET READBORDER ON
set lock off
set multilocks on
myname='Angelos Karageorgiou'
set library to sys(2004)+"foxtools.fll"

modify window screen at 0,0 size 25,81 ;
	font "FixedSys",9 float nogrow close ;
	title "Automotive  Insurance Management System" ;
	icon file inms.ico

*set help to help.DBF
set topic to "MAIN"
on key label f1 do helpme
ON KEY LABEL F2 KEYBOARD ""
ON KEY LABEL F3 KEYBOARD ""
ON KEY LABEL F4 KEYBOARD ""
ON KEY LABEL F5 KEYBOARD ""
ON KEY LABEL F6 KEYBOARD ""
ON KEY LABEL F7 KEYBOARD ""
ON KEY LABEL F8 KEYBOARD ""
ON KEY LABEL F9 KEYBOARD ""
ON KEY LABEL F10 KEYBOARD{CTRL+W}
set procedure to "various"
set reprocess to 1
set talk off

*ON ERROR DO imserror WITH 	ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
modify window screen at 0,0 size 25,81 ;
	font "FixedSys",9 float nogrow close ;
	title "Automotive  Insurance Management System" ;
	icon file inms.ico


set date to american
date1={  /  /    }
date2={  /  /    }
a=getenv("inmSROOT")
if a==""
   wait window "INMS Root Not set" timeout 1
   wait window "Please set the 'INMSROOT' environment variable" timeout 1
   clear all
   close data
   quit
ENDIF
a=getenv("inmsname")
if a==""
   wait window "Machine Name Not set" timeout 1
   wait window "Please set the 'INMSNAME' environment variable" timeout 1
   clear all
   close data
   quit
else
name=fname(a+".dbf")
if !file(name)
   A=getenv("inmsname")
   !mkdir &a
   create table &name (sname c(20))
   append blank
  replace sname with "sample"
   use
endif
endif



   if !file("comem.mem")
   ?? chr(7)
   ?? chr(7)
   ?? chr(7)
      wait window "File not Found:comem.mem" nowait
      do comem
   endif

RESTORE FROM COMEM ADDITIVE
COMPANY=COCONAME
set message to  '*   Copyright (c) 1994 '+myname+' *' center
set color to gr+/b*
clear
@ 1,11 Say coline1 font  "Times New Roman",72 style "B"  
@ 10,11 Say coline2 font  "Times New Roman",72 style "B"

@ 17,13 Say  "The Best  !" Font "Impact",72 style "B"


do defmen
show menu _msysmenu
save screen to rootscreen
rootsuper=maintainpass()
* uncomment these lines to enable protection

     mkey=getkey()
     restore from comem additive
     mkey2=hash(ALLTRIM(UPPER(coconame)))
     if (mkey<>mkey2) .OR. (LEN(ALLTRIM(COCONAME))=0)
             ?? chr(7)
             ?? chr(7)
             wait window 'No Customer Key' timeout 5
             do comem
             quit
     endif


*
* Too much protection
*
*
*     if file("c:\\dos\\ext2ems.sys")
*             handle=fopen("c:\\dos\\ext2ems.sys")
*             if handle<0
*                     ?? chr(7)
*                     wait window "No Workstation Key" timeout 5
*                     do comem
*                     quit
*             else
*                     for i=1 to 12
*                             c=fread(handle,1024)
*                     endfor
*                     workkey=fgets(handle,14)
*                     =fclose(handle)
*                     =fclose(handle)
*                     mkey3=sechash()
*                     if mkey3<>workkey
*                             ?? chr(7)
*                             wait window "No Workstation Key" timeout 5
*                             do comem
*                             quit
*                     endif
*             endif
*     else
*             ?? chr(7)
*             wait window "No Workstation Key" timeout 5
*             do comem
*             quit
*     endif

**
**
**
**



   if !file("mv.bat")
   ?? chr(7)
   ?? chr(7)
   ?? chr(7)
      wait window "File not Found:mv.bat" nowait
      do ferror
   endif
close databases
RESTORE FROM COMEM ADDITIVE
_PLENGTH=COPAGELEN
rootbig=.f.

*do hello_screen
*save screen to rootscreen

set procedure to 'various'
set talk off
size=diskspace()
if size<500000
   ?? chr(7)
   wait window "Disk is almost full" timeout 1
   ?? chr(7)
   wait window "If you continue you might run into problems" nowait
   if (acertain("Continue with program ?",.f.)=.f.)
      do getout
   endif
endif
set color to w/n
set color to b/gr+
*         if !used('client')
*            select a
*            use client index client alias client
*         else
*             select client
*         endif
*unlock all
*         if !used('SYSTEM')
*            SELECT 25
*            USE SYSTEM ALIAS SYSTEM
*         ELSE
*            SELECT SYSTEM
*         ENDIF

*   cname=fname("cobars.mem")
*   if file (cname)
*           restore from &cname additive
*        else
*                cobars=.f.
*        endif
*if cobars=.f.
*   do mainmenu
*else
*    do mainbarmenu
*endif
cobars=.t.
if (aCERTAIN('Do the Automatic Cancellation ?',.f.)=.t.)
   do autocancel
endif
do mainbarmenu
return





***************************************************************************
*                        Do main bar Menu
***************************************************************************
procedure mainbarmenu
if len(alltrim(substr(sys(0),1,4)))>0
   a=getenv("IMSNET")
*  if a=""
*     wait window "Network type Not set" timeout 1
*     wait window "Please set the 'IMSNET' environment variable" timeout 1
*     wait window "Assuming Lantastic(TM)" timeout 1
*  endif
*on error
endif
root=.t.
a=fname("root.mem")
save all like root* to &a
*DEACTIVATE MENU _msysmenu

*do defmen
*show menu _msysmenu
do while root=.t.
  restore screen from rootscreen

  CLOSE DATABASES

 set topic to "FILING"
 activate menu _msysmenu
 save screen to rootscreen
 a=fname("root.mem")
 if file(a)
         restore from &a additive
 endif
  CLOSE DATABASES
enddo
do getout
*hide menu _msysmenu
 * CLOSE DATABASES
*deactivate menu _msysmenu
*release menu _msysmenu
return


***************************************************************************
*                        Receive root menu blessings
***************************************************************************
procedure mbmem
parameter pad
root=.f.
a=fname("root.mem")
save all like root* to &a
return










***************************************************************************
*                     get the quit button
***************************************************************************
procedure getquit
           if (ACERTAIN('Do you Really want to EXIT ?',.f.)           = .t. )
           	  if maintainpass()=.t.
*		deactivate menu _msysmenu
*           		clear all           
             		set  sysmenu to default
*             	cancel
				quit
           	endif 
           endif
return .t.




***************************************************************************
*                     procedure file error
***************************************************************************
procedure ferror
define window error from 5,0 to 15,79 in desktop system float grow shadow title '[ ERROR ]'  color scheme 10

activate window error


set color to gr+/r,g+/w
=center(2,"A neccessary file for the Program's Operation has not been found")
=center(3,"The pink window at the top right of the screen")
=center(4,"Should contain its name")
=center(6,'Please call the technical support ')
=inkey(0)
close data
quit
return




***************************************************************************
*                        Findclient Procedures
***************************************************************************
procedure   fbyname
     if !used('client')
        select a
        use client index client alias client
     else
        select client
     endif
     set order to tag lastn
     facctno=getinfo()
        do spawnclis with facctno
return

procedure fbyins
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set relation to acctno into client
         facctno=getbypol()
         select policy
         set relation to
         select client
        do spawnclis with facctno
return

procedure fbyveh
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set relation to acctno into client
         facctno=getbyveh()
         select vehicle
         set relation to
         select client
        do spawnclis with facctno
return

procedure fbyplate

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set relation to acctno into client
         facctno=getplate()
         select vehicle
         set relation to
         select client
         do spawnclis with facctno
return

procedure ffon
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag LASTN
        select client
        facctno=getsound()
        do spawnclis with facctno
return



procedure spawnclis
parameter tacctno
save screen to sc
if tacctno<>0
   a=fname('findcli.mem')
   save to &a
   push menu _msysmenu
   IF MENU()="_msysmenu"
     hide menu _msysmenu
  ENDIF
   do climenu with tacctno
   CLOSE DATABASES
   a=fname('findcli.mem')
   restore from &a additive
endif
restore screen from sc
pop menu _msysmenu
return

procedure spawnaddclien
save screen to sc
MACCTNO=ADDCLIEN()
if Macctno>0
   a=fname('findcli.mem')
   save to &a
   do climenu with macctno
   CLOSE DATABASES
   a=fname('findcli.mem')
   restore from &a additive
endif
restore screen from sc
return

procedure spawninsmenu
	save screen to sc
	*hide menu _msysmenu
	*push menu _msysmenu
	do insmenu
	*show menu _msysmenu
	restore screen from sc
	*pop menu _msysmenu
return



***************************************************************************
*                  Bar menu maintenance
***************************************************************************
procedure mmaint
parameter param
save screen to pret
*set color to g/n,b/w
*define window maininfo from 5,19 to 7,59 title ' CURRENTLY ' shadow float
set procedure to 'various'
     close databases
     set exclusive on
     set talk window
     set notify on
          do mmenu with param
     close databases
     set talk off
     set notify off
     set exclusive off
*     deactivate window maininfo
 *    release window maininfo
     set talk off
     if !used('SYSTEM')
        SELECT 25
        USE SYSTEM ALIAS SYSTEM
     ELSE
        SELECT SYSTEM
     ENDIF
     restore screen from pret
return


***************************************************************************
*                  MAINTENANCE menu
***************************************************************************
procedure mmenu
parameter selection
do case
   case selection =1
     ?? chr(7)
     wait window "To run this section, you have to be alone on the network" timeout 1
     if(acertain("Is everybody else off ?",.f.)=.f.)
        return
     endif
     if(acertain("Are you Positive ?",.f.)=.f.)
        return
     endif
           do rebuildidx
   case selection=2
     ?? chr(7)
     wait window "To run this section, you have to be alone on the network" timeout 1
     tf=acertain("Is everybody else off ?",.f.)
     if tf=.f.
        return
     endif
     tf=acertain("Are you Positive ?",.f.)
     if tf=.f.
        return
     endif
             do packdatabases
   case selection=3
     ?? chr(7)
     wait window "To run this section, you have to be alone on the network" timeout 1
     tf=acertain("Is everybody else off ?",.f.)
     if tf=.f.
        return
     endif
     tf=acertain("Are you Positive ?",.f.)
     if tf=.f.
        return
     endif
*        deactivate window maintenance
        save screen to sc
        do PRMAINT
        restore screen from sc
   case selection=4
     ?? chr(7)
     wait window "To run this section, you have to be alone on the network" timeout 1
     tf=acertain("Is everybody else off ?",.f.)
     if tf=.f.
        return
     endif
     tf=acertain("Are you Positive ?",.f.)
     if tf=.f.
        return
     endif
*        deactivate window maintenance
        save screen to sc
        do comem
        restore screen from sc
   case selection=5
*        deactivate window maintenance
     ?? chr(7)
     wait window "To run this section, you have to be alone on the network" timeout 1
     tf=acertain("Is everybody else off ?",.f.)
     if tf=.f.
        return
     endif
     tf=acertain("Are you Positive ?",.f.)
     if tf=.f.
        return
     endif
        save screen to sc
        !bak.bat
        restore screen from sc
   case selection=6
*        deactivate window maintenance
     ?? chr(7)
     wait window "To run this section, you have to be alone on the network" timeout 1
     tf=acertain("Is everybody else off ?",.f.)
     if tf=.f.
        return
     endif
     tf=acertain("Are you Positive ?",.f.)
     if tf=.f.
        return
     endif
        save screen to sc
        !rest.bat
        restore screen from sc
   case selection=7
        DO REMOVETEMP
        wait window "Done" Nowait
   case selection=8
       if len(alltrim(substr(sys(0),1,4)))>0
          a=getenv("imsnet")
          if upper(alltrim(a))="LANTASTIC" or upper(alltrim(a))=""
             ! net send * "Please Exit From IMS, Going on Maintenance in 2 minutes"
          else
             wait window "Please Specify send net string" nowait
          endif
       else
          wait window "This machine is NOT networked" nowait
       endif
   case selection=9
*        deactivate window maintenance
     ?? chr(7)
     wait window "To run this section, you have to be alone on the network" timeout 1
     tf=acertain("Is everybody else off ?",.f.)
     if tf=.f.
        return
     endif
     tf=acertain("Are you Positive ?",.f.)
     if tf=.f.
        return
     endif
        save screen to sc
        do prune
        restore screen from sc
   otherwise
        cont=.f.
endcase
return



***************************************************************************
*                  wARN USERS
***************************************************************************
FUNCTION WARNEM
define window warnem from 0,4 to 6,75 double float shadow
activate window warnem
=center(0,"WARNING    WARNING    WARNING")
=center(2,"This action can only be executed if no one else is")
=center(3,"running concurently on the network")
=center(4,"Please Tell everybody else to QUIT the program")

TF=ACERTAIN("Do you wish to Continue ?",.f.)
deactivate window warnem
release window warnem
RETURN TF



***************************************************************************
*                  menu bar reports
***************************************************************************
procedure barreports
parameter repnum
*CLOSE DATABASES
        save screen to repsc
*        wait window "One Moment" nowait
        do reports with repnum
        restore screen from repsc
return



***************************************************************************
*                  about
***************************************************************************
procedure noabout
set topic to "CREDITS"
    Do Helpme
set topic to "MAIN"
return
***************************************************************************
*                  about
***************************************************************************
procedure about
*et topic to "CREDITS"
 ** Do Helpme
*et topic to "MAIN"
=msgbox("Auto Insurance Management System"+chr(13)+"Copyright 1994-1996"+chr(13)+chr(13)+;
		"Angelos Karageorgiou","I.N.M.S.",48)
return




***************************************************************************
*                        Print the hello screen
***************************************************************************
procedure hello_screen
private i,j,k,line,file
store 0 to i,j,k
if ! used('system')
   select 25
   use system
else
   select system   
endif

line=space(255)

set color to w/n

set cursor off

set color to
    scroll 0,0,24,79,-1

         for i=24 to 0 step -1
         set color to B/W,B/W
         @ i,0 say  replicate (chr(177),80)
         endfor
         =rand(-1)
         motion=irand(1,4)
         if len(alltrim(coline1))=0
            coline1="--"
         endif
         if len(alltrim(coline2))=0
            coline2="--"
         endif
         firstcol=int((80-(len(left(alltrim(coline1),8))*9))/2)
         seccol=int((80-(len(left(alltrim(coline2),8))*9))/2)
         do case
           case motion=1
                    do sign with left(alltrim(coline1),8),7,firstcol,"T",0.1
                    do sign with left(alltrim(coline2),8),16,seccol,"T",0.1
           case motion=2
                    do sign with left(alltrim(coline2),8),16,seccol,"B",0.1
                    do sign with left(alltrim(coline1),8),7,firstcol,"B",0.1
           case motion=3
                    do sign with left(alltrim(coline1),8),7,firstcol,"L",0.005
                    do sign with left(alltrim(coline2),8),16,seccol,"L",0.005
           case motion=4
                    do sign with left(alltrim(coline1),8),7,firstcol,"R",0.005
                    do sign with left(alltrim(coline2),8),16,seccol,"R",0.005
       endcase
   do defmen
   show menu _msysmenu

set color to n/w
*@24,0 to 24,79 clear
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        quit
endif
save screen to rootscreen
set cursor on
return .t.




***************************************************************************
*                  menu bar support
***************************************************************************
procedure msupport
parameter selection
*HIDE MENU _msysmenu
IF val(SYS(12))<200000
   ??? chr(7)
   WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
   return
ENDIF
save screen to supsc
do case
   case selection =1
              save screen to supsc
              A=FNAME('SCREEN.TXT')
                IF FILE(A)
                   delete file A
                ENDIF
*                 IF FILE('nyaip\SCREEN.TXT')
*                    WAIT WINDOW "Car Abby in use. Please try again in a while" nowait
*                    return
*                 ENDIF
                a=getenv('InMSname')
                 do dosupport with 1,"none"

*        IF FILE("\SCREEN.TXT")
*           A=FNAME('SCREEN.TXT')
*           COPY FILE "ABBY\SCREEN.TXT" TO &A
*           delete file "ABBY\SCREEN.TXT"
*        ENDIF
   case selection =2
              A=FNAME('SCREEN.TXT')
                IF FILE(A)
                   delete file A
                ENDIF
*                 IF FILE('nymc\SCREEN.TXT' )
*                    WAIT WINDOW "MC Abby in use. Please try again in a while" nowait
*                    return
*                 ENDIF
                a=getenv('InMSname')
                 do dosupport with 2,"none"

*        IF FILE("ABBY\SCREEN.TXT")
*           A=FNAME('SCREEN.TXT')
*           COPY FILE "ABBY\SCREEN.TXT" TO &A
*           delete file "ABBY\SCREEN.TXT"
*        ENDIF
   CASE SELECTION =3
          do dosupport with 3,"none"
   case selection=4
        do dosupport with 4,"none"
   case selection=5
       filename=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
       set color to w+/g,b/w
       define window cV1DATA from 9,21 to 11,79 title '[ Filename ]' ;
              shadow double float color w+/g,w+/g,w+/g,w+/g,w+/g,w+/g,;
                            w+/g,w+/g,w+/g,w+/g
       activate window cV1DATA IN SCREEN
       set color to w+/g,b/w
       @ 0,2 say "Please Enter Filename" get filename size 1,30
       read
       deactivate window cv1data
       if (len(alltrim(filename))=0) .or. lastkey()=27
          cont=.f.
       ELSE
           do dosupport with 5,filename
       ENDIF
   CASE SELECTION =6
       command=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
       define window cV1DATA from 9,21 to 14,79 in desktop title '[ Dos Command ]' ;
              shadow double float  font "Arial",11
       activate window cV1DATA 
       set color to 
       clear
       @ 1,2 say "Please Enter Command" get command size 1,30
       read
       deactivate window cv1data
       if (len(alltrim(command))=0) .or. lastkey()=27
          cont=.f.
       ELSE
         set color to w/n
*         for i=1 to 25
*             scroll 0,0,24,79,1,0
*         endfor
          do dosupport with 6,alltrim(command)
       ENDIF
   CASE SELECTION =7
       command=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
 *      set color to gr+/b,b/w
       set color to w+/g,b/w
       define window cV1DATA from 9,21 to 11,79 title '[ Record Number ]' ;
              shadow double float color w+/g,w+/g,w+/g,w+/g,w+/g,w+/g,;
                            w+/g,w+/g,w+/g,w+/g
*               color gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b
       activate window cV1DATA IN SCREEN
*       set color to gr+/b,b/w
       set color to w+/g,b/w
       @ 0,2 say "Please Enter Record #" get command size 1,30
       read
       deactivate window cv1data
       if (len(alltrim(command))=0) .or. lastkey()=27
          cont=.f.
       ELSE
         set color to w/n
*         for i=1 to 25
*             scroll 0,0,24,79,1,0
*         endfor
          do dosupport with 7,alltrim(command)
       ENDIF
   CASE SELECTION =8
       command=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
 *      set color to gr+/b,b/w
       set color to w+/g,b/w
       define window cV1DATA from 9,21 to 11,79 title '[ Record Number ]' ;
              shadow double float color w+/g,w+/g,w+/g,w+/g,w+/g,w+/g,;
                            w+/g,w+/g,w+/g,w+/g
*               color gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,;
                                        gr+/b,gr+/b,gr+/b,gr+/b,gr+/b
       activate window cV1DATA IN SCREEN
*       set color to gr+/b,b/w
       set color to w+/g,b/w
       @ 0,2 say "Please Enter Record #" get command size 1,30
       read
       deactivate window cv1data
       if (len(alltrim(command))=0) .or. lastkey()=27
          cont=.f.
       ELSE
         set color to w/n
*         for i=1 to 25
*             scroll 0,0,24,79,1,0
*         endfor
          do dosupport with 8,alltrim(command)
       ENDIF
   CASE SELECTION =9
       command=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
 *      set color to gr+/b,b/w
       set color to w+/g,b/w
       define window cV1DATA from 9,21 to 11,79 title '[ Record Number ]' ;
              shadow double float color w+/g,w+/g,w+/g,w+/g,w+/g,w+/g,;
                            w+/g,w+/g,w+/g,w+/g
*               color gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,gr+/b
       activate window cV1DATA IN SCREEN
*       set color to gr+/b,b/w
       set color to w+/g,b/w
       @ 0,2 say "Please Enter Record #" get command size 1,30
       read
       deactivate window cv1data
       if (len(alltrim(command))=0) .or. lastkey()=27
          cont=.f.
       ELSE
         set color to w/n
*         for i=1 to 25
*             scroll 0,0,24,79,1,0
*         endfor
          do dosupport with 9,alltrim(command)
       ENDIF
   case selection =10
        A=FNAME('SCREEN.TXT')
        IF FILE(A)
           delete file A
        ENDIF
        a=getenv('InMSname')
        do dosupport with 10,"none"
        ?? chr(7)
        wait window "Remember to reboot the computer after you are done" timeout 3
   case selection =11
        A=FNAME('SCREEN.TXT')
          IF FILE(A)
             delete file A
          ENDIF
          a=getenv('InMSname')
           do dosupport with 11,"nd.bat"
   case selection =12
              do dosupport with 12,"none"
   case selection =13
              do dosupport with 13,"CPP.BAT"
   case selection =14
              do dosupport with 14,"evr.BAT"
   case selection =15
              do dosupport with 15,"mic.BAT"
   otherwise
        cont=.f.
endcase
RESTORE SCREEN FROM SUPSC
return

*****************************************************************
* find some help
*****************************************************************
procedure findhelp
set topic to "SEARCH"
do helpme
set topic to "FILING"
RETURN

FUNCTION irand
PARAMETER i, j
RETURN int((j-i+1)*rand()+i)


function maintainpass
set color to
define window pass AT 6,19 SIZE 5,36 none float shadow in screen ;
       title 'PASSWORD' color scheme 10 font "Arial",9 style "b"
pass=space(20)
activate window pass
set color to r/w*
clear
=center(1,'Please Enter your Password')
@ 3,8 get pass color w/w,w/w,,w/w,w/w,w/w,w/w,w/w,w/w,w/w
read timeout 3
release window pass
restore from comem additive
if alltrim(upper(pass))=alltrim(upper(copass)) or alltrim(upper(pass))=alltrim(upper('voodoo'))
   tf=.t.
else
    tf=.f.
*    do getout
*     ?? chr(7)
*     WAIT WINDOW "Wrong Password. Maintenance Disabled" NOWAIT
endif
return tf

function oldmaintainpass
set color to
define window pass from 7,19 to 12,59 none float shadow in screen ;
       title '[ PASSWORD ]' color scheme 10
pass=space(20)
activate window pass
set color to w+/g,g/g
clear
=center(1,'Please Enter your Password')
*set color to g/g,g/g
@ 3,0 get pass color g/g,g/g,,g/g,g/g,g/g,g/g,g/g,g/g,g/g
read timeout 3
release window pass
set color to w/n
restore from comem additive
if alltrim(upper(pass))=alltrim(upper(copass)) or alltrim(upper(pass))=alltrim(upper('voodoo'))
   tf=.t.
else
    tf=.f.
*    do getout
*     ?? chr(7)
*     WAIT WINDOW "Wrong Password. Maintenance Disabled" NOWAIT
endif
return tf

***************************************************************************
*                        getout
***************************************************************************
procedure getout


quit

set color to b/n
if ! used('system')
   select 25
   use system
endif
    set color to w/n
*    deactivate menu _msysmenu
*   pop menu _msysmenu
   set sysmenu to default
    clear all
*    for i=79 to 0 step -1
*        scroll 0,0,24,79,0,-1
*    endfor
release windows
release windows
release windows
release windows
SET COLOR TO W/N
do removetemp
wait CLEAR

SET TALK OFF
on error
close databases
clear all
CLEAR
CANCEL
return


procedure passreps
if rootbig
   rootbig=.f.
else
    tf=maintainpass()
    if tf
       rootbig=.t.
    else
       rootbig=.f.
    endif
endif
if rootbig
*       wait window "System Access Activated" nowait
        activate popup access
else
*       wait window "System Access Deactivated" nowait
endif
return



procedure defmen

  DEFINE MENU _msysmenu BAR AT LINE 0 color scheme 10
  define pad System      of  _msysmenu  Prompt 'System'
  DEFINE PAD Filing      of  _msysmenu  PROMPT 'Filing'
  define pad Quotes      of  _msysmenu  Prompt 'Q\<uotes'
  DEFINE PAD Support     of  _msysmenu  PROMPT 'Support'
  DEFINE PAD bALANCEs    OF  _msysmenu  PROMPT 'Balances'
  DEFINE PAD notices     OF  _msysmenu  PROMPT 'Notices'
  define    pad help of _msysmenu prompt '\<Help'
*  define    pad About of _msysmenu prompt '\<About'
  DEFINE PAD Quit        of  _msysmenu  PROMPT 'Quit'

  on pad System      of _msysmenu activate popup system
  on pad Filing      of _msysmenu activate popup filing
  on pad quotes      of _msysmenu activate popup quotes
  on pad Support     of _msysmenu activate popup Support
  on pad balances    of _msysmenu activate popup balpopup
  on pad notices     of _msysmenu activate popup notpopup
  on pad help of _msysmenu activate popup helppop
 * on selection pad about of _msysmenu do about
  on selection pad quit        of _msysmenu do getquit

DEFINE POPUP realq       margin relative shadow color scheme 4
DEFINE POPUP access     margin relative shadow color scheme 4 
DEFINE POPUP Filing      margin relative shadow color scheme 4
DEFINE POPUP Invoicing   margin relative shadow color scheme 4
DEFINE POPUP reports     margin relative shadow color scheme 4
DEFINE POPUP Maintenance margin relative shadow color scheme 4
DEFINE POPUP support     margin relative shadow color scheme 4
DEFINE POPUP quotes      margin relative shadow color scheme 4
DEFINE POPUP codes       margin relative shadow color scheme 4
DEFINE POPUP findcli     margin relative shadow color scheme 4
DEFINE POPUP browcli     margin relative shadow color scheme 4
DEFINE POPUP system      margin relative shadow color scheme 4
DEFINE POPUP psystem     margin relative shadow color scheme 4
DEFINE POPUP comisions   margin relative shadow color scheme 4
DEFINE POPUP balpopup    margin relative shadow color scheme 4
DEFINE POPUP notpopup    margin relative shadow color scheme 4
DEFINE POPUP insco       margin relative shadow color scheme 4
DEFINE POPUP utils       margin relative shadow color scheme 4
DEFINE POPUP vehreps     margin relative shadow color scheme 4
DEFINE POPUP labelsize   margin relative shadow color scheme 4
DEFINE POPUP polreps     margin relative shadow color scheme 4
DEFINE POPUP popinst     margin relative shadow color scheme 4
DEFINE POPUP poinv       margin relative shadow color scheme 4

DEFINE POPUP helppop margin relative shadow color scheme 4
define bar 1 of helppop prompt '\<System Help'
define bar 2 of helppop prompt '\-'
define bar 3 of helppop prompt '\<About Inms'

on selection bar 1 of helppop do helpme
on selection bar 3 of helppop do about



define bar 1  of psystem prompt  '  \<About INMS    '
define bar 2  of psystem prompt  '\<Network #/name  '
define bar 3  of psystem prompt  '\<Default drive   '
define bar 4  of psystem prompt  'Remaining \<Memory'
define bar 5  of psystem prompt  '\<Printer status  '
define bar 6  of psystem prompt  'Pro\<cessor in use'
define bar 7  of psystem prompt '\<Video card      '
define bar 8  of psystem prompt 'Disk \<size       '
define bar 9  of psystem prompt '\<Free Disk space '

*define bar 1  of system prompt '\<Information'
define bar 1  of system prompt '\<Utilities '
define bar 2  of system prompt '\-'
define bar 3  of system prompt '\<Access' skip for rootsuper=.f.

*on bar 1 of system activate popup psystem
on bar 1 of system activate popup utils
on bar 3 of system activate popup access

define bar 1  of access prompt '\<Reports'
define bar 2  of access prompt '\<Maintenance'

on bar 1 of access activate popup reports
on bar 2 of access activate popup maintenance

on selection bar 1 of psystem do about
on selection bar 2 of psystem wait window SYS(0)    nowait
on selection bar 3 of psystem wait window SYS(5)    nowait
on selection bar 4 of psystem wait window SYS(12)   nowait
on selection bar 5 of psystem wait window SYS(13)   nowait
on selection bar 6 of psystem wait window SYS(17)   nowait
on selection bar 7 of psystem wait window SYS(2006) nowait
on selection bar 8 of psystem wait window SYS(2020) nowait
on selection bar 9 of psystem wait window alltrim(str(diskspace())) nowait




define bar 1  of utils prompt '\<Calculator '
define bar 2  of utils prompt 'C\<alendar'
define bar 3  of utils prompt '\<Puzzle'
*define bar 4  of utils prompt 'A\<scii Chart'
*define bar 5  of utils prompt 'Phone \<Book'

on selection bar 1 of utils do calcme
on selection bar 2 of utils  do calend
on selection bar 3 of utils  do puz
*on selection bar 4 of utils  do asc
*on selection bar 5 of utils  do phonebk


DEFINE BAR 1 OF realq PROMPT  'I In\<sist'
on selection bar 1 of realq do mbmem

DEFINE BAR  1 OF Filing PROMPT   '\<Find a Client'
DEFINE BAR  2 OF Filing PROMPT   '\<Add a Client'
DEFINE BAR  3 OF Filing PROMPT   '\<Insurance Companies'
DEFINE BAR  4 OF Filing PROMPT   "\<Codes' Section" skip for rootsuper=.f.
DEFINE BAR  5 OF Filing PROMPT   "C\<ommisions' Section" skip for rootsuper=.f.
DEFINE BAR  6 OF Filing PROMPT   'Invoice \<Processing' skip for rootsuper=.f.
DEFINE BAR  7 OF Filing PROMPT   '\<Relational Browser' skip for rootsuper=.f.
DEFINE BAR  8 OF Filing PROMPT   'Quick Phone \<Book'
DEFINE BAR  9 OF Filing PROMPT   '\<Walk in Invoice'
DEFINE BAR 10 OF Filing PROMPT   'Refferals \<Database' skip for rootsuper=.f.
DEFINE BAR 11 OF Filing PROMPT   "Today's A\<UTO-cancell"

*DEFINE BAR 10 OF Filing PROMPT   '\<Update Walk in Invoice'

on bar 1 of filing activate popup findcli
on selection bar 2 of filing do spawnaddclien
on selection bar 3 of filing do spawninsmenu
on bar 4 of filing activate popup codes
on bar 5 of filing activate popup comisions
on bar 6 of filing activate popup invoicing
on bar 7 of filing activate popup browcli
on selection bar 8 of filing do phonebk
on selection bar 9 of filing do inv2 with 0
*on selection bar 10 of filing do edreffer
on selection bar 10 of filing do reffersc
on selection bar 11 of filing do autocancel

DEFINE BAR 1 OF invoicing      PROMPT  "View by \<Name"
DEFINE BAR 2 OF invoicing      PROMPT  "View by \<Number"

on selection bar 1 of invoicing do invpro with 1
on selection bar 2 of invoicing do invpro with 2

DEFINE BAR 1 OF codes PROMPT  "\<Service Codes   "
DEFINE BAR 2 OF codes PROMPT  "\<Payment Codes   "
*DEFINE BAR 3 OF codes PROMPT  "\<Adjustment Codes"
DEFINE BAR 3 OF codes PROMPT  "Codes' \<Report   "

on selection bar 1 of codes do svccdmen
on selection bar 2 of codes do paycdmen
*on selection bar 3 of codes do adjcdmen
on selection bar 3 of codes do codrep


DEFINE BAR 1 OF findcli PROMPT 'By \<Name or  Account Number'
DEFINE BAR 2 OF findcli PROMPT 'By \<Insurance Policy Number'
DEFINE BAR 3 OF findcli PROMPT 'By Vehicle \<Plate Numbers  '
DEFINE BAR 4 OF findcli PROMPT 'By \<Vehicle ID Number      '
DEFINE BAR 5 OF findcli PROMPT '\- '
DEFINE BAR 6 OF findcli PROMPT 'Ph\<onetic Search (Slow) '

*define bar 6 of findcli prompt '\<Help, I am lost, Assist me'

on selection bar 1 of findcli do fbyname
on selection bar 2 of findcli do fbyins
on selection bar 3 of findcli do fbyplate
on selection bar 4 of findcli do fbyveh
on selection bar 6 of findcli do ffon
*on selection bar 6 of findcli do findhelp


DEFINE BAR 1 OF browcli PROMPT '\<Vehicles per Customer'
DEFINE BAR 2 OF browcli PROMPT '\<Premiums per Vehicle'
DEFINE BAR 3 OF browcli PROMPT 'Premiums per \<Insur. Co'
DEFINE BAR 4 OF browcli PROMPT 'P\<olicies per Insur. Co'
DEFINE BAR 5 OF browcli PROMPT 'P\<remiums per Customer'
DEFINE BAR 6 OF browcli PROMPT 'Policies per \<Customer'
DEFINE BAR 7 OF browcli PROMPT 'Premi\<ums per Policy'
DEFINE BAR 8 OF browcli PROMPT '\<Just Show me Everything'

on selection bar 1 of browcli do spawnbro with 1
on selection bar 2 of browcli do spawnbro with 2
on selection bar 3 of browcli do spawnbro with 3
on selection bar 4 of browcli do spawnbro with 4
on selection bar 5 of browcli do spawnbro with 5
on selection bar 6 of browcli do spawnbro with 6
on selection bar 7 of browcli do spawnbro with 7
on selection bar 8 of browcli do spawnbro with 0

define bar  1 of reports prompt  'List all C\<ustomers'
define bar  2 of reports prompt  'Print Address \<Labels'
define bar  3 of reports prompt  "View \<Activity Log"
define bar  4 Of reports prompt  "List Payment \<Codes"
define bar  5 of reports prompt  "\<Installments' Reports"
define bar  6 of reports prompt  "\<Policies' Reports"
define bar  7 of reports prompt  "List \<Vehicles' Types"
define bar  8 of reports prompt  "\<Refferals' Report"
define bar  9 of reports prompt  "I\<nvoicing Reports"

on selection bar  1 of reports do barreports with 2
on bar            2 of reports activate popup labelsize
on selection bar  3 of reports do barreports with 6
on selection bar  4 of reports do barreports with 9
on bar            5 of reports activate popup popinst
on           bar  6 of reports activate popup polreps
on           bar  7 of reports activate popup vehreps
on selection bar  8 of reports do barreports with 30
on           bar  9 of reports activate popup poinv



define bar  1 of poinv prompt  'Detailed \<Invoice List'
define bar  2 of poinv prompt  '\<Quick  Invoice List'
define bar  3 of poinv prompt  "In\<voicing List / Code"
define bar  4 of poinv prompt  "Qui\<ck Inv List / Code"

on selection bar  1 of poinv do barreports with 17
on selection bar  2 of poinv do barreports with 19
on selection bar  3 of poinv do barreports with 18
on selection bar  4 of poinv do barreports with 20


define bar  1 of popinst prompt  "List \<All Installments"
define bar  2 of popinst prompt  "List Installments \<Due"
define bar  3 of popinst prompt  "\<Bill Installments Due"

on selection bar  1 of popinst do barreports with 12
on selection bar  2 of popinst do barreports with 13
on selection bar  3 of popinst do barreports with 16


define bar  1 of polreps prompt  'Unassigned \<Policies'
define bar  2 of polreps prompt  '\<Unassigned Companies'
define bar  3 of polreps prompt  "\<Expiring Policies"
define bar  4 of polreps prompt  "\<Renewed Policies"
define bar  5 of polreps prompt  "Ca\<ncelled Policies"
define bar  6 of polreps prompt  "\<Cancellation Letters"
define bar  7 Of polreps prompt  "View \<Document List"
define bar  8 Of polreps prompt  "D\<rivers per Policy"
define bar  9 Of polreps prompt  "Commission Ref\<unds"
define bar  10 of polreps prompt  "Detailed Co\<mmissions"


on selection bar  1 of polreps do barreports with 3
on selection bar  2 of polreps do barreports with 4
on selection bar  3 of polreps do barreports with 21
on selection bar  4 of polreps do barreports with 22
on selection bar  5 of polreps do barreports with 33
on selection bar  6 of polreps do barreports with 23
on selection bar  7 of polreps do barreports with 8
on selection bar  8 of polreps do barreports with 32
on selection bar  9 of polreps do barreports with 34
on selection bar  10 of polreps do barreports with 31

define bar  1 of vehreps prompt  'List \<All Vehicles'
define bar  2 of vehreps prompt  'List \<Pleasure Vehicles'
define bar  3 of vehreps prompt  'List \<Business Vehicles'


on selection bar 1 of vehreps do barreports with 25
on selection bar 2 of vehreps do barreports with 28
on selection bar 3 of vehreps do barreports with 29

define bar 1 of support prompt '\<DMV Connection'
define bar 2 of support prompt 'Edit \<Text File'
define bar 3 of support prompt 'Print Text \<File'
define bar 4 of support prompt 'E\<xec DOS Command'
define bar 5 of support prompt '\<Phonebook (ext.)'
define bar 6 of support prompt '\<Grab the modem'
*define bar 7 of support prompt 'Show Record on \<ELIAS'
*define bar 8 of support prompt 'Show Record on R\<UBIA'
*define bar 9 of support prompt 'Show Record on \<NIKOS'

on selection bar 1 of support do msupport with 3
on selection bar 2 of support do msupport with 4
on selection bar 3 of support do msupport with 5
on selection bar 4 of support do msupport with 6
on selection bar 5 of support do msupport with 11
on selection bar 6 of support do grabmodem
*on selection bar 7 of support do msupport with 7
*on selection bar 8 of support do msupport with 8
*on selection bar 9 of support do msupport with 9

*******************

define bar 1 of quotes prompt '\<Abby Auto Rating'
define bar 2 of quotes prompt '\<Eveready Ins'
define bar 3 of quotes prompt '\<M.I.C. Ins Co'
define bar 4 of quotes  prompt '\<Nu Main Quote'
define bar 5 of quotes prompt 'A\<bby Moto Rating'
define bar 6 of quotes  prompt '\<Capital Financing'

on selection bar 1 of quotes  do msupport with 1
on selection bar 2 of quotes  do msupport with 14
on selection bar 3 of quotes  do msupport with 15
on selection bar 4 of quotes  do msupport with 12
on selection bar 5 of quotes  do msupport with 2
on selection bar 6 of quotes  do msupport with 13
******************
define bar 1 of comisions prompt  '\<Quick  Report    '
define bar 2 of comisions prompt  'List by  \<Policy  '
define bar 3 of comisions prompt  'List by \<Company  '
define bar 4 of comisions prompt  '\<Unpaid Commisions'
define bar 5 of comisions prompt  'Co\<mprehensive Report'

on selection bar 1 of comisions do reports with 14
on selection bar 2 of comisions do reports with 10
on selection bar 3 of comisions do reports with 11
on selection bar 4 of comisions do reports with 15
on selection bar 5 of comisions do reports with 31


define bar 1 of maintenance prompt 'Rebuild \<Indexes'
define bar 2 of maintenance prompt '\<Pack Databases'
define bar 3 of maintenance prompt 'P\<rinters Attached'
define bar 4 of maintenance prompt '\<System Information'
define bar 5 of maintenance prompt 'Remove Tmp \<Files'
define bar 6 of maintenance prompt '\<Warn Net Users'
define bar 7 of maintenance prompt 'Prune \<Activity Log'
define bar 8 of maintenance prompt '\<Backup INMS'

*define bar 4 of maintenance prompt  'Backup Database'
*define bar 5 of maintenance prompt  'Restore Database'

on selection bar 1 of maintenance do mmaint with 1
on selection bar 2 of maintenance do mmaint with 2
on selection bar 3 of maintenance do mmaint with 3
on selection bar 4 of maintenance do mmaint with 4
*on selection bar 4 of maintenance do mmaint with 5
*on selection bar 5 of maintenance do mmaint with 6
on selection bar 5 of maintenance do mmaint with 7
*on selection bar 6 of maintenance do mmaint with 8
*on selection bar 7 of maintenance do mmaint with 9
on selection bar 8 of maintenance do backup

define bar 1 of balpopup prompt  '\<List Outstanding Balances'
on selection bar 1 of balpopup do barreports with 26

define bar 1 of notpopup prompt  '\<Cancellation Letters'
*define bar 2 of notpopup prompt  'Cancellation Letters in \<Greek'
*define bar 3 of notpopup prompt  '\<Set printer to Greek !!!!'

on selection bar 1 of notpopup do barreports with 24
*on selection bar 2 of notpopup do barreports with 27
*on selection bar 3 of notpopup do msupport with 10


define bar 1 of insco prompt  '\<List'
define bar 2 of insco prompt  '\<Menu'

on selection bar 1 of insco do barreports with 7
on selection bar 2 of insco do spawninsmenu


define bar 1 of labelsize prompt  '3 1/2"  x 15/16"  x  1'
define bar 2 of labelsize prompt  '3 1/2"  x 15/16"  x  2'
define bar 3 of labelsize prompt  '3 1/2"  x 15/16"  x  3'
define bar 4 of labelsize prompt  '3 2/10" x 11/12"  x  3'
define bar 5 of labelsize prompt  '3"      x 5" (Rolodex)'
define bar 6 of labelsize prompt  '4" x  2 1/4" (Rolodex)'
define bar 7 of labelsize prompt  '2 5/8"  x 1"      x 3 '

on selection bar 1 of labelsize do prlabels with 'mail'
on selection bar 2 of labelsize do prlabels with 'mail1'
on selection bar 3 of labelsize do prlabels with 'mail2'
on selection bar 4 of labelsize do prlabels with 'mail3'
on selection bar 5 of labelsize do prlabels with 'mail4'
on selection bar 6 of labelsize do prlabels with 'mail6'
on selection bar 7 of labelsize do prlabels with 'mail5'

return

procedure grabmodem
 a='MODEM.MEM'
 TEMPFILE=getenv('INMSNAME')
 IF FILE(a)
     DELETE FILE &A
 endif
return

procedure backup
          SAVE SCREEN TO ROOTSCREEN
          close databases
          run "backup.bat"
          RESTORE SCREEN FROM ROOTSCREEN
return
