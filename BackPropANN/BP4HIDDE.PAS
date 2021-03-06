      (*********************************************************)
      (*********************************************************)
      (**************    Angelos  Karageorgiou     *************)
      (**************        Summer  1990          *************)
      (*********************************************************)
      (*********************************************************)


(****************************************************************************
        This net is practically the same as 'BACKPROP.PAS' the
    difference is that it has 4 Neurons in the hidden layer.
****************************************************************************)



program backprop;
uses crt;

const
     n          = 0.18;       (* training rate coefficient *)
     A          = 0.9;       (* Momentum coefficient *)
     D          = 89;        (* Random Number Divisor !? !? !? !? !? !? !?*)
     VectorBase = 0;
     VectorMax  = 63;
     BitBase    = 0;
     BitMax     = 7;

type
    Bit           = BitBase..1;
    BigBit        = BitBase..BitMax;
    Byte          = 0..255;
    CurrentNumber = BitBase..9;
    BigBitArray   = array[BitBase..9,BitBase..BitMax,BitBase..BitMax] of Bit;
                                            (* 10 characters 8 x 8 each *)

    BitArray      = array[BitBase..BitMax] of bit;
    WeightVector  = Array[VectorBase..VectorMax] of Real;
                                            (* for an 8x8 matrix *)


    OutputLayer   = Array[BitBase..BitMax,0..3]  of Real;
    HiddLayer     = Array[0..3,VectorBase..VectorMax] of Real;
    HidLayerOut   = Array[0..3]  of Real;
    NetOutput     = Array[Bitbase..BitMax] of Bit;
    TrueNetOutput = Array[Bitbase..BitMax] of Real;
    ExpectedTarg  = NetOutput;


var
       (*   Global Variables  *)
   Threshold   :real;
   Input       : BigBitArray;
   InputLayer  : WeightVector;
   HiddenLayer,HiddenWeightChange : HiddLayer;
   OutLayer,OutWeightChange    : Outputlayer;
   NetOut      : NetOutput;
   TrueNetOut  : TrueNetOutput;
   HidOut      : HidLayerOut;
   Target      : ExpectedTarg;
   Pass        : Real;
   Error,TotError       : Real;
   Errors      : Array[currentNumber] of real;
   OutError    : Array[bitbase..bitmax] of real;
   hiddenerror : Array[0..3] of real;




(*************************)
(* Initialize everything *)
(*************************)
Procedure Initialize(var InLayer : WeightVector; var HidLayer : HiddLayer;
                     var OLayer  : OutputLayer;  var NOut     : NetOutput);
Var
    i,j   : integer;
    Dummy : Real;
begin
Dummy:=random;    (* Discharge the first random number generated  TP quirk *)
gotoxy(30,17);
highvideo;
write('Please wait Initializing Weights');
LowVideo;
    for i:=BitBase to Bitmax do
    begin
         Nout[i]:=0;
         TrueNetOut[i]:=0;
         Target[i]:=0;
    end;

    for i:=BitBase to Bitmax do
      for j:=0 to 3 do
      begin
         OLayer[i,j]:=Random/d;     (* Numbers have to be close to 0 *)
         OutWeightChange[i,j]:=0;
      end;

    for i:=VectorBase to VectorMax do
       InLayer[i]:=0;

    for i:=0 to 3 do
       Hidout[i]:=0;

      for i:=0 to 3 do
        for j:=VectorBase to VectorMax do
       begin
        HidLayer[i,j]:=random/d;     (* Numbers have to be close to 0 *)
        HiddenWeightChange[i,j]:=0;
       end;
end;
















(*****************************************)
(* Save the weight values of the network *)
(*****************************************)
Procedure SaveValues(var HidLayer : HidDLayer; var OLayer  : OutputLayer);
label
      out;
Var
    i,j   : integer;
    Answer: char;
    Outfile: text;

begin
Assign(Outfile,'b:bp4weigh.dat');  (* Plain Vanila file for internal use *)
rewrite(Outfile);


for i:=0 to 3 do
    for j:=VectorBase to VectorMax do
       Writeln(outfile,HidLayer[i,j]);


    for i:=Bitbase to Bitmax do
      for j:=0 to 3 do
         Writeln(outfile,Olayer[i,j]);

close(Outfile);


Assign(Outfile,'b:bp4weigh.out');  (* Extended file for Presentations *)
rewrite(Outfile);
 Writeln(outfile,'           Network Fully Trained');
 Writeln(outfile,'Number of Passes over the whole input Set:',pass:6:0);
 Writeln(outfile,'Training Rate Coefficient : ',n:5:3);
 Writeln(outfile,'Momentum Coefficient      : ',a:5:3);
 Writeln(outfile,'Total Error               : ',Toterror:10:6);
 Writeln(outfile);
 Writeln(OutFile,'     Hidden Layer Weights');
 writeln(outfile);

for i:=0 to 3 do
begin
  Writeln(outfile);
  Writeln(OutFile,'Weights for Hidden Layer Neuron No ',i);
    for j:=VectorBase to VectorMax do
       Writeln(outfile,HidLayer[i,j]:20:16);
End;

 Writeln(outfile);
 Writeln(OutFile,'     OutPut Layer Weights');
 writeln(outfile);

    for i:=BitBase to Bitmax do
    begin
    Writeln(outfile);
    Writeln(OutFile,'Weights for OutPut Layer Neuron No ',i);
      for j:=0 to 3 do
         Writeln(outfile,Olayer[i,j]:20:16);
    end;

Writeln(outfile);
Writeln(outfile,'For an Example of Input and Output Vectors run the program in training mode');

close(Outfile);

end;















(********************************)
(* Calculate the Nth power of 2 *)
(********************************)
Function Pow_2(X:Bit;n:BigBit):Byte;
var
   i     : integer;
   value : Byte;
begin
if x<>0 then
begin
  value:=1;
    for i:=1 to n do
      value:=value*2;
 Pow_2:=value;
end
 else
 Pow_2:=0;
end;







(**********************************************************************)
(* Given the Calculated output layer find the corresponding character *)
(**********************************************************************)
Function OutToChar(var Out:NetOutput):char;
var
   i     : integer;
   val   : Byte;
begin
val:=0;
   for i:=BitMax downto BitBase do
      Val:=Val+Pow_2(Out[i],7-i);
   OutTochar:=Chr(Val);
end;







(*********************************************************)
(* Read  from the font file the bits that comprise the   *)
(* data of the input layer                               *)
(*********************************************************)
procedure ReadInput(var a:BigBitArray);
var
    c        : byte;          (* read one byte at a time   *)
    infile   : text;          (* form this file            *)
    i,j,k    : integer;       (* using these indexes       *)
    bitfield : string[8];     (* the bitfield return value *)
    Dummy    : String[13];    (* get rid of the fancy stuff *)

begin                           (* of readinput *)
assign(infile,'b:asc8x8.fnt');  (* for an 8x8 bit matrix *)
reset(infile);

for i:=1 to (ord('0')) do
begin
readln(infile,dummy);
  for j:=1 to 8 do              { read all the values before the numeral 0 }
     readln(infile,bitfield);
end;

for i:=0 to 9 do                (* read the actual data *)
begin
Readln(infile,dummy);
 for j:=BitBase to BitMax do               { for 8 x 8 matrix }
  begin
   readln(infile,bitfield);
        for k:=1 to 8  do        (* assign the values to the input layer *)
                 a[i,j,K-1]:=Ord(BitField[k])-Ord('0');
  end;
end;
close(infile);    (* all done with our input *)
end; (*of readinput *)







(****************************************************)
(* Give them something on the screen to think about *)
(****************************************************)
procedure ShowThem(var a:BigBitArray);
var
   i,j,k:integer;
   dummy:string;
begin
clrscr;

gotoxy(25,2);
writeln('Back Propagation Network');
gotoxy(30,3);
writeln('Summer 1990');

gotoxy(1,1);

for i:=0 to 9 do                          (* print out the bit fields *)
  for j:=BitBase to BitMax  do
  begin
  if (i<=4)
   then
     gotoxy((i+1)*11,j+5)                 (* fancifully please,           *)
   else
      gotoxy(((i mod 5)+1)*11,(j+15));    (* otherwise why bother at all  *)
      for k:=BitBase to BitMax  do
          if (a[i,j,k]=1) then
             begin
                highvideo;                (* make the 1s fancier *)
                write(a[i,j,k]);
                lowvideo;
             end
          else
            write (a[i,j,k]);             (* make the 0s fade *)
    writeln;
  end;

gotoxy(15,23);
writeln('These are the Input Patterns to the Network ');
gotoxy(21,24);
Highvideo;
writeln('Press Enter to Continue ');
gotoxy(1,25);
write('Angelos Karageorgiou');
gotoxy(57,25);
write('<Voodoo Man>');
LowVideo;
gotoxy(45,24);
readln(dummy);
end;   (* of ShowThem *)





(**********************************************************************)
(* Initialize the input layer array values from the input array using *)
(* CurNumber for the next number Bitmap                               *)
(**********************************************************************)
procedure InitInput(var a:WeightVector; var Number:Currentnumber);
var
   inrow,incol:integer;
begin
  for inrow:=BitBase to BitMax do
     for incol:= BitBase to BitMax do
          a[inrow*8+incol]:=Input[Number,inrow,incol]; (* row wise *)
end;








(************************************)
(* Display the Forward pass results *)
(************************************)
Procedure DisplayResults(number:CurrentNumber);
var
   i,j,r,c:integer;

begin


    (* Display the current  Network Output And The Expected Output *)

HighVideo;
gotoxy(37,3);
Write('Network Output');
gotoxy(37,6);
Write('Logical Output');
LowVideo;
for i:=BitBase to Bitmax do
   begin
      r:=(i+3)*6;
      c:=7;
      IF NetOut[i]=1 then
         Highvideo;
      gotoxy(9+r-5,c);
      write(NetOut[i]:1);
      gotoxy(7+r-6,4);
      Write(Truenetout[i]:6:3);
      LowVideo;
   end;

HighVideo;
gotoxy(37,9);
Write('Expected Output ');
LowVideo;
for i:=BitBase to BitMax do
   begin
      r:=(i+3)*6;
      c:=10;
      IF Target[i]=1 then
         Highvideo;
      gotoxy(9+r-5,c);
      write(Target[i]:1);
      LowVideo;
   end;


end;




(**********************************************************)
(* Calculate the values for the forward pass of back prop *)
(**********************************************************)
Procedure ForwardPass(number:CurrentNumber);
Var
    i,j : integer;
   sum  : real;
begin
                  (* the folowing part can be parallelized *)
                  (* It is the standard back prop calculations *)
for i:=0 to 3 do
begin
sum:=0;
 for  j:=VectorBase to VectorMax do
 begin
      sum:=sum+HiddenLayer[i,j]*InputLayer[j];
 end;
      HidOut[i]:=1/(1+exp((-5*sum)));    (*  Now do the net transform *)
End;
     (* the -5 term is arbitrary and gives a nice region between 0 and 1 *)

for  i:=BitBase to BitMax do
begin
Sum:=0;
   For j:=0 to 3 do
   begin
      Sum:=Sum+OutLayer[i,j]*hidout[j];
   end;
      TrueNetOut[i]:=1/(1+exp((-5*Sum)));

     (* the -5 term is arbitrary and gives a nice region between 0 and 1 *)

      IF TrueNetOut[i]>=Threshold then
         NetOut[i]:=1
      else
         Netout[i]:=0;
   End;
end;





(*****************************************************)
(* Do the weight adjustment during the backward pass *)
(*****************************************************)
Procedure BackwardPass(number:currentnumber);
var
    i,j:integer;
    Sum,Temp,length,Delta:Real;
begin
(* Calculate the output layer Error *)
Error:=0;
For i:=bitBase to BitMax do
begin
   OutError[i]:=target[i]-truenetout[i];
   if OutError[i]<0 then
      Error:=error-OutError[i]
   else
      Error:=error+OutError[i];
end;
    Errors[number]:=error;


(* Calculate the sum of the (Deltas * weights) at the output layer *)
(* with the hidden layer error                                     *)

for i:=0 to 3 do
begin
Sum:=0;
  For j:=BitBase to BitMax do
    Sum:=Sum+outError[j]*OutLayer[j,i];
 HiddenError[i]:=(HidOut[i]*(1-HidOut[i])*Sum);
end;

(* Adjust the output layer weights *)


Length:=0;
For i:=0 to 3 do
   Length:=length+HidOut[i]*HidOut[i];

If length<0.1 then
   length:=0.1;

(* Adjust the output layer weights *)

For i:=bitbase to BitMax do
  for j:=0 to 3 do
  begin
    delta:=n*OutError[i]*hidOut[j]/length;
    OutLayer[i,j]:=OutLayer[i,j]+Delta+a*outWeightChange[i,j];
    OutWeightChange[i,j]:=delta;
end;

(* Adjust the hidden layer weights *)
Length:=0;
for I:=Vectorbase To VectorMax do
   Length:=Length+InputLayer[i]*InputLayer[i];

If Length<0.1 then
   Length:=0.1;

For i:=0 to 3 do
    For j:=Vectorbase to VectorMax do
    begin
       delta:=n*HiddenError[i]*InputLayer[j]/length;
       HiddenLayer[i,j]:=HiddenLayer[i,j]+delta+a*hiddenWeightchange[i,j];
       HiddenWeightChange[i,j]:=delta;
    end;
end;






(**************************************************************)
(* Convert the decimal number to a binary string of 0s and 1s *)
(**************************************************************)

function bin(a:integer):string;   (* only used for input reading *)
var
    i,rem,big:integer;
    c,s:string[8];

begin   (* of bin *)
{decimal to binary conversion returns a bit string }
s:='';
c:='';
big:=a;
rem :=a;
while big>0 do                     (*  decimal to binary conversion *)
 begin
  rem:=big mod 2;
  if rem>0 then s:=s+'1' else s:=s+'0';
  big:=big div 2;
 end;

 for i:=8 downto length(s) do
     s:=s+'0';           { fill up remaining spaces to reach the eighth bit }

 for  i:=1 to 8 do       { reverse the resulting string to get the normal }
 c:=c+s[9-i];
 bin:=c;
end; (* of bin *)













(**************************************)
(* Calculate  The target array values *)
(**************************************)
Procedure CalcTarget(number:currentnumber);
var
   i:integer;
   Tstring:string[8];
begin
Tstring:=bin(Ord('0')+number);
for i:=1 to 8 do
   if Tstring[i]='1'
   then
       Target[i-1]:=1
   else
       Target[i-1]:=0;
end;




(*************************************)
(* Check if the two arrays are equal *)
(*************************************)
Function Equal(Var a,b:NetOutput):boolean;
Var
    i      : integer;
    What,W : boolean;
Begin
What:=true;
W:=What;
For i:=BitBase to BitMax do
    Begin
       What:=a[i]=b[i];
       if (not What) then
           W:=False;
    end;
Equal:=w;
End;









(*****************************************************)
(* Show The Network's input layer in two forms        *)
(* The top one is the Vector as used by the network  *)
(* The bottom one is the one we humans use           *)
(*****************************************************)
Procedure ShowInputLayer;
var
     i,j:integer;
begin
        HighVideo;
        GotoXy(1,14);
        writeln(' Input  ');
          Write(' Layer  ');
        LowVideo;

        For i:=VectorBase To VectorMax do
        begin
           If InputLayer[i]=1 then
                Highvideo;
           Write(InputLayer[i]:1:0);
           LowVideo;
        end;
        Writeln;

        Gotoxy(1,5);
            For i:=Bitbase to bitMax do
            Begin
              For j:=Bitbase to Bitmax do
              begin
              if inputlayer[i*8+j]=1 then
                  Highvideo;
                    Write(inputlayer[i*8+j]:1:0);
                    LowVideo;
              End;
             if i<bitmax then
                Writeln;
           end;
end;







(**********************************)
(*  See if the network is trained *)
(**********************************)
Function AllEqual:boolean;
Var
       i : CurrentNumber;
      OK : Integer;
     j,k : integer;

begin
OK:=0;

for j:=1 to 25 do               (* tell them what we are doing *)
    begin
      HighVideo;
      gotoxy(74,j);
      write('TEST');
      Lowvideo;
    End;


  for i:=0 to 9 do
   begin
    InitInput(InputLayer,i);
    CalcTarget(i);



   ForwardPass(I);                  (* Even if one is wrong , continue *)

    ShowInputLayer;
    DisplayResults(I);

    If (Equal(Target,Netout)) then
        OK:=Ok+1;
   end;
AllEqual:=OK=10;

For j:=1 to 25 do      (* Erase the 'TEST display *)
    begin
      gotoxy(74,j);
      for k:=0 to 3 do
        write(' ');
    end;

end;










(******************************************************************)
(* The main  Back Prop training routine that acts as a driver for *)
(* everything else that is going on                               *)
(******************************************************************)
procedure TrainNet;
Var
    I,j:integer;
    Number :CurrentNumber;
begin     (* of the TrainNet procedure *)
clrscr;
Pass:=0;
Number:=0;




While  (not AllEqual)  do

   (* All The Patterns have to be learned *)

begin
 Pass:=Pass+1;
 gotoxy(35,24);
 highvideo;
 write('Pass:');
 Lowvideo;
 gotoxy(40,24);
 Write(Pass:5:0);
   For Number := 0   to  9  do   (* the Whole Range of digits *)
    Begin
      CalcTarget(number);
      InitInput(InputLayer,Number);
      ForwardPass(Number);
      ShowInputLayer;
      DisplayResults(number);
      BackwardPass(number);

             (* Display the Error *)

             gotoxy(26,19);
             highVideo;
             write('Error for Pattern ',number:1,': ',Error:10:8);
             LowVideo;
    end;

     (* Calculate and Display the Total Error *)
TotError:=0;
 for i:=0 to 9 do
    Toterror:=Toterror+errors[i];

        gotoxy(22,21);
        highVideo;
        write('Total Error Previous Pass : ',TotError:10:8);

end;

end;







(**************************************************************************)
(* Display a Number's bit field and alter it so that we can later feed it *)
(* to the network and get results                                         *)
(**************************************************************************)
procedure  AlterBitField(var A:BigBitArray; Number :CurrentNumber);
Var
    Continue        : string[8];
    row,col         : integer;
    Rowchar,Colchar : char;



procedure DispBitField;
Var
    i,j             : integer;

begin
gotoxy(1,1);
    write('r/c� ');
    for i:=0 to 7 do
    Begin
      write(i);
      Write(' � ');
    End;
      writeln;
      writeln('����������������������������������͵');

    for i:=0 to 6 do
    begin
    write(i:2);
    Write(' � ');
       for j:=BitBase to BitMax do
       begin
        if  A[number,i,j]=1 then
           HighVideo;
         write(a[number,i,j]);
         LowVideo;
         write(' � ');
       end;
      writeln;
      writeln('����������������������������������Ĵ');
    end;

    i:=i+1;
    write(i:2,' � ');
    for j:=BitBase to BitMax do
       begin
        if  a[number,i,j]=1 then
           HighVideo;
         write(a[number,i,j]);
         LowVideo;
         write(' � ');
       end;
       writeln;
      writeln('������������������������������������');
end;  (* OF DispBitField *)

begin (* OF AlterBitField *)
gotoxy(5,24);
HighVideo;
Writeln('You can use this screen to Change cell values from 0 to 1 and vice versa');
LowVideo;
gotoxy(1,25);
Write('Angelos Karageorgiou');
gotoxy(70,25);
write('Voodoo Man');
DispBitField;               (* Show Them What We have now *)
(***************************************************************************)
(*                               INSTRUCTIONS                              *)
(* The character 'Y' has to be typed in  to continue.Any numerical input   *)
(* of more than two numbers wide will default to the first number's or     *)
(* character's if you wish value. Any Illegal entry is reentered.Any legal *)
(* entry Toggles the value of the associated cell just like a binary not   *)
(*   One Last Thang. The Program remembers all the changes so if you alter *)
(* something to much and you want its original form make sure you remember *)
(* it yourself                                                             *)
(***************************************************************************)
Continue:='Y';           (* More tricks of the trade *)
While ( (Continue='Y') or (Continue='y') ) do
    begin
       gotoxy (40 ,5);
       write('Alter some values? (YES/NO)           ');
       gotoxy (70,5);
       readln(Continue);
       if ( (Continue='Y') or (Continue='y') ) then
       begin
           row:=8;
           while ( (row<0) or (row>7) ) do
           begin
               gotoxy (40 ,7);
               write('Give me the row Number (0..7)        ');
               gotoxy(70,7);
               readln(RowChar);
               Row:=Ord(RowChar)-Ord('0');
           end;
           Col:=8;
           while ( (Col<0) or (Col>7) ) do
           begin
               gotoxy (40 ,9);
               write('Give me the column Number (0..7)         ');
               gotoxy(73,9);
               readln(ColChar);
               Col:=Ord(ColChar)-Ord('0');
           end;
       end;
       if ( (Continue='Y') or (Continue='y') ) then
          if A[Number,row,col]=0
             then
                 A[Number,row,col]:=1
             else
                 A[Number,row,col]:=0;
      DispBitField;                   (* Show 'em what's going on *)
    end;
end;








(******************************************************************)
(* The main  Back Prop testing  routine that acts as a driver for *)
(* everything else that is going on                               *)
(******************************************************************)
procedure TestNet;
var
   result   : char;
   Numeral  : char;
   Reply    : Char;
   Number   : CurrentNumber;

begin
ThreShold:=0.7;
ClrScr;
Reply:='Y';
While ( (Reply='Y') or (Reply='y')) do
begin
 Numeral:='a';
 While ((Numeral<'0') or (Numeral>'9')) do
  begin
    gotoxy (10,23);
    write ('Which numeral Do you want to test the network for ? (0..9)             ');
    gotoxy(70,23);
    readln(numeral);
  end;

  gotoxy(10,20);
  Writeln('                                                   ');

 clrscr;                             (* Tricks of the trade *)
 Number:=Ord(Numeral)-Ord('0');
 AlterBitField(Input,Number);
  InitInput(InputLayer,Number);       (* Give the corresponding input layer *)
 ForwardPass(number);
 Result:=OutToChar(NetOut);
 writeln('The expected Numeral is',number:2);
 writeln('The calculated numeral is ',result);
 Write('Continue ? (Y/N) ');
 Readln (Reply);
end;
end;




 (***************************************************************************)
 (* Does the user want to retrain the network or keep the Previous values ? *)
 (***************************************************************************)
 Procedure Retrain(var HidLayer : Hiddlayer; var OLayer  : OutputLayer);
 label
       again,out;
 Var
     i,j,weight : integer;
     Answer: char;
     Infile: text;

 begin

 again:
 Clrscr;
 gotoxy(10,10);
 HighVideo;
 write('R');
 Lowvideo;
 write('etrain network or ');
 HighVideo;
 Write('L');
 Lowvideo;
 Write('oad old weight values (R/L) ? ');
 readln(answer);

 If ((Answer='R') or (Answer='r')) then
    Begin
          Initialize(InputLayer,Hiddenlayer,OutLayer,NetOut);
          TrainNet;
          SaveValues(HiddenLayer,OutLayer);                                               Goto out;
    End;

 If  ((Answer<>'L') and (Answer<>'l')) then
    goto again;
 (* Load Network Weights *)
 GotoXY(25,18);

 Write('Please wait  Loading ');
    HighVideo;
 Write('288 ');
   LowVideo;
 Write('weights');

 gotoxy(30,24);
 Write('Now Loading Number : ');
 Weight:=0;
 HighVideo;
 Assign(infile,'b:bp4weigh.dat');
 reset(infile);

     for i:=0 to 3 do
          for j:=VectorBase to VectorMax do
          begin
             Readln(infile,HidLayer[i,j]);
             Weight:=Weight+1;
             gotoxy(52,24);
             Writeln(weight);
          end;
     for i:=BitBase to Bitmax do
       for j:=0 to 3 do
       begin
             Readln(infile,Olayer[i,j]);
             Weight:=Weight+1;
             gotoxy(52,24);
             Writeln(weight);
          end;

  LowVideo;
 close(infile);
 Out:
 end;









(***************************************************)
(* The main program is here. Not big but essential *)
(***************************************************)
begin
  clrscr;
  Threshold  := 0.9;
  readinput(Input);
  Showthem(Input);
  clrscr;
  Retrain(HiddenLayer,OutLayer);
  TestNet;
  clrscr;
  Gotoxy(20,1);
  Writeln('Thank you for using this Program');
  Writeln('I hope it was helpful and enlightening for understanding');
  highvideo;
  writeln('     Back Propagation Neural Networks ');
  lowvideo;
end.





