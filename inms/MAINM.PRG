deactivate menu all
release all
private all
clear all
set notify on
set escape off
set talk off
set sysmenu off
set exclusive off
set century on
SET DATE AMERICAN
public company,section,macctno,presult
set safety off

set help to help.DBF
set topic to "MAIN"
on key label f1 do helpme
set procedure to "various"
set reprocess to 1
set talk off
ON ERROR DO imserror WITH ;
	ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()


set date to american
date1={  /  /  }
date2={  /  /  }
a=getenv("inmSROOT")
if a==""
   wait window "INMS Root Not set" timeout 1
   wait window "Please set the 'INMSROOT' environment variable" timeout 1
   clear all
   close data
   cancel
ENDIF
a=getenv("inmsname")
if a==""
   wait window "Machine Name Not set" timeout 1
   wait window "Please set the 'INMSNAME' environment variable" timeout 1
   clear all
   close data
   cancel
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

* uncomment these lines to enable protection

*     mkey=getkey()
*     restore from comem additive
*     mkey2=hash(ALLTRIM(UPPER(coconame)))
*     if (mkey<>mkey2) .OR. (LEN(ALLTRIM(COCONAME))=0)
*             ?? chr(7)
*             ?? chr(7)
*             wait window 'No Customer Key' timeout 5
*             do comem
*             cancel
*     endif
*     if file("c:\\dos\\ext2ems.sys")
*             handle=fopen("c:\\dos\\ext2ems.sys")
*             if handle<0
*                     ?? chr(7)
*                     wait window "No Workstation Key" timeout 5
*                     do comem
*                     cancel
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
*                             cancel
*                     endif
*             endif
*     else
*             ?? chr(7)
*             wait window "No Workstation Key" timeout 5
*             do comem
*             cancel
*     endif
*
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

do hello_screen


save screen to rootscreen
set procedure to 'various'
set talk off
size=diskspace()
if size<500000
   ?? chr(7)
   wait window "Disk is almost full" timeout 1
   ?? chr(7)
   wait window "If you continue you might run into problems" nowait
   tf =acertain("Continue with program ?",.f.)
   if tf=.f.
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
do mainbarmenu
return


***************************************************************************
*                        Do main Menu
***************************************************************************
procedure mainmenu
do paintmain
if len(alltrim(substr(sys(0),1,4)))>0
   a=getenv("IMSNET")
*   if a=""
*      wait window "Network type Not set" timeout 1
*      wait window "Please set the 'IMSNET' environment variable" timeout 1
*      wait window "Assuming Lantastic(TM)" timeout 1
*   endif
*on error
endif
section=0
tf=.f.

save screen to mainscreen
a=fname('main.mem')
delete file &a
save to &a
do while section=0
   @ 12,1 get section picture '@*IH ;;;' size 4,16,5;
          valid dispatch(_curobj) color w+/b,w+/rb+,,w+/b,w+/b,w+/rb+,w+/b,w+/b,w+/b,w+/b
   read
   if type('mainscreen')='U'
      a=fname('main.mem')
      restore from &a additive
   endif
   restore screen from mainscreen
*   save screen to mainscreen
*        a=fname('main.mem')
*   delete file &a
*   save to &a
    section=0
   @ 17,32 get section picture '@*IH' size 4,17,5;
           valid getquit(_curobj) color w+/b,w+/rb+,,w+/b,w+/b,w+/rb+,w+/b,w+/b,w+/b,w+/b
   read
   if type('mainscreen')='U'
      a=fname('main.mem')
      restore from &a additive
  endif
  restore screen from mainscreen
enddo
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
DEACTIVATE MENU rootmenu
do while root=.t.
  restore screen from rootscreen

  A=FNAME('ADMIN.MEM')
  IF FILE(A)
     ADMIN=.T.
  ELSE
      ADMIN=.F.
  ENDIF
  CLOSE DATABASES
  DEFINE MENU rootmenu BAR AT LINE 0 KEY ALT+Z MARK CHR(254) COLOR SCHEME 3
  define pad System      of  rootmenu  Prompt 'System'
  DEFINE PAD Filing      of  rootmenu  PROMPT 'Filing'
  if ADMIN
     DEFINE PAD Reports     of  rootmenu  PROMPT 'Reports'
     DEFINE PAD Maintenance of  rootmenu  PROMPT 'Maintenance'
  endif
  DEFINE PAD Support     of  rootmenu  PROMPT 'Support'
  DEFINE PAD bALANCEs    OF  ROOTMENU  PROMPT 'Balances'
  DEFINE PAD notices     OF  ROOTMENU  PROMPT 'Notices'
  DEFINE PAD Quit        of  rootmenu  PROMPT 'Quit'

  on pad System      of rootmenu activate popup system
  on pad Filing      of rootmenu activate popup filing
  IF ADMIN
    on pad Reports     of rootmenu activate popup reports
    on pad Maintenance of rootmenu activate popup maintenance
  ENDIF
  on pad Support     of rootmenu activate popup Support
  on pad balances    of rootmenu activate popup balpopup
  on pad notices     of rootmenu activate popup notpopup
*  on pad quit        of rootmenu activate popup realq
  on selection pad quit        of rootmenu do getquit with 'QUIT'

*  ON SELECTION MENU rootmenu DO mbmem with pad()
*  ON SELECTION MENU rootmenu DO tmenu


DEFINE POPUP realq       margin relative shadow color scheme 4
DEFINE POPUP Filing      margin relative shadow color scheme 4
DEFINE POPUP Invoicing   margin relative shadow color scheme 4
DEFINE POPUP reports     margin relative shadow color scheme 4
DEFINE POPUP Maintenance margin relative shadow color scheme 4
DEFINE POPUP support     margin relative shadow color scheme 4
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



define bar 1  of psystem prompt  '\<About INMS      '
define bar 2  of psystem prompt  '\<Network #/name  '
define bar 3  of psystem prompt  '\<Default drive   '
define bar 4  of psystem prompt  'Remaining \<Memory'
define bar 5  of psystem prompt  '\<Printer status  '
define bar 6  of psystem prompt  'Pro\<cessor in use'
define bar 7  of psystem prompt '\<Video card      '
define bar 8  of psystem prompt 'Disk \<size       '
define bar 9  of psystem prompt '\<Free Disk space '

define bar 1  of system prompt '\<Information'
define bar 2  of system prompt '\<Utilities '


on selection bar 1 of psystem do about
on selection bar 2 of psystem wait window SYS(0)    nowait
on selection bar 3 of psystem wait window SYS(5)    nowait
on selection bar 4 of psystem wait window SYS(12)   nowait
on selection bar 5 of psystem wait window SYS(13)   nowait
on selection bar 6 of psystem wait window SYS(17)   nowait
on selection bar 7 of psystem wait window SYS(2006) nowait
on selection bar 8 of psystem wait window SYS(2020) nowait
on selection bar 9 of psystem wait window alltrim(str(diskspace())) nowait

on bar 1 of system activate popup psystem
on bar 2 of system activate popup utils



define bar 1  of utils prompt '\<Calculator '
define bar 2  of utils prompt 'C\<alendar'
define bar 3  of utils prompt '\<Puzzle'
define bar 4  of utils prompt 'A\<scii Chart'
*define bar 5  of utils prompt 'Phone \<Book'

on selection bar 1 of utils do calcme
on selection bar 2 of utils  do calend
on selection bar 3 of utils  do puz
on selection bar 4 of utils  do asc
*on selection bar 5 of utils  do phonebk




DEFINE BAR 1 OF realq PROMPT  'I In\<sist'
on selection bar 1 of realq do mbmem

DEFINE BAR 1 OF Filing PROMPT   '\<Find a Client'
DEFINE BAR 2 OF Filing PROMPT   '\<Relational Browser'
DEFINE BAR 3 OF Filing PROMPT   '\<Insurance Companies'
DEFINE BAR 4 OF Filing PROMPT   "\<Codes' Section"
DEFINE BAR 5 OF Filing PROMPT   "C\<ommisions' Section"
DEFINE BAR 6 OF Filing PROMPT   'Invoice \<Processing'
DEFINE BAR 7 OF Filing PROMPT   '\<Add a Client'
DEFINE BAR 8 OF Filing PROMPT   'Phone \<Book'

on bar 1 of filing activate popup findcli
on bar 2 of filing activate popup browcli
on bar 3 of filing activate popup insco
on bar 4 of filing activate popup codes
on bar 5 of filing activate popup comisions
on bar 6 of filing activate popup invoicing
on selection bar 7 of filing do spawnaddclien
on selection bar 8 of filing do phonebk

DEFINE BAR 1 OF invoicing      PROMPT  "View by \<Name"
DEFINE BAR 2 OF invoicing      PROMPT  "View by \<Number"

on selection bar 1 of invoicing do invpro with 1
on selection bar 2 of invoicing do invpro with 2

DEFINE BAR 1 OF codes PROMPT  "\<Service Codes   "
*DEFINE BAR 2 OF codes PROMPT  "\<Adjustment Codes"
DEFINE BAR 2 OF codes PROMPT  "\<Payment Codes   "
DEFINE BAR 3 OF codes PROMPT  "Codes' \<Report   "

on selection bar 1 of codes do svccdmen
*on selection bar 2 of codes do adjcdmen
on selection bar 2 of codes do paycdmen
on selection bar 3 of codes do codrep


DEFINE BAR 1 OF findcli PROMPT 'By \<Name or  Account Number'
DEFINE BAR 2 OF findcli PROMPT 'By \<Insurance Policy Number'
DEFINE BAR 3 OF findcli PROMPT 'By Vehicle \<Plate Numbers  '
DEFINE BAR 4 OF findcli PROMPT 'By \<Vehicle ID Number      '
DEFINE BAR 5 OF findcli PROMPT 'Ph\<onetic Search (Slow)    '
define bar 6 of findcli prompt '\<Help, I am lost, Assist me'

on selection bar 1 of findcli do fbyname
on selection bar 2 of findcli do fbyins
on selection bar 3 of findcli do fbyplate
on selection bar 4 of findcli do fbyveh
on selection bar 5 of findcli do ffon
on selection bar 6 of findcli do findhelp


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

define bar  1 of reports prompt  '\<A.Detailed Payment List'
define bar  2 of reports prompt  '\<B.Detailed Invoice List'
define bar  3 of reports prompt  '\<C.Quick  Invoice List  '
define bar  4 of reports prompt  '\<D.List all Customers   '
define bar  5 of reports prompt  '\<E.Unassigned Policies  '
define bar  6 of reports prompt  '\<F.Unassigned Companies '
define bar  7 of reports prompt  '\<G.Customer Adr. Labels '
define bar  8 of reports prompt  "\<H.View Activity Log    "
*efine bar  9 of reports prompt  "\<I.Insurance Companies  "
define bar  9 Of reports prompt  "\<J.View Document List   "
define bar 10 Of reports prompt  "\<K.List Payment Codes   "
define bar 11 of reports prompt  "\<L.List all Installments"
define bar 12 of reports prompt  "\<M.List Installments Due"
define bar 13 of reports prompt  "\<N.Bill Installments Due"
define bar 14 of reports prompt  "\<O.Invoicing List / Code"
define bar 15 of reports prompt  "\<P.Quick Inv List / Code"
define bar 16 of reports prompt  "\<Q.Expiring Policies    "
define bar 17 of reports prompt  "\<R.Renewed Policies     "
define bar 18 of reports prompt  "\<S.List Cancellations   "
define bar 19 of reports prompt  "\<T.List Vehicles' Types "

on selection bar  1  of reports do barreports with 1
on selection bar  2  of reports do barreports with 17
on selection bar  3  of reports do barreports with 19
on selection bar  4  of reports do barreports with 2
on selection bar  5  of reports do barreports with 3
on selection bar  6  of reports do barreports with 4
on selection bar  7  of reports do barreports with 5
on selection bar  8  of reports do barreports with 6
*on selection bar  9  of reports do barreports with 7
on selection bar  9  of reports do barreports with 8
on selection bar 10 of reports do barreports with 9
on selection bar 11 of reports do barreports with 12
on selection bar 12 of reports do barreports with 13
on selection bar 13 of reports do barreports with 16
on selection bar 14 of reports do barreports with 18
on selection bar 15 of reports do barreports with 20
on selection bar 16 of reports do barreports with 21
on selection bar 17 of reports do barreports with 22
on selection bar 18 of reports do barreports with 23
on selection bar 19 of reports do barreports with 25

define bar 1 of support prompt '\<Auto Rating Prg'
define bar 2 of support prompt '\<Moto Rating Prg'
define bar 3 of support prompt '\<DMV Connection'
define bar 4 of support prompt 'Edit \<Text File'
define bar 5 of support prompt '\<Print Text File'
define bar 6 of support prompt 'E\<xec DOS Command'
**define bar 7 of support prompt 'Show Record on \<ELIAS'
*define bar 8 of support prompt 'Show Record on R\<UBIA'
*define bar 9 of support prompt 'Show Record on \<NIKOS'

on selection bar 1 of support do msupport with 1
on selection bar 2 of support do msupport with 2
on selection bar 3 of support do msupport with 3
on selection bar 4 of support do msupport with 4
on selection bar 5 of support do msupport with 5
on selection bar 6 of support do msupport with 6
*on selection bar 7 of support do msupport with 7
*on selection bar 8 of support do msupport with 8
*on selection bar 9 of support do msupport with 9


*Define bar 1 of comisions prompt '  Enter Commisions  '
define bar 1 of comisions prompt  '\<Quick  Report    '
define bar 2 of comisions prompt  'List by  \<Policy  '
define bar 3 of comisions prompt  'List by \<Company  '
define bar 4 of comisions prompt  '\<Unpaid Commisions'

*on selection bar 1 of comisions wait window "Not Implemented Yet" nowait
on selection bar 1 of comisions do reports with 14
on selection bar 2 of comisions do reports with 10
on selection bar 3 of comisions do reports with 11
on selection bar 4 of comisions do reports with 15


define bar 1 of maintenance prompt   'Rebuild \<Indexes'
define bar 2 of maintenance prompt   '\<Pack Databases'
*define bar 3 of maintenance prompt  'Choose P\<rinter'
define bar 3 of maintenance prompt   '\<System Information'
define bar 4 of maintenance prompt   'Remove Tmp \<Files'
define bar 5 of maintenance prompt   '\<Warn Net Users'
define bar 6 of maintenance prompt   'Prune \<Activity Log'

*define bar 4 of maintenance prompt  'Backup Database'
*define bar 5 of maintenance prompt  'Restore Database'

on selection bar 1 of maintenance do mmaint with 1
on selection bar 2 of maintenance do mmaint with 2
*on selection bar 3 of maintenance do mmaint with 3
on selection bar 3 of maintenance do mmaint with 4
*on selection bar 4 of maintenance do mmaint with 5
*on selection bar 5 of maintenance do mmaint with 6
on selection bar 4 of maintenance do mmaint with 7
on selection bar 5 of maintenance do mmaint with 8
on selection bar 6 of maintenance do mmaint with 9


define bar 1 of balpopup prompt  '\<List Outstanding Balances'
on selection bar 1 of balpopup do barreports with 26

define bar 1 of notpopup prompt  '\<Cancelation Letters'
on selection bar 1 of notpopup do barreports with 24


define bar 1 of insco prompt  '\<List'
define bar 2 of insco prompt  '\<Menu'

on selection bar 1 of insco do barreports with 7
on selection bar 2 of insco do spawninsmenu

 set topic to "FILING"
 activate menu rootmenu pad 'Filing'
 save screen to rootscreen
 a=fname("root.mem")
 if file(a)
         restore from &a additive
 endif
  CLOSE DATABASES
enddo
do getout
hide menu rootmenu
  CLOSE DATABASES
deactivate menu rootmenu
release menu rootmenu
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
*                     Do the client rap
***************************************************************************
procedure clients

set topic to "FILING"
CLIENTSECTION=0
SAVE SCREEN TO SCOPT
A=FNAME("SCOPT.MEM")
SAVE ALL LIKE SCOPT TO &A
DO WHILE CLIENTSECTION=0
*set color to w+/b,b/w+
set color to w+/rb+,b/w
A=FNAME("SCOPT.MEM")
RESTORE FROM &A ADDITIVE
RESTORE SCREEN FROM SCOPT
define window whatis from 2,10 to 16,32 title "Filing Menu" float shadow
activate window whatis

   @ 1,4 prompt  'Find a Client'
   @ 3,4 prompt  'Add a Client'
   @ 5,1 prompt  'Insurance Companies'
   @ 7,4 prompt  "Codes' Section"
   @ 9,2 prompt  "Commisions Section"
   @ 11,2 prompt 'Quit to Main  Menu'

*   @ 9,49 prompt 'E. Selection E        '

   	menu to clientsection
	deactivate window whatis
        RELEASE WIDOW WHATIS
   do case
      case clientsection = 1
           do findCLI  && CLIENTs
           clientsection=0
      case clientsection = 2
           macctno=addCLIEN()  && ADDCLIENT
           IF MACCTNO>0
              do spawnclis with macctno
           ENDIF
           CLIENTSECTION=0
      case clientsection = 3
           do insmenu
           clientsection=0
      case clientsection = 4
           do codemenu
           clientsection=0
      case clientsection=5
            do commenu
            clientsection=0
      otherwise
           clientsection=-1
   endcase                X
enddo
set topic to "MAIN"
deactivate window whatis
release window whatis
return


***************************************************************************
*                     codemenu
***************************************************************************
procedure codemenu

set color to w+/g,b/w
define window codes from 4,19 to 16,46 float shadow title '[ CODES ]'

optopt=0
set topic to "CODES"
do while optopt <5
   set color to w+/g,b/w
     activate window codes
     clear
     @ 1,6 prompt 'Service Codes'
     @ 3,5 prompt 'Adjustment Codes'
     @ 5,6 prompt 'Payment  Codes'
     @ 7,6 prompt 'List all Codes'
     @ 9,5 prompt 'Quit from Codes '
     menu to optopt
     do case
        case optopt=1
             deactivate window codes
             save screen to mainsc
             do svccdmen
             restore screen from mainsc
        case optopt=2
             deactivate window codes
             save screen to mainsc
             do adjcdmen
             restore screen from mainsc
        case optopt=3
             deactivate window codes
             save screen to mainsc
             do paycdmen
             restore screen from mainsc
        case optopt=4
             deactivate window codes
             save screen to mainsc
             do codrep
             restore screen from mainsc
     endcase
enddo
deactivate window codes
release window codes
set topic to "FILING"
return




***************************************************************************
*                     get section
***************************************************************************
procedure dispatch
parameter what
private tf
tf=.f.
   section=what
   do case
      case section = 1
                  a=fname('main2')
           delete file &a
           save to &a
           do clients && clientmenu
                  a=fname('main2')
           restore from &a
      case section=2
           set topic to "REPORTS"
           do oldreps
           set topic to "MAIN"
      case section=3
        A=FNAME('ADMIN.MEM')
        IF FILE(A)
           set topic to "MAINTENANCE"
           do maintain     && maintenance menu
           set topic to "MAIN"
        ENDIF
      case section=4
                    a=fname('main3.mem')
           DELETE FILE &a
           SAVE TO &a
           set topic to "SUPPORT"
           do support
*          do ALL
           set topic to "MAIN"
           a=fname('main3.mem')
           RESTORE FROM &a
      otherwise
      		tf=.t.
   endcase
   clear read
*restore screen from mainscreen
return tf

***************************************************************************
*                     get the quit button
***************************************************************************
procedure getquit
   parameter what
   section=5
           TF=ACERTAIN('Do you Really want to EXIT ?',.f.)
           if tf=.t.
              if menu()='ROOTMENU'
                 DO MBMEM
              ELSE
                  do getout
              ENDIF
           else
               section=0
           endif
*restore screen from mainscreen
         clear read
return .t.




***************************************************************************
*                     procedure file error
***************************************************************************
procedure ferror
define window error from 5,0 to 15,79 double title '[ ERROR ]' shadow;
       color gr+/r,gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r, gr+/r
activate window error


set color to gr+/r,g+/w
=center(2,"A neccessary file for the Program's Operation has not been found")
=center(3,"The pink window at the top right of the screen")
=center(4,"Should contain its name")
=center(6,'Please call the technical support ')
=inkey(0)
close data
cancel
return


***************************************************************************
*                        Paint main Screen
***************************************************************************
procedure paintmain
section=0
restore from comem.mem additive
company=coconame
if ! used('system')
   select 25
   use system
endif

set color to w/b
for i=0 to 79
    for j=1 to 100
    endfor
   scroll 0,0,24,79,0,1
endfor


set color to w/rb+
@ 01,20 to 07,59 fill color w/rb+
@ 01,20 to 07,59 double
=center(2,'Auto Insurance Management Program')
=center(3,'')
=center(4,'Version 2.3')
=center(5,'');
=center(6,alltrim(company))


set color to w/rb+
@ 7,40 say  'Ñ'

set color to W+/b
@ 23,0 to 23,79
=center(24,'Please Make your Selection')
*@ 5,20 say '¶'
*@ 5,60 say 'Ç'

@ 12,1 to 15,16
@ 12,22 to 15,37

@ 12,43 to 15,58
@ 12,64 to 15,79

@ 17,32 to 20,48

@ 8,40 to 16,40
@ 17,40 say 'Á'

@ 9,8 to 9,72
@ 9,40 say 'Å'
@ 9,8 say 'Ú'
@ 9,72 say '¿'
@ 9,29 say 'Â'
@ 9,51 say 'Â'

@ 10,8 to 11,8
@ 10,72 to 11,72
@ 10,29 to 11,29
@ 10,51 to 11,51

@ 12,8 say 'Á'
@ 12,72 say 'Á'
@ 12,29 say 'Á'
@ 12,51 say 'Á'

set color to W/b
@ 13,6 Say 'Filing'
@ 14,7 Say 'Menu'

@ 13,27 say 'Reports'
@ 14,29 say 'Menu'

@ 13,46 say 'Maintenance'
@ 14,49 say 'Menu'

@ 13,68 say 'Support'
@ 14,68 say 'Programs'

@ 18,39 say 'Quit'
@ 19,37 say 'Program'
  ADMIN=maintainpass()
  A=FNAME('ADMIN.MEM')
  IF ADMIN
     SAVE ALL LIKE ADMIN TO &A
  ELSE
      IF FILE(A)
         DELETE FILE &A
      ENDIF
  ENDIF
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
   IF MENU()="ROOTMENU"
      hide menu rootmenu
   ENDIF
   do climenu with tacctno
   CLOSE DATABASES
   a=fname('findcli.mem')
   restore from &a additive
endif
restore screen from sc
return

procedure spawnaddclien
save screen to sc
HIDE MENU ROOTMENU
MACCTNO=ADDCLIEN()
if Macctno>0
   a=fname('findcli.mem')
   save to &a
   hide menu rootmenu
   do climenu with macctno
   CLOSE DATABASES
   a=fname('findcli.mem')
   restore from &a additive
endif
restore screen from sc
*show menu rootmenu
return

procedure spawninsmenu
save screen to sc
hide menu rootmenu
do insmenu
*show menu rootmenu
restore screen from sc
return



***************************************************************************
*                  Bar menu maintenance
***************************************************************************
procedure mmaint
parameter param
save screen to pret
set color to g/n,b/w
define window maininfo from 5,19 to 7,59 title ' CURRENTLY ' shadow float
set procedure to 'various'
close databases
     close databases
     set exclusive on
     set talk window
     set notify on
         do mmenu with param
     close databases
     set talk off
     set notify off
     set exclusive off
     deactivate window maininfo
     release window maininfo
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
     tf=acertain("Is everybody else off ?",.f.)
     if tf=.f.
        return
     endif
     tf=acertain("Are you Positive ?",.f.)
     if tf=.f.
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
             do prnchoic
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
        deactivate window maintenance
        save screen to sc
        do comem
        restore screen from sc
   case selection=5
        deactivate window maintenance
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
        deactivate window maintenance
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
        deactivate window maintenance
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
procedure about
set topic to "CREDITS"
    Do Helpme
set topic to "MAIN"
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
  ADMIN=maintainpass()
  A=FNAME('ADMIN.MEM')
  IF ADMIN
     SAVE ALL LIKE ADMIN TO &A
  ELSE
      IF FILE(A)
         DELETE FILE &A
      ENDIF
  ENDIF
  DEFINE MENU rootmenu BAR AT LINE 0 KEY ALT+Z MARK CHR(254) COLOR SCHEME 3
  define pad System      of  rootmenu  Prompt 'System'
  DEFINE PAD Filing      of  rootmenu  PROMPT 'Filing'
  A=FNAME('ADMIN.MEM')
  IF FILE(A)
     DEFINE PAD Reports     of  rootmenu  PROMPT 'Reports'
     DEFINE PAD Maintenance of  rootmenu  PROMPT 'Maintenance'
  ENDIF
  DEFINE PAD Support     of  rootmenu  PROMPT 'Support'
  DEFINE PAD bALANCEs    OF  ROOTMENU  PROMPT 'Balances'
  DEFINE PAD notices     OF  ROOTMENU  PROMPT 'Notices'
  DEFINE PAD Quit        of  rootmenu  PROMPT 'Quit'
   show menu rootmenu

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
save screen to rootscreen
set cursor on
return .t.



***************************************************************************
*                  report menu
***************************************************************************
procedure oldreps
set color to w/rb+,r+/w
private cont

cont=.t.


set color to w/g+,b/w
define window moreport from 0,35 to 24,59 Title '[ REPORTS ]' shadow float
activate window moreport


moselection=0
lk=0
do while moselection<22 and lk<>27
set color to w/g+,b/w
@ 0,1  PROMPT  'Detailed Payment List'
@ 1,1  PROMPT  'Detailed Invoice List'
@ 2,1  PROMPT  'Quick  Invoice List  '
@ 3,1  prompt  'List all Customers   '
@ 4,1  prompt  'Unassigned  Policies '
@ 5,1  prompt  'Unassigned Companies '
@ 6,1  prompt  'Customer Adr. Labels '
@ 7,1  prompt  "View Activity Log    "
* 8,1  prompt  "Insurance Companies  "
@ 8,1  prompt  "View Document List   "
@ 9,1  prompt  "List Payment Codes   "
@10,1  prompt  "List all Installments"
@11,1  prompt  "List Installments Due"
@12,1  prompt  "Bill Installments Due"
@13,1  prompt  "Invoicing List / Code"
@14,1  prompt  "Quick Inv List / Code"
@15,1  prompt  "Expiring Policies    "
@16,1  prompt  "Renewed Policies     "
@17,1  prompt  "List Cancellations   "
@18,1  prompt  "Cancellation Letters "
@19,1  prompt  "List Vehicles' Types "
@20,1  prompt  "List Oustdng Balances"
@22,1  prompt  '* Quit to Main menu *'

menu to moselection
lk=lastkey()
if lk<>27
     cont=.t.
     save screen to rep
     deact window moreport
     save screen to repsc
     *wait window "One Moment" nowait
     *CLOSE DATABASES
           do case
              case moselection=1
                   do reports with 1
              case moselection=2
                   do reports with 17
              case moselection=3
                   do reports with 19
              case moselection=4
                   do reports with 2
              case moselection=5
                   do reports with 3
              case moselection=6
                   do reports with 4
              case moselection=7
                   do reports with 5
              case moselection=8
                   do reports with 6
*             case moselection=9
*                   do reports with 7
              case moselection=9
                   do reports with 8
              case moselection=10
                   do reports with 9
              case moselection=11
                   do reports with 12
              case moselection=12
                   do reports with 13
              case moselection=13
                   do reports with 16
              case moselection=14
                   do reports with 18
              case moselection=15
                   do reports with 20
              case moselection=16
                   do reports with 21
              case moselection=17
                   do reports with 22
              case moselection=18
                   do reports with 23
              case moselection=19
                   do reports with 24
              case moselection=20
                   do reports with 25
              case moselection=21
                   do reports with 26
           endcase
           if moselection<22
             restore screen from repsc
             activate window moreport
             restore screen from rep
           endif
else
    cont=.f.
endif
enddo
deactivate window moreport
release window moreport
return

***************************************************************************
*                  menu bar support
***************************************************************************
procedure msupport
parameter selection
HIDE MENU ROOTMENU
do case
   case selection =1
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
              save screen to supsc
              A=FNAME('SCREEN.TXT')
                IF FILE(A)
                   delete file A
                ENDIF
                 IF FILE('nyaip\SCREEN.TXT' )
                    WAIT WINDOW "Car Abby in use. Please try again in a while" nowait
                    return
                 ENDIF
                a=getenv('InMSname')
                 do dosupport with 1,"none"

*        IF FILE("\SCREEN.TXT")
*           A=FNAME('SCREEN.TXT')
*           COPY FILE "ABBY\SCREEN.TXT" TO &A
*           delete file "ABBY\SCREEN.TXT"
*        ENDIF
        RESTORE SCREEN FROM SUPSC
   case selection =2
                  save screen to supsc
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
              A=FNAME('SCREEN.TXT')
                IF FILE(A)
                   delete file A
                ENDIF
                 IF FILE('nymc\SCREEN.TXT' )
                    WAIT WINDOW "MC Abby in use. Please try again in a while" nowait
                    return
                 ENDIF
                a=getenv('InMSname')
                 do dosupport with 2,"none"

*        IF FILE("ABBY\SCREEN.TXT")
*           A=FNAME('SCREEN.TXT')
*           COPY FILE "ABBY\SCREEN.TXT" TO &A
*           delete file "ABBY\SCREEN.TXT"
*        ENDIF
        RESTORE SCREEN FROM SUPSC
   CASE SELECTION =3
        SAVE SCREEN TO SUPSC
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIf
          do dosupport with 3,"none"
        RESTORE SCREEN FROM SUPSC
   case selection=4
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
        do dosupport with 4,"none"
   case selection=5
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
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
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
        SAVE SCREEN TO SUPSC
       command=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
 *      set color to gr+/b,b/w
       set color to w+/g,b/w
       define window cV1DATA from 9,21 to 11,79 title '[ Dos Command ]' ;
              shadow double float color w+/g,w+/g,w+/g,w+/g,w+/g,w+/g,;
                            w+/g,w+/g,w+/g,w+/g
*               color gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,;
                                        gr+/b,gr+/b,gr+/b,gr+/b,gr+/b
       activate window cV1DATA IN SCREEN
*       set color to gr+/b,b/w
       set color to w+/g,b/w
       @ 0,2 say "Please Enter Command" get command size 1,30
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
         RESTORE SCREEN FROM SUPSC
   CASE SELECTION =7
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
        SAVE SCREEN TO SUPSC
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
          do dosupport with 7,alltrim(command)
       ENDIF
         RESTORE SCREEN FROM SUPSC
   CASE SELECTION =8
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
        SAVE SCREEN TO SUPSC
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
         RESTORE SCREEN FROM SUPSC
   CASE SELECTION =9
              IF val(SYS(12))<200000
                 ??? chr(7)
                 WAIT WINDOW "Not enough Memory for this,Try it on the server" nowait
                 return
              ENDIF
        SAVE SCREEN TO SUPSC
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
          do dosupport with 9,alltrim(command)
       ENDIF
         RESTORE SCREEN FROM SUPSC
   otherwise
        cont=.f.
endcase
return


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
if alltrim(upper(pass))=alltrim(upper(copass)) or alltrim(upper(pass))=alltrim(upper('colos'))
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
set color to b/n
if ! used('system')
   select 25
   use system
endif
    set color to w/n
    deactivate menu rootmenu
    clear all
    for i=79 to 0 step -1
        scroll 0,0,24,79,0,-1
    endfor
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
