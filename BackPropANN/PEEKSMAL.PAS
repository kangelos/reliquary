{ copyright march 1990 Angelos Karageorgiou
  this program dump the font files to the screen
  so that one can see the bitmap of the characters}



program peek;

uses crt;
var c     : char;
    inf   : text;
    i,j   : integer;
    dummy : string;

function bin(a:integer):string;
var
    i,rem,big:integer;
    c,s:string[8];

begin
{decimal to binary conversion returns a bit string }
s:='';
c:='';
big:=a;
rem :=a;
while big>0 do
 begin
  rem:=big mod 2;
  if rem>0 then s:=s+'#' else s:=s+'.';
  big:=big div 2;
 end;

 for i:=8 downto length(s) do
     s:=s+'.';           { fill up remaining spaces to reach the eighth bit }

 for  i:=1 to 8 do       { reverse the resulting string to get the normal }
 c:=c+s[9-i];
 bin:=c;
end;

begin
clrscr;
assign(inf,'b:set8x8.fnt');
reset(inf);
for i:=0 to 255 do
begin
 for j:=1 to 8 do       { for 8 x 8 matrix }
  begin
   read(inf,c);
   writeln('                     ',bin(ord(c)));
  end;
 writeln;
 write('Press return to continue or type "end" to stop program ');
 readln(dummy);
 if dummy='end' then begin close(inf); halt; end;
 clrscr;
end;
close(inf);
end.