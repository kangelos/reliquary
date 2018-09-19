

declare vehscreen[41 , 11 ]
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
=center(0,"Vehicle Screen Designer")
set color to gr+/b

index=2
oldindex=2

vappname=replicate('X', 40)
vvid=replicate('X',20)
vowner=vappname
vaddress=replicate('X',50)
vyear='9999'
vplates=replicate('X',10)
vmake=replicate('X',20)
vmodel=replicate('X',25)
vcond='N'
vmonth=0
vpuryear=0
vcost=replicate('X',10)
vcyls=0
vhpcu=replicate('X',6)
vincc=replicate('X',6)
vloss=.f.
vlessor=.f.
vlessname=replicate('X',35)
vlestreet=replicate('X',25)
vlesscity=replicate('X',25)
vlessstate='  '
vlesszip='99999-9999'
vlesscomment=replicate('X',45)
vUSE=replicate('X',30)
vdlicno=replicate('X',30)
vstatereg=replicate('X',2)
vgaragaddr=replicate('X',25)
vgaragaddr=replicate('X',25)
vmilestow=replicate('X',10)
vappadress=replicate('X',35)
vappadress=replicate('X',35)
vterry=replicate('X',10)
vrate=replicate('X',10)
vpenalty=replicate('X',10)
vsymbol=replicate('X',25)
vantitheft   = .f.
vamodel      = replicate('X',25)
vabrand      = replicate('X',25)
vapassive    = .f.
vaactive     = .f.

vehscits=41
fn=fname("vehscre.mem")
if !file(fn)
   
   do initveh
else
    restore from &fn additive
endif

do showveh

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

index=2
oldindex=2
do showvel
do moveveh
release vehscits
release vescreen
vehscits=0
return saved






***************************************************************************
*                   Initialize vehicle screen
***************************************************************************
procedure initveh
for i=1 to vehscits
    vehscreen[i , 1]=0
    vehscreen[i , 2]=0
    vehscreen[i , 3]=" "
    vehscreen[i , 4]=" "
    vehscreen[i , 5]=" "
    vehscreen[i , 6]=0
    vehscreen[i , 7]=" "
    vehscreen[i , 8]=.t.
    vehscreen[i , 9]=.t.
    vehscreen[i, 10]=' '
    vehscreen[i, 11]=' '
endfor

*@ 2 ,  4   say 'Applicant Name:' get vappname picture "!"+replicate('X' , 40) default left(a.lastn+a.firstn , 40) disabled color  ,  ,  ,  ,  ,  ,  ,  , rb+/b , rb+/b
vehscreen[01 , 01]=2
vehscreen[01 , 02]=4
vehscreen[01 , 03]='Applicant Name:'
vehscreen[01 , 04]='vappname'
vehscreen[01 , 05]="!"+replicate('X' , 40)
vehscreen[01 , 06]=40
vehscreen[01 , 07]=',  ,  ,  ,  ,  ,  ,  , rb+/b , rb+/b'
vehscreen[01 , 08]=.t.
vehscreen[01 , 09]=.f.
vehscreen[01, 10]=' '
vehscreen[01, 11]=' '
*@ 3 ,  4   say 'Vehicle Identification Number:' get vvid picture Replicate('X' , 20) valid checkvid(upper(vvid)) ERROR 'Vehicle ID # Already in Use' size 1 , 20
vehscreen[02 , 01]=3
vehscreen[02 , 02]=4
vehscreen[02 , 03]='Vehicle Identification Number:'
vehscreen[02 , 04]='vvid'
vehscreen[02 , 05]=Replicate('X' , 20)
vehscreen[02 , 06]=20
vehscreen[02 , 07]='bg+/b'
vehscreen[02 , 08]=.t.
vehscreen[02 , 09]=.t.
vehscreen[02, 10]='checkvid(upper(vvid))'
vehscreen[02, 11]='Vehicle ID # Already in Use'

*@ 3,57  Say 'Plates:' get vplates picture Replicate('X',10)  valid checkplate(upper(vplates)) size 1,10
vehscreen[03 , 01]=3
vehscreen[03 , 02]=57
vehscreen[03 , 03]='Plates:'
vehscreen[03 , 04]='vplates'
vehscreen[03 , 05]=Replicate('X' , 10)
vehscreen[03 , 06]=10
vehscreen[03 , 07]='bg+/b'
vehscreen[03 , 08]=.t.
vehscreen[03 , 09]=.t.
vehscreen[03,  10]='checkplate(upper(vplates))'
vehscreen[03,  11]=' '

*@ 4 ,  6   say 'Owner:' get vowner picture "!"+replicate('X' , 40) default vappname
vehscreen[04 , 01]=4
vehscreen[04 , 02]=6
vehscreen[04 , 03]='Owner:'
vehscreen[04 , 04]='vowner'
vehscreen[04 , 05]="!"+replicate('X' , 40)
vehscreen[04 , 06]=40
vehscreen[04 , 07]='bg+/b'
vehscreen[04 , 08]=.t.
vehscreen[04 , 09]=.t.
vehscreen[04,  10]=' '
vehscreen[04,  11]=' '
*@ 5 ,  4   say 'Address:' get vaddress picture replicate('X' , 50)
vehscreen[05 , 01]=5
vehscreen[05 , 02]=4
vehscreen[05 , 03]='Address:'
vehscreen[05 , 04]='vaddress'
vehscreen[05 , 05]=replicate('X' , 50)
vehscreen[05 , 06]=50
vehscreen[05 , 07]='bg+/b'
vehscreen[05 , 08]=.t.
vehscreen[05 , 09]=.t.
vehscreen[05, 10]=' '
vehscreen[05, 11]=' '
*@ 6 , 25 say 'Year:' get vyear picture '9999'
vehscreen[06 , 01]=6
vehscreen[06 , 02]=25
vehscreen[06 , 03]='Year:'
vehscreen[06 , 04]='vyear'
vehscreen[06 , 05]='9999'
vehscreen[06 , 06]=4
vehscreen[06 , 07]='bg+/b'
vehscreen[06 , 08]=.t.
vehscreen[06 , 09]=.t.
vehscreen[06, 10]=' '
vehscreen[06, 11]=' '
*@ 6 , 41 say 'Make:' get vmake picture replicate ('X'  , 20)
vehscreen[07 , 01]=6
vehscreen[07 , 02]=41
vehscreen[07 , 03]='Make:'
vehscreen[07 , 04]='vmake'
vehscreen[07 , 05]=replicate ('X'  , 20)
vehscreen[07 , 06]=20
vehscreen[07 , 07]='bg+/b'
vehscreen[07 , 08]=.t.
vehscreen[07 , 09]=.t.
vehscreen[07, 10]=' '
vehscreen[07, 11]=' '
*@ 7 ,  4  say 'Model Name and Body Style:' get vmodel picture replicate('X' , 25)
vehscreen[08 , 01]=7
vehscreen[08 , 02]=4
vehscreen[08 , 03]='Model Name and Body Style:'
vehscreen[08 , 04]='vmodel'
vehscreen[08 , 05]=replicate('X' , 25)
vehscreen[08 , 06]=25
vehscreen[08 , 07]='bg+/b'
vehscreen[08 , 08]=.t.
vehscreen[08 , 09]=.t.
vehscreen[08, 10]=' '
vehscreen[08, 11]=' '
*@ 8 , 10  say 'Purchased Condition:' get vcond picture '!' valid (vcond='N' or vcond='U' )
vehscreen[09 , 01]=8
vehscreen[09 , 02]=10
vehscreen[09 , 03]='Purchased Condition:'
vehscreen[09 , 04]='vcond'
vehscreen[09 , 05]=' '
vehscreen[09 , 06]=1
vehscreen[09 , 07]='bg+/b'
vehscreen[09 , 08]=.t.
vehscreen[09 , 09]=.t.
vehscreen[09, 10]="((vcond='N') or (vcond='U'))"
vehscreen[09, 11]=' '
*@ 8 , 33 say '( [N]ew or [U]sed )'
vehscreen[10 , 01]=8
vehscreen[10 , 02]=33
vehscreen[10 , 03]='( [N]ew or [U]sed )'
vehscreen[10 , 04]=' '
vehscreen[10 , 05]=' '
vehscreen[10 , 06]=0
vehscreen[10 , 07]='bg+/b'
vehscreen[10 , 08]=.t.
vehscreen[10 , 09]=.f.
vehscreen[10, 10]=' '
vehscreen[10, 11]=' '
*@ 9 , 14 say 'Purchased Month:' get vmonth picture '99' valid (vmonth >0 or vmonth <13)
vehscreen[11 , 01]=9
vehscreen[11 , 02]=14
vehscreen[11 , 03]='Purchased Month:'
vehscreen[11 , 04]='vmonth'
vehscreen[11 , 05]='99'
vehscreen[11 , 06]=2
vehscreen[11 , 07]='bg+/b'
vehscreen[11 , 08]=.t.
vehscreen[11 , 09]=.t.
vehscreen[11, 10]='( (vmonth >0) or (vmonth <13)) '
vehscreen[11, 11]=' '
*@ 9 , 41 say 'Purchased Year:' get vpuryear picture '9999' valid (vpuryear >=0)
vehscreen[12 , 01]=9
vehscreen[12 , 02]=41
vehscreen[12 , 03]='Purchased Year:'
vehscreen[12 , 04]='vpuryear'
vehscreen[12 , 05]='9999'
vehscreen[12 , 06]=4
vehscreen[12 , 07]='bg+/b'
vehscreen[12 , 08]=.t.
vehscreen[12 , 09]=.t.
vehscreen[12, 10]='(vpuryear >=0) '
vehscreen[12, 11]=' '
*@ 10 , 25 say 'Cost:' get vcost picture 'XXXXXXXXXX'
vehscreen[13 , 01]=10
vehscreen[13 , 02]=25
vehscreen[13 , 03]='Cost:'
vehscreen[13 , 04]='vcost'
vehscreen[13 , 05]='XXXXXXXXXX'
vehscreen[13 , 06]=10
vehscreen[13 , 07]='bg+/b'
vehscreen[13 , 08]=.t.
vehscreen[13 , 09]=.t.
vehscreen[13, 10]=' '
vehscreen[13, 11]=' '
*@ 11 , 10 say 'Number of Cylinders:' get vcyls picture '99' valid (vcyls >0)
vehscreen[14 , 01]=11
vehscreen[14 , 02]=10
vehscreen[14 , 03]='Number of Cylinders:'
vehscreen[14 , 04]='vcyls'
vehscreen[14 , 05]='99'
vehscreen[14 , 06]=2
vehscreen[14 , 07]='bg+/b'
vehscreen[14 , 08]=.t.
vehscreen[14 , 09]=.t.
vehscreen[14, 10]='(vcyls >0) '
vehscreen[14, 11]=' '
*@ 12 , 23 say 'H.P\CU:' get vhpcu picture 'XXXXXX'
vehscreen[15 , 01]=12
vehscreen[15 , 02]=23
vehscreen[15 , 03]='H.P\CU:'
vehscreen[15 , 04]='vhpcu'
vehscreen[15 , 05]='XXXXXX'
vehscreen[15 , 06]=6
vehscreen[15 , 07]='bg+/b'
vehscreen[15 , 08]=.t.
vehscreen[15 , 09]=.t.
vehscreen[15, 10]=' '
vehscreen[15, 11]=' '
*@ 12 , 51 say 'IN.\CC:' get vincc picture 'XXXXXX'
vehscreen[16 , 01]=12
vehscreen[16 , 02]=51
vehscreen[16 , 03]='IN.\CC:'
vehscreen[16 , 04]='vincc'
vehscreen[16 , 05]='XXXXXX'
vehscreen[16 , 06] =6
vehscreen[16 , 07]='bg+/b'
vehscreen[16 , 08]=.t.
vehscreen[16 , 09]=.t.
vehscreen[16, 10]=' '
vehscreen[16, 11]=' '
*
set color to gr+/b
*@ 13 ,  1 say 'Dr Lic No:' get vdlicno PICTURE REPLICATE('X' , 30)
vehscreen[17 , 01]=13
vehscreen[17 , 02]=1
vehscreen[17 , 03]='Dr Lic No:'
vehscreen[17 , 04]='vdlicno'
vehscreen[17 , 05]=REPLICATE('X' , 30)
vehscreen[17 , 06]=30
vehscreen[17 , 07]='gr+/b'
vehscreen[17 , 08]=.t.
vehscreen[17 , 09]=.t.
vehscreen[17, 10]=' '
vehscreen[17, 11]=' '
*@ 13 , 46 SAY 'USE:'  GET VUSE PICTURE "!" valid ( vuse="P" or vuse="W" or  vuse="F" or  vuse="B"   )  error "Valid Input is P:pleasure B:business F:farm W:work"
vehscreen[18 , 01]=13
vehscreen[18 , 02]=46
vehscreen[18 , 03]='USE:'
vehscreen[18 , 04]='VUSE'
vehscreen[18 , 05]="!"
vehscreen[18 , 06]=1
vehscreen[18 , 07]='gr+/b'
vehscreen[18 , 08]=.t.
vehscreen[18 , 09]=.t.
vehscreen[18, 10]='( vuse="P" or vuse="W" or  vuse="F" or  vuse="B"   )'
vehscreen[18, 11]="Valid Input is P:pleasure B:business F:farm W:work"
*@ 13 , 56 say "State Registered in:" get vstatereg picture "AA" function "@!"
vehscreen[19 , 01]=13
vehscreen[19 , 02]=56
vehscreen[19 , 03]="State Registered in:"
vehscreen[19 , 04]='vstatereg'
vehscreen[19 , 05]="AA"
vehscreen[19 , 06]=2
vehscreen[19 , 07]='gr+/b'
vehscreen[19 , 08]=.t.
vehscreen[19 , 09]=.t.
vehscreen[19, 10]=' '
vehscreen[19, 11]=' '
*@ 14 , 1 say "Principal Garage Address:" get vgaragaddr picture replicate ('X' , 25)
vehscreen[20 , 01]=14
vehscreen[20 , 02]=1
vehscreen[20 , 03]="Principal Garage Address:"
vehscreen[20 , 04]='vgaragaddr'
vehscreen[20 , 05]=replicate ('X' , 25)
vehscreen[20 , 06]=25
vehscreen[20 , 07]='gr+/b'
vehscreen[20 , 08]=.t.
vehscreen[20 , 09]=.t.
vehscreen[20, 10]=' '
vehscreen[20, 11]=' '
*@ 14 , 54  say "Miles to Work:" get vmilestow picture replicate('X' , 10)
vehscreen[21 , 01]=14
vehscreen[21 , 02]=54
vehscreen[21 , 03]="Miles to Work:"
vehscreen[21 , 04]='vmilestow'
vehscreen[21 , 05]=replicate('X' , 10)
vehscreen[21 , 06]=10
vehscreen[21 , 07]='gr+/b'
vehscreen[21 , 08]=.t.
vehscreen[21 , 09]=.t.
vehscreen[21, 10]=' '
vehscreen[21, 11]=' '
*@ 15 , 1 say "Principal Applicant Address:" get vappadress picture replicate ('X' , 35)
vehscreen[22 , 01]=15
vehscreen[22 , 02]=1
vehscreen[22 , 03]="Principal Applicant Address:"
vehscreen[22 , 04]='vappadress'
vehscreen[22 , 05]=replicate ('X' , 35)
vehscreen[22 , 06]=35
vehscreen[22 , 07]='gr+/b'
vehscreen[22 , 08]=.t.
vehscreen[22 , 09]=.t.
vehscreen[22, 10]=' '
vehscreen[22, 11]=' '
*@ 16 , 1  Say "Territory:" get vterry picture replicate ('X' , 10)
vehscreen[23 , 01]=16
vehscreen[23 , 02]=1
vehscreen[23 , 03]="Territory:"
vehscreen[23 , 04]='vterry'
vehscreen[23 , 05]=replicate ('X' , 10)
vehscreen[23 , 06]=10
vehscreen[23 , 07]='gr+/b'
vehscreen[23 , 08]=.t.
vehscreen[23 , 09]=.t.
vehscreen[23, 10]=' '
vehscreen[23, 11]=' '
*@ 16 , 28  say "Rate Class:" get vrate  picture replicate ('X' , 10)
vehscreen[24 , 01]=16
vehscreen[24 , 02]=28
vehscreen[24 , 03]="Rate Class:"
vehscreen[24 , 04]='vrate'
vehscreen[24 , 05]=replicate ('X' , 10)
vehscreen[24 , 06]=10
vehscreen[24 , 07]='gr+/b'
vehscreen[24 , 08]=.t.
vehscreen[24 , 09]=.t.
vehscreen[24, 10]=' '
vehscreen[24, 11]=' '
*@ 16 , 53  say "Penalty Points:" get vpenalty  picture replicate ('X' , 10)
vehscreen[25 , 01]=16
vehscreen[25 , 02]=53
vehscreen[25 , 03]="Penalty Points:"
vehscreen[25 , 04]='vpenalty'
vehscreen[25 , 05]=replicate ('X' , 10)
vehscreen[25 , 06]=10
vehscreen[25 , 07]='gr+/b'
vehscreen[25 , 08]=.t.
vehscreen[25 , 09]=.t.
vehscreen[25, 10]=' '
vehscreen[25, 11]=' '
*@ 17 , 1  say "Symbol:" get vsymbol  picture replicate ('X' , 25)
vehscreen[26 , 01]=17
vehscreen[26 , 02]=1
vehscreen[26 , 03]="Symbol:"
vehscreen[26 , 04]='vsymbol'
vehscreen[26 , 05]=replicate ('X' , 25)
vehscreen[26 , 06]=25
vehscreen[26 , 07]='gr+/b'
vehscreen[26 , 08]=.t.
vehscreen[26 , 09]=.t.
vehscreen[26, 10]=' '
vehscreen[26, 11]=' '
*@ 17 , 37 SAY 'COMMENT:' get vlesscomment picture replicate ('X' , 45) SIZE 1 , 30
vehscreen[27 , 01]=17
vehscreen[27 , 02]=37
vehscreen[27 , 03]='COMMENT:'
vehscreen[27 , 04]='vlesscomment'
vehscreen[27 , 05]=replicate ('X' , 45)
vehscreen[27 , 06]=30
vehscreen[27 , 07]='gr+/b'
vehscreen[27 , 08]=.t.
vehscreen[27 , 09]=.t.
vehscreen[27, 10]=' '
vehscreen[27, 11]=' '

*set color to bgr+/b
*@ 18 , 1 say 'Loss Payee:' get vloss picture '@*C' when vlessor=.f.
vehscreen[28 , 01]=18
vehscreen[28 , 02]=1
vehscreen[28 , 03]='Loss Payee:'
vehscreen[28 , 04]='vloss'
vehscreen[28 , 05]='@*C'
vehscreen[28 , 06]=0
vehscreen[28 , 07]='bgr+/b'
vehscreen[28 , 08]=.t.
vehscreen[28 , 09]=.t.
vehscreen[28, 10]='(vlupdate(vloss))'
vehscreen[28, 11]=' '
*@ 18 , 18 say 'or'
vehscreen[29 , 01]=18
vehscreen[29 , 02]=18
vehscreen[29 , 03]='or'
vehscreen[29 , 04]=' '
vehscreen[29 , 05]=' '
vehscreen[29 , 06]=0
vehscreen[29 , 07]='gr+/b'
vehscreen[29 , 08]=.t.
vehscreen[29 , 09]=.f.
vehscreen[29, 10]=' '
vehscreen[29, 11]=' '
*@ 18 , 21 say 'Lessor:' get vlessor picture '@*C' when vloss=.f.
vehscreen[30 , 01]=18
vehscreen[30 , 02]=21
vehscreen[30 , 03]='Lessor:'
vehscreen[30 , 04]='vlessor'
vehscreen[30 , 05]='@*C'
vehscreen[30 , 06]=0
vehscreen[30 , 07]='gr+/b'
vehscreen[30 , 08]=.t.
vehscreen[30 , 09]=.t.
vehscreen[30, 10]=' '
vehscreen[30, 11]=' '
*@ 19 , 1 say 'If Loss Payee or Lessor please complete'
vehscreen[31 , 01]=19
vehscreen[31 , 02]=1
vehscreen[31 , 03]='If Loss Payee or Lessor please complete'
vehscreen[31 , 04]=' '
vehscreen[31 , 05]=' '
vehscreen[31 , 06]=0
vehscreen[31 , 07]='bgr+/b'
vehscreen[31 , 08]=.t.
vehscreen[31 , 09]=.f.
vehscreen[31, 10]=' '
vehscreen[31, 11]=' '
*@ 20 , 3 say 'Name:'   get vlessname picture "!"+replicate("X" , 34)   when   ( (vlessor=.t.) .or. (vloss=.t.) )
vehscreen[32 , 01]=20
vehscreen[32 , 02]=3
vehscreen[32 , 03]='Name:'
vehscreen[32 , 04]='vlessname'
vehscreen[32 , 05]="!"+replicate("X" , 35)
vehscreen[32 , 06]=35
vehscreen[32 , 07]='bgr+/b'
vehscreen[32 , 08]=.t.
vehscreen[32 , 09]=.t.
vehscreen[32, 10]=' '
vehscreen[32, 11]=' '
*@ 21 , 1 say 'Street:' get vlestreet picture "!"+replicate("X" , 24) when   ( (vlessor=.t.) or (vloss=.t.) )
vehscreen[33 , 01]=21
vehscreen[33 , 02]=1
vehscreen[33 , 03]='Street:'
vehscreen[33 , 04]='vlestreet'
vehscreen[33 , 05]="!"+replicate("X" , 24)
vehscreen[33 , 06]=24
vehscreen[33 , 07]='bgr+/b'
vehscreen[33 , 08]=.t.
vehscreen[33 , 09]=.t.
vehscreen[33, 10]=' '
vehscreen[33, 11]=' '
*@ 22 , 3 say 'City:'   get vlesscity picture  "!"+replicate("X" , 24)  size 1 , 15  when   ( (vlessor=.t.) or (vloss=.t.) )
vehscreen[34 , 01]=22
vehscreen[34 , 02]=3
vehscreen[34 , 03]='City:'
vehscreen[34 , 04]='vlesscity'
vehscreen[34 , 05]= "!"+replicate("X" , 24)
vehscreen[34 , 06]=15
vehscreen[34 , 07]='bgr+/b'
vehscreen[34 , 08]=.t.
vehscreen[34 , 09]=.t.
vehscreen[34, 10]=' '
vehscreen[34, 11]=' '
*@ 22 , 25 say 'State:'  get vlessstate picture "AA"                             when   ( (vlessor=.t.) or (vloss=.t.) )
vehscreen[35 , 01]=22
vehscreen[35 , 02]=25
vehscreen[35 , 03]='State:'
vehscreen[35 , 04]='vlessstate'
vehscreen[35 , 05]="AA"
vehscreen[35 , 06]=2
vehscreen[35 , 07]='bgr+/b'
vehscreen[35 , 08]=.t.
vehscreen[35 , 09]=.t.
vehscreen[35, 10]=' '
vehscreen[35, 11]=' '
*@ 22 , 35 say 'ZIP:'    get vlesszip picture '99999-99999'                      when   ( (vlessor=.t.) or (vloss=.t.) )
vehscreen[36 , 01]=22
vehscreen[36 , 02]=35
vehscreen[36 , 03]='ZIP:'
vehscreen[36 , 04]='vlesszip'
vehscreen[36 , 05]='99999-9999'
vehscreen[36 , 06]=10
vehscreen[36 , 07]='bgr+/b'
vehscreen[36 , 08]=.t.
vehscreen[36 , 09]=.t.
vehscreen[36, 10]=' '
vehscreen[36, 11]=' '
*@ 18 , 46  to 21 , 46 double

*set color to rb+/b
*@ 18 , 47 say "AntiTheft Equipped" get vantitheft function "*C" picture ""
vehscreen[37 , 01]=18
vehscreen[37 , 02]=47
vehscreen[37 , 03]="AntiTheft Equipped"
vehscreen[37 , 04]='vantitheft'
vehscreen[37 , 05]="@*C"
vehscreen[37 , 06]=  0
vehscreen[37 , 07]='rb+/b'
vehscreen[37 , 08]=.t.
vehscreen[37 , 09]=.t.
vehscreen[37, 10]=' '
vehscreen[37, 11]=' '
*@ 19 , 47 Say "Model:" get vamodel picture replicate("X" , 25) size 1 , 25 when vantitheft=.t.
vehscreen[38 , 01]=19
vehscreen[38 , 02]=47
vehscreen[38 , 03]="Model:"
vehscreen[38 , 04]='vamodel'
vehscreen[38 , 05]=replicate("X" , 25)
vehscreen[38 , 06]=25
vehscreen[38 , 07]='rb+/b'
vehscreen[38 , 08]=.t.
vehscreen[38 , 09]=.t.
vehscreen[38, 10]=' '
vehscreen[38, 11]=' '
*@ 20 , 47 Say "Brand:" get vabrand picture replicate("X" , 25) size 1 , 25 when vantitheft=.t.
vehscreen[39 , 01]=20
vehscreen[39 , 02]=47
vehscreen[39 , 03]="Brand:"
vehscreen[39 , 04]='vabrand'
vehscreen[39 , 05]=replicate("X" , 25)
vehscreen[39 , 06]=25
vehscreen[39 , 07]='rb+/b'
vehscreen[39 , 08]=.t.
vehscreen[39 , 09]=.t.
vehscreen[39, 10]=' '
vehscreen[39, 11]=' '
*@ 21 , 47 say "Active:" get vaactive function "*C" when ( (vantitheft=.t.) and (vapassive=.f.) )
vehscreen[40 , 01]=21
vehscreen[40 , 02]=47
vehscreen[40 , 03]="Active:"
vehscreen[40 , 04]='vaactive'
vehscreen[40 , 05]='@*C'
vehscreen[40 , 06]=0
vehscreen[40 , 07]='rb+/b'
vehscreen[40 , 08]=.t.
vehscreen[40 , 09]=.t.
vehscreen[40, 10]=' '
vehscreen[40, 11]=' '
*@ 21 , 60 say "Passive:" get vapassive function "*C" when ( (vantitheft=.t.) and (vaactive=.f.) )
vehscreen[41 , 01]=21
vehscreen[41 , 02]=60
vehscreen[41 , 03]="Passive:"
vehscreen[41 , 04]='vapassive'
vehscreen[41 , 05]='@*C'
vehscreen[41 , 06]=0
vehscreen[41 , 07]='rb+/b'
vehscreen[41 , 08]=.t.
vehscreen[41 , 09]=.t.
vehscreen[41, 10]=' '
vehscreen[41, 11]=' '

return




***************************************************************************
*                   Show vehicle screen
***************************************************************************
procedure showveh
for i=1 to vehscits
if len(alltrim(vehscreen[i,4]))<>0
    if vehscreen[i,6]>0
       if vehscreen[i,8]=.f.   && disabled
               @ vehSCREEN[I,1],vehSCREEN[I,2] SAY         vehSCREEN[I,3] ;
                                               GET         (vehSCREEN[I,4]);
                                               picture     vehSCREEN[I,5] ;
                                               size         1,vehscreen[i,6];
                                               color r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ vehSCREEN[I,1],vehSCREEN[I,2] SAY         vehSCREEN[I,3] ;
                                               GET         (vehSCREEN[I,4]);
                                               picture     vehSCREEN[I,5] ;
                                               size         1,vehscreen[i,6];
                                               COLOR        gr+/b,w/b
       endif
    else
       if vehscreen[i,8]=.f.   && disabled
               @ vehSCREEN[I,1],vehSCREEN[I,2] SAY         vehSCREEN[I,3] ;
                                               GET         (vehSCREEN[I,4]);
                                               picture     vehSCREEN[I,5];
                                               color       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ vehSCREEN[I,1],vehSCREEN[I,2] SAY         vehSCREEN[I,3] ;
                                               GET         (vehSCREEN[I,4]);
                                               picture     vehSCREEN[I,5];
                                               COLOR       gr+/b,w/b
       endif
    endif
    else
       if vehscreen[i,8]=.f.   && disabled
        @ vehSCREEN[i,1],vehSCREEN[i,2] SAY         vehSCREEN[i,3] ;
                                        COLOR       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else
        @ vehSCREEN[i,1],vehSCREEN[i,2] SAY         vehSCREEN[i,3] ;
                                        COLOR       gr+/b,w/b
       endif
    endif
endfor
clear gets
return


***************************************************************************
*                   Show element of vehicle screen
***************************************************************************
procedure showvel
&& do the oldindex stuff
if len(alltrim(vehscreen[oldindex,4]))<>0
    if vehscreen[oldindex,6]>0
       if vehscreen[oldindex,8]=.f.   && disabled
               @ vehSCREEN[oldindex,1],vehSCREEN[oldindex,2] SAY         vehSCREEN[oldindex,3] ;
                                               GET         (vehSCREEN[oldindex,4]);
                                               picture     vehSCREEN[oldindex,5] ;
                                               size         1,vehscreen[oldindex,6];
                                               color r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ vehSCREEN[oldindex,1],vehSCREEN[oldindex,2] SAY         vehSCREEN[oldindex,3] ;
                                               GET         (vehSCREEN[oldindex,4]);
                                               picture     vehSCREEN[oldindex,5] ;
                                               size         1,vehscreen[oldindex,6];
                                               COLOR        gr+/b,w/b
       endif
    else
       if vehscreen[oldindex,8]=.f.   && disabled
               @ vehSCREEN[oldindex,1],vehSCREEN[oldindex,2] SAY         vehSCREEN[oldindex,3] ;
                                               GET         (vehSCREEN[oldindex,4]);
                                               picture     vehSCREEN[oldindex,5];
                                               color       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ vehSCREEN[oldindex,1],vehSCREEN[oldindex,2] SAY         vehSCREEN[oldindex,3] ;
                                               GET         (vehSCREEN[oldindex,4]);
                                               picture     vehSCREEN[oldindex,5];
                                               COLOR       gr+/b,w/b
       endif
    endif
    else
       if vehscreen[oldindex,8]=.f.   && disabled
        @ vehSCREEN[oldindex,1],vehSCREEN[oldindex,2] SAY         vehSCREEN[oldindex,3] ;
                                                COLOR       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else
        @ vehSCREEN[oldindex,1],vehSCREEN[oldindex,2] SAY         vehSCREEN[oldindex,3] ;
                                                COLOR       gr+/b,w/b
       endif
    endif
&& now do the new index stuff
if len(alltrim(vehscreen[index,4]))<>0
    if vehscreen[index,6]>0
       if vehscreen[index,8]=.f.   && disabled
               @ vehSCREEN[index,1],vehSCREEN[index,2] SAY         vehSCREEN[index,3] ;
                                               GET         (vehSCREEN[index,4]);
                                               picture     vehSCREEN[index,5] ;
                                               size         1,vehscreen[index,6];
                                               color r+/b,r+/b,r+/b,r+/b, r+/b,r+/b, r+/b,r+/b, r+/b,r+/b
       else  && enabled
               @ vehSCREEN[index,1],vehSCREEN[index,2] SAY         vehSCREEN[index,3] ;
                                               GET         (vehSCREEN[index,4]);
                                               picture     vehSCREEN[index,5] ;
                                               size         1,vehscreen[index,6];
                                               COLOR        bg+/b,bg+/b
       endif
    else
       if vehscreen[index,8]=.f.   && disabled
               @ vehSCREEN[index,1],vehSCREEN[index,2] SAY         vehSCREEN[index,3] ;
                                               GET         (vehSCREEN[index,4]);
                                               picture     vehSCREEN[index,5];
                                               color       r+/b,r+/b,r+/b,r+/b, r+/b,r+/b, r+/b,r+/b, r+/b,r+/b
       else  && enabled
               @ vehSCREEN[index,1],vehSCREEN[index,2] SAY         vehSCREEN[index,3] ;
                                               GET         (vehSCREEN[index,4]);
                                               picture     vehSCREEN[index,5];
                                               COLOR       bg+/b,bg+/b
       endif
    endif
    else
       if vehscreen[index,8]=.f.   && disabled
        @ vehSCREEN[index,1],vehSCREEN[index,2] SAY         vehSCREEN[index,3] ;
                                                COLOR       r+/b,r+/b,r+/b,r+/b, r+/b,r+/b, r+/b,r+/b, r+/b,r+/b
       else
        @ vehSCREEN[index,1],vehSCREEN[index,2] SAY         vehSCREEN[index,3] ;
                                                COLOR       bg+/b,bg+/b
       endif
    endif
clear gets
return




***************************************************************************
*                   first
***************************************************************************
procedure first
oldindex=index
index=2
       do showvel
return

***************************************************************************
*                   last
***************************************************************************
procedure last
oldindex=index
index=vehscits
       do showvel
return

***************************************************************************
*                   next
***************************************************************************
procedure next
oldindex=index
index=index+1
if index>=vehscits
   index=vehscits
endif
       do showvel
return

***************************************************************************
*                   previous
***************************************************************************
procedure prev
oldindex=index
index=index-1
if index<=2
   index=2
endif
       do showvel
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
             hide menu edvehmenu
             DEACTIVATE MENU edvehmenu
             RELEASE MENU edvehmenu
          endif
RETURN


***************************************************************************
*                   hide
***************************************************************************
procedure hide
       if index<>2
          oldindex=index
          vehscreen[index,8]=.f.
          do showvel
          saved=.f.
       else
       ??chr(7)
       wait window "Cannot disable this, it is necessary" nowait
       endif
return


***************************************************************************
*                   show
***************************************************************************
procedure Cshow
          oldindex=index
          vehscreen[index,8]=.t.
          do showvel
          saved=.f.
return

***************************************************************************
*                   save data
***************************************************************************
procedure saveall
      fn=fname("vehscre.mem")
      save all like vehsc* to &fn
      wait window "Screen Design is Saved" nowait
      saved=.t.
return



***************************************************************************
*                   show
***************************************************************************
procedure show
          oldindex=index
          if index>=vehscits
             index=vehscits
          endif
          vehscreen[index,8]=.t.
          do showvel
return



***************************************************************************
*                   move
***************************************************************************
procedure move
set console off
set cursor off
i=index
SET COLOR TO GR+/b
@ 23,0 to 23,79
@ 24,0 to 24,79 clear

=CENTER(24,"Use the cursor keys to move, Press Enter to Drop, Esc to Abort")
FIRST =0
SAVE SCREEN TO SCedit
LK=0
DUMMY=' '
ORR=vehscreen[I,1]
ORC=vehscreen[I,2]
DO WHILE LK<>ENTER AND LK<>27
set color to n/n,n/n
@ 0,0 SAY " " GET DUMMY color n/n,n/n
READ
set color to gr+/b,gr+/b
LK=LASTKEY()
    IF FIRST=0
       FIRST=2
       IF vehscreen[I,6]=0
          itemlen=LEN(vehscreen[I,3])+LEN(vehscreen[I,7])
       ELSE
           itemlen=LEN(vehscreen[I,3])+vehscreen[I,6]+1
       ENDIF
       @ vehscreen[I,1],vehscreen[I,2] SAY SPACE(itemlen)
       SAVE SCREEN TO SCedit
    ENDIF
    DO CASE
       CASE LK=UP
            vehscreen[I,1]=vehscreen[I,1]-1
            IF vehscreen[I,1]<2
               ?? CHR(7)
               vehscreen[I,1]=2
            ENDIF
       CASE LK=DOWN
            vehscreen[I,1]=vehscreen[I,1]+1
            IF vehscreen[I,1]>22
               ?? CHR(7)
               vehscreen[I,1]=22
            ENDIF
       CASE LK=LEFT
            vehscreen[I,2]=vehscreen[I,2]-1
            IF vehscreen[I,2]<0
               ?? CHR(7)
               vehscreen[I,2]=0
            ENDIF
       CASE LK=RIGHT
            vehscreen[I,2]=vehscreen[I,2]+1
            IF (vehscreen[I,2]+itemlen)>79
               ?? CHR(7)
               vehscreen[I,2]=79-itemlen
            ENDIF
    ENDCASE
    RESTORE SCREEN FROM SCedit
DO showvel
ENDDO
IF LK=27
   restore screen from scedit
   vehscreen[I,1]=ORR
   vehscreen[I,2]=ORC
   DO showvel
ENDIF
      @ 23,0 to 24,79 clear
      saved=.f.
      set color to n/n
      @ 0,0 to 0,4 clear
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
      set color to gr+/b
set console on
set cursor on
return


***************************************************************************
*                   revert
***************************************************************************
procedure revert
for i=1 to 41
    vehscreen[i,1]=0
    vehscreen[i,2]=0
    vehscreen[i,3]=" "
    vehscreen[i,4]=" "
    vehscreen[i,5]=" "
    vehscreen[i,6]=0
    vehscreen[i,7]=" "
    vehscreen[i,8]=.t.
    vehscreen[i,9]=.t.
endfor
do initveh
@ 2,0 to 24,79 clear
      fn=fname("vehscre.mem")
      delete file &fn
      wait window "Screen is Restored to its defaults" nowait
      saved=.f.
do showveh
index=2
oldindex=2
do showvel
return

***************************************************************************
*                   Initialize vehicle screen
***************************************************************************
procedure moveveh
define menu edvehmenu color scheme 3

  DEFINE PAD First      OF edvehmenu  PROMPT '\<First'     at 1,01
  DEFINE PAD Previous   OF edvehmenu  PROMPT '\<Previous'  at 1,10
  DEFINE PAD Next       OF edvehmenu  PROMPT '\<Next'      at 1,20
  DEFINE PAD Last       OF edvehmenu  PROMPT '\<Last'      at 1,27
  DEFINE PAD Move       OF edvehmenu  PROMPT '\<Move'      at 1,35
  DEFINE PAD Hide       OF edvehmenu  PROMPT '\<Hide'      at 1,42
  DEFINE PAD Show       OF edvehmenu  PROMPT 'Sh\<ow'      at 1,50
  DEFINE PAD Revert     OF edvehmenu  PROMPT '\<Revert'    at 1,58
  DEFINE PAD Save       OF edvehmenu  PROMPT '\<Save'      at 1,67
  DEFINE PAD Quit       OF edvehmenu  PROMPT '\<Quit'      at 1,74

on selection pad First      of edvehmenu do first
on selection pad Previous   of edvehmenu do prev
on selection pad Next       of edvehmenu do next
on selection pad Last       of edvehmenu do last
on selection pad Move       of edvehmenu do Move
on selection pad Hide       of edvehmenu do Hide
on selection pad Show       of edvehmenu do CShow
on selection pad Revert     of edvehmenu do revert
on selection pad Save       of edvehmenu do saveall
on selection pad Quit       of edvehmenu do quit
SET COLOR TO N/W
@1,0 to 1,79 clear
set color to gr+/b,W/b
lastk=27
do while lastk=27
   activate menu edvehmenu
   lastk=lastkey()
enddo
return
