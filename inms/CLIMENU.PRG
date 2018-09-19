parameter acct

push menu _msysmenu
*define window wclient at 5,1 size 25,80 in desktop system float shadow nogrow noclose ;
* 	title "Client Database Window" font "FixedSys",8

*activate window wclient

CLOSE DATABASES
set topic to "CLIENT"
set procedure to 'various'
set exclusive off
declare cliscreen[31,11]
cliscits=0
release cliscits
*ide menu rootmenu
set safety off
sdesign=.f.

if menu()='ROOTMENU'
	hide menu rootmenu
endif
*public macctno
public result

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag acctno

       if !used('client')
          select a
          use client index client alias client
       else
           select client
       endif
       SET ORDER TO TAG ACCTNO
       set relation to acctno into invoice
*       set skip to invoice
       SEEK ACCT


select client
*set order to tag lastn
   clnamesize =25
   cfnamesize =25
   cadrsize   =35
   captsize   =8
   csalsize   =10
   cdlicsize  =25
   coccsize   =30
   cempsize   =30
   cempadsize =30
   cempcszsize=30
   crefsize   =30
   cnotesize  =50
   cvarsize   =70
   ccitysize  =20
   ccountysize=20

 **
****  Initialize the variables now.
 **
   macctno=0
   clname=space(clnamesize)
   cfname=space(cfnamesize)
   cmi=' '
   caddress=space(cadrsize)
   captno=space(captsize)
   ccity=space(ccitysize)
   cstate='  '
   czip=space(11)

   cappaddress=space(cadrsize)
   cappaptno=space(captsize)
   cappcity=space(ccitysize)
   cappstate='  '
   cappzip=space(11)

   csalutation=space(csalsize)
   cbdate={  /  /  }
   csex='M'
   cssc='   -  -    '
   cdrivlic=space(cdlicsize)
   chomephone='(   )-   -    '
   cworkphone='(   )-   -    '
   coccupation=space(coccsize)
   cemployer=space(cempsize)
   cempadress=space(cempadsize)
   cempcsz=space(cempcszsize)
   cemphone='(   )-   -    '
   cmarstat='S'
   creffered=0
   crefferal=space(crefsize)
   cnotes=space(cnotesize)
   cbroker=' '
   cthirty=0
   csixty=0
   cninety=0
   conetwenty=0
   ctotal=0
   cvar=space(cvarsize)
   ccounty=space(ccountysize)
   ccounty=space(ccountysize)
   cappcounty=space(ccountysize)
   mbalance=0

macctno=       acctno
clname=        lastn
cfname=        firstn
cmi=           mi

caddress=      add
captno=        aptno
csalutation=   salut
cbdate=        bdate
csex=          sex
cssc=          ss
cdrivlic=      dr_lic_no
chomephone=    phoneh
cworkphone=    phonew
coccupation=   occu
cemployer=     emp_name
cempadress=    emp_add
cempcsz=       emp_csz
cemphone=      phoneem
cmarstat=      marstatus
creffered=     ref_no
crefferal=     ref_name
cnotes=        notes
cthirty=       thirty
csixty=        sixty
cninety=       ninety
conetwenty=    onetwenty
ctotal=        total
cvar=          var
ccity=         city
cstate=        state
czip=          zip
ccounty=       county
issstate=      dissstate
issdate=       dissdate
mlast=         lastpayday
mamount=       lastamount
mbalance=      dbalance
cbroker = broker

cappaddress=appadress
cappaptno=  appaptno
cappcity=   appcity
cappstate = appstate
cappzip=    appzip
cappcounty=appcounty

*skip
*select invoice
*skip -1
*go bottom
PAYDATE={  /  /  }
PAYAMOUNT=0
*skip
*SELECT CLIENT
*skip -1

set procedure to "various"
set color to w/b
clear
*restore from "main2.scr" additive
*restore screen from main2

do clientpaint with .F.
save screen to mainsc
do clprevnext
select client
set relation to
set printer to lpt1:
IF WEXIST('BROWSEWIN')
   RELEASE WINDOW BROWSEWIN
ENDIF
IF WEXIST('CLIBRO')
   RELEASE WINDOW CLIBRO
ENDIF
close databases

pop menu _msysmenu
return

******************************************************************************
*                    Procedure clprevnext
******************************************************************************
procedure clprevnext
private rec,mpad

go top
*locate for acctno=acct
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
SET ORDER TO tag acctno
*SET ORDER TO tag lastn
seek acct
*SET ORDER TO tag lastn
do clientdisplay
result=1
wait clear

do setMENU
getout=0

do while getout=0
	ACTIVATE MENU _msysmenu
enddo

IF WEXIST('BROWSEWIN')
   RELEASE WINDOW BROWSEWIN
ENDIF
IF WEXIST('wclient')
   RELEASE WINDOW wclient
ENDIF

return







******************************************************************************
*                    Procedure client display
******************************************************************************
procedure clientdisplay


select client
   clnamesize =25
   cfnamesize =25
   cadrsize   =35
   captsize   =8
   csalsize   =10
   cdlicsize  =25
   coccsize   =30
   cempsize   =30
   cempadsize =30
   cempcszsize=30
   crefsize   =30
   cnotesize  =50
   cvarsize   =70
   ccitysize  =20
   ccountysize=20

macctno=       acctno
clname=        lastn
cfname=        firstn
cmi=           mi
caddress=      add
captno=        aptno
csalutation=   salut
cbdate=        bdate
csex=          sex
cssc=          ss
cdrivlic=      dr_lic_no
chomephone=    phoneh
cworkphone=    phonew
coccupation=   occu
cemployer=     emp_name
cempadress=    emp_add
cempcsz=       emp_csz
cemphone=      phoneem
cmarstat=      marstatus
creffered=     ref_no
crefferal=     ref_name
cnotes=        notes
cbroker = broker
cthirty=       thirty
csixty=        sixty
cninety=       ninety
conetwenty=    onetwenty
ctotal=        total
cvar=          var
ccity=         city
cstate=        state
czip=          zip
ccounty=       county
issstate=      dissstate
issdate=       dissdate
paydate=       lastpayday
payamount=     lastamount
mbalance=      dbalance

cappaddress=appadress
cappaptno=  appaptno
cappcity=   appcity
cappstate = appstate
cappzip=    appzip
cappcounty=appcounty

*wait clear
*@ 0,0 say space(80) color w+/n
*SET COLOR TO gr+/b
*@ 2,0 to 24,79 clear
*@ 23,0 to 23,79
*=center(24,'Press F10 to ACCEPT this entry')
SET COLOR TO gr+/b,w/gr+
*if type('cliscits')='U'
*        a=fname("mainsc.mem")
*        if file(a)
*                restore from &a additive
*           restore screen from mainsc
*        else
*                do clientpaint with .t.
*        endif
*else
*	restore screen from mainsc
*endif

SDESIGN=.F.
if type('cliscits')='U'
        sdesign=.f.
        a=fname("cliscre.mem")
        if file(a)
                restore from &a additive
                sdesign=.t.
        else
                sdesign=.f.
        endif
else
        sdesign=.t.
endif
SDESIGN=.F.

*set color to n/w
*@ 24,0 to 24,79 clear
*myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
*namekey=hash(myname)
*if namekey<>'54631178529559'
*        wait window "Don't Fuck with my name"
*        quit
*endif
SET COLOR TO gr+/b,w/gr+
if sdesign=.f.
select client
      @ 2,13 get macctno disabled color ,,,,,,,,w+/b,w+/b
      @ 3,13 get clname picture '!'+replicate('X',(clnamesize)) size 1,25 disabled color ,,,,,,,,w+/b,w+/b
      @ 3,52 get cfname picture '!'+replicate('X',(cfnamesize)) size 1,20 disabled color ,,,,,,,,w+/b,w+/b
      @ 3,77 get cmi picture '!' disabled color ,,,,,,,,w+/b,w+/b
      @ 4,13 get caddress  picture '!'+replicate('X',(cadrsize)) size 1,30 disabled color ,,,,,,,,w+/b,w+/b
      @ 4,52 get captno picture replicate('X',(captsize)) size 1,8 disabled color ,,,,,,,,w+/b,w+/b
      @ 5,13 get ccity picture replicate('X',ccitysize) size 1,15 disabled color ,,,,,,,,w+/b,w+/b
      @ 5,37 get ccounty picture replicate('X',ccountysize) size 1,14 disabled color ,,,,,,,,w+/b,w+/b
      @ 5,59 get cstate picture '!!' disabled color ,,,,,,,,w+/b,w+/b
      @ 5,67 get czip picture '99999-99999' disabled color ,,,,,,,,w+/b,w+/b

@ 7,0 say "Application Address" color b/w

      @ 8,13 get cappaddress  picture '!'+replicate('X',(cadrsize)) size 1,30 disabled color ,,,,,,,,w+/b,w+/b
      @ 8,52 get cappaptno picture replicate('X',(captsize)) size 1,8 disabled color ,,,,,,,,w+/b,w+/b
      @09,13 get cappcity picture replicate('X',ccitysize) size 1,15 disabled color ,,,,,,,,w+/b,w+/b
      @09,37 get cappcounty picture replicate('X',ccountysize) size 1,14 disabled color ,,,,,,,,w+/b,w+/b
      @09,59 get cappstate picture '!!' disabled color ,,,,,,,,w+/b,w+/b
      @09,67 get cappzip picture '99999-99999' disabled color ,,,,,,,,w+/b,w+/b

      @11,32  get csex picture '!' valid (csex='M' or csex='F' or csex=' ') disabled color ,,,,,,,,w+/b,w+/b
      @12,13  get csalutation  picture replicate('X',(csalsize)) size 1,10 disabled color ,,,,,,,,w+/b,w+/b
      @13,13  get cbdate picture '@d' disabled color ,,,,,,,,w+/b,w+/b
      @14,13  get cssc picture '999-99-9999' disabled color ,,,,,,,,w+/b,w+/b
      @15,13  get cdrivlic picture replicate('X',(cdlicsize)) size 1,25 disabled color ,,,,,,,,w+/b,w+/b

      @ 12,52 get chomephone picture '(999)-999-9999' disabled color ,,,,,,,,w+/b,w+/b
      @ 13,52 get cworkphone picture '(999)-999-9999' disabled color ,,,,,,,,w+/b,w+/b
      @ 14,52 get coccupation picture '!'+replicate('X',(coccsize)) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
      @ 15,52 get cemployer picture '!'+replicate('X',(cempsize)) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
      @ 16,52 get cempadress picture '!'+replicate('X',(cempadsize)) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
      @ 17,52 get cempcsz picture '!'+replicate('X',(cempcszsize)) size 1,26 disabled color ,,,,,,,,w+/b,w+/b
      @ 18,52 get cemphone picture '(999)-999-9999' disabled color ,,,,,,,,w+/b,w+/b

      @ 16,13 get issstate picture 'aa'       disabled color ,,,,,,,,w+/b,w+/b
      @ 16,28 get issdate picture '@d' disabled color ,,,,,,,,w+/b,w+/b
      @ 17,13 get cmarstat picture '!' valid (cmarstat='M' or cmarstat='S' or cmarstat='W' or cmarstat=' ' ) disabled color ,,,,,,,,w+/b,w+/b
      @ 19,14  get creffered picture '9999' disabled color ,,,,,,,,w+/b,w+/b
      @ 19,36  get crefferal picture '!'+replicate('X',(crefsize)) size 1,30 disabled color ,,,,,,,,w+/b,w+/b
*      @ 20,11  get cbroker picture '!' disabled color ,,,,,,,,w+/b,w+/b
      @ 20,24  get cnotes picture '!'+replicate('X',(cnotesize)) size 1,54 disabled color ,,,,,,,,w+/b,w+/b
      @ 21,5  SAY 'Balance:' get mbalance picture '999,999.99' disabled color ,,,,,,,,w+/b,w+/b
      @ 22,5 get cvar picture replicate('X',cvarsize) size 1,(cvarsize) disableD color ,,,,,,,,w+/b,w+/b
      *select invoice
      *        set order to tag acctno
      *set filter to acctno=client->acctno
      **set order to tag invdate
      **SET INDEX TO INVDATE
      *go bottom
      *if client->acctno=invoice.acctno
      *   PAYDATE=invoice.IDATE
      *   PAYAMOUNT=invoice.DPRICE
      *else
      *   PAYDATE={  /  /  }
      *   PAYAMOUNT=0
      *endif
      *set order to tag acctno
      @ 23,9 Say "Last payment made at:"  get paydate disableD color ,,,,,,,,w+/b,w+/b
      @ 23,45 say "Amount:" get payamount picture'9999999.99' disableD color ,,,,,,,,w+/b,w+/b
      clear gets
else
I=0
hidden=.f.
    for i=1 to cliscITS
       if cliscreen[i,8]=.t.   && not disabled
          if cliscreen[i,6]>0
               @ CLISCREEN[I,1],CLISCREEN[I,2]+len(cliscreen[i,3])+1 GET (CLISCREEN[I,4]);
                                               picture     CLISCREEN[I,5] ;
                                               size         1,cliscreen[i,6];
                                               COLOR        gr+/b,w+/b
          else
               @ CLISCREEN[I,1],CLISCREEN[I,2] say (CLISCREEN[I,3]);
                                               COLOR        gr+/b,w+/b
          endif
       else
                if type(cliscreen[i,4])="C" .and. len(alltrim(evaluate(cliscreen[i,4])))>0
                   hidden=.t.
                endif
       endif
    endfor
    clear gets
    if hidden
       wait window "There is Hidden Data that you do not see!" nowait
    endif
endif

if deleted()
   set color to gr+/r+
   =center(23,'WARNING! This Record Is Marked For Deletion')
   ?? chr(7)
endif

set reprocess to 1
if lock(alltrim(str(recno())),'client')=.f.
   ?? chr(7)
   wait window 'This CLIENT is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in client
set reprocess to 1
return



******************************************************************************
*                    Procedure dataedit
******************************************************************************
function dataedit

*define window wclient at 1,1 size 25,80 in desktop system float shadow nogrow noclose title "Client Editing Window" font "FixedSys",9

*hide menu _msysmenu
set color to w/rb+
locked=.f.
if lock(alltrim(str(recno())),'client')=.f.
   wait window 'This Account is edited by Another User Try Again Later'
   locked =.f.
   return locked
else
  locked=.t.
endif
set color to w/b
clear

   clnamesize =25
   cfnamesize =25
   cadrsize   =35
   captsize   =8
   csalsize   =10
   cdlicsize  =25
   coccsize   =30
   cempsize   =30
   cempadsize =30
   cempcszsize=30
   crefsize   =30
   cnotesize  =50
   cvarsize   =70
   ccitysize  =20
   ccountysize=20

define window wclient at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Client Editing Window" font "FixedSys",9
activate window wclient

 **
****  Initialize the variables now.
 **
   macctno=0
   clname=space(clnamesize)
   cfname=space(cfnamesize)
   cmi=' '
   caddress=space(cadrsize)
   captno=space(captsize)
   csalutation=space(csalsize)
   cappaddress=space(cadrsize)
   cappaptno=space(captsize)
   cappcity=space(ccitysize)
   cappstate='  '
   cappzip=space(11)
   cbdate={  /  /  }
   csex='M'
   cssc='   -  -    '
   cdrivlic=space(cdlicsize)
   chomephone='(   )-   -    '
   cworkphone='(   )-   -    '
   coccupation=space(coccsize)
   cemployer=space(cempsize)
   cempadress=space(cempadsize)
   cempcsz=space(cempcszsize)
   cemphone='(   )-   -    '
   cmarstat='S'
   creffered=0
   crefferal=space(crefsize)
   cnotes=space(cnotesize)
   cthirty=0
   csixty=0
   cninety=0
   conetwenty=0
   ctotal=0
   cvar=space(cvarsize)
   ccity=space(ccitysize)
   cstate='  '
   czip=space(11)
   ccounty=space(ccountysize)
cappaddress=appadress
cappaptno=  appaptno
cappcity=   appcity
cappstate = appstate
cappzip=    appzip
cappcounty=appcounty

macctno=       acctno
clname=        lastn
cfname=        firstn
cmi=           mi
caddress=      add
captno=        aptno
csalutation=   salut
cbdate=        bdate
csex=          sex
cssc=          ss
cdrivlic=      dr_lic_no
chomephone=    phoneh
cworkphone=    phonew
coccupation=   occu
cemployer=     emp_name
cempadress=    emp_add
cempcsz=       emp_csz
cemphone=      phoneem
cmarstat=      marstatus
creffered=     ref_no
crefferal=     ref_name
cnotes=        notes
cbroker =broker
cthirty=       thirty
csixty=        sixty
cninety=       ninety
conetwenty=    onetwenty
ctotal=        total
cvar=          var
ccity=         city
cstate=        state
czip=          zip
ccounty=       county
issstate=      dissstate
issdate=       dissdate
paydate=       lastpayday
payamount=     lastamount
mbalance=      dbalance

if type('cliscits')='U'
        sdesign=.f.
        a=fname("cliscre.mem")
        if file(a)
                restore from &a additive
                sdesign=.t.
        else
                sdesign=.f.
        endif
else
        sdesign=.t.
endif

SDESIGN=.F.

@ 0,0 say space (80) color w/rb+
set color to gr+/rb+
=center(0,'Editing Existing Account')
SET COLOR TO gr+/b
*@ 24,0 to 24,79
=center(24,'Press <F10> to ACCEPT this entry, or <ESC> to exit')
if deleted()
   set color to r+/b
   =center(23,'WARNING! This Record Is Marked For Deletion')
endif
SET COLOR TO gr+/b
on key label f10 keyboard "{ctrl+w}"

if sdesign=.f.
    SET COLOR TO gr+/b,w+/bg
    @ 2,1 SAY 'Account No:' get macctno disabled color ,,,,,,,,w+/b,w+/b
    @ 3,2 say  'Last Name:' get clname picture '!'+replicate('X',(clnamesize)) size 1,25
    @ 3,40 say 'First Name:' get cfname picture '!'+replicate('X',(cfnamesize)) size 1,20
    @ 3,73 say 'MI:' get cmi picture '!'

    @ 4,4 say 'Address:' get caddress  picture '!'+replicate('X',(cadrsize)) size 1,30
    @ 4,44 SAY 'Apt No:' get captno    picture replicate('X',(captsize)) size 1,8
    @ 5,7 say 'City:'    get ccity     picture replicate('X',ccitysize) size 1,15
    @ 5,29 say 'County:' get ccounty   picture replicate('X',ccountysize) size 1,14
    @ 5,52 say 'State:'  get cstate    picture '!!'
    @ 5,62 say 'Zip:'    get czip      picture '99999-99999'

@ 7,0 say "Application Address" color b/w

    @ 8,4 say 'Address:' get cappaddress  picture '!'+replicate('X',(cadrsize)) size 1,30
    @ 8,44 SAY 'Apt No:' get cappaptno    picture replicate('X',(captsize)) size 1,8
    @09,7 say 'City:'    get cappcity     picture replicate('X',ccitysize) size 1,15
    @09,29 say 'County:' get cappcounty   picture replicate('X',ccountysize) size 1,14
    @09,52 say 'State:'  get cappstate    picture '!!'
    @09,62 say 'Zip:'    get cappzip      picture '99999-99999'

    @11,27 say 'Sex:' get csex picture '!' valid (csex='M' or csex='F' or csex=' ')
    @12,1 say 'Salutation:' get csalutation  picture replicate('X',(csalsize)) size 1,10
    @13,1 say 'Birth Date:' get cbdate picture '@d'
    @14,1 say 'Social Sec:' get cssc picture '999-99-9999'
    @15,1 say 'Driv Lic #:' get cdrivlic picture replicate('X',(cdlicsize)) size 1,25
    @16,1 say 'State Issd:' get issstate picture 'aa'
    @16,17 say 'Date Issd:'  get issdate picture '@d'
    @17,1 say 'Mar Status:' get cmarstat picture '!' valid (cmarstat='M' or cmarstat='S' or cmarstat='W' or cmarstat=' '  )

    @ 12,40  say 'Home phone:' get chomephone picture '(999)-999-9999'
    @ 13,40 say 'Work phone:' get cworkphone picture '(999)-999-9999'
    @ 14,40 say 'Occupation:'get coccupation picture '!'+replicate('X',(coccsize)) size 1,26
    @ 15,42 say 'Employer:' get cemployer picture '!'+replicate('X',(cempsize)) size 1,26
    @ 16,39 say 'Emp Address:' get cempadress picture '!'+replicate('X',(cempadsize)) size 1,26
    @ 17,43 say 'Emp CSZ:' get cempcsz picture '!'+replicate('X',(cempcszsize)) size 1,26
    @ 18,41 say 'Emp Phone:' get cemphone picture '(999)-999-9999'
    @ 19,1  say 'Referred by:' get creffered picture '9999' valid getreffer(creffered)
    @ 19,21 say 'Referral name:' get crefferal picture '!'+replicate('X',(crefsize)) size 1,30 disabled
*    @ 20,1  say 'Broker:' get cbroker picture "!" disabled color ,,,,,,,,w+/b,w+/b
    @ 20,17 say 'Notes:' get cnotes picture '!'+replicate('X',(cnotesize)) size 1,54
    @ 21,5  SAY 'Balance:' get mbalance picture '999,999.99'

    @ 22,5   get cvar picture replicate('X',cvarsize) size 1,(cvarsize)

*    @ 21,33 say paydate color rb+/b,w+/b
*    @ 21,52 say payamount picture'9999999.99' color rb+/b,w+/b
else
    for i=1 to cliscits
    if cliscreen[i,9]=.t. && real data
                if cliscreen[i,6]>0   && we got size
                   if cliscreen[i,8]=.t.   && disabled
                           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                                           GET         (CLISCREEN[I,4]);
                                                           picture     CLISCREEN[I,5] ;
                                                           size         1,cliscreen[i,6];
                                                           COLOR        gr+/b,w/bg+
                   endif
                else
                   if cliscreen[i,8]=.t.   && disabled
                           @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                                           GET         (CLISCREEN[I,4]);
                                                           picture     CLISCREEN[I,5];
                                                           COLOR       gr+/b,w/bg+
                   endif
                endif
    else    && just data displayed
               if cliscreen[i,6]>0     && we got size
                  if cliscreen[i,8]=.t.   && disabled
                          @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                                          GET         (CLISCREEN[I,4]);
                                                          picture     CLISCREEN[I,5] ;
                                                          size         1,cliscreen[i,6];
                                                          disableD color ,,,,,,,,w+/b,w+/b
                  endif
               else
                  if cliscreen[i,8]=.t.   && disabled
                          @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                                          GET         (CLISCREEN[I,4]);
                                                          picture     CLISCREEN[I,5];
                                                          disableD color ,,,,,,,,w+/b,w+/b
                  endif
               endif
       endif
    endfor
endif
*accept=0
*reject=0
*@ 24,25 get accept function '* Accept'
*@ 24,45 get reject function '* Reject'
read cycle
CSTATE=UPPER(CSTATE)
issstate=upper(issstate)
*@ 2,0 to 2,79 fill color w/b
=center(24,space(72))
*@ 1,0 to 1,79 clear
A=FNAME('CLIDAT.MEM')
*show menu _msysmenu
deactivate window wclient
release window wclient
SAVE TO &A

return locked

********************************************************************************
*                 get option
********************************************************************************
procedure getoption
parameter mprompt

result=-2
if mprompt='Policy  Info'
  wait window 'Policy  Info'
endif
if mprompt='Yellow  Form'
  result =10
endif
return


******************************************************************************
*                    Procedure dovehicles
******************************************************************************
procedure dovehicles
parameter mprompt
wait window mprompt timeout 1
result=-2
return


******************************************************************************
*                    Procedure skipem
******************************************************************************
procedure skipem
private amount,rec

set color to w+/b,b/w
define window skip from 9,19 to 18,59 Title '[ High Gear ]' shadow float system color scheme 8
activate window skip
=center(1,'How many records to Jump Over ?')
=center(2,'Positive number Skips Forward')
=center(3,'Negative number skips Backwards')

clear gets
amount=0
@ 5,17 get amount picture '99999'
read

select client
*rec=recno()
*go bottom
*last=recno()
*goto (rec)


*rec=rec+amount
set order to tag lastn
skip (amount)
if bof()
   ?? chr(7)
   wait window 'Could only jump BACK to the FIRST record' timeout 1
   go top
   rec=1
endif

if eof()
   ?? chr(7)
   wait window 'Could only jump FORWARD  to the LAST record' timeout 1
   go bottom
endif

*goto (rec)
set order to tag acctno
deactivate window skip
release window skip
do clientdisplay
return



***************************************************************************
*                     clientputdata
***************************************************************************
procedure clientputdata
private testlen,testzip
if !used('client')
   select a
   use client index client alias client
else
   select client
endif
A=FNAME('CLIDAT.MEM')
RESTORE FROM &A ADDITIVE
   testzip=alltrim(czip)
   testlen=len(testzip)
   if right(testzip,1)='-'
       czip = left( testzip,(testlen-1) )
   else
       czip = testzip
   endif
   testvar=padc(upper(alltrim(cvar)),cvarsize)

   replace acctno       with   macctno,;
        lastn        with   upper(alltrim(clname)),;
        firstn       with   upper(alltrim(cfname)),;
        mi           with   upper(alltrim(cmi)),;
        add          with   upper(alltrim(caddress)),;
        aptno        with   upper(alltrim(captno)),;
        city         with   upper(alltrim(ccity)),;
        state        with   upper(alltrim(cstate)),;
        zip          with   upper(alltrim(czip)),;
        county       with   upper(alltrim(ccounty)),;
        appadress    with   upper(alltrim(cappaddress)),;
        appaptno     with   upper(alltrim(cappaptno)),;
        appcity      with   upper(alltrim(cappcity)),;
        appstate     with   upper(alltrim(cappstate)),;
        appzip       with   upper(alltrim(cappzip)),;
        appcounty    with   upper(alltrim(cappcounty)),;
        salut        with   upper(alltrim(csalutation)),;
        bdate        with   cbdate,;
        sex          with   upper(alltrim(csex)),;
        ss           with   cssc,;
        dr_lic_no    with   upper(alltrim(cdrivlic)),;
        phoneh       with   upper(alltrim(chomephone)),;
        phonew       with   upper(alltrim(cworkphone)),;
        occu         with   upper(alltrim(coccupation)),;
        emp_name     with   upper(alltrim(cemployer)),;
        emp_add      with   upper(alltrim(cempadress)),;
        emp_csz      with   upper(alltrim(cempcsz)),;
        phoneem      with   upper(alltrim(cemphone)),;
        marstatus    with   upper(alltrim(cmarstat)),;
        ref_no       with   creffered,;
        ref_name     with   upper(alltrim(crefferal)),;
        notes        with   upper(alltrim(cnotes)),;
        broker       with   cbroker,;
        thirty       with   cthirty,;
        sixty        with   csixty,;
        ninety       with   cninety,;
        onetwenty    with   conetwenty,;
        total        with   ctotal,;
        var          with   testvar,;
        dissdate     with   issdate,;
        dissSTATE    with   ALLTRIM(issSTATE),;
        dbalance     with   mbalance

* Activity posting
MINVOICENO=0
MACCTNO   =client.acctno
MTRANCODE =1002
MQTY      =1
MPRICE    =0
MTOTAL    =0
MDATE     =date()
MCLERK    =''
MDESCRIPT ="Customer Edited"
MPOSTED   =.f.
MBILLED   =.f.
MCHECKNO  =''

             DVID      =' '

             =POST_ACT(MINVOICENo,client->ACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
select client
*CLERK=""
*=POST_ACT(0,MACCTNO,2,1,0,0,DATE(),CLERK,"Client Data Edited",.f.,.f.,"")
return






********************************************************************************
*                 Popup functions that spawn real code
********************************************************************************
procedure popay
         SAVE SCREEN TO OPTSC
              a=fname('opt1sc.mem')
         delete file &a
         SAVE all like optsc* TO &a
*         hide menu _msysmenu
                             hide popup poptions
                             hide popup poins
              do paymen WITH client->acctno
              a=fname('opt1sc.mem')
         RESTORE from &a additive
*         RESTORE SCREEN FROM OPTSC
         select invoice
         set order to tag acctno
         SET FILTER TO
         select client
         SET ORDER TO TAG ACCTNO
         set relation to acctno into invoice
*         SET ORDER TO LASTN
         do clientdisplay
return




******************************************************************************
*                        History
******************************************************************************
procedure pohis
parameter reports
          hide popup his
        SAVE SCREEN TO OPTSC
        a=fname('opt1sc.mem')
        delete file &a
        SAVE all like optsc* TO &a
*        hide menu _msysmenu
        select invoice
        set order to tag acctno
        set filter to
        hide popup poptions
        hide popup poins
                             do clihist WITH client->acctno,reports
        a=fname('opt1sc.mem')
        RESTORE from &a additive
*        RESTORE SCREEN FROM OPTSC
        select invoice
        set order to tag acctno
        SET FILTER TO
        select client
        set relation to acctno into invoice
        show popup his
return


******************************************************************************
*                        Invoice
******************************************************************************
procedure poinv
          hide popup invpop
         SAVE SCREEN TO OPTSC
              a=fname('opt1sc.mem')
         delete file &a
         SAVE all like optsc* TO &a
*         hide menu _msysmenu
                             hide popup poptions
                             hide popup poins
*              do inv2 WITH client->acctno
              do invmenu WITH client->acctno
         a=fname('opt1sc.mem')
         RESTORE from &a additive
*         RESTORE SCREEN FROM OPTSC
*         result=10
         select invoice
        set order to tag acctno
         set filter to
*      set order to tag invdate
*         set filter to acctno=client->acctno
*do clprevnext
*a=fname("res.mem")
*save all like result to &a
*          activate menu _msysmenu pad 'OPTIONS'
*           do clientdisplay
show popup invpop
return



*******************************************************************************
*                        Update Invoice
*******************************************************************************
procedure poedinv
          hide popup invpop
         SAVE SCREEN TO OPTSC
              a=fname('opt1sc.mem')
         delete file &a
         SAVE all like optsc* TO &a
*         hide menu _msysmenu
                             hide popup poptions
                             hide popup poins
*              do inv2 WITH client->acctno
              do edinv WITH client->acctno
         a=fname('opt1sc.mem')
         RESTORE from &a additive
*         RESTORE SCREEN FROM OPTSC
*         result=10
         select invoice
        set order to tag acctno
         set filter to
*      set order to tag invdate
*         set filter to acctno=client->acctno
*do clprevnext
*a=fname("res.mem")
*save all like result to &a
*          activate menu _msysmenu pad 'OPTIONS'
*           do clientdisplay
show popup invpop
return

******************************************************************************
*                         policy
******************************************************************************
procedure popol
parameter result
*a=fname("res.mem")
*save all like result to &a
         save screen to sc1
         a=fname('opt1.mem')
         delete file &a
         save to &a
*         clear memory
                             hide popup poptions
                             hide popup poins
*                             hide menu _msysmenu
                           do POLMENU with client->acctno
         IF USED('COMISION')
            SELECT COMISION
            SET FILTER TO
         ENDIF
         select policy
         set relation to
         select coverage
*         set filter to acctno=client->acctno
          SET FILTER TO
         set relation to
         select invoice
        set order to tag acctno
        SET FILTER TO
         select client
         unlock in client
         SET ORDER TO ACCTNO
      set relation to acctno into invoice
*      SET ORDER TO LASTN
         a=fname('opt1.mem')
         restore from &a additive
*         RESTORE SCREEN FROM SC1
		 do clientpaint with .t.
         do clientdisplay
return

******************************************************************************
*                         policy
******************************************************************************
procedure hopol
parameter result
*a=fname("res.mem")
*save all like result to &a
         save screen to sc1
         a=fname('opt1.mem')
         delete file &a
         save to &a
*         clear memory
                             hide popup poptions
                             hide popup hoins
*                             hide menu _msysmenu
                           do hPLMENU with client->acctno
         IF USED('COMISION')
            SELECT COMISION
            SET FILTER TO
         ENDIF
         select client
         unlock in client
         SET ORDER TO ACCTNO
      set relation to acctno into invoice
*      SET ORDER TO LASTN
         a=fname('opt1.mem')
         restore from &a additive
*         RESTORE SCREEN FROM SC1
         do clientdisplay
return


******************************************************************************
*                        vehicles
******************************************************************************
procedure povehs
parameter result

a=fname("res.mem")
save all like result to &a
         save screen to sc1
*         hide menu _msysmenu
                           hide popup poptions
                           hide popup poins
                           do vehmenu with client->acctno
         select invoice
         set order to tag acctno
         SET FILTER TO
         select client
         SET ORDER TO TAG ACCTNO
         set relation to acctno into invoice
*         SET ORDER TO LASTN
*         do clientdisplay
*        RESTORE SCREEN FROM SC1
         select client
         unlock in client
         do clientpaint with .t.
         do clientdisplay
return


******************************************************************************
*                        vehicles
******************************************************************************
procedure homes
parameter result

a=fname("res.mem")
save all like result to &a
         save screen to sc1
                           hide popup poptions
                           hide popup hoins
                           do homenu with client->acctno
         select invoice
         set order to tag acctno
         SET FILTER TO
         select client
         SET ORDER TO TAG ACCTNO
         set relation to acctno into invoice
*        RESTORE SCREEN FROM SC1
         select client
         unlock in client
         set color to gr+/b
         clear
         do clientpaint with .t.
         do clientdisplay
return

******************************************************************************
*                        application
******************************************************************************
procedure poapp
parameter result

a=fname("res.mem")
save all like result to &a
         save screen to sc1
              a=fname('opt1sc.mem')
         delete file &a
         save all like sc* to &a
         release all like sc*
         a=fname('autoins.mem')
         delete file &a
         rec=recno('client')
         save to &a
         release all like sc*
         wait window "Coming up" nowait
*         hide menu _msysmenu
*         clear memory
*                           do cleanfilters
*                            set
                             hide popup poptions
                             hide popup poins
                           set deleted on
                             if lock(alltrim(str(recno())),'client')=.f.
                                ?? chr(7)
                                wait window 'This CLIENT is edited by Another User' timeout 1
                                wait window 'The Information might Change' timeout 1
                             endif
                           do applicat with client->acctno
                           set deleted off
                           select driver
                           set filter to
                           select policy
                           set relation to
                           set filter to
                           select coverage
                           set relation to
                           set filter to  acctno=client->acctno
                           select policy
                           set relation to
                           select client
                           set filter to
                           select invoice
                           set order to tag acctno
*      set order to tag invdate
*                           set filter to acctno=client->acctno
        SET FILTER TO
        select client
        unlock in client
        set relation to acctno into invoice
*      set relation to acctno into invoice
*                           do cleanfilters
*                           set
         a=fname('autoins.mem')
         restore from &a additive
         a=fname('opt1sc.mem')
         restore from &a additive
 *       RESTORE SCREEN FROM SC1
         select client
         goto (rec)
*         result=10
*a=fname("res.mem")
*save all like result to &a
      *do clprevnext
*          activate menu _msysmenu pad 'OPTIONS'
wait clear
return




******************************************************************************
*                    Procedure client paint
******************************************************************************
procedure clientpaint
parameter first
fn=fname("cliscre.mem")
if !file(fn)
	set color to gr+/n
*	@ 0,0 to 0,79 clear
	@ 0,0 say space(80)
	=center(0,'  CLIENT INFORMATION  ')

    SET COLOR TO gr+/b
    @ 2,0 to 24,79 clear
    *@ 23,0 to 23,79
    *=center(24,'Press F10 to ACCEPT this entry')
    SET COLOR TO gr+/b,w/gr+
    @ 2,1 SAY 'Account No:'
    @ 3,2 say  'Last Name:'
    @ 3,40 say 'First Name:'
    @ 3,73 say 'MI:'
    @ 4,4 say  'Address:'
    @ 4,44 SAY 'Apt No:'
    @ 5,7 say 'City:'
    @ 5,29 say 'County:'
    @ 5,52 say 'State:'
    @ 5,62 say 'Zip:'

@ 7,0 say "Application Address" color b/w

    @ 8,4 say  'Address:'
    @ 8,44 SAY 'Apt No:'
    @ 09,7 say 'City:'
    @ 09,29 say 'County:'
    @ 09,52 say 'State:'
    @ 09,62 say 'Zip:'


    @11,27 say 'Sex:'
    @12,1 say 'Salutation:'
    @13,1 say 'Birth Date:'
    @14,1 say 'Social Sec:'
    @15,1 say 'Driv Lic #:'

    @ 12,40 say 'Home phone:'
    @ 13,40 say 'Work phone:'
    @ 14,40 say 'Occupation:'
    @ 15,42 say 'Employer:'
    @ 16,39 say 'Emp Address:'
    @ 17,43 say 'Emp CSZ:'
    @ 18,41 say 'Emp Phone:'

    @ 16,1 say 'State Issd:'
    @ 16,17 say 'Date Issd:'
    @ 17,1 say 'Mar Status:'
    @ 19,1 say 'Referred by:'
    @ 19,21 say 'Referral name:'
*    @ 20,1 say 'Broker:'
    @ 20,17 say 'Notes:'
    @ 21,5  SAY 'Balance:'

    *@ 19,3 say 'Current:         30:         60:         90:       120+:      Total:'
*    @ 21,10 SAY "Last payment made at:"
*    @ 21,45 say "Amount:"
    set color to gr+/b
else
    restore from &fn additive
    for i=1 to cliscits
                  if cliscreen[i,8]=.t.
                          @ CLISCREEN[I,1],CLISCREEN[I,2] SAY         CLISCREEN[I,3] ;
                                                          COLOR        gr+/b,w+/b
                  endif
                  clear gets
    endfor
endif
     set color to r+/n
*    @ 0,0 to 0,79 clear
    @ 0,0 say space(80)
    =center(0,'  CLIENT INFORMATION  ')
    if first
      save screen to mainsc
      a=fname("mainsc.mem")
      save all like mainsc to &a
    else
      set color to 
      save screen to mainsc
      a=fname("mainsc.mem")
      save all like mainsc to &a
    endif
return



procedure PREVc
          select client
          set order to tag lastn
          skip -1
          if bof('client')
                   ?? chr(7)
                   wait window 'This is the First Record' timeout 1
                   go top
          endif
          set order to tag acctno
          do clientdisplay
return

procedure NEXTc
          select client
          set order to tag lastn
          skip
          if eof('client')
                   ?? chr(7)
                   wait window 'This is the Last Record' timeout 1
                   go bottom
          endif
          set order to tag acctno
          do clientdisplay
return

procedure edc
private ed
          select client
          save screen to ed
          locked=dataedit()
          select client
          if  ( (locked=.t.) and (lastkey() != 27) )
                 wait window "Updating" nowait
                 do clientputdata
                 wait clear
          endif
         unlock in client
         do clientpaint with .f.
		 do clientdisplay
		 wait clear
*          activate menu _msysmenu pad 'EDIT'
 return

procedure delc
          select client
          tf=acertain('DELETE REALLY?',.f.)
          oldrec=recno()
          if ( (tf=.t.) and !recused('client',recno()) )

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag acctno
         macctno=client->acctno
         set deleted on
SET ORDER TO tag acctno
         seek macctno
*SET ORDER TO tag lastn
         set deleted off
         if found()
            ?? chr(7)
            wait window "Don't delete this client, There exists policy for him/her" timeout 1
         else
             select client
             go (oldrec)
             delete
             unlock in client

             * Activity posting
             MINVOICENO=0
             MACCTNO   =client.acctno
             MTRANCODE =1003
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =date()
             MCLERK    =''
             MDESCRIPT ="Customer Deleted"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
             DVID      =' '

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
             select client
             do clientdisplay
          endif
         endif
         select client
*          activate menu _msysmenu pad 'Delete'
return

procedure undelc
          select client
          recall
          do clientdisplay
*          activate menu _msysmenu pad 'Undelete'
return

procedure firstc
          select client
          set order to tag lastn
          go top
          set order to tag acctno
          do clientdisplay
*          activate menu _msysmenu pad 'First'
return

procedure lastc
          select client
          set order to tag lastn
          go bottom
          set order to tag acctno
          do clientdisplay
*          activate menu _msysmenu pad 'Last'
return

PROCEDURE QUITC
*          hide menu _msysmenu
          getout=1
*          DEACTIVATE MENU _msysmenu
*          RELEASE MENU _msysmenu
          set topic to "SEARCH"
RETURN


proc setMENU

  DEFINE MENU _msysmenu bar color scheme 3
*  BAR AT LINE 1 COLOR SCHEME 3
*  DEFINE PAD Jump      OF _msysmenu   PROMPT '\<Jump'     
  DEFINE PAD Options    OF _msysmenu  PROMPT '\<Options'   
  DEFINE PAD First      OF _msysmenu  PROMPT '\<First'     
*  DEFINE PAD FIND       OF _msysmenu   PROMPT 'F\<ind'    
  DEFINE PAD Previous   OF _msysmenu  PROMPT '\<Previous'  
  DEFINE PAD Next       OF _msysmenu  PROMPT '\<Next'      
  DEFINE PAD Last       OF _msysmenu  PROMPT '\<Last'      
  DEFINE PAD Edit       OF _msysmenu  PROMPT '\<Edit'      
  DEFINE PAD Delete     OF _msysmenu  PROMPT '\<Delete'    
  DEFINE PAD Undelete   OF _msysmenu  PROMPT '\<UnDel'    
  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit'      

  on pad options of _msysmenu activate popup poptions
*  on pad find of _msysmenu activate popup findem
*  ON SELECTION MENU _msysmenu DO tmenu with PAD()
*  ON SELECTION MENU _msysmenu DO tmenu

DEFINE POPUP Findem      margin relative shadow color scheme 4
DEFINE POPUP UTILS      margin relative shadow color scheme 4

DEFINE BAR 1 OF findem PROMPT 'By \<Name or  Account Number'
DEFINE BAR 2 OF findem PROMPT 'By \<Insurance Policy Number'
DEFINE BAR 3 OF findem PROMPT 'By Vehicle \<Plate Numbers  '
DEFINE BAR 4 OF findem PROMPT 'By \<Vehicle ID Number      '
DEFINE BAR 5 OF findem PROMPT 'Ph\<onetic Search (Slow)    '
define bar 6 of findem prompt '\<Help, I am lost, Assist me'

on selection bar 1 of findem do fclibyname
on selection bar 2 of findem do fclibyins
on selection bar 3 of findem do fclibyplate
on selection bar 4 of findem do fclibyveh
on selection bar 5 of findem do fclifon
on selection bar 6 of findem do fcliindhelp


DEFINE POPUP poptions margin relative shadow color scheme 4
DEFINE POPUP poins margin relative shadow color scheme 4
DEFINE POPUP hoins margin relative shadow color scheme 4
DEFINE POPUP his margin relative shadow color scheme 4
DEFINE POPUP memopop margin relative shadow color scheme 4
DEFINE POPUP invpop margin relative shadow color scheme 4
DEFINE POPUP ACCT margin relative shadow color scheme 4

*DEFINE BAR 1 OF poptions PROMPT  'Enter Payments'
DEFINE BAR 1 OF poptions PROMPT  '\<Auto Insurance '
DEFINE BAR 2 OF poptions PROMPT  '\<Property Insurance '
DEFINE BAR 3 OF poptions PROMPT  '\<Free Form Data '
DEFINE BAR 4 OF poptions PROMPT  '\<Client History '



on BAR 1 OF poptions activate popup poins
on BAR 2 OF poptions activate popup hoins
on bar 3 of poptions activate popup memopop
on bar 4 of poptions activate popup his



DEFINE BAR 1 OF invpop PROMPT  '\<Create Invoice'
DEFINE BAR 2 OF invpop PROMPT  '\<Update Invoice'

on selection bar 1 of invpop do poinv
on selection bar 2 of invpop do poedinv

DEFINE BAR 1 OF poins PROMPT  "\<Vehicles"
DEFINE BAR 2 OF poins PROMPT  "\<Policies"
*DEFINE BAR 3 OF poins PROMPT  "Assigned \<Risc Form"

ON SELECTION BAR 1 OF poins do povehs with 10
ON SELECTION BAR 2 of poins do popol  with 10
*ON SELECTION BAR 3 OF poins do poapp  with 10


DEFINE BAR 1 OF hoins PROMPT  "P\<roperties"
*DEFINE BAR 2 OF hoins PROMPT  "\<Policies"

ON SELECTION BAR 1 OF hoins do homes
*ON SELECTION BAR 2 of hoins do hopol



DEFINE BAR 1 OF memopop PROMPT  ' \<Edit '
DEFINE BAR 2 OF memopop PROMPT  '\<Import'
DEFINE BAR 3 OF memopop PROMPT  'E\<xport'
DEFINE BAR 4 OF memopop PROMPT  '\<Print '

ON SELECTION BAR 1 OF memopop do edtmemo
ON SELECTION BAR 2 of memopop do grabdata
ON SELECTION BAR 3 OF memopop do expdata
ON SELECTION BAR 4 OF memopop do clprmemo

DEFINE BAR 1 OF his PROMPT  '\<Activity  Log'
DEFINE BAR 2 OF his PROMPT  '\<Transactions'
DEFINE BAR 3 OF his PROMPT  '\<Commissions'

ON SELECTION BAR 1 OF his do pohis with 1
ON SELECTION BAR 2 of his do pohis with 2
ON SELECTION BAR 3 OF his do pohis with 3


*on selection pad jump       of _msysmenu do skipem
on selection pad First      of _msysmenu do firstc
on selection pad Previous   of _msysmenu do prevc
on selection pad Next       of _msysmenu do nextc
on selection pad Last       of _msysmenu do lastc
on selection pad Edit       of _msysmenu do edc
on selection pad Delete     of _msysmenu do delc
on selection pad Undelete   of _msysmenu do undelc
on selection pad Quit       of _msysmenu do quitc
return


procedure grabdata
private locked
locked=.f.
if lock(alltrim(str(recno())),'client')=.f.
   wait window 'This Account is edited by Another User Try Again Later'
   locked =.f.
   return
else
  locked=.t.
endif
a=fname("data.ins")
if file( a )
   wait window "Retrieving" nowait
   append memo info from &a
   DELETE FILE &A
   wait clear
   do edtmemo
else
    wait window "No external data found !" nowait
    a=getfile('???','Please Select Text File to Import','IMPORT',0)
    if len(a)>0 .and. lastkey()<>27
    	append memo info from &a
        do edtmemo
        wait clear
    endif
endif
   unlock in client
   root=getenv('inmsroot')
   set default to &root
return


procedure edtmemo
private sc,locked

locked=.f.
if lock(alltrim(str(recno())),'client')=.f.
   wait window 'This Account is edited by Another User Try Again Later'
   locked =.f.
   return
else
  locked=.t.
endif

        save screen to sc
        set color to gr+/b
        on key label f10 keyboard "{ctrl+w}"
        set topic to "EDITOR"
        if wexist('editor')
           release window editor
        endif
        set color to
        on key label f10 keyboard "{ctrl+w}"
        define window editor at 1,1 size 25,80 in desktop system shadow float ;
                      color scheme 10 font "FixedSys",9;
                      title "Press <F10> to Save, <ESC> to Abort"
        save screen to sc
           modify memo info nomenu
       deactivate window editor
       release window editor
*      restore screen from sc
       on key label f10
        unlock in client
             * Activity posting
             MINVOICENO=0
             MACCTNO   =client.acctno
             MTRANCODE =6603
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =date()
             MCLERK    =''
             MDESCRIPT ="Customer Free Data Edited"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
             DVID      =' '

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
select client
UNLOCK IN CLIENT
set topic to "CLIENT"
return

procedure expdata
          b=sys(5)+"\memo.txt"
          copy memo client.info to (b)
          wait window "File '"+upper(b)+"' created"
return



procedure scedit
          save screen to ed
*         hide popup poptions
*          hide menu _msysmenu
          tf=cliedit()
              release cliscreen
              release cliscits
              set color to gr+/b
*              @ 2,0 to 24,79 clear
              clear
              do clientpaint with .t.
              do clientdisplay
*         show popup poptions
*         show menu _msysmenu
return

procedure clprmemo
DO PRNCHOIC
wait window "Now printing" nowait
rec=recno('client')
restore from comem additive
report form clmemo for recno('client')=rec to print noconsole
wait CLEAR
SELECT CLIENT
*!!!!!
GOTO REC
UNLOCK IN CLIENT
return




procedure fcliindhelp
set topic to "SEARCH"
do helpme
set topic to "CLIENT"
RETURN


***************************************************************************
*                        Findclient Procedures
***************************************************************************
procedure   fclibyname
     if !used('client')
        select a
        use client index client alias client
     else
        select client
     endif
*     set order to tag lastn
     facctno=getinfo()
        do clientdisplay
return

procedure fclibyins
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
*         set order to tag acctno
*          set order to tag lastn
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
        do clientdisplay
return

procedure fclibyveh
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
*         set order to tag acctno
*         set order to tag lastn
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
        do clientdisplay
return

procedure fclibyplate

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
*         set order to tag acctno
*         set order to tag lastn

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
        do clientdisplay
return

procedure fclifon
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
*         set order to tag LASTN
        select client
        facctno=getsound()
        do clientdisplay
return

function getreffer
parameter number

       if !used('reffer')
          select 15
          use reffer index reffer alias refferance
       else
          select refferance
       endif
       set order to tag ref_no
seek number

if ( (!found()) or (number=0))
       define window browser at 3,3 size 10,40;
              Title "Refferals list" color scheme 10 float system shadow grow IN desktop;
                      footer "Press <F10> to Save, <ESC> to Abort" font "Arial",11
        go top
        on key label enter keyboard "{ctrl+w}"
        set deleted on
        lastk=27
        do while (lastk=27)
           browse fields ref_no:h="##":w=(.t.=.f.),;
                             ref_name:h="Refferal" ;
                             nomodify window browser nomenu

           lastk=lastkey()
        enddo
        set deleted off
        on key label enter
        release window browser
endif
creffered=refferance.ref_no
crefferal=refferance.ref_name
show gets
return .t.




procedure chacct
    tf=maintainpass()
    if !tf
       return
    endif
oldrec=recno()

    release window browser
    define window browser from 8,3 to 20,64;
     Title "Select Account to Switch to. [ESC] to abort" color scheme 10 float system shadow IN SCREEN;
     footer "Press <F10> to Select, <ESC> to Abort"
on key label f10 keyboard "{ctrl+w}"
on key label enter keyboard "{ctrl+w}"
set order to tag lastn

    go top
    browse fields acctno,lastn:h="Last Name",firstn:h="First Name" window browser

set order to tag acctno

on key label f10
on key label enter
release window browser

if lastkey()==27
    goto oldrec
    do clientdisplay
    return
endif

*    wait window str(acctno)
    newact=acctno
    message="Really change this account to :"+alltrim(str(newact))
    tf=acertain(message)
    if !tf
       goto oldrec
       do clientdisplay
       return
    endif


    goto oldrec


 if ( !recused('client',oldrec ) )
    replace acctno with newact
    unlock in client
    do clientdisplay
 endif
return
