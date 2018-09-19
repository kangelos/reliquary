parameter macctno

push menu _msysmenu
*define window wveh at 4,1 size 25,80 in desktop system float shadow noclose ;
 	title "Vehicles Database Window" font "FixedSys",8
 	
*activate window wveh
set procedure to 'various'
set exclusive off
set filter to
*public vvid,vresult,vlocked,climenu,vfilename
declare vehscreen[41 , 11 ]
vehscits=0
release vehscits
private optopt,has,added
*hide menu mainmenu

vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
vvid=space(20)
vowner=vappname
*vaddress=left(alltrim(CLIENT.add)+' '+alltrim(CLIENT.city)+' '+alltrim(CLIENT.state)+' '+;
*                 alltrim(CLIENT.zip),50)
vaddress=left(alltrim(CLIENT.APPadRESS)+' '+ALLTRIM(CLIENT.APPAPTNO)+","+;
         alltrim(CLIENT.APPcity)+','+alltrim(CLIENT.APPstate)+' '+alltrim(CLIENT.APPzip),50)
vyear='00/00/00'
vmake=space(20)
vmodel=space(25)
vcond='N'
vmonth='01'
vpuryear='    '
vcost=space(10)
vplates=space(10)
vcyls=0
vhpcu=space(6)
vincc=space(6)
vloss=.f.
vlessor=.f.
vlessname=space(35)
vlestreet=space(25)
vlesscity=space(25)
vlessstate='  '
vlesszip='     -     '
vlesscomment=space(45)
vUSE=SPACE(30)
vdlicno=space(30)
vstatereg=space(2)
vgaragaddr=space(25)
vgaragaddr=space(25)
vmilestow=space(10)
vappadress=space(35)
vappadress=space(35)
vterry=space(10)
vrate=space(10)
vpenalty=space(10)
vsymbol=space(25)
vantitheft   = .f.
vamodel      = space(25)
vabrand      = space(25)
vapassive    = .f.
vaactive     = .f.

has=.f.
has=initvehsystem()
if has=.f.
     ?? CHR(7)
     wait window 'No VEHICLE Found For this Customer' timeout 1
     ?? chr(7)
     wait window 'Press any key to ADD one'
   addedveh=addveh()
   if addedveh
      =initvehsystem()
      do vehdisplay
      wait window "Now Press a key to add a PREMIUM for this car"
      do mcover
      wait window "You can now go to the Policies Menu and Create a Policy" timeout 2
      wait window "So that you can print the Assigned Risc Form" timeout 2
   else
      return
   endif
endif

set color to w/b
do vehoptions

*clear
DO VEHPAINT with .t.
*SAVE SCREEN TO vscreen
do vehdisplay
*DEACTIVATE MENU _msysmenu
*activate menu _msysmenu
mquit=0
do while mquit=0
	activate menu _msysmenu
enddo
set filter to
wait clear
*release window wveh
pop menu _msysmenu
return

******************************************************************************
*                    Procedure vehicle system Initialization
******************************************************************************
function initvehsystem
private tf
tf=.t.
if !used('Vehicle')
   select b
            use VEHICLE index VEHICLE alias VEHICLE
else
   select vehicle
endif
set filter to
LoCATE FOR ACCTNO=mACCTNO
*seek macctno
IF FOUND()
   set filter to acctno=macctno
*   go top
    go bottom
ELSE
    tf=.f.
endif
return tf

******************************************************************************
*                    Procedure vehicle options
******************************************************************************
Procedure VehOptions
  DeFINE MENU _msysmenu bar color scheme 3
  * BAR AT LINE 1 COLOR SCHEME 4
*	DeFINE MENU _msysmenu color scheme 3

  DEFINE PAD Add        OF _msysmenu  PROMPT '\<Add'         
  DEFINE PAD Options    OF _msysmenu  PROMPT '\<Options'     
  DEFINE PAD First      OF _msysmenu  PROMPT '\<First'       
  DEFINE PAD Previous   OF _msysmenu  PROMPT '\<Previous'    
  DEFINE PAD Next       OF _msysmenu  PROMPT '\<Next '       
  DEFINE PAD Last       OF _msysmenu  PROMPT '\<Last'        
  DEFINE PAD Edit       OF _msysmenu  PROMPT '\<Edit'        
  DEFINE PAD Delete     OF _msysmenu  PROMPT '\<Delete'      
  DEFINE PAD Undelete   OF _msysmenu  PROMPT '\<UnDelete'    
  DEFINE PAD Quit       OF _msysmenu  PROMPT '\<Quit'        


DEFINE POPUP vehpoptions margin relative shadow color scheme 4



on selection pad  Add      of _msysmenu  do mvehAdd
on pad  options  of _msysmenu  activate popup vehpoptions
on selection pad  First    of _msysmenu  do mvehFirst
on selection pad  Previous of _msysmenu  do mvehPrevious
on selection pad  Next     of _msysmenu  do mvehNext
on selection pad  Last     of _msysmenu  do mvehLast
on selection pad  Edit     of _msysmenu  do mvehEdit
on selection pad  Delete   of _msysmenu  do mvehDelete
on selection pad  Undelete of _msysmenu  do mvehUndelete
on selection pad  Quit     of _msysmenu  do mvehQuit

DEFINE BAR 1 OF vehpoptions PROMPT  'Ins. \<Premiums'
DEFINE BAR 2 OF vehpoptions PROMPT  '(De)\<Activate'

ON SELECTION BAR 1 OF vehpoptions do mcover
ON selection BAR 2 OF vehpoptions do endisable


return


******************************************************************************
*                       previous vehicle
******************************************************************************
procedure mvehprevious
          skip -1
          if bof('vehicle')
             Wait window 'This is the FIRST Vehicle' timeout 1
             go top
          else
              do vehdisplay
          endif
return


******************************************************************************
*                    next vehicle
******************************************************************************
procedure mvehnext     
           skip
           if eof('vehicle')
              wait window 'This is the LAST Vehicle' timeout 2
              go bottom
           else
               do vehdisplay
           endif
return


******************************************************************************
*                     edit vehicle
******************************************************************************
procedure mvehedit
          rec=recno()
*          hide menu _msysmenu
          vlocked=vehdataedit()
          select vehicle
          if ( (vlocked=.t.) and (lastkey() # 27) )
                 wait window "Updating" nowait
                 goto rec
                 do putvehdata
                 wait clear
          endif
          unlock in vehicle
          vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
          do vehdisplay
          show menu _msysmenu
return

******************************************************************************
*                  Check Coverages
******************************************************************************
procedure checkvin
parameter mvin

         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         SET ORDER TO TAG VIN
         SET DELETED ON
         SEEK MVIN
         SET DELETED OFF
         IF FOUND()
         	tf=.f.
         ELSE             
         	tf=.t.
         endif
        SELECT VEHICLE
return tf

******************************************************************************
*                  delete vehicle
******************************************************************************
procedure mvehdelete
     select client
     if recused('client',recno()) )
        ?? chr(7)
        wait window "Somebody is editing this vehicle's owner" nowait
     else
     select vehicle
*          ?? chr(7)
*          wait window 'Make sure you have deleted all the Premiums too' timeout 1
          tf=acertain('DELETE REALLY?',.f.)
          if ( (tf=.t.) and !recused('vehicle',recno()) )
         oldrec=recno()
         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         SET ORDER TO TAG VIN
         MVIN=VEHICLE->VIN
         SET DELETED ON
         SEEK MVIN
         SET DELETED OFF
         IF FOUND()
            ?? CHR(7)
            WAIT WINDOW "DON'T delete this Vehicle,it has Premiums" NOWAIT
         ELSE
             select vehicle
             go (oldrec)
             delete
             unlock in vehicle
             * Activity posting
             MINVOICENO=0
             MACCTNO   =client->ACCTNO
             MTRANCODE =2003
             MQTY      =1
             MPRICE    =0
             MTOTAL    =0
             MDATE     =DATE()
             MCLERK    =''
             MDESCRIPT ="Vehicle Deleted"
             MPOSTED   =.f.
             MBILLED   =.f.
             MCHECKNO  =''
             DVID      =VEHICLE.VIN

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
             select vehicle
          do vehdisplay
          endif
        ENDIF
       endif
        SELECT VEHICLE
return

******************************************************************************
*                   recall vehicle
******************************************************************************
procedure mvehundelete
          rec=recno()
          recall for vin=vvid
          goto rec
          do vehdisplay
return

******************************************************************************
*                    goto first vehicle
******************************************************************************
procedure mvehfirst
          go top
          do vehdisplay
return


******************************************************************************
*                    goto last vehicle
******************************************************************************
procedure mvehlast
          go bottom
          do vehdisplay
return


******************************************************************************
*                    add vehicle
******************************************************************************
procedure mvehadd
          addedveh=addveh()
          if addedveh
             do vehdisplay
             wait window "Now Press a key to add a PREMIUM for this car"
           do mcover
             wait window "You can now go to the Policies Menu and Create a Policy" timeout 2
             wait window "So that you can print the Assigned Risc Form" timeout 2
          endif
          do vehdisplay
return

******************************************************************************
*                    quit vehicles
******************************************************************************
procedure mvehquit
		  mquit=1
*          hide menu _msysmenu
*          DEACTIVATE MENU _msysmenu
*          RELEASE MENU _msysmenu          
return



******************************************************************************
*                    Procedure display vehicle info
******************************************************************************
procedure vehdisplay


if type('VEHscits')='U'
        a=fname("VEHsc.mem")
	if file(a)
   		restore from &a additive
                restore screen from vscreen
	else
   		do vehpaint with .t.
	endif
else 
        restore screen from vscreen
endif
*do vehpaint with .f.
if !used('Vehicle')
   select b
            use VEHICLE index VEHICLE alias VEHICLE
else
   select vehicle
endif
vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
set color to rb+/b
vvid         = VIN
vowner       = VIVOWNER
vplates      = plates
vaddress     = VIvaddR
vyear        = YEAR
vmake        = MAKE
vmodel       = MODST
vcond        = CONDPUR

REMAINING=2-LEN(ALLTRIM(STR(PURMO)) )
vmonth       = SPACE(REMAINING)+ALLTRIM(STR(PURMO))

REMAINING=4-LEN(ALLTRIM(STR(PURyr)) )
vpuryear     = SPACE(REMAINING)+ALLTRIM(STR(PURYR))

vcost        = COST
vcyls        = CYLS
vhpcu        = HPCU
vincc        = INCC
vloss        = LOSSPAYEE
vlessor      = LESSOR
vlessname    = LNAME
vlestreet    = LSTREET
vlesscity    = LCITY
vlessstate   = LSTATE
vlesszip     = LZIP
vlesscomment = COMMENT
VUSE         = DUSE
vdlicno      = licno
vstatereg    = dstatereg
vgaragaddr   = dgaragaddr
vmilestow    = dmilestow
vappadress   = dappadress
vterry       = dterritor
vrate        = drateclass
vpenalty     = dpenalty
vsymbol      = dsymbol
vantitheft   = dantitheft
vamodel      = damodel
vabrand      = dabrand
vapassive    = dapassive
vaactive     = daactive

if type('vehscits')='U'
        sdesign=.f.
        a=fname("vehscre.mem")
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
     @ 2,20    get vappname picture "!"+replicate('X',40) default left(CLIENT.lastn+CLIENT.firstn,40) disabled color ,,,,,,,,w+/b,w+/b
set color to n/w
*@ 24,0 to 24,79 clear
myname='Angelos Karageorgiou'
*=center(24,'*    Copyright (c) 1994 '+myname+'    *')
SET MESSAGE TO MYNAME CENTER
namekey=hash(myname)
if namekey<>'54631178529559'
        wait window "Don't Fuck with my name"
        quit
endif
if sdesign=.f.
vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
     set color to gr+/b,w+/b
     @ 3,35    get vvid picture Replicate('X',20) valid checkvid(upper(vvid)) ERROR 'Vehicle ID # Already in Use' size 1,20 disabled color ,,,,,,,,w+/b,w+/b
     @ 3,65    get vplates picture Replicate('X',10) valid checkplate(upper(vplates)) size 1,10
     @ 4,13    get vowner picture "!"+replicate('X',40) default vappname disabled color ,,,,,,,,w+/b,w+/b
     @ 5,13    get vaddress picture replicate('X',50) disabled color ,,,,,,,,w+/b,w+/b
     @ 6,31    get vyear picture '9999' disabled color ,,,,,,,,w+/b,w+/b
     @ 6,47    get vmake picture replicate ('X' ,20) disabled color ,,,,,,,,w+/b,w+/b
     @ 7,31    get vmodel picture replicate('X',25) disabled color ,,,,,,,,w+/b,w+/b
     @ 8,31    get vcond picture '!' valid (vcond='N' or vcond='U' ) disabled color ,,,,,,,,w+/b,w+/b
     @ 9,31    get vmonth picture '99' valid (VAL(vmonth) >0 .AND. VAL(vmonth) <13) disabled color ,,,,,,,,w+/b,w+/b
     @ 9,57    get vpuryear picture '9999'valid (vpuryear>=0) disabled color ,,,,,,,,w+/b,w+/b
     @ 10,31   get vcost picture 'XXXXXXXXXX' disabled color ,,,,,,,,w+/b,w+/b
     @ 11,31   get vcyls picture '99' valid (vcyls >0) disabled color ,,,,,,,,w+/b,w+/b
     @ 12,31   get vhpcu picture 'XXXXXX' disabled color ,,,,,,,,w+/b,w+/b
     @ 12,59   get vincc picture 'XXXXXX' disabled color ,,,,,,,,w+/b,w+/b

     *set color to gr+/b,w+/b
     @ 13,15  get vdlicno PICTURE REPLICATE('X',30) disabled color ,,,,,,,,w+/b,w+/b
     @ 13,51  GET VUSE PICTURE "!" valid ( vuse="P" or vuse="W" or  vuse="F" or  vuse="B"   )  error "Valid Input is P:pleasure B:business F:farm W:work" disabled color ,,,,,,,,w+/b,w+/b
     @ 13,77  get vstatereg picture "AA" function "@!" disabled color ,,,,,,,,w+/b,w+/b
     @ 14,27  get vgaragaddr picture replicate ('X',25) disabled color ,,,,,,,,w+/b,w+/b
     @ 14,68  get vmilestow picture replicate('X',10) disabled color ,,,,,,,,w+/b,w+/b
     @ 15,30  get vappadress picture replicate ('X',35) disabled color ,,,,,,,,w+/b,w+/b
     @ 16,11  get vterry picture replicate ('X',10) disabled color ,,,,,,,,w+/b,w+/b
     @ 16,40  get vrate  picture replicate ('X',10) disabled color ,,,,,,,,w+/b,w+/b
     @ 16,69  get vpenalty  picture replicate ('X',10) disabled color ,,,,,,,,w+/b,w+/b
     @ 17,9   get vsymbol  picture replicate ('X',25) disabled color ,,,,,,,,w+/b,w+/b
     @ 17,46  get vlesscomment picture replicate ('X',45) SIZE 1,33 disabled color ,,,,,,,,w+/b,w+/b

     *set color to bgr+/b
     @ 18,13  get vloss picture '@*C' disabled color ,,,,,,,,w+/b,w+/b
     @ 18,29  get vlessor picture '@*C' disabled color ,,,,,,,,w+/b,w+/b
     @ 20,9   get vlessname picture "!"+replicate("X",35)  disabled color ,,,,,,,,w+/b,w+/b
     @ 21,9   get vlestreet picture "!"+replicate("X",25) disabled color ,,,,,,,,w+/b,w+/b
     @ 22,9   get vlesscity picture  "!"+replicate("X",25)  size 1,15  disabled color ,,,,,,,,w+/b,w+/b
     @ 22,32  get vlessstate picture "AA"                              disabled color ,,,,,,,,w+/b,w+/b
     @ 22,40  get vlesszip picture '99999-99999'                       disabled color ,,,,,,,,w+/b,w+/b

     *set color to rb+/b
     @ 18,66 get vantitheft function "*C" picture "" disabled color ,,,,,,,,w+/b,w+/b
     @ 19,54 get vamodel picture replicate("X",25) size 1,25 disabled color ,,,,,,,,w+/b,w+/b
     @ 20,54 get vabrand picture replicate("X",25) size 1,25 disabled color ,,,,,,,,w+/b,w+/b
     @ 21,54 get vaactive function "*C" disabled color ,,,,,,,,w+/b,w+/b
     @ 21,69 get vapassive function "*C" disabled color ,,,,,,,,w+/b,w+/b
else
hidden=.f.
     for i=2 to vehscits
        if vehscreen[i,8]=.t.
              if vehscreen[i,6]>0
                    @ vehSCREEN[I,1],vehSCREEN[I,2]+len(vehSCREEN[I,3])+1 GET         (vehSCREEN[I,4]);
                                                    picture     vehSCREEN[I,5] ;
                                                    size         1,vehscreen[i,6];
                                                    COLOR        gr+/b,w+/b
*         else
*                    @ vehSCREEN[I,1],vehSCREEN[I,2] SAY    vehSCREEN[I,3] ;
*                                                    COLOR  gr+/b,w+/b
         endif
        else
                if type(vehscreen[i,4])="C" .and. len(alltrim(evaluate(vehscreen[i,4])))>0
                   hidden=.t.
                endif
        endif
     endfor
    if hidden
       wait window "There is Hidden Data that you do not see!" nowait
    endif
endif
clear gets

 if deleted()
   set color to gr+/r
   =CENTER( 23,"This record has been marked for deletion")
   ?? chr(7)
   set color to gr+/b
else
   set color to gr+/b
   @23,0 to 23,79 clear
   @ 23,0 say space(80)
endif
 if vehicle.active=.f.
   set color to gr+/r
   @ 2,56  SAY "This Vehicle is INACTIVE"
   ?? chr(7)
   set color to gr+/b
endif
set color to gr+/n
*@,0 say space(80)
@ 0,0 say space(80)
=center(0,'  VEHICLE INFORMATION  ')
set reprocess to 1
if lock(alltrim(str(recno())),'vehicle')=.f.
   ?? chr(7)
   wait window 'This VEHICLE is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in vehicle
set reprocess to 1
return



******************************************************************************
*                    Procedure edit vehicle data
******************************************************************************
function vehdataedit


select client
if recused('client',recno())
   ?? chr(7)
   wait window "NO EDITING,Somebody is editing the vehicles owner!!" Nowait
   return .f.
endif

select vehicle

vlocked=.f.
if lock(alltrim(str(recno())),'vehicle')=.f.
   wait window 'This Account is edited by Another User Try Again Later'
   vlocked =.f.
   return vlocked
else
   vlocked=.t.
endif

define window wveh at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Vehicle Editing Window" font "FixedSys",9
activate window wveh

on key label f10 keyboard "{ctrl+w}"
set color to gr+/b
clear
*set color to w/b,b/w
*set color to 
*@ 0,0 to 24,79 clear
set color to gr+/n
@ 0,0 to 1,79 clear
@ 0,0 say space(80)
=CENTER(0,'EDITING VEHICLE DATA')
@ 23,0 to 23,79 color gr+/b
@ 23,0 say space(80) color gr+/b

SET COLOR TO gr+/b,w+/bg
=center(24,'Press F10 to Accept this Vehicle')
* 0,0 say '³'
* 0,79 say '³'
* 1,0 say 'À'
* 1,79 say 'Ù'
* 1,1 to 1,78


if type('vehscits')='U'
        sdesign=.f.
        a=fname("vehscre.mem")
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

     @ 2,4   say 'Applicant Name:' get vappname picture "!"+replicate('X',40) default left(CLIENT.lastn+CLIENT.firstn,40) disabled color ,,,,,,,,w+/b,w+/b
vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
if sdesign=.f.
     @ 3,4   say 'Vehicle Identification Number:' get vvid picture Replicate('X',20) valid checkvid(upper(vvid)) ERROR 'Vehicle ID # Already in Use' size 1,20
     @ 3,57  Say 'Plates:' get vplates picture Replicate('X',10)  valid checkplate(upper(vplates)) size 1,10
     @ 4,6   say 'Owner:' get vowner picture "!"+replicate('X',40) default vappname
     @ 5,4   say 'Address:' get vaddress picture replicate('X',50)
     @ 6,25 say 'Year:' get vyear picture '9999' VALID KVYEAR()
     @ 6,41 say 'Make:' get vmake picture replicate ('X' ,20)
     @ 7,4  say 'Model Name and Body Style:' get vmodel picture replicate('X',25)
     @ 8,10  say 'Purchased Condition:' get vcond picture '!' valid (vcond='N' or vcond='U' )
     @ 8,33 say '( [N]ew or [U]sed )'
     @ 9,14 say 'Purchased Month:' get vmonth picture '99' valid (VAL(vmonth) >0 .AND. VAL(vmonth) <=12)
     @ 9,41 say 'Purchased Year:' get vpuryear picture '9999' valid K2VYEAR()
     @ 10,25 say 'Cost:' get vcost picture 'XXXXXXXXXX'
     @ 11,10 say 'Number of Cylinders:' get vcyls picture '99' valid (vcyls >0)
     @ 12,23 say 'H.P\CU:' get vhpcu picture 'XXXXXX'
     @ 12,51 say 'IN.\CC:' get vincc picture 'XXXXXX'

     *set color to gr+/b
     @ 13,1 say 'Dr Lic No:' get vdlicno PICTURE REPLICATE('X',30)
     @ 13,46 SAY 'USE:'  GET VUSE PICTURE "!" valid ( vuse="P" or vuse="W" or  vuse="F" or  vuse="B"   )  error "Valid Input is P:pleasure B:business F:farm W:work"
     @ 13,56 say "State Registered in:" get vstatereg picture "AA" function "@!"
     @ 14,1 say "Principal Garage Address:" get vgaragaddr picture replicate ('X',25)
     @ 14,54  say "Miles to Work:" get vmilestow picture replicate('X',10)
     @ 15,1 say "Principal Applicant Address:" get vappadress picture replicate ('X',35)
     @ 16,1  Say "Territory:" get vterry picture replicate ('X',10)
     @ 16,28  say "Rate Class:" get vrate  picture replicate ('X',10)
     @ 16,53  say "Penalty Points:" get vpenalty  picture replicate ('X',10)
     @ 17,1  say "Symbol:" get vsymbol  picture replicate ('X',25)
     @ 17,37 SAY 'COMMENT:' get vlesscomment picture replicate ('X',45) SIZE 1,33

     *set color to bgr+/b
     @ 18,1 say 'Loss Payee:' get vloss picture '@*C' valid vlupdate(vloss)
     @ 18,18 say 'or'
     @ 18,21 say 'Lessor:' get vlessor picture '@*C'
     @ 19,1 say 'If Loss Payee or Lessor please complete'
     @ 20,3 say 'Name:'   get vlessname picture "!"+replicate("X",35)
     @ 21,1 say 'Street:' get vlestreet picture "!"+replicate("X",25)
     @ 22,3 say 'City:'   get vlesscity picture  "!"+replicate("X",25)  size 1,15
     @ 22,25 say 'State:'  get vlessstate picture "AA"
     @ 22,35 say 'ZIP:'    get vlesszip picture '99999-99999'
     *@ 18,46  to 21,46 double

     *set color to rb+/b
     @ 18,47 say "AntiTheft Equipped" get vantitheft function "*C" picture ""
     @ 19,47 Say "Model:" get vamodel picture replicate("X",25) size 1,25
     @ 20,47 Say "Brand:" get vabrand picture replicate("X",25) size 1,25
     @ 21,47 say "Active:" get vaactive function "*C"
     @ 21,60 say "Passive:" get vapassive function "*C"

else
    vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
    for i=2 to vehscits
    if VEHSCREEN[i,9]=.t. && real data
                if VEHSCREEN[i,6]>0   && we got size
                   if VEHSCREEN[i,8]=.t.   && disabled
                           @ VEHSCREEN[I,1],VEHSCREEN[I,2] SAY         VEHSCREEN[I,3] ;
                                                           GET         (VEHSCREEN[I,4]);
                                                           picture     VEHSCREEN[I,5] ;
                                                           size         1,VEHSCREEN[i,6];
                                                           COLOR        gr+/b,w/bg+
                   endif
                else
                   if VEHSCREEN[i,8]=.t.   && disabled
                           @ VEHSCREEN[I,1],VEHSCREEN[I,2] SAY         VEHSCREEN[I,3] ;
                                                           GET         (VEHSCREEN[I,4]);
                                                           picture     VEHSCREEN[I,5];
                                                           COLOR       gr+/b,w/bg+
                   endif
                endif
    else    && just data displayed
               if VEHSCREEN[i,6]>0     && we got size
                  if VEHSCREEN[i,8]=.t.   && disabled
                          @ VEHSCREEN[I,1],VEHSCREEN[I,2] SAY         VEHSCREEN[I,3]
                  endif
               else
                  if VEHSCREEN[i,8]=.t.   && disabled
                          @ VEHSCREEN[I,1],VEHSCREEN[I,2] SAY         VEHSCREEN[I,3]
                  endif
               endif
       endif
    endfor
endif

read cycle

vstatereg =upper(vstatereg)
vgaragaddr =upper(vgaragaddr)
vmilestow =alltrim(upper(vmilestow))
vcost=alltrim(upper(vcost))
vplates=alltrim(upper(vplates))
vappadress =upper(vappadress)
vterry =upper(vterry)
vrate =upper(vrate)
vpenalty =upper(vpenalty)
vsymbol =upper(vsymbol)
VLESSSTATE=UPPER(VLESSSTATE)
set color to gr+/b
@ 23,0 say space(80)
@ 24,0 say space(80)
on key label f10
deactivate window wveh
release window wveh
return vlocked


******************************************************************************
*                    Procedure Putvehdata
******************************************************************************
Procedure Putvehdata
private testlen,testzip,testdate,testss

*if !used('vehicle')
*   select b
*            use VEHICLE index VEHICLE alias VEHICLE
*else
*   select vehicle
*endif
   testzip = alltrim(vlesszip)
   testlen = len(testzip)
   if right(testzip,1)='-'
       vlesszip=left( testzip,(testlen-1) )
   else
       vlesszip=testzip
   endif

replace acctno      with    CLIENT.acctno,;
       VIN         with    alltrim(upper(vvid)),;
       VIVOWNER    with    alltrim(upper(vowner)),;
       plates      with    alltrim(upper(vplates)),;
       VIVADDR     with    alltrim(upper(vaddress)),;
       YEAR        with    vyear,;
       MAKE        with    alltrim(upper(vmake)),;
       MODST       with    alltrim(upper(vmodel)),;
       CONDPUR     with    vcond,;
       PURMO       with    VAL(vmonth),;
       PURYR       with    VAL(vpuryear),;
       COST        with    vcost,;
       CYLS        with    vcyls,;
       HPCU        with    alltrim(upper(vhpcu)),;
       INCC        with    alltrim(upper(vincc)),;
       LOSSPAYEE   with    vloss,;
       LESSOR      with    vlessor,;
       LNAME       with    alltrim(upper(vlessname)),;
       LSTREET     with    alltrim(upper(vlestreet)),;
       LCITY       with    alltrim(upper(vlesscity)),;
       LSTATE      with    alltrim(upper(vlessstate)),;
       LZIP        with    vlesszip,;
       COMMENT     with    alltrim(upper(vlesscomment)),;
       DUSE        WITH    UPPER(ALLTRIM(VUSE)),;
       licno       WITH    UPPER(ALLTRIM(Vdlicno)),;
       dstatereg   with vstatereg,;
       dgaragaddr  with vgaragaddr,;
       dmilestow   WITH vmilestow,;
       dappadress  WITH vappadress,;
       dterritor   with vterry,;
       drateclass  with vrate,;
       dpenalty    WITH vpenalty,;
       dsymbol     WITH vsymbol,;
       dantitheft  WITH vantitheft,;
       damodel     with upper(alltrim(vamodel)),;
       dabrand     with upper(alltrim(vabrand)),;
       dapassive   WITH vapassive,;
       daactive    WITH vaactive
* Activity posting
MINVOICENO=0
MACCTNO   =client->ACCTNO
MTRANCODE =2002
MQTY      =1
MPRICE    =0
MTOTAL    =0
MDATE     =DATE()
MCLERK    =''
MDESCRIPT ="Vehicle Data Edited"
MPOSTED   =.f.
MBILLED   =.f.
MCHECKNO  =''
             DVID      =VEHICLE.VIN

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )

select vehicle
return

******************************************************************************
*                    function checkfordoubleid
******************************************************************************
function checkvid
parameter vid
private tf,id,rec

olorder=order('vehicle')
id=alltrim(vid)
tf=.f.
select vehicle
rec=recno()
*wait window str(rec)
set filter to
go top
set exact on
set order to tag vin
seek id
if ( found() and (rec # recno()) )
   tf=.f.
   wait window "VIN already in use" timeout 1
else
   tf=.t.
endif
set filter to acctno=macctno
go (rec)
set exact off
set order to tag (olorder)

*if tf=.t.
*         IF !USED('coverage')
*            select c
*            use coverage index coverage alias coverage
*         else
*           select coverage
*         endif
*         SET ORDER TO TAG VIN
*         SET DELETED ON
*         SEEK VID
*         SET DELETED OFF
*         IF FOUND()
*         	tf=.f.
*         	?? chr (7)
*         	wait window "You cannot change this VIN "+chr(13)+"There are active COVERAGES Under it"
*         ELSE             
*         	tf=.t.
*         endif
*        SELECT VEHICLE
*endif        

*return tf
return .t.

******************************************************************************
*                    function checkfordoubleplates
******************************************************************************
function checkplate
parameter newplate
private tf,id,rec

if len(alltrim(newplate))<1
   return .t.
endif
tf=.f.
olorder=order('vehicle')
select vehicle
rec=recno()
set filter to
go top
set exact on
set order to tag plates
seek alltrim(newplate)
set exact off
if ( found() and (rec # recno()) )
   tf=.f.
else
   tf=.t.
endif
set filter to acctno=macctno
go (rec)
if tf=.f.
   ?? chr(7)
   wait window "Plates are already in USE or EMPTY" nowait
endif
set order to tag (olorder)
return .t.


******************************************************************************
*                    PAINT VEHICLE SCREEN
******************************************************************************
PROCEDURE vEHPAINT
parameter first

fn=fname("vehscre.mem")
if !file(fn)
     set color to gr+/b
     @ 2,0 to 24,79 clear
     @ 23,0 to 24,79 clear
     @ 2,4   say 'Applicant Name:'
     @ 3,4   say 'Vehicle Identification Number:'
     @ 3,57  Say 'Plates:'
     @ 4,6   say 'Owner:'
     @ 5,4   say 'Address:'
     @ 6,25 say  'Year:'
     @ 6,41 say  'Make:'
     @ 7,4  say  'Model Name and Body Style:'
     @ 8,10  say 'Purchased Condition:'
     @ 8,33 say  '( [N]ew or [U]sed )'
     @ 9,14 say  'Purchased Month:'
     @ 9,41 say  'Purchased Year:'
     @ 10,25 say 'Cost:'
     @ 11,10 say 'Number of Cylinders:'
     @ 12,23 say 'H.P\CU:'
     @ 12,51 say 'IN.\CC:'

     *set color to gr+/b
     @ 13,1 say 'Dr Lic No:'
     @ 13,46 SAY 'USE:'
     @ 13,56 say "State Registered in:"
     @ 14,1 say "Principal Garage Address:"
     @ 14,54  say "Miles to Work:"
     @ 15,1 say "Principal Applicant Address:"
     @ 16,1  Say "Territory:"
     @ 16,28  say "Rate Class:"
     @ 16,53  say "Penalty Points:"
     @ 17,1  say "Symbol:"
     @ 17,37 SAY 'COMMENT:'

     *set color to bgr+/b
     @ 18,1 say 'Loss Payee:'
     @ 18,18 say 'or'
     @ 18,21 say 'Lessor:'
     @ 19,1 say 'If Loss Payee or Lessor please complete'
     @ 20,3 say 'Name:'
     @ 21,1 say 'Street:'
     @ 22,3 say 'City:'
     @ 22,25 say 'State:'
     @ 22,35 say 'ZIP:'
     *@ 18,46  to 21,46 double

     *set color to rb+/b
     @ 18,47 say "AntiTheft Equipped"
     @ 19,47 Say "Model:"
     @ 20,47 Say "Brand:"
     @ 21,47 say "Active:"
     @ 21,60 say "Passive:"
else
    restore from &fn additive
vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
    for i=1 to vehscits
                  if vehscreen[i,8]=.t.
                          @ vehsCREEN[I,1],vehSCREEN[I,2] SAY  vehSCREEN[I,3] ;
                                                         COLOR gr+/b,w+/b
                  endif
                  clear gets
    endfor
endif
set color to gr+/n
@0,0 say space (80)
=center(0,'  VEHICLE INFORMATION  ')


if first
  SAVE SCREEN TO vscreen
  A=FNAME("VEHSC.MEM")
  SAVE ALL LIKE vscreen TO &A
  set color to gr+/b
else
*  set color to n/w
*  @1,0 to 1,79 clear
  SAVE SCREEN TO vscreen
  A=FNAME("VEHSC.MEM")
  SAVE ALL LIKE vscreen TO &A
  set color to gr+/b
endif
return



******************************************************************************
*                   call coverages
******************************************************************************
procedure mcover
          pop=popup()
          if left(pop,8)="VEHPOPTI"
             hide popup vehpoptions
          endif
           set filter to
           set reprocess to 1
               save scree to vehs
           if lock(alltrim(str(recno())),'vehicle')=.f.
              ?? chr(7)
              wait window 'This VEHICLE is edited by Another User' timeout 1
              ?? chr(7)
              wait window 'Please Try Again Later' timeout 1
           else
               do covmenu with vehicle.vin,CLIENT.ACCTNO
               select vehicle
               set filter to acctno=client->acctno
           endif
           unlock in vehicle
           unlock in coverage
           set reprocess to 1
           restore screen from vehs

          pop=popup()
          if left(pop,8)="VEHPOPTI"
             show popup vehpoptions
          endif
          men=menu()
          if left(men,8)="VEHICLEM"
             show menu _msysmenu
          endif
          do vehpaint with .t.
          do vehdisplay
return


******************************************************************************
*                   call vehicle edit screen
******************************************************************************
procedure mvehed
          save screen to ed
          hide popup vehpoptions
*          hide menu _msysmenu
          tf=vehedit()
              release vehscreen
              release vehscits
              release vscreen
              set color to gr+/b
              @ 2,0 to 24,79 clear
              do vehpaint with .f.
              do vehdisplay
          show popup vehpoptions
          show menu _msysmenu
return



function kvyear
          temp=1900+val(vyear)
          IF VAL(VYEAR)<1900
             vyear=alltrim(str(temp))
          ENDIF
          show gets
return .t.

function k2vyear
          Temp=1900+VAL(VPURyear)
          IF VAL(VPURYEAR)<1900
             vpuryear=ALLTRIM(STR(temp))
          ENDIF
          show gets
return .t.



procedure endisable
mactive=vehicle.active
if recused('vehicle',recno())
   ?? chr(7)
   wait window "NO CHANGING,Somebody is editing the vehicle!!" Nowait
   return .f.
endif
if mactive=.t.
   tf=acertain("DEACTIVATE this Vehicle",.F.)
   if tf
      replace vehicle.active with .f.
   endif
else
   tf=acertain("ACTIVATE this Vehicle",.F.)
   if tf
      replace vehicle.active with .t.
   endif
endif
unlock in vehicle
do vehdisplay
return

