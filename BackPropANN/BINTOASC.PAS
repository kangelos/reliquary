Program bintoascii;
uses crt;
type
     byte=0..255;


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






(*********************************************************)
(* Read  from the font file the bits that comprise the   *)
(* data of the input layer                               *)
(*********************************************************)
procedure ReadInput;
var
    c        : byte;          (* read one byte at a time   *)
    infile   : file of byte;  (* form this file            *)
    i,j,k    : integer;       (* using these indexes       *)
    bitfield : string[8];     (* the bitfield return value *)
    Outfile  : text;
begin                           (* of readinput *)
assign(infile,'b:set8x8.fnt');  (* for an 8x8 bit matrix *)
reset(infile);
assign(outfile,'b:asc8x8.fnt');
rewrite(outfile);
for i:=0 to 255 do                (* read the actual data *)
begin
Writeln(outfile,'character ',i:3);
 for j:=1 to 8 do               { for 8 x 8 matrix }
  begin
   read(infile,c);
   BITFIELD:=bin(ord(c));
        for k:=1 to 8  do        (* assign the values to the input layer *)
            Write(outfile,bitfield[k]);
   Writeln(outfile);;
  end;
end;
close(infile);    (* all done with our input *)
close(outfile);
end; (*of readinput *)




begin
  clrscr;
  ReadInput;
end.

