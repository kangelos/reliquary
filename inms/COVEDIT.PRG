

declare covscreen[50 , 11]
covscits=49
* 1 row  ,
* 2 column  ,
* 3 message  ,
* 4 variable  ,
* 5 picture  ,
* 6 size  ,
* 7 color  ,
* 8 enabled  ,
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
=center(0,"Premiums' Screen Designer")
set color to w/b
index=4
oldindex=4

STORE 0 TO BodIn1 ,  PrpDm1 ,  BaPIP1 ,  AdPIP1 ,  FADPIP1 ,  Obelc1 ,  MedPa1 ,  StUnM1 ,  VoUnM1
STORE 0 TO Total1 ,  Depos1 ,  Payms1 ,  Compr1 ,  Coll1 ,  OldCl1 ,  BscCl1 , eip1

STORE 0 TO BodIn2 ,  PrpDm2 ,  BaPIP2 ,  AdPIP2 ,  FADPIP2 ,  Obelc2 ,  MedPa2 ,  StUnM2 ,  VoUnM2
STORE 0 TO Total2 ,  Depos2 ,  Payms2 ,  Compr2 ,  Coll2 ,  OldCl2 ,  BscCl2

STORE replicate('X',20) TO BBodIn1 ,  BPrpDm1 ,  BBaPIP1 ,  BAdPIP1 ,  BFADPIP1 ,  BObelc1 ,  BMedPa1 ,  BStUnM1 ,  BVoUnM1
STORE replicate('X',20) TO BDepos1 ,  BPayms1 ,  bCompr1 ,  bColl1 ,  BOldCl1 ,  BBscCl1

STORE replicate('X',20) TO BBodIn2 ,  BPrpDm2 ,  BBaPIP2 ,  BAdPIP2 ,  BFADPIP2 ,  BObelc2 ,  BMedPa2 ,  BStUnM2 ,  BVoUnM2
STORE replicate('X',20) TO BDepos2 ,  BPayms2 ,  bCompr2 ,  bColl2 ,   BOldCl2 ,  BBscCl2 , beip1

icompanyno=replicate('X',20)
limits =replicate('X',30)
dummyname=replicate('X',30)
dummyvin=replicate('X',20)
temp=replicate('X',50)
policy=replicate('X',30)
pactive=.f.
expiRDATE='00/00/00'
ESTTOTPRE=0
ESTDEPRE=0
nopol='N'
vehicles=1
STORE .F. TO OPTION1 , OPTION2
FINANCED=.F.
FINCOMPANY=replicate('X',30)
PREMIUM=0
INSTALLMENT=0
TOTPRE=0
DOWN1=0
DOWN2=0
option1=.t.
option2=.f.
major=.f.
spolicy=replicate('X',30)
*policy->from={11/11/1111}
*policu->to  ={11/11/1111}
pactive=.t.

fn=fname("covscre.mem")
if !file(fn)
      do initcov
else
    restore from &fn additive
endif

do showcov


index=4
oldindex=4
do showcel
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
do movecov
*release covscits
*release covscreen
covscits=0
return saved


***************************************************************************
*                   Initialize coverage screen
***************************************************************************
procedure initcov
for i=1 to covscits
   covscreen[i  ,  1]=0
   covscreen[i  ,  2]=0
   covscreen[i  ,  3]=" "
   covscreen[i  ,  4]=" "
   covscreen[i  ,  5]=" "
   covscreen[i  ,  6]=0
   covscreen[i  ,  7]=" "
   covscreen[i  ,  8]=.t.
   covscreen[i  ,  9]=.t.
   covscreen[i ,  10]=' '
   covscreen[i ,  11]=' '
endfor

*@  2 , 47 say 'vehicle :'
covscreen[01 , 01]=2
covscreen[01 , 02]=47
covscreen[01 , 03]='Vehicle :'
covscreen[01 , 04]=' '
covscreen[01 , 05]=' '
covscreen[01 , 06]=0
covscreen[01 , 07]= ''
covscreen[01 , 08]=.t.
covscreen[01 , 09]=.f.
covscreen[01 , 10]=''
covscreen[01 , 11]=''
*@  2 , 60 say vehICLE->VIN color rb+/b size 1 , 20
covscreen[02 , 01]=2
covscreen[02 , 02]=60
covscreen[02 , 03]=' '
covscreen[02 , 04]='dummyVIN'
covscreen[02 , 05]=''
covscreen[02 , 06]=20
covscreen[02 , 07]=''
covscreen[02 , 08]=.t.
covscreen[02 , 09]=.f.
covscreen[02 , 10]=''
covscreen[02 , 11]=''
*@  3 ,  1 Say 'Non - Owner Policy                            '
covscreen[ 3 , 01]=3
covscreen[ 3 , 02]=1
covscreen[ 3 , 03]='Non - Owner Policy                            '
covscreen[ 3 , 04]='noPOL'
covscreen[ 3 , 05]=' Y;N'
covscreen[ 3 , 06]=1
covscreen[ 3 , 07]=''
covscreen[ 3 , 08]=.t.
covscreen[ 3 , 09]=.f.
covscreen[ 3 , 10]=''
covscreen[ 3 , 11]=''
*@  4 ,  1 Say 'Bodily Injuiry Liability . . . . . . . . . . .'
covscreen[04 , 01]=4
covscreen[04 , 02]=1
covscreen[04 , 03]='Bodily Injuiry Liability . . . . . . . . . . .'
covscreen[04 , 04]=''
covscreen[04 , 05]=''
covscreen[04 , 06]=0
covscreen[04 , 07]=''
covscreen[04 , 08]=.t.
covscreen[04 , 09]=.f.
covscreen[04 , 10]=''
covscreen[04 , 11]=''
*@  4 ,  50 get bBodIn1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[05,01]=4
covscreen[05,02]=50
covscreen[05,03]=''
covscreen[05,04]='bBodIn1'
covscreen[05,05]=REPLICATE('X' , 20)
covscreen[05,06]=9
covscreen[05,07]=''
covscreen[05,08]=.t.
covscreen[05,09]=.t.
covscreen[05,10]=''
covscreen[05,11]=''
*@  4 ,  6 get BodIn1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[06,01]=4
covscreen[06,02]=60
covscreen[06,03]=''
covscreen[06,04]='BodIn1'
covscreen[06,05]='99999.9'
covscreen[06,06]=7
covscreen[06,07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[06,08]=.t.
covscreen[06,09]=.t.
covscreen[06,10]='ICALC_1_TOT()'
covscreen[06,11]=''
*@  5 ,  1 Say 'Property Damage Liability  . . . . . . . . . .'
covscreen[07 , 01]=5
covscreen[07 , 02]=1
covscreen[07 , 03]='Property Damage Liability  . . . . . . . . . .'
covscreen[07 , 04]=''
covscreen[07 , 05]=''
covscreen[07 , 06]=0
covscreen[07 , 07]=''
covscreen[07 , 08]=.t.
covscreen[07 , 09]=.f.
covscreen[07 , 10]=''
covscreen[07 , 11]=''
*@  5 ,  50 get bPrpDm1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[08 , 01]=5
covscreen[08 , 02]=50
covscreen[08 , 03]=''
covscreen[08 , 04]='bPrpDm1'
covscreen[08 , 05]=REPLICATE('X' , 20)
covscreen[08 , 06]=9
covscreen[08 , 07]=''
covscreen[08 , 08]=.t.
covscreen[08 , 09]=.t.
covscreen[08 , 10]=''
covscreen[08 , 11]=''
*@  5 ,  60 get PrpDm1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALiD ICALC_1_TOT()
covscreen[09 , 01]=5
covscreen[09 , 02]=60
covscreen[09 , 03]=''
covscreen[09 , 04]='PrpDm1'
covscreen[09 , 05]='99999.9'
covscreen[09 , 06]=7
covscreen[09 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[09 , 08]=.t.
covscreen[09 , 09]=.t.
covscreen[09 , 10]='ICALC_1_TOT()'
covscreen[09, 11]=''
*@  6 ,  1 Say 'Mandatory Personal Injury Protection Coverage '
covscreen[10 , 01]=6
covscreen[10 , 02]=1
covscreen[10 , 03]='Mandatory Personal Injury Protection Coverage '
covscreen[10 , 04]=''
covscreen[10 , 05]=''
covscreen[10 , 06]=0
covscreen[10 , 07]=''
covscreen[10 , 08]=.t.
covscreen[10 , 09]=.f.
covscreen[10 , 10]=''
covscreen[10 , 11]=''
*@  6 ,  50 get bBaPIP1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[11 , 01]=6
covscreen[11 , 02]=50
covscreen[11 , 03]=''
covscreen[11 , 04]='bBaPIP1'
covscreen[11 , 05]=REPLICATE('X' , 20)
covscreen[11 , 06]=9
covscreen[11 , 07]=''
covscreen[11 , 08]=.t.
covscreen[11 , 09]=.t.
covscreen[11 , 10]=''
covscreen[11 , 11]=''
*@  6 ,  60 get BaPIP1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[12 , 01]=6
covscreen[12 , 02]=60
covscreen[12 , 03]=''
covscreen[12 , 04]='BaPIP1'
covscreen[12 , 05]='99999.9'
covscreen[12 , 06]=7
covscreen[12 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[12 , 08]=.t.
covscreen[12 , 09]=.t.
covscreen[12 , 10]='ICALC_1_TOT()'
covscreen[12 , 11]=''
*@  7 ,  1 Say 'Optional Basic Economic Loss Coverage. . . . .'
covscreen[13 , 01]=7
covscreen[13 , 02]=1
covscreen[13 , 03]='Optional Basic Economic Loss Coverage. . . . .'
covscreen[13 , 04]=''
covscreen[13 , 05]=''
covscreen[13 , 06]=0
covscreen[13 , 07]=''
covscreen[13 , 08]=.t.
covscreen[13 , 09]=.f.
covscreen[13 , 10]=''
covscreen[13 , 11]=''
*@  7 ,  50 get bObelc1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[14 , 01]=7
covscreen[14 , 02]=50
covscreen[14 , 03]=''
covscreen[14 , 04]='bObelc1'
covscreen[14 , 05]=REPLICATE('X' , 20)
covscreen[14 , 06]=9
covscreen[14 , 07]=''
covscreen[14 , 08]=.t.
covscreen[14 , 09]=.t.
covscreen[14 , 10]=''
covscreen[14 , 11]=''
*@  7 ,  60 get Obelc1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[15 , 01]=7
covscreen[15 , 02]=60
covscreen[15 , 03]=''
covscreen[15 , 04]='Obelc1'
covscreen[15 , 05]='99999.9'
covscreen[15 , 06]=7
covscreen[15 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[15 , 08]=.t.
covscreen[15 , 09]=.t.
covscreen[15 , 10]='ICALC_1_TOT()'
covscreen[15 , 11]=''
*@  8 ,  1 Say "Addit'l PIP Cov. Opt.  * Guest Occup. OoS PIP "
covscreen[16 , 01]=8
covscreen[16 , 02]=1
covscreen[16 , 03]="Addit'l PIP Cov. Opt.  * Guest Occup. OoS PIP "
covscreen[16 , 04]=''
covscreen[16 , 05]=''
covscreen[16 , 06]=0
covscreen[16 , 07]=''
covscreen[16 , 08]=.t.
covscreen[16 , 09]=.f.
covscreen[16 , 10]=''
covscreen[16 , 11]=''
*@  8 ,  50 get bAdPIP1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[17 , 01]=8
covscreen[17 , 02]=50
covscreen[17 , 03]=''
covscreen[17 , 04]='bAdPIP1'
covscreen[17 , 05]=REPLICATE('X' , 20)
covscreen[17 , 06]=9
covscreen[17 , 07]=''
covscreen[17 , 08]=.t.
covscreen[17 , 09]=.t.
covscreen[17 , 10]=''
covscreen[17 , 11]=''
*@  8 ,  60 get AdPIP1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[18 , 01]=8
covscreen[18 , 02]=60
covscreen[18 , 03]=''
covscreen[18 , 04]='AdPIP1'
covscreen[18 , 05]='99999.9'
covscreen[18 , 06]=7
covscreen[18 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[18 , 08]=.t.
covscreen[18 , 09]=.t.
covscreen[18 , 10]='ICALC_1_TOT()'
covscreen[18 , 11]=''
*@  9 ,  1 Say '                       * Full Additional PIP  '
covscreen[19 , 01]=9
covscreen[19 , 02]=1
covscreen[19 , 03]=' Full Additional PIP  '
covscreen[19 , 04]=''
covscreen[19 , 05]=''
covscreen[19 , 06]=0
covscreen[19 , 07]=''
covscreen[19 , 08]=.t.
covscreen[19 , 09]=.f.
covscreen[19 , 10]=''
covscreen[19 , 11]=''
*@  9 ,  50 GET bFADPIP1 picture REPLICATE('X' , 20) size 1 , 9
covscreen[20 , 01]=9
covscreen[20 , 02]=50
covscreen[20 , 03]=''
covscreen[20 , 04]='bFADPIP1'
covscreen[20 , 05]=REPLICATE('X' , 20)
covscreen[20 , 06]=9
covscreen[20 , 07]=''
covscreen[20 , 08]=.t.
covscreen[20 , 09]=.t.
covscreen[20 , 10]=''
covscreen[20 , 11]=''
*@  9 ,  60 GET FADPIP1  picture '99999.9' COLOR GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[21 , 01]=9
covscreen[21 , 02]=60
covscreen[21 , 03]=''
covscreen[21 , 04]='FADPIP1'
covscreen[21 , 05]='99999.9'
covscreen[21 , 06]=7
covscreen[21 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[21 , 08]=.t.
covscreen[21 , 09]=.t.
covscreen[21 , 10]='ICALC_1_TOT()'
covscreen[21 , 11]=''
*@ 10 ,  1 Say 'Medical Payments Coverage  . . . . . . . . . .'
covscreen[22 , 01]=10
covscreen[22 , 02]=1
covscreen[22 , 03]='Medical Payments Coverage  . . . . . . . . . .'
covscreen[22 , 04]=''
covscreen[22 , 05]=''
covscreen[22 , 06]=0
covscreen[22 , 07]=''
covscreen[22 , 08]=.t.
covscreen[22 , 09]=.f.
covscreen[22 , 10]=''
covscreen[22 , 11]=''
*@ 10 ,  50 get bMedPa1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[23 , 01]=10
covscreen[23 , 02]=50
covscreen[23 , 03]=''
covscreen[23 , 04]='bMedPa1'
covscreen[23 , 05]=REPLICATE('X' , 20)
covscreen[23 , 06]=9
covscreen[23 , 07]=''
covscreen[23 , 08]=.t.
covscreen[23 , 09]=.t.
covscreen[23 , 10]=''
covscreen[23 , 11]=''
*@ 10 ,  60 get MedPa1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[24 , 01]=10
covscreen[24 , 02]=60
covscreen[24 , 03]=''
covscreen[24 , 04]='MedPa1'
covscreen[24 , 05]='99999.9'
covscreen[24 , 06]=7
covscreen[24 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[24 , 08]=.t.
covscreen[24 , 09]=.t.
covscreen[24 , 10]='ICALC_1_TOT()'
covscreen[24 , 11]=''
*@ 11 ,  1 Say 'Statutory Uninsured Motorists Coverage . . . .'
covscreen[25 , 01]=11
covscreen[25 , 02]=1
covscreen[25 , 03]='Statutory Uninsured Motorists Coverage . . . .'
covscreen[25 , 04]=''
covscreen[25 , 05]=''
covscreen[25 , 06]=0
covscreen[25 , 07]=''
covscreen[25 , 08]=.t.
covscreen[25 , 09]=.f.
covscreen[25 , 10]=''
covscreen[25 , 11]=''
*@ 11 ,  50 get bStUnM1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[26 , 01]=11
covscreen[26 , 02]=50
covscreen[26 , 03]=''
covscreen[26 , 04]='bStUnM1'
covscreen[26 , 05]=REPLICATE('X' , 20)
covscreen[26 , 06]=9
covscreen[26 , 07]=''
covscreen[26 , 08]=.t.
covscreen[26 , 09]=.t.
covscreen[26 , 10]=''
covscreen[26 , 11]=''
*@ 11 ,  60 get StUnM1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[27 , 01]=11
covscreen[27 , 02]=60
covscreen[27 , 03]=''
covscreen[27 , 04]='StUnM1'
covscreen[27 , 05]='99999.9'
covscreen[27 , 06]=7
covscreen[27 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[27 , 08]=.t.
covscreen[27 , 09]=.t.
covscreen[27 , 10]='ICALC_1_TOT()'
covscreen[27 , 11]=''
*@ 12 ,  1 Say 'Voluntary Uninsured Motorists Coverage . . . .'
covscreen[28 , 01]=12
covscreen[28 , 02]=1
covscreen[28 , 03]='Voluntary Uninsured Motorists Coverage . . . .'
covscreen[28 , 04]=''
covscreen[28 , 05]=''
covscreen[28 , 06]=0
covscreen[28 , 07]=''
covscreen[28 , 08]=.t.
covscreen[28 , 09]=.f.
covscreen[28 , 10]=''
covscreen[28 , 11]=''
*@ 12 ,  50 get bVoUnM1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[29 , 01]=12
covscreen[29 , 02]=50
covscreen[29 , 03]=''
covscreen[29 , 04]='bVoUnM1'
covscreen[29 , 05]=REPLICATE('X' , 20)
covscreen[29 , 06]=9
covscreen[29 , 07]=''
covscreen[29 , 08]=.t.
covscreen[29 , 09]=.t.
covscreen[29 , 10]=''
covscreen[29 , 11]=''
*@ 12 ,  60 get VoUnM1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[30 , 01]=12
covscreen[30 , 02]=60
covscreen[30 , 03]=''
covscreen[30 , 04]='VoUnM1'
covscreen[30 , 05]='99999.9'
covscreen[30 , 06]=7
covscreen[30 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[30 , 08]=.t.
covscreen[30 , 09]=.t.
covscreen[30 , 10]='ICALC_1_TOT()'
covscreen[30 , 11]=''
*@ 13 ,  1 Say 'Comprehen. Submit Signed Auth. For Insp. Form '
covscreen[31 , 01]=13
covscreen[31 , 02]=1
covscreen[31 , 03]='Comprehen. Submit Signed Auth. For Insp. Form '
covscreen[31 , 04]=''
covscreen[31 , 05]=''
covscreen[31 , 06]=0
covscreen[31 , 07]=''
covscreen[31 , 08]=.t.
covscreen[31 , 09]=.f.
covscreen[31 , 10]=''
covscreen[31 , 11]=''
*@ 13 ,  50 get bCOMPR1  picture REPLICATE('X' , 20) size 1 , 9
covscreen[32 , 01]=13
covscreen[32 , 02]=50
covscreen[32 , 03]=''
covscreen[32 , 04]='bCOMPR1'
covscreen[32 , 05]=REPLICATE('X' , 20)
covscreen[32 , 06]=9
covscreen[32 , 07]=''
covscreen[32 , 08]=.t.
covscreen[32 , 09]=.t.
covscreen[32 , 10]=''
covscreen[32 , 11]=''
*@ 13 ,  60 get COMPR1   picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[33 , 01]=13
covscreen[33 , 02]=60
covscreen[33 , 03]=''
covscreen[33 , 04]='COMPR1'
covscreen[33 , 05]='99999.9'
covscreen[33 , 06]=7
covscreen[33 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[33 , 08]=.t.
covscreen[33 , 09]=.t.
covscreen[33 , 10]='ICALC_1_TOT()'
covscreen[33 , 11]=''
*@ 14 ,  1 Say 'Collision  . . . . . . . . . . . . . . . . . .'
covscreen[34 , 01]=14
covscreen[34 , 02]=1
covscreen[34 , 03]='Collision  . . . . . . . . . . . . . . . . . .'
covscreen[34 , 04]=''
covscreen[34 , 05]=''
covscreen[34 , 06]=0
covscreen[34 , 07]=''
covscreen[34 , 08]=.t.
covscreen[34 , 09]=.f.
covscreen[34 , 10]=''
covscreen[34 , 11]=''
*@ 14 ,  50 GET bCOLL1   picture REPLICATE('X' , 20) size 1 , 9
covscreen[35 , 01]=14
covscreen[35 , 02]=50
covscreen[35 , 03]=''
covscreen[35 , 04]='bCOLL1'
covscreen[35 , 05]=REPLICATE('X' , 20)
covscreen[35 , 06]=9
covscreen[35 , 07]=''
covscreen[35 , 08]=.t.
covscreen[35 , 09]=.t.
covscreen[35 , 10]=''
covscreen[35 , 11]=''
*@ 14 ,  60 GET COLL1    picture  '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[36 , 01]=14
covscreen[36 , 02]=60
covscreen[36 , 03]=''
covscreen[36 , 04]='COLL1'
covscreen[36 , 05]='99999.9'
covscreen[36 , 06]=7
covscreen[36 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[36 , 08]=.t.
covscreen[36 , 09]=.t.
covscreen[36 , 10]='ICALC_1_TOT()'
covscreen[36 , 11]=''
*@ 15 ,  1 Say 'Excess Indemnity Policy  . . . . . . . . . . .'
covscreen[37 , 01]=15
covscreen[37 , 02]=1
covscreen[37 , 03]='Excess Indemnity Policy  . . . . . . . . . . .'
covscreen[37 , 04]=''
covscreen[37 , 05]=''
covscreen[37 , 06]=0
covscreen[37 , 07]=''
covscreen[37 , 08]=.t.
covscreen[37 , 09]=.f.
covscreen[37 , 10]=''
covscreen[37 , 11]=''
*@ 15 ,  50 GET BEIP1    picture REPLICATE('X' , 20) size 1 , 9
covscreen[38 , 01]=15
covscreen[38 , 02]=50
covscreen[38 , 03]=''
covscreen[38 , 04]='BEIP1'
covscreen[38 , 05]=REPLICATE('X' , 20)
covscreen[38 , 06]=9
covscreen[38 , 07]=''
covscreen[38 , 08]=.t.
covscreen[38 , 09]=.t.
covscreen[38 , 10]=''
covscreen[38 , 11]=''
*@ 15 ,  60 GET EIP1     picture   '99999.9' COLOR  GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR VALID ICALC_1_TOT()
covscreen[39 , 01]=15
covscreen[39 , 02]=60
covscreen[39 , 03]=''
covscreen[39 , 04]='EIP1'
covscreen[39 , 05]='99999.9'
covscreen[39 , 06]=7
covscreen[39 , 07]='GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR , GR+/GR , B/GR'
covscreen[39 , 08]=.t.
covscreen[39 , 09]=.t.
covscreen[39 , 10]='ICALC_1_TOT()'
covscreen[39 , 11]=''
*@ 16 ,  1 Say '                             Estimated Premium'
covscreen[40 , 01]=16
covscreen[40 , 02]=1
covscreen[40 , 03]=' Estimated Premium'
covscreen[40 , 04]=''
covscreen[40 , 05]=''
covscreen[40 , 06]=0
covscreen[40 , 07]=''
covscreen[40 , 08]=.t.
covscreen[40 , 09]=.f.
covscreen[40 , 10]=''
covscreen[40 , 11]=''
*@ 16 ,  60 SAY TOTAL1 PICTURE  '99999.9' COLOR  rb+/b
covscreen[41 , 01]=16
covscreen[41 , 02]=60
covscreen[41 , 03]=''
covscreen[41 , 04]='total1'
covscreen[41 , 05]='99999.9'
covscreen[41 , 06]=7
covscreen[41 , 07]='rb+/b '
covscreen[41 , 08]=.t.
covscreen[41 , 09]=.t.
covscreen[41 , 10]=''
covscreen[41 , 11]=''
*@ 18 ,  1 say "Insurance Company:"
covscreen[42 , 01]=18
covscreen[42 , 02]=1
covscreen[42 , 03]="Insurance Company:"
covscreen[42 , 04]=''
covscreen[42 , 05]=''
covscreen[42 , 06]=0
covscreen[42 , 07]=''
covscreen[42 , 08]=.t.
covscreen[42 , 09]=.f.
covscreen[42 , 10]=''
covscreen[42 , 11]=''
*@ 18 , 20 get icompanyno picture '99999999999999999999'
covscreen[43 , 01]=18
covscreen[43 , 02]=20
covscreen[43 , 03]=''
covscreen[43 , 04]='icompanyno'
covscreen[43 , 05]='99999999999999999999'
covscreen[43 , 06]=20
covscreen[43 , 07]=''
covscreen[43 , 08]=.t.
covscreen[43 , 09]=.t.
covscreen[43 , 10]=''
covscreen[43 , 11]=''
*@ 18 , 30 say "Name:"
covscreen[44 , 01]=18
covscreen[44 , 02]=45
covscreen[44 , 03]="Name:"
covscreen[44 , 04]='icompany->iname'
covscreen[44 , 05]=replicate("X",30)
covscreen[44 , 06]=30
covscreen[44 , 07]=''
covscreen[44 , 08]=.t.
covscreen[44 , 09]=.f.
covscreen[44 , 10]=''
covscreen[44 , 11]=''
*@ 19 , 1 say "The Above Is The Vehicle's Major Coverage Company :" get major picture ' Y , N' valid getmajor(major) error 'Major Coverage Already Exists'
covscreen[45 , 01]=19
covscreen[45 , 02]=1
covscreen[45 , 03]="The Above Is The Vehicle's Major Coverage Company :"
covscreen[45 , 04]='major'
covscreen[45 , 05]=' Y , N'
covscreen[45 , 06]=1
covscreen[45 , 07]=''
covscreen[45 , 08]=.t.
covscreen[45 , 09]=.t.
covscreen[45 , 10]='getmajor(major)'
covscreen[45 , 11]='Major Coverage Already Exists'
*@ 22, 5  SAY "Policy Number:"  spolicy picture replicate ('X',30)
covscreen[46 , 01]=22
covscreen[46 , 02]=5
covscreen[46 , 03]="Policy Number:"
covscreen[46 , 04]='policy->policyno'
covscreen[46 , 05]=replicate ('X',30)
covscreen[46 , 06]=30
covscreen[46 , 07]=''
covscreen[46 , 08]=.t.
covscreen[46 , 09]=.f.
covscreen[46 , 10]=''
covscreen[46 , 11]=''
*@ 22, 51 say "Active Policy:"  pactive picture ' Y;N'
covscreen[47 , 01]=22
covscreen[47 , 02]=51
covscreen[47 , 03]="Active Policy:"
covscreen[47 , 04]='pactive'
covscreen[47 , 05]=' Y;N'
covscreen[47 , 06]=1
covscreen[47 , 07]=''
covscreen[47 , 08]=.t.
covscreen[47 , 09]=.f.
covscreen[47 , 10]=''
covscreen[47 , 11]=''
*@ 23,11 say "Policy From:"  pfrom color rb+/b
covscreen[48 , 01]=23
covscreen[48 , 02]=11
covscreen[48 , 03]="Policy From:"
covscreen[48 , 04]='policy->from'
covscreen[48 , 05]='@D'
covscreen[48 , 06]=10
covscreen[48 , 07]='rb+/b '
covscreen[48 , 08]=.t.
covscreen[48 , 09]=.f.
covscreen[48 , 10]=''
covscreen[48 , 11]=''
*@ 23,36 say "To:" pto color rb+/b
covscreen[49 , 01]=23
covscreen[49 , 02]=36
covscreen[49 , 03]='To:'
covscreen[49 , 04]='policy->to'
covscreen[49 , 05]='@D'
covscreen[49 , 06]=10
covscreen[49 , 07]='rb+/b'
covscreen[49 , 08]=.t.
covscreen[49 , 09]=.f.
covscreen[49 , 10]=''
covscreen[49 , 11]=''
return




***************************************************************************
*                   Show coverage screen
***************************************************************************
procedure showcov
set color to gr+/b
@  2,1  Say 'Customer :'
@  2,12 say 'XXXXXXXXXXXXXXXXXXXX' color w/b
for i=1 to covscits
if len(alltrim(covscreen[i,4]))<>0
    if covscreen[i,6]>0
       if covscreen[i,8]=.f.   && disabled
               @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                               GET         (covSCREEN[I,4]);
                                               picture     covSCREEN[I,5] ;
                                               size         1,covscreen[i,6];
                                               color r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                               GET         (covSCREEN[I,4]);
                                               picture     covSCREEN[I,5] ;
                                               size         1,covscreen[i,6];
                                               COLOR        gr+/b,w/b
       endif
    else
       if covscreen[i,8]=.f.   && disabled
               @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                               GET         (covSCREEN[I,4]);
                                               picture     covSCREEN[I,5];
                                               color       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ covSCREEN[I,1],covSCREEN[I,2] SAY         covSCREEN[I,3] ;
                                               GET         (covSCREEN[I,4]);
                                               picture     covSCREEN[I,5];
                                               COLOR       gr+/b,w/b
       endif
    endif
    else
       if covscreen[i,8]=.f.   && disabled
        @ covSCREEN[i,1],covSCREEN[i,2] SAY         covSCREEN[i,3] ;
                                        COLOR       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else
        @ covSCREEN[i,1],covSCREEN[i,2] SAY         covSCREEN[i,3] ;
                                        COLOR       gr+/b,w/b
       endif
    endif
endfor
clear gets
return



***************************************************************************
*                   Show element of coverage screen
***************************************************************************
procedure showcel
&& do the oldindex stuff
if len(alltrim(covscreen[oldindex,4]))<>0
    if covscreen[oldindex,6]>0
       if covscreen[oldindex,8]=.f.   && disabled
               @ covscreen[oldindex,1],covscreen[oldindex,2] SAY         covscreen[oldindex,3] ;
                                               GET         (covscreen[oldindex,4]);
                                               picture     covscreen[oldindex,5] ;
                                               size         1,covscreen[oldindex,6];
                                               color r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ covscreen[oldindex,1],covscreen[oldindex,2] SAY         covscreen[oldindex,3] ;
                                               GET         (covscreen[oldindex,4]);
                                               picture     covscreen[oldindex,5] ;
                                               size         1,covscreen[oldindex,6];
                                               COLOR        gr+/b,w/b
       endif
    else
       if covscreen[oldindex,8]=.f.   && disabled
               @ covscreen[oldindex,1],covscreen[oldindex,2] SAY         covscreen[oldindex,3] ;
                                               GET         (covscreen[oldindex,4]);
                                               picture     covscreen[oldindex,5];
                                               color       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else  && enabled
               @ covscreen[oldindex,1],covscreen[oldindex,2] SAY         covscreen[oldindex,3] ;
                                               GET         (covscreen[oldindex,4]);
                                               picture     covscreen[oldindex,5];
                                               COLOR       gr+/b,w/b
       endif
    endif
    else
       if covscreen[oldindex,8]=.f.   && disabled
        @ covscreen[oldindex,1],covscreen[oldindex,2] SAY         covscreen[oldindex,3] ;
                                                COLOR       r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b,r/b
       else
        @ covscreen[oldindex,1],covscreen[oldindex,2] SAY         covscreen[oldindex,3] ;
                                                COLOR       gr+/b,w/b
       endif
    endif
&& now do the new index stuff
if len(alltrim(covscreen[index,4]))<>0
    if covscreen[index,6]>0
       if covscreen[index,8]=.f.   && disabled
               @ covscreen[index,1],covscreen[index,2] SAY         covscreen[index,3] ;
                                               GET         (covscreen[index,4]);
                                               picture     covscreen[index,5] ;
                                               size         1,covscreen[index,6];
                                               color r+/b,r+/b,r+/b,r+/b, r+/b,r+/b, r+/b,r+/b, r+/b,r+/b
       else  && enabled
               @ covscreen[index,1],covscreen[index,2] SAY         covscreen[index,3] ;
                                               GET         (covscreen[index,4]);
                                               picture     covscreen[index,5] ;
                                               size         1,covscreen[index,6];
                                               COLOR        bg+/b,w+/b
       endif
    else
       if covscreen[index,8]=.f.   && disabled
               @ covscreen[index,1],covscreen[index,2] SAY         covscreen[index,3] ;
                                               GET         (covscreen[index,4]);
                                               picture     covscreen[index,5];
                                               color       r+/b,r+/b,r+/b,r+/b, r+/b,r+/b, r+/b,r+/b, r+/b,r+/b
       else  && enabled
               @ covscreen[index,1],covscreen[index,2] SAY         covscreen[index,3] ;
                                               GET         (covscreen[index,4]);
                                               picture     covscreen[index,5];
                                               COLOR       bg+/b,w+/b
       endif
    endif
    else
       if covscreen[index,8]=.f.   && disabled
        @ covscreen[index,1],covscreen[index,2] SAY         covscreen[index,3] ;
                                                COLOR       r+/b,r+/b,r+/b,r+/b, r+/b,r+/b, r+/b,r+/b, r+/b,r+/b
       else
        @ covscreen[index,1],covscreen[index,2] SAY         covscreen[index,3] ;
                                                COLOR       bg+/b,w+/b
       endif
    endif
clear gets
return


***************************************************************************
*                   move coverage screen
***************************************************************************
procedure movecov
define menu edcovmenu color scheme 3

  DEFINE PAD First      OF edcovmenu  PROMPT '\<First'     at 1,01
  DEFINE PAD Previous   OF edcovmenu  PROMPT '\<Previous'  at 1,10
  DEFINE PAD Next       OF edcovmenu  PROMPT '\<Next'      at 1,20
  DEFINE PAD Last       OF edcovmenu  PROMPT '\<Last'      at 1,27
  DEFINE PAD Move       OF edcovmenu  PROMPT '\<Move'      at 1,35
  DEFINE PAD Hide       OF edcovmenu  PROMPT '\<Hide'      at 1,42
  DEFINE PAD Show       OF edcovmenu  PROMPT 'Sh\<ow'      at 1,50
  DEFINE PAD Revert     OF edcovmenu  PROMPT '\<Revert'    at 1,58
  DEFINE PAD Save       OF edcovmenu  PROMPT '\<Save'      at 1,67
  DEFINE PAD Quit       OF edcovmenu  PROMPT '\<Quit'      at 1,74

on selection pad First      of edcovmenu do first
on selection pad Previous   of edcovmenu do prev
on selection pad Next       of edcovmenu do next
on selection pad Last       of edcovmenu do last
on selection pad Move       of edcovmenu do Move
on selection pad Hide       of edcovmenu do Hide
on selection pad Show       of edcovmenu do CShow
on selection pad Revert     of edcovmenu do revert
on selection pad Save       of edcovmenu do saveall
on selection pad Quit       of edcovmenu do quit
SET COLOR TO N/W
@1,0 to 1,79 clear
set color to gr+/b,w/b

lastk=27
do while lastk=27
   activate menu edcovmenu
   lastk=lastkey()
enddo

return





***************************************************************************
*                   first
***************************************************************************
procedure first
oldindex=index
index=4
       do showcel
return

***************************************************************************
*                   last
***************************************************************************
procedure last
oldindex=index
index=38
       do showcel
return

***************************************************************************
*                   next
***************************************************************************
procedure next
oldindex=index
    index=index+1
   if index>38
      index=38
   endif
   if index>=covscits
      index=covscits
   endif
   do showcel
return

***************************************************************************
*                   previous
***************************************************************************
procedure prev
oldindex=index
index=index-1
if index>38
   index=38
endif
if index<=4
   index=4
endif

       do showcel
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
             hide menu edcovmenu
             DEACTIVATE MENU edcovmenu
             RELEASE MENU edcovmenu
          endif
RETURN


***************************************************************************
*                   hide
***************************************************************************
procedure hide
       if index<>2
          if index>3 and index<39
             row=int((index-4)/3)+1
             oldindex=(row*3)+1
             covscreen[(row*3)+1,8]=.f.
             do showcel
             oldindex=(row*3)+2
             covscreen[(row*3)+2,8]=.f.
             do showcel
             oldindex=(row*3)+3
             covscreen[(row*3)+3,8]=.f.
             do showcel
          else
             oldindex=index
             covscreen[index,8]=.f.
             do showcel
             saved=.f.
          endif
       else
       ??chr(7)
       wait window "Cannot disable this, it is necessary" nowait
       endif
return


***************************************************************************
*                   save data
***************************************************************************
procedure saveall
      fn=fname("covscre.mem")
      save all like covsc* to &fn
      wait window "Screen Design is Saved" nowait
      saved=.t.
return



***************************************************************************
*                   show
***************************************************************************
procedure cshow
          if index>3 and index<39
             row=int((index-4)/3)+1
             oldindex=(row*3)+1
             covscreen[(row*3)+1,8]=.t.
             do showcel
             oldindex=(row*3)+2
             covscreen[(row*3)+2,8]=.t.
             do showcel
             oldindex=(row*3)+3
             covscreen[(row*3)+3,8]=.t.
             do showcel
          else
             oldindex=index
             covscreen[index,8]=.t.
             do showcel
             saved=.f.
          endif
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
ORR=covscreen[I,1]
ORC=covscreen[I,2]
DO WHILE LK<>ENTER AND LK<>27
set color to n/n,n/n
@ 0,0 SAY " " GET DUMMY color n/n,n/n
READ
set color to gr+/b,gr+/b
LK=LASTKEY()
    IF FIRST=0
       FIRST=1
       IF covscreen[I,6]=0
          itemlen=LEN(covscreen[I,3])+LEN(covscreen[I,7])
       ELSE
           itemlen=LEN(covscreen[I,3])+covscreen[I,6]+1
       ENDIF
       @ covscreen[I,1],covscreen[I,2] SAY SPACE(itemlen)
       SAVE SCREEN TO SCedit
    ENDIF
    DO CASE
       CASE LK=UP
            covscreen[I,1]=covscreen[I,1]-1
            IF covscreen[I,1]<2
               ?? CHR(7)
               covscreen[I,1]=2
            ENDIF
       CASE LK=DOWN
            covscreen[I,1]=covscreen[I,1]+1
            IF covscreen[I,1]>22
               ?? CHR(7)
               covscreen[I,1]=22
            ENDIF
       CASE LK=LEFT
            covscreen[I,2]=covscreen[I,2]-1
            IF covscreen[I,2]<0
               ?? CHR(7)
               covscreen[I,2]=0
            ENDIF
       CASE LK=RIGHT
            covscreen[I,2]=covscreen[I,2]+1
            IF (covscreen[I,2]+itemlen)>79
               ?? CHR(7)
               covscreen[I,2]=79-itemlen
            ENDIF
    ENDCASE
    RESTORE SCREEN FROM SCedit
DO showcel
ENDDO
IF LK=27
   restore screen from scedit
   covscreen[I,1]=ORR
   covscreen[I,2]=ORC
   DO showcel
ENDIF
      @ 23,0 to 24,79 clear
      saved=.f.
set console on
set cursor on
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
set color to w/b
return


***************************************************************************
*                   revert
***************************************************************************
procedure revert
for i=1 to 40
    covscreen[i,1]=0
    covscreen[i,2]=0
    covscreen[i,3]=" "
    covscreen[i,4]=" "
    covscreen[i,5]=" "
    covscreen[i,6]=0
    covscreen[i,7]=" "
    covscreen[i,8]=.t.
    covscreen[i,9]=.t.
endfor
do initcov
@ 2,0 to 24,79 clear
      fn=fname("covscre.mem")
      delete file &fn
      wait window "Screen is Restored to its defaults" nowait
      saved=.f.
do showcov
index=4
oldindex=4
do showcel
return
