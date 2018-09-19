set procedure to 'various'
set exclusive off
declare vehscreen[41 , 11 ]
vehscits=0
release vehscits
if menu()=upper("vehiclemen")
   hide menu vehiclemenu
endif
if menu()=upper("mainmenu")
   hide menu mainmenu
endif
private what
clear read
clear gets
if !used('Vehicle')
   select b
            use VEHICLE index VEHICLE alias VEHICLE
else
   select vehicle
endif
on key label f10 keyboard "{CTRL+W}"

vappname=ALLTRIM(CLIENT.SALUT)+' '+Alltrim(CLIENT.firstn)+' '+alltrim(CLIENT.lastn)

vvid=space(20)
vowner=vappname
vaddress=space(50)
*temp=left(alltrim(CLIENT.add)+' '+alltrim(CLIENT.city)+' '+alltrim(CLIENT.state)+' '+alltrim(CLIENT.zip),50)
temp=left(alltrim(CLIENT.APPadRESS)+' '+ALLTRIM(CLIENT.APPAPTNO)+','+alltrim(CLIENT.APPcity)+','+alltrim(CLIENT.APPstate)+' '+alltrim(CLIENT.APPzip),50)
vaddress=stuff(vaddress,1,len(temp),temp)
vyear='    '
vmake=space(20)
vplates=space(10)
vmodel='4DSD'+space(21)
vcond='N'
vmonth='01'
vpuryear='    '
vcost='N/A'+space(7)
vcyls=6
vhpcu='N/A   '
vincc='N/A   '
vloss=.f.
vlessor=.f.
vlessname=space(35)
vlestreet=space(25)
vlesscity=space(25)
vlessstate='  '
vlesszip='     -     '
vlesscomment=space(45)
vdlicno=space(30)
temp=alltrim( upper(CLIENT.dr_lic_no ) )
vdlicno=stuff(vdlicno,1,len(temp),temp)
VUSE='P'+space(29)
vstatereg='NY'
*temp=left(alltrim(CLIENT.add)+' '+alltrim(CLIENT.city)+' '+alltrim(CLIENT.state)+' '+alltrim(CLIENT.zip),50)
temp=left(alltrim(CLIENT.APPadRESS)+' '+ALLTRIM(CLIENT.APPAPTNO)+' '+alltrim(CLIENT.APPcity)+' '+alltrim(CLIENT.APPstate)+' '+alltrim(CLIENT.APPzip),50)
vgaragaddr=space(25)
*vgaragaddr=stuff(vgaragaddr,1,len(temp),temp)
vgaragaddr='S/A                               '
vmilestow=space(10)
vappadress=space(35)
*vappadress=stuff(vappadress,1,len(temp),temp)
VAPPADRESS='S/A                               '
vterry=space(10)
vrate=space(10)
vpenalty=space(10)
vsymbol=space(25)
vantitheft=.f.
vamodel=space(25)
vabrand=space(25)
vapassive=.f.
vaactive=.F.
POLACTIVE=.T.



*save screen to addvehsc
define window wveh at 1,1 size 25,80 in desktop system shadow nogrow noclose title "Vehicle Adding Window" font "FixedSys",9
activate window wveh

what=addvehicle()
deactivate window wveh
release window wveh
*wait window "Now Press a Key to add a PREMIUM for this car"
*do mcover
*restore screen from addvehsc
*release addvehsc
return what


******************************************************************************
*                    Procedure add vehicle
******************************************************************************
function addvehicle
private tf,double

double=.t.
vvid=space(20)
set color to w/b
clear
set color to w/n
*@ 0,0 to 0,79 fill color w/n
@ 0,0 say space(80)
@ 23,0 to 23,79 color gr+/b
set color to gr+/n
=CENTER(0,'ADD  NEW  VEHICLE ')
set color to gr+/b,w/bg+

do while double=.t.
set color to gr+/b
=center(24,'Press <F10> to Accept this Vehicle,or <ESC> to exit')
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
set color to gr+/b,w/bg+

@ 2,4   say 'Applicant Name:' get vappname picture "!"+replicate('X',39) default left(CLIENT.lastn+CLIENT.firstn,40) disabled color ,,,,,,,,w+/b,w+/b
if sdesign=.f.
   vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
     @ 3,4   say 'Vehicle Identification Number:' get vvid picture Replicate('X',20) valid cid(upper(vvid)) ERROR 'Vehicle ID # Already in Use' size 1,20
     @ 3,57  Say 'Plates:' get vplates picture Replicate('X',10) valid checkplate(upper(vplates)) size 1,10
     @ 4,6   say 'Owner:' get vowner picture "!"+replicate('X',39) default vappname
     @ 5,4   say 'Address:' get vaddress picture replicate('X',50)
     @ 6,25  say 'Year:' get vyear picture '9999' valid kvyear()
     @ 6,41  say 'Make:' get vmake picture replicate ('X' ,20)
     @ 7,4   say 'Model Name and Body Style:' get vmodel picture replicate('X',25)
     @ 8,10  say 'Purchased Condition:' get vcond picture '!' valid (vcond='N' or vcond='U' )
     @ 8,33  say '( [N]ew or [U]sed )'
     @ 9,14  say 'Purchased Month:' get vmonth picture '99' valid (VAL(vmonth) >0 .AND. VAL(vmonth) <13)
     @ 9,41  say 'Purchased Year:' get vpuryear picture '9999' valid k2vyear()
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
     @ 18,1 say 'Loss Payee:' get vloss picture '@*C' when vlessor=.f. valid vlupdate(vloss)
     @ 18,18 say 'or'
     @ 18,21 say 'Lessor:' get vlessor picture '@*C' when vloss=.f.
     @ 19,1 say 'If Loss Payee or Lessor please complete'
     @ 20,3 say 'Name:'   get vlessname picture "!"+replicate("X",34)   when   ( (vlessor=.t.) .or. (vloss=.t.) )
     @ 21,1 say 'Street:' get vlestreet picture "!"+replicate("X",24) when   ( (vlessor=.t.) or (vloss=.t.) )
     @ 22,3 say 'City:'   get vlesscity picture  "!"+replicate("X",24)  size 1,15  when   ( (vlessor=.t.) or (vloss=.t.) )
     @ 22,25 say 'State:'  get vlessstate picture "AA"                             when   ( (vlessor=.t.) or (vloss=.t.) )
     @ 22,35 say 'ZIP:'    get vlesszip picture '99999-99999'                      when   ( (vlessor=.t.) or (vloss=.t.) )
     *@ 18,46  to 21,46 double

     *set color to rb+/b
     @ 18,47 say "AntiTheft Equipped" get vantitheft function "*C" picture ""
     @ 19,47 Say "Model:" get vamodel picture replicate("X",25) size 1,25 when vantitheft=.t.
     @ 20,47 Say "brand:" get vabrand picture replicate("X",25) size 1,25 when vantitheft=.t.
     @ 21,47 say "Active:" get vaactive function "*C" when ( (vantitheft=.t.) and (vapassive=.f.) )
     @ 21,60 say "Passive:" get vapassive function "*C" when ( (vantitheft=.t.) and (vaactive=.f.) )

else
    vappname=left(alltrim(CLIENT.lastn)+' '+alltrim(CLIENT.firstn),40)
    for i=2 to vehscits
    if vehscreen[i,8]=.t.
     if len(alltrim(vehscreen[i,10]))=0
         if vehscreen[i,9]=.t. && real data
                     if vehscreen[i,6]>0   && we got size
                                @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3] ;
                                                                GET         (vehscreen[I,4]);
                                                                picture     vehscreen[I,5] ;
                                                                size         1,vehscreen[i,6];
                                                                COLOR        gr+/b,w/bg+
                     else
                                @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3] ;
                                                                GET         (vehscreen[I,4]);
                                                                picture     vehscreen[I,5];
                                                                COLOR       gr+/b,w/bg+
                     endif
         else    && just data displayed
                    if vehscreen[i,6]>0     && we got size
                               @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3]+' '+(vehscreen[I,4]);
                                                               picture     vehscreen[I,5] ;
                                                               size        1,vehscreen[i,6]
                    else
                               @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3]+' '+(vehscreen[I,4]);
                                                               picture     vehscreen[I,5]
                    endif
         endif
     else
         if vehscreen[i,9]=.t. && real data
                     if vehscreen[i,6]>0   && we got size
                                @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3] ;
                                                                GET         (vehscreen[I,4]);
                                                                picture     vehscreen[I,5] ;
                                                                size        1,vehscreen[i,6];
                                                                valid       &vehscreen[i,10];
                                                                COLOR       gr+/b,w/bg+
                     else
                                @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3] ;
                                                                GET         (vehscreen[I,4]);
                                                                picture     vehscreen[I,5];
                                                                valid       &vehscreen[i,10];
                                                                COLOR       gr+/b,w/bg+
                     endif
         else    && just data displayed
                    if vehscreen[i,6]>0     && we got size
                               @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3]+' '+evaluate(&vehscreen[I,4]);
                                                               picture     vehscreen[I,5] ;
                                                               size        1,vehscreen[i,6]
                    else
                               @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3]+' '+evaluate(&vehscreen[I,4]);
                                                               picture     vehscreen[I,5]
                    endif
         endif
     endif
    else
           if vehscreen[i,8]=.t.   && not disabled
                   @ vehscreen[I,1],vehscreen[I,2] SAY         vehscreen[I,3] ;
                                                   color       gr+/b,w+/b
           endif
     endif
     endfor
endif
     read cycle

VLESSSTATE=UPPER(VLESSSTATE)
vstatereg =upper(vstatereg)
vplates=upper(vplates)
vgaragaddr =upper(vgaragaddr)
vmilestow =alltrim(upper(vmilestow))
vcost=alltrim(upper(vcost))
vappadress =upper(vappadress)
vterry =upper(vterry)
vrate =upper(vrate)
vpenalty =upper(vpenalty)
vsymbol =upper(vsymbol)

if lastkey()=27
        return .f.
endif


       tf=acertain('Proceed with ADDING this vehicle?',.t.)
       if tf=.f.
          return .f.
       else
           append blank
           do putvehdata
           double =.f.
       endif
enddo
return .t.


******************************************************************************
*                    Procedure Putvehdata
******************************************************************************
Procedure Putvehdata
private testlen,testzip,testdate,testss
if !used('vehicle')
   select b
            use VEHICLE index VEHICLE alias VEHICLE
else
   select vehicle
endif
   testzip = alltrim(vlesszip)
   testlen = len(testzip)
   if right(testzip,1)='-'
       vlesszip=left( testzip,(testlen-1) )
   else
       vlesszip=testzip
   endif

id=getveHid()
select vehicle
replace dvehid with id,;
    acctno      with    CLIENT.acctno,;
    VIN         with    alltrim(upper(vvid)),;
    VIVOWNER    with    alltrim(upper(vowner)),;
    plates      with    alltrim(upper(vplates)),;
    VIVADDR     with    alltrim(upper(vaddress)),;
    YEAR        with    vyear,;
    MAKE        with    alltrim(upper(vmake)),;
    MODST       with    alltrim(upper(vmodel)),;
    CONDPUR     with    vcond,;
    PURMO       with    VAL(vmonth),;
    PURYR       with    val(vpuryear),;
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
    daactive    WITH vaactive,;
    ACTIVE      WITH POLACTIVE

* Activity posting
MINVOICENO=0
MACCTNO   =client->ACCTNO
MTRANCODE =2001
MQTY      =1
MPRICE    =0
MTOTAL    =0
MDATE     =DATE()
MCLERK    =''
MDESCRIPT ="New Vehicle Added"
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
function cid
parameter vid
private tf,id,rec

vid=alltrim(vid)
if (len(vid)<=0)
        ?? chr(7)
        wait window "Watch it , VIN is EMPTY" timeout 1
        return .t.
endif

rec=recno()
olorder=order('vehicle')
set filter to acctno=macctno
count to many
id=alltrim(vid)
tf=.f.
select vehicle
set filter to
go top
set exact on
set order to tag vin
seek id
set exact off
if ( found() )
   tf=.f.
   wait window "VIN already in use" timeout 1
else
   tf=.t.
endif
if many > 0
   go (rec)
endif
set filter to acctno=macctno
set order to tag (olorder)
*return tf
return .t.


******************************************************************************
*                    function checkfordoubleplates
******************************************************************************
function checkplate
parameter newplate
private tf,id,rec


rec=recno()
olorder=order('vehicle')
newplate=alltrim(upper(newplate))
set filter to acctno=macctno
count to many
tf=.f.
select vehicle
set filter to
go top
set exact on
set order to tag plates
seek newplate
set exact off
if ( found() )
   tf=.f.
else
   tf=.t.
endif
if many > 0
   go (rec)
endif
set filter to acctno=macctno
if tf=.f.
   ?? chr(7)
   wait window "Plates already in USE or EMPTY" nowait
endif
set order to tag (olorder)
return .t.



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
