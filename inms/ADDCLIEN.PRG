
controlw=23
Set procedure to 'various'
set exclusive off
declare cliscreen[31,11]
cliscits=0
release cliscits



 **
**** Initialize the sizes first
 **
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
   cbroker=' '
 **
****  Initialize the variables now.
 **
   creffered=0
   crefferal=space(crefsize)
   macctno=0
   clname=space(clnamesize)
   cfname=space(cfnamesize)
   cmi=' '
   caddress=space(cadrsize)
   captno=space(captsize)
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
   cthirty=0
   csixty=0
   cninety=0
   conetwenty=0
   ctotal=0
   cvar=space(cvarsize)
   ccity=space(ccitysize)
   cstate='  '
   czip=space(10)
   ccounty=space(ccountysize)
   cappcounty=space(ccountysize)
   paydate={  /  /  }
   payamount=0
   mbalance=0
   cappaddress=space(cadrsize)
   cappaptno=space(captsize)
   cappcity=space(ccitysize)
   cappstate='  '
   cappzip=space(11)



if !used('reffer')
     select 15
	use reffer index reffer alias refferance
else
    select refferance
endif
set order to tag ref_no
count to refsize
go top
dimension refarray(refsize,2)
*select distinct ref_no,h.ref_name_from refferance into array refarray
i=1
do while ( eof ('refferance') =.f.)
	refarray(i,1)=alltrim(str(ref_no))
	refarray(i,2)=ref_name
	skip
	i=i+1
enddo
go top
   
if !used('client')
   select a
   use client index client alias client
else
   select client
endif

ON KEY LABEL F10 KEYBOARD "{CTRL+W}"
*set talk off

if !used('client')
   select a
   use client index client alias client
else
   select client
endif

*do clpaint
*do getbroker

define window wclient at 1,1 size 25,80 in desktop system float shadow nogrow noclose ;
        title "Adding a client" font "FixedSys",8
activate window wclient

do addclient
deactivate window wclient
release window wclient
return macctno


***************************************************************************
*                     PROCEDURE ADD
***************************************************************************
PROCEDURE ADDCLIENT
private tf,selection,cont,string,ACCEPT,yes,no
yes=0
no=0
cont=.t.
ACCEPT=.F.
*do while cont=.t.
   SET COLOR TO gr+/b
   CLEAR
   @ 0,0 TO 2,79 FILL COLOR W/RB+
*   @ 23,0 to 23,79
*   =center(24,'Press F10 to process this Entry')
   SET COLOR TO w/rb+
   =CENTER(1,'ADD CLIENT SCREEN')
   SET COLOR TO gr+/b,w+/bg
     issstate='NY'
     issdate={  /  /  }

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
         Save Screen to TempScrn
         NAME=FNAME("DATA.INS")
          IF FILE (NAME)
            wait window "Please Wait I am Getting the Driver Info" nowait
            Do Getautoclient
         endif

         Restore Screen From TempScrn

set color to n/w
*@ 24,0 to 24,79 clear
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
set message to '*    Copyright (c) 1994 '+myname+'    *' center
namekey=space(10)
namekey=alltrim(hash(myname))
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        cancel
endif

   SET COLOR TO gr+/b,w+/bg
if sdesign=.f.
*        @2,1 SAY 'Account No:' get macctno disabled color ,,,,,,,,w+/b,w+/b
        @3,2 say  'Last Name:' get clname picture '!'+replicate('X',(clnamesize)-1) size 1,25
        @3,40 say 'First Name:' get cfname picture '!'+replicate('X',(cfnamesize)-1) size 1,20
        @3,73 say 'MI:' get cmi picture '!'

        @ 4,4 say 'Address:' get caddress  picture '!'+replicate('X',(cadrsize)-1) size 1,30 valid upadd(caddress)
        @ 4,44 SAY 'Apt No:' get captno picture replicate('X',(captsize)-1) size 1,8         valid upaptno(captno)
        @ 5,7 say 'City:' get ccity picture replicate('X',ccitysize) size 1,15               valid upcity(ccity)
        @ 5,29 say 'County:' get ccounty picture replicate('X',ccountysize) size 1,14        valid upcounty(ccounty)
        @ 5,52 say 'State:' get cstate picture 'aa'                                          valid upstate(cstate)
        @ 5,62 say 'Zip:' get czip picture '99999-99999'                                     valid upzip(czip)

@ 7,0 say "Application Address" color r/w

    @ 8,4 say 'Address:' get cappaddress  picture '!'+replicate('X',(cadrsize)) size 1,30
    @ 8,44 SAY 'Apt No:' get cappaptno    picture replicate('X',(captsize)) size 1,8
    @09,7 say 'City:'    get cappcity     picture replicate('X',ccitysize) size 1,15
    @09,29 say 'County:' get cappcounty   picture replicate('X',ccountysize) size 1,14
    @09,52 say 'State:'  get cappstate    picture '!!'
    @09,62 say 'Zip:'    get cappzip      picture '99999-99999'

        @11,27 say 'Sex:' get csex picture '!' valid (csex='M' or csex='F' or csex=' ' )
        @12,1 say 'Salutation:' get csalutation  picture replicate('X',(csalsize)-1) size 1,10
        @13,1 say 'Birth Date:' get cbdate picture '@d'
        @14,1 say 'Social Sec:' get cssc picture '999-99-9999'
        @15,1 say 'Driv Lic #:' get cdrivlic picture replicate('X',(cdlicsize)) size 1,25
        @16,1 say 'State Issd:' get issstate picture 'aa'
        @16,17 say 'Date Issd:'  get issdate picture '@d'

        @ 12,40 say 'Home phone:' get chomephone picture '(999)-999-9999'
        @ 13,40 say 'Work phone:' get cworkphone picture '(999)-999-9999'
        @ 14,40 say 'Occupation:'get coccupation picture '!'+replicate('X',(coccsize)-1) size 1,26
        @ 15,42 say 'Employer:' get cemployer picture '!'+replicate('X',(cempsize)-1) size 1,26
        @ 16,39 say 'Emp Address:' get cempadress picture '!'+replicate('X',(cempadsize)-1) size 1,26
        @ 17,43 say 'Emp CSZ:' get cempcsz picture '!'+replicate('X',(cempcszsize)-1) size 1,26
        @ 18,41 say 'Emp Phone:' get cemphone picture '(999)-999-9999'

        @ 17,1 say 'Mar Status:' get cmarstat picture '!' valid (cmarstat='M' or cmarstat='S' or cmarstat='W' or cmarstat=' ' )
*        @ 16,1 say 'Reffered by:' get creffered picture '9999'
*        @ 16,21 say 'Refferal name:' get crefferal picture '!'+replicate('X',(crefsize)-1) size 1,30

        @ 19,1  say 'Referred by:' get creffered picture '@^' from refarray valid getreffer(creffered)
        @ 19,25 say 'Referral name:' get crefferal picture '!'+replicate('X',(crefsize)) size 1,30 disabled
*        @ 20,1 say 'Broker:' get cbroker picture '!' disabled
        @ 20,21 say 'Notes:' get cnotes picture '!'+replicate('X',(cnotesize)-1) size 1,50
        @ 21,5  SAY 'Balance:' get mbalance picture '999,999.99'       
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

        @ 22,5 get cvar picture replicate('X',cvarsize) size 1,(cvarsize) disabled color ,,,,,,,,w+/b,w+/b
*        SET SYSMENU OFF
		@ 23,25 get yes function "* Accept" size 2,8
		@ 23,45 get no  function "* Cancel" size 2,8
		
        READ CYCLE
        CSTATE=UPPER(CSTATE)
        last=lastkey()
*        if last=(controlw)
*            cont=.f.
*            tf=1
*        ENDIF
*        if last=27
*            cont=.f.
*            tf=0
*        ENDIF

*		if yes=1 or last=(controlw)
*			tf=acertain("Insert this Client ?",.t.)
*		else
*			tf=.f.
*		endif	
*ENDDO

if yes=1 or last=(controlw)
	tf=.t.
else
	tf=.f.	
endif

if tf=.t.
   ACCEPT=getdoubles(alltrim(upper(clname)))
endif

if accept=.t. and tf=.t.
   append blank
   rec=recno()
   if !lock(alltrim(str(rec)),'client')
       wait window 'Fatal: Cannot lock new record'
       ? chr(7)
       cancel
   endif

   macctno=getcacctno()
   set color to gr+/b
   wait window "Updating" nowait
   do clientputdata
   wait clear
   define window account from 8,5 to 18,47 color scheme 10 system float shadow;
              Title 'ACCOUNT INFO' in desktop font "Arial",11
   activate window account
   @ 1,5 say  "The customer's account number is"
   string=alltrim(str(macctno))
   =CENTER(3,string)
   @ 5,9 say 'Please make a note of it'
   =inkey(5)
   deactivate window account
   release window account
endif

unlock in client
RETURN


***************************************************************************
*                     PROCEDURE getrest
***************************************************************************
PROCEDURE getrest
private tf,selection,cont,string,ACCEPT
cont=.t.
ACCEPT=.F.
do while cont=.t.
        SET COLOR TO gr+/b
        CLEAR
        @ 0,0 TO 2,79 FILL COLOR W/RB+
        @ 23,0 to 23,79
*        =center(24,'Press F10 to process this Entry')
        SET COLOR TO W/RB+
        =CENTER(1,'ADD CLIENT SCREEN')
        SET COLOR TO gr+/b,w+/bg

SDESIGN=.F.
if type('cliscreen[1,1]')='U'
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
if sdesign=.f.
        @4,1 SAY 'Account No:' get macctno disabled color ,,,,,,,,w+/b,w+/b
        @5,2 say  'Last Name:' get clname picture '!'+replicate('X',(clnamesize)-1) size 1,25 disabled color ,,,,,,,,w+/b,w+/b
        @5,40 say 'First Name:' get cfname picture '!'+replicate('X',(cfnamesize)-1) size 1,20 disabled color ,,,,,,,,w+/b,w+/b
        @5,73 say 'MI:' get cmi picture '!' disabled color ,,,,,,,,w+/b,w+/b
        @ 6,4 say 'Address:' get caddress  picture '!'+replicate('X',(cadrsize)-1) size 1,30 disabled color ,,,,,,,,w+/b,w+/b
        @ 6,44 SAY 'Apt No:' get captno picture replicate('X',(captsize)-1) size 1,8  disabled color ,,,,,,,,w+/b,w+/b
        @ 7,7 say 'City:' get ccity picture replicate('X',ccitysize) size 1,15   disabled color ,,,,,,,,w+/b,w+/b
        @ 7,29 say 'County:' get ccounty picture replicate('X',ccountysize) size 1,14  disabled color ,,,,,,,,w+/b,w+/b
        @ 7,52 say 'State:' get cstate picture '!!'  disabled color ,,,,,,,,w+/b,w+/b
        @ 7,62 say 'Zip:' get czip picture '99999-99999'  disabled color ,,,,,,,,w+/b,w+/b

        @ 9,1 say 'Salutation:' get csalutation  picture replicate('X',(csalsize)-1) size 1,10
        @10,1 say 'Birth Date:' get cbdate picture '@d' &&valid date_validate(cbdate)
        @8,27 say 'Sex:' get csex picture '!' valid (csex='M' or csex='F' or csex=' ' )  disabled color ,,,,,,,,w+/b,w+/b
        @11,1 say 'Social Sec:' get cssc picture '999-99-9999'
        @12,1 say 'Driv Lic #:' get cdrivlic picture replicate('X',(cdlicsize)) size 1,25
        @13,1 say 'State Issd:' get issstate picture 'aa'
        @13,17 say 'Date Issd:'  get issdate picture '@d'
        @ 14,1 say 'Mar Status:' get cmarstat picture '!' valid (cmarstat='M' or cmarstat='S' or cmarstat='W' or cmarstat=' ' )

        @ 9,40 say 'Home phone:' get chomephone picture '(999)-999-9999'
        @ 10,40 say 'Work phone:' get cworkphone picture '(999)-999-9999'
        @ 11,40 say 'Occupation:'get coccupation picture '!'+replicate('X',(coccsize)-1) size 1,26
        @ 12,42 say 'Employer:' get cemployer picture '!'+replicate('X',(cempsize)-1) size 1,26
        @ 13,39 say 'Emp Address:' get cempadress picture '!'+replicate('X',(cempadsize)-1) size 1,26
        @ 14,43 say 'Emp CSZ:' get cempcsz picture '!'+replicate('X',(cempcszsize)-1) size 1,26
        @ 15,41 say 'Emp Phone:' get cemphone picture '(999)-999-9999'
        @ 16,1 say 'Reffered by:' get creffered picture '9999'
        @ 16,21 say 'Refferal name:' get crefferal picture '!'+replicate('X',(crefsize)-1) size 1,30 disabled
        @ 17,21 say 'Notes:' get cnotes picture '!'+replicate('X',(cnotesize)-1) size 1,50
        @ 18,5  SAY 'Balance:' get mbalance picture '999,999.99'

        *@ 19,3 say 'Current:         30:         60:         90:       120+:      Total:'
        *@ 20,13 get cthirty picture '999,999.99'    valid ((cthirty >=0)    and cvalid())
        *@ 20,25 get csixty  picture '999,999.99'    valid ((csixty  >=0)    and cvalid())
        *@ 20,37 get cninety picture '999,999.99'    valid ((cninety >=0)    and cvalid())
        *@ 20,49 get conetwenty picture '999,999.99' valid ((conetwenty >=0) and cvalid())
        *@ 20,61 get ctotal picture '999,999.99' valid ( (ctotal >=0) ) disabled color ,,,,,,,,w+/b,w+/b
        @ 19,5 get cvar picture replicate('X',cvarsize) size 1,(cvarsize)
else
    for i=1 to 11
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
    clear gets
    for i=12 to cliscits
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
        READ CYCLE
        cstate=upper(cstate)
        issstate=upper(issstate)

        last=lastkey()
        if last=(controlw)
            cont=.f.
            tf=1
        ENDIF
        if last=27
            cont=.t.
        ENDIF
ENDDO
do clientputdata
RETURN

***************************************************************************
*                     PROCEDURE paint screen
***************************************************************************
Procedure paint_screen
@4,1 SAY 'Account No:'
@5,2 say  'Last Name:'
@5,40 say 'First Name:'
@5,73 say 'MI:'
@ 6,4 say 'Address:'
@ 6,44 SAY 'Apt No:'
@ 7,7 say 'City:'
@ 7,29 say 'County:'
@ 7,52 say 'State:'
@ 7,62 say 'Zip:'
@ 9,1 say 'Salutation:'
@10,1 say 'Birth Date:'
@8,25 say 'Sex:'
@11,1 say 'Social Sec:'
@12,1 say 'Driv Lic #:'
@ 9,40 say 'Home phone:'
@ 10,40 say 'Work phone:'
@ 11,40 say 'Occupation:'
@ 12,42 say 'Employer:'
@ 13,39 say 'Emp Address:'
@ 14,43 say 'Emp CSZ:'
@ 15,41 say 'Emp Phone:'
@ 14,2 say 'Mar Status:'
@ 16,1 say 'Reffered by:'
@ 16,21 say 'Refferal name:'
@ 17,21 say 'Notes:'
@ 18,5  SAY 'Balance:'


*@ 21,3 say 'Current:         30:         60:         90:       120+:      Total:'
*@ 22,13 say cthirty
*@ 22,25 say csixty
*@ 22,37 say cninety
*@ 22,49 say conetwenty
*@ 22,61 say ctotal
return


***************************************************************************
*                     PROCEDURE paint screen
***************************************************************************
procedure find_doubles
set exact off
go top
locate for lastn=clname
locate for firstn=cfname

return


***************************************************************************
*                     PROCEDURE GET DOUBLES
***************************************************************************
PROCEDURE GETDOUBLES
PARAMETER LNAME
SET EXACT OFF
private action,tf

IF LEN(LNAME) >0
set color to w/b,w/rb+
define window matches from 10,1 to 21,79 double float shadow close;
              Title 'CLIENTS ALREADY IN DATABASE' in desktop font "Arial",11

locate for lastn=(lname)
if found()
   set color to gr+/b
   =center(24,space(50))
?? CHR(7)
WAIT WINDOW "DUPLICATE ENTRIES FOUND" NOWAIT
   browse fields acctno:W=(.t.=.f.),lastn,firstn,dr_lic_no ;
   		FOR LASTN=(LNAME) window matches;
        nomodify nomenu color scheme 7
   TF=COMMITABORT()
   set color to gr+/b,w+/bg
ELSE
   TF=COMMITABORT()
   set color to gr+/b,w+/bg
endif

release window doubles
set color to gr+/b,gr+/b
ELSE
  TF=.F.
ENDIF

RETURN TF






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
    thirty       with   cthirty,;
    sixty        with   csixty,;
    ninety       with   cninety,;
    onetwenty    with   conetwenty,;
    total        with   ctotal,;
    var          with   testvar,;
    city         with   upper(alltrim(ccity)),;
    state        with   upper(alltrim(cstate)),;
    zip          with   upper(alltrim(czip)),;
    county       with   upper(alltrim(ccounty)),;
    dissstate    with   UPPER(alltrim(issstate)),;
    dissdate     with   issdate,;
    broker       with   cbroker,;
    dbalance     with   mbalance

* Activity posting
MINVOICENO=0
MACCTNO   =client->acctno
MTRANCODE =1001
MQTY      =1
MPRICE    =0
MTOTAL    =0
MDATE     =date()
MCLERK    =''
MDESCRIPT ="Customer Added"
MPOSTED   =.f.
MBILLED   =.f.
MCHECKNO  =''
DVID      ='      '

=POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
          MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )

 select client
*CLERK=""
*=POST_ACT(0,MACCTNO,1,1,0,0,DATE(),CLERK,"New Customer Added",.f.,.f.,"")
return








***************************************************************************
*     automatic client info
***************************************************************************
procedure getautoclient
PRIVATE DESCR1,DESCR2
textline=space(80)
A=FNAME('DATA.INS')
OFILE=FOPEN(A,0)

IF OFILE=-1
   RETURN .F.
ENDIF

i=1
do while (!feof(ofile))
    textline= fgets(ofile,82)
    do case
        case i=5
                cdrivlic=alltrim(substr(textline,8,30))  && mi #
        case i=6
                fullname=alltrim(substr(textline,1,30))
                loc=at(',',textline)
                clname=substr(fullname,1,loc-2)+space(10)
                loc2=rat(',',textline)
                if loc2<>loc
                        cfname=substr(fullname,loc,loc2-loc-1)+space(10)
                        cmi=substr(fullname,loc2,1)
                else
                        loc2=len(fullname)
                        cfname=substr(fullname,loc,loc2-loc+1)+space(10)
                        cmi=' '
                endif
                cbdate=ctod(alltrim(substr(textline,49,10)))
                csex=alltrim(substr(textline,67,1))
                if csex='M'
                        csalutation='Mr.'
                endif
                if csex='F'
                        csalutation='Mrs.'
                endif
       case i=7
                textline=alltrim(substr(textline,1,35))
                loc=rat('AP',textline)
                if loc>0
                        captno=alltrim(substr(textline,loc+3,2))
                        caddress=substr(textline,1,loc-2)+space(10)
                else
                        caddress=textline+space(10)
                endif
       case i=8
                ccounty=alltrim(substr(textline,49,4))
                if ccounty='QUEE'
                        ccounty='QUEENS'
                endif
                textline=alltrim(substr(textline,1,35))
                loc=at(' ',textline,1)
                ccity=alltrim(substr(textline,1,loc-1))+space(10)


                do while substr(textline,loc,1)=' '
                        loc=loc+1
                enddo
                cstate=alltrim(substr(textline,loc,2))
                czip=alltrim(right(textline,5))
       endcase
    i=i+1
enddo
=fclose(ofile)
issstate='NY'
wait clear
return

function oldgetreffer
parameter number

       if !used('reffer')
          select 15
          use reffer index reffer alias refferance
       else
          select refferance
       endif
       set order to tag ref_no
go top
seek number

wait window str(number)

if ( (!found()) or (number=0))
       define window browser at 3,3 size 10,40;
              Title "Refferals list" color scheme 10 float system shadow in desktop;
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
*creffered=refferance.ref_no
crefferal=refferance.ref_name
show gets
SELECT CLIENT
return .t.

function getreffer
parameter number

*wait window str(number) timeout 2
* creffered=val(refarray(number,1)) ARSEHOLE
crefferal=refarray(creffered,2)
show gets
SELECT CLIENT
return .t.


function upadd
parameter   valuestring
if len(alltrim(cappaddress))=0
   cappaddress=valuestring
   show gets
endif
return .t.

function upaptno
parameter valuestring
if len(alltrim(cappaptno))=0
   cappaptno=valuestring
   show gets
endif
return .t.

function upcity
parameter valuestring
if len(alltrim(cappcity))=0
   cappcity= valuestring
   show gets
endif
return .t.

function upcounty
parameter  valuestring
if len(alltrim(cappcounty))=0
   cappcounty=valuestring
   show gets
endif
return .t.

function upstate
parameter  valuestring
if len(alltrim(cappstate))=0
   cappstate=valuestring
   show gets
endif
return .t.

function upzip
parameter valuestring
if len(alltrim(cappzip))=0
   cappzip=  valuestring
   show gets
endif
return .t.        



***************************************************************************
*     get the broker
***************************************************************************
procedure getbroker


set color to
define window sure from 7,19 to 12,59 none float shadow in desktop ;
       title 'Select Broker' color scheme 10

activate window sure

lastk=27
set color to w+/g,w+/bg
clear
string="Please Select the Broker"
column=(40-len(string))/2

do while lastk=27
	@ 1,column say (string)
	@ 3,1 prompt '           Cousins Brokerage           '
	@ 4,1 prompt '           Olympic Insurance           '

	menu to yesno

    if yesno=2
       cbroker='O'
    else
       cbroker='C'
    endif

	lastk=lastkey()
enddo

deactivate window sure
release window sure
set color to w/n
return



******************************************************************************
*                    Procedure client paint
******************************************************************************
procedure clpaint

   SET COLOR TO gr+/b
   CLEAR
   @ 0,0 TO 2,79 FILL COLOR W/RB+
   @ 23,0 to 23,79
   =center(24,'Press F10 to process this Entry')
   SET COLOR TO w/rb+
   =CENTER(1,'ADD CLIENT SCREEN')
   SET COLOR TO gr+/b,w+/bg

    SET COLOR TO gr+/b,w/gr+
    @ 3,2 say  'Last Name:'
    @ 3,40 say 'First Name:'
    @ 3,73 say 'MI:'
    @ 4,4 say  'Address:'
    @ 4,44 SAY 'Apt No:'
    @ 5,7 say 'City:'
    @ 5,29 say 'County:'
    @ 5,52 say 'State:'
    @ 5,62 say 'Zip:'

@ 7,0 say "Application Address" color r/w

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
    @ 19,25 say 'Referral name:'
*    @ 20,1 say 'Broker:'
    @ 20,21 say 'Notes:'
    @ 21,5  SAY 'Balance:'
    set color to gr+/b
return
