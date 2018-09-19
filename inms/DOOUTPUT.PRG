*****  PREPARING  OUTPUT  *****

PROCEDURE  PrepareOutput
************************

Set Color to W/N
Clear
Rdv = 'N'
@ 12, 25 Say ' Do you want Ready values ? ' Get Rdv Pict '!X'
Read
If Rdv = 'Y'
  Do ReadyValues
EndIf

Store ' ' to Lines[6],  Lines[10], Lines[12], Lines[17], Lines[18], Lines[19]
Store ' ' to Lines[20], Lines[27], Lines[28], Lines[29], Lines[30], Lines[52]
Store ' ' to L151, L152, L212
Store Space(79) to L46, Lines[26], Lines[46], Lines[47], Lines[59], Lines[60]
Store 0 to LNr
Set color to GR+/B
Clear
TF = AskForExit (' Do you want a Printout ? ')
If TF
  Return
EndIf
Set color to GR+/B
@ 10, 20 Say ' Enter Empty Lines ' Get LNr Pict '99'
Read
Clear

Lines[1]  = FxL(LstNm,19) + FxL(FstNm,11) + FxL(MdlNm,7) + FxL(Strt,28);
          + FxL(Apt,10)
Lines[3]  = FxL(City,18) + FxL(Cnty,15) + '  '+ FxL(State,5) + FxL(ZipCd,9);
          + FxL(TcdHm,3) + FxL(TelHm,8) + FxL(TcdBs,3) + FxL(TelBs,8)
Lines[5]  = FxL(Occup,15) + FxL(EmpNm,28) + FxL(EmAdr,34)
Lines[7]  = Space(12) + FxL(OwnNm,27) + FxL(OwAdr,35) + '  X'
Lines[9]  = '      '+ Fxl(Year1,4) + Fxl(Mk1,12) + Fxl(Modl1,15)
Lines[11] = Fxl(VhId1,39)
L131      = '  ' + FxL(PMo1,2) + Fxl(PYr1,2) 
L132      = ' '+ FxL(Cost1,8) + Fxl(Cyl1,6) + FxL(Hp1,11)
L133      = ' '+ FxL(PMo2,2) + Fxl(PYr2,2) 
L134      = ' '+ FxL(Cost2,8) + Fxl(Cyl2,5) + FxL(Hp2,11)
NUsd1     = '   X'
NUsd2     = '   X'
If New1 = 'Y'
   NUsd1 = 'X   '
EndIf
If New2 = 'Y'
   NUsd2 = 'X   '
EndIf
Lines[13] = L131 + NUsd1 + L132
L141      = Space(21) + 'X' + Space(18)
L142      = Space(21) + 'X'
If AtDv1 = 'Y'
   L141 = Space(17) + 'X' + Space(22)
   L151 = '    '+ Fxl(DvMl1,11) +'  '+ Fxl(DvBd1,10)
   AP   = '          X'     
   If AcPs1 = 'A'
      AP = 'X          '
   EndIf
   L151 = L151 + AP
EndIf
If AtDv2 = 'Y'
   L142 = Space(17) +'X'
   L152 = '   '+ Fxl(DvMl2,11) +'   '+ Fxl(DvBd2,10)
   AP   = '          X'     
   If AcPs2 = 'A'
      AP = 'X          '
   EndIf
   L152 = L152 + AP
EndIf
Lines[14] = L141 
Lines[15] = L151
Lines[17] = Space(8) + FxL(Substr(LpNm1,1,24), 24);
          + FxL(Substr(Lstr1,1,20),20) + FxL(Substr(LCty1,1,13), 13);
          + FxL(Substr(LpSt1,1,3), 3) + FxL(Substr(LpZC1,1,6), 6)
Lines[18] = '    X   '+ FxL(Substr(LpNm1,25,24), 24);
          + FxL(Substr(LStr1,21,20),20) + FxL(Substr(LCty1,14,13), 13);
          + FxL(Substr(LpSt1,4,3), 3) + FxL(Substr(LpZC1,7,6), 6) 
Do Case
  Case UsFr1 = 'P'
    Lines[21] = Space(13) + 'X' + Space(26)
  Case UsFr1 = 'W'
    Lines[21] = Space(20) + 'X' + Space(19)
  Case UsFr1 = 'B'
    Lines[21] = Space(26) + 'X' + Space(13)
  Case UsFr1 = 'F'
    Lines[21] = Space(33) + 'X' + Space(6)
EndCase

Lines[24] = FxL(GAdr1,31) + Fxl(Milt1,7)
Lines[26] = '  ' + FxL(StR1,10) + FxL(RAdr1,27)
Lines[27] = FxL(Tery1,9) + FxL(RtCs1,7) + FxL(PlPt1,7) + FxL(Symb1,13)
If NoPol = 'Y'
  Lines[28] = '  X' 
EndIf
Lines[29] = Space(48) + FxL(BBodIn1,7) + FxL(Str(BodIn1),8)
Lines[30] = Space(48) + FxL(BPrpDm1,7) + FxL(Str(PrpDm1),8)
Lines[31] = Space(48) + FxL(BBaPIP1,7) + FxL(Str(BaPIP1),8)
Lines[32] = Space(17) + 'X'
If Alltrim(BBaPIP1)='$ 0 DEDUCTIBLE'
  Lines[32] = '         X'
EndIf
Lines[33] = Space(48) + FxL(BOBELC1,7) + FxL(Str(OBELC1),8)
L35 = '    X'
If ADPIP1 > 0
  Lines[35] = L35 + Space(43) + FxL(BADPIP1,7) + FxL(Str(ADPIP1),8)
Else
  Lines[35] = Space(48) + FxL(BADPIP1,7) + FxL(Str(ADPIP1),8)
EndIf

If FADPIP1 > 0
  Lines[36] = L35 + Space(44) + FxL(BFADPIP1,7) + FxL(Str(FADPIP1),8)
Else
  Lines[36] = Space(48) + FxL(BFADPIP1,7) + FxL(Str(FADPIP1),8)
EndIf
Lines[37] = Space(48) + FxL(BMedPa1,7) + FxL(Str(MedPa1),8)
Lines[38] = Space(48) + FxL(BStUnM1,7) + FxL(Str(StUnM1),8)
Lines[39] = Space(48) + FxL(BVoUnM1,7) + FxL(Str(VoUnM1),8)
Lines[40] = Space(48) + FxL(BCompr1,7) + FxL(Str(Compr1),8)
Lines[41] = Space(48) + FxL(BColl1,7)  + FxL(Str(Coll1),8)
Lines[42] = Space(48) + FxL(BEIP1,7)   + FxL(Str(EIP1),8)
Lines[43] = Space(20) + FxL(Company,28) +'        '+ FxL(Str(Total1),8)
Lines[44] = Space(9)  + FxL(Limits,16) +'    '+ FxL(Policy,20);
          + '    '    + FxL(ExpirDate,8) 
Lines[45] = Space(51)  + FxL(Str(EstTotPre),9) +'          ';
          + FxL(Str(EstDePre),7) 

Lines[46] = Stuff(L46,38,1,'X')
If Upper(Fs75) = 'Y'
  Lines[46] = Stuff(L46,36,1,'X')
EndIf
If IRR1 = 'I'
  Lines[47] = Stuff(Lines[47],25,1,'X')
Else
  Lines[47] = Stuff(Lines[47],47,1,'X')
EndIf
If IRR2 = 'I'
  Lines[47] = Stuff(Lines[47],31,1,'X')
Else
  Lines[47] = Stuff(Lines[47],54,1,'X')
EndIf
If PoI1 = 'Y'
  Lines[47] = Stuff(Lines[47],70,1,'X')
EndIf
If PoI2 = 'Y'
  Lines[47] = Stuff(Lines[47],76,1,'X')
EndIf
Lines[48] = Space(43) + Alltrim(Str(Premium))
Lines[49] = Space(46) + FxL(Str(Installment),10) + Space(9)
Lines[50] = '              X'
If Option1
  Lines[49] = Lines[49] + Alltrim(Str(Down1))
  Lines[50] = '  X'
EndIf
Lines[51] = '   '
If Financed
  Lines[51] = '  X'
  Lines[52] = Space(17) + FxL(FinCompany,23)
EndIf
Lines[51] = Lines[51] + Space(40) + FxL(Alltrim(Str(TotPre)),11)
If Option2
  Lines[51] = Lines[51] + Space(10) + Alltrim(Str(Down2))
EndIf
Lines[53] = Space(47) + 'X'
If Credit
  Lines[53] = Space(50) + 'X'
EndIf

If Vh1 = '2'
   Lines[6]  = Space(78) + 'X'
   Lines[9]  = Lines[9] + '      '+ Fxl(Year2,4) + Fxl(Mk2,12) + Fxl(Modl2,12)
   Lines[11] = Lines[11] + FxL(VhId2,39)
   Lines[13] = Lines[13] + L133 + NUsd2 + L134
   Lines[14] = Lines[14] + L142
   Lines[15] = Lines[15] + L152
   Lines[19] = Space(8) + FxL(Substr(LpNm2,1,24), 24) + FxL(Substr(Lstr2,1,20),20);
             + FxL(Substr(LCty2,1,13), 13) + FxL(Substr(LpSt2,1,3), 3);
             + FxL(Substr(LpZC2,1,6), 6) 
   Lines[20] = '    X   '+ FxL(Substr(LpNm2,25,24), 24);
             + FxL(Substr(Lstr2,21,20),20) + FxL(Substr(LCty2,14,13), 13);
             + FxL(Substr(LpSt2,4,3), 3) + FxL(Substr(LpZC2,7,6), 6) 
   Do Case
     Case UsFr1 = 'P'
       L212 = Space(13) + 'X' + Space(26)
     Case UsFr1 = 'W'
       L212 = Space(20) + 'X' + Space(19)
     Case UsFr1 = 'B'
       L212 = Space(26) + 'X' + Space(13)
     Case UsFr1 = 'F'
       L212 = Space(33) + 'X' + Space(6)
   EndCase
   Lines[21] = Lines[21] + L212
   Lines[24] = Lines[24] + Fxl(GAdr2,31) + Fxl(Milt2,7)
   Lines[26] = Lines[26] + ' ' + Fxl(StR2,10) + Fxl(RAdr2,26)
   Lines[27] = Lines[27] + FxL(Tery2,9) + FxL(RtCs2,7) + FxL(PlPt2,7);
             + FxL(Symb1,12)
   Lines[29] = Lines[29] + Space(8) + FxL(Str(BodIn2),6)
   Lines[30] = Lines[30] + Space(8) + FxL(Str(PrpDm2),6)
   Lines[31] = Lines[31] + Space(8) + FxL(Str(BaPIP1),6)
   Lines[33] = Lines[33] + FxL(BOBELC2,7) + FxL(Str(OBELC2),6)
   Lines[35] = Lines[35] + FxL(BADPIP2,7) + FxL(Str(ADPIP2),6)
   Lines[36] = Lines[36] + FxL(BFADPIP2,7) + FxL(Str(FADPIP2),6)
   Lines[37] = Lines[37] + FxL(BMedPa2,7) + FxL(Str(MedPa2),6)
   Lines[38] = Lines[38] + FxL(BStUnM2,7) + FxL(Str(StUnM2),6)
   Lines[39] = Lines[39] + FxL(BVoUnM2,7) + FxL(Str(VoUnM2),6)
   Lines[40] = Lines[40] + FxL(BCompr2,7) + FxL(Str(Compr2),6)
   Lines[41] = Lines[41] + FxL(BColl2,7)  + FxL(Str(Coll2),6)
   Lines[42] = Lines[42] + FxL(BEIP2,7)   + FxL(Str(EIP2),6)
   Lines[43] = Lines[43] + Space(8) + FxL(Str(Total2),5)
EndIf

****  Printer Control Chartacters
Lines[2]  = Chr(27) + '3' + Chr(29)
Lines[4]  = Chr(27) + '3' + Chr(32)
Lines[6]  = Lines[6]+ Chr(27) + '3' + Chr(29)
Lines[8]  = Chr(27) + '3' + Chr(30)
Lines[16] = Chr(27) + '3' + Chr(30)
Lines[17] = Lines[17] + Chr(27) + '3' + Chr(30)
Lines[18] = Lines[18] + Chr(27) + '3' + Chr(34)
Lines[19] = Lines[19] + Chr(27) + '3' + Chr(28)
Lines[20] = Lines[20] + Chr(27) + '3' + Chr(34)
Lines[22] = Chr(27) + '3' + Chr(28)
Lines[23] = Chr(27) + '3' + Chr(22)
Lines[24] = Lines[24] + Chr(27) + '3' + Chr(30)
Lines[25] = Chr(27) + '3' + Chr(31)
Lines[26] = Lines[26] + Chr(27) + '3' + Chr(50)
Lines[27] = Lines[27] + Chr(27) + '3' + Chr(82)
Lines[28] = Lines[28] + Chr(27) + '3' + Chr(33)
Lines[29] = Lines[29] + Chr(27) + '3' + Chr(30)
Lines[34] = Chr(27) + '3' + Chr(28)
Lines[35] = Lines[35] + Chr(27) + '3' + Chr(30)
Lines[42] = Lines[42] + Chr(27) + '3' + Chr(30)
Lines[43] = Lines[43] + Chr(27) + '3' + Chr(48)
Lines[44] = Lines[44] + Chr(27) + '3' + Chr(25)
Lines[45] = Lines[45] + Chr(27) + '3' + Chr(45)
Lines[46] = Lines[46] + Chr(27) + '3' + Chr(30)
Lines[47] = Lines[47] + Chr(27) + '3' + Chr(49)
Lines[48] = Lines[48] + Chr(27) + '3' + Chr(41)
Lines[49] = Lines[49] + Chr(27) + '3' + Chr(24)
Lines[50] = Lines[50] + Chr(27) + '3' + Chr(24)
Lines[51] = Lines[51] + Chr(27) + '3' + Chr(30)
Lines[52] = Lines[52] + Chr(27) + '3' + Chr(32)
Lines[53] = Lines[53] + Chr(27) + '3' + Chr(78)
Lines[54] = Chr(27) + '3' + Chr(30)


Set Printer On
For i=1 to LNr
  ? ' '
EndFor

For i=1 to 54
  ? Lines[i]
EndFor 

CPI10 = Chr(27) + 'P'
CPI12 = Chr(27) + 'M'
For Elm = 1 to 4
  TxtLn = FxL(Drvr[Elm],17) + FxL(Relt[Elm],6) + CPI12;
        + FxL(Alltrim(Us1[Elm]) +' '+ Alltrim(Us2[Elm]),5) + Alltrim(BDt[Elm]);
        + '  ' + FxL(Sex[Elm],1) +' '+ FxL(MSts[Elm],2) + FxL(LcNr[Elm],28);
        + Fxl(Stt[Elm],3) + Fxl(Durt3[Elm],2) + Alltrim(DurtM[Elm]) + CPI10
  ? TxtLn
EndFor

Lines[59] = Stuff(Lines[59],29,33,Left (Alltrim(FrAdr),33))
Lines[60] = Stuff(Lines[60],12,14,Left(Alltrim(TML),14))
Lines[60] = Stuff(Lines[60],60,10,Left(Alltrim(CMR),10))
? Chr(27) + '3' + Chr(7)
? Lines[59] + Chr(27) + '3' + Chr(23)
? Chr(27) + '3' + Chr(46)
? Lines[60]
? Chr(27) + '3' + Chr(30)
For i=1 to 18
  ? ' '
EndFor
Set Printer Off
=Inkey(10)

Return   && PrepareOutput



FUNCTION  FxL
*************

Param VarNm, L1
Private Blnk
Blnk = L1 - Len(Alltrim(VarNm)) + 1
If Blnk < 1
   Blnk = 1
EndIf
Return Substr(Alltrim(VarNM),1,L1) + Space(Blnk)
*****   End FxL
