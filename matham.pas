unit matham;

interface

uses math, SysUtils;

 type
   TCompare = (Ls, Mr, Eq);
   TSign = (negative , posetive);
   TBigInt = Record
      Sign : TSign;
      Number : Array Of byte;
   End;


 procedure XMulY(Const x, y: TBigInt; Var z: TBigInt);
 procedure XModY(Const x, y: TBigInt; Var z: TBigInt);
 function STRHexToInt(s : String) : Cardinal;
 procedure XpowerYmodN(Const x, y, n: TBigInt; var z: TBigInt);
 function XCompareY(Const x, y: TBigInt): TCompare;
 procedure NODXY(Const x, y :TBigInt; Var z:TBigInt);
 procedure XsumY(Const x, y :TBigInt; Var z:TBigInt);
 function IsPrime(n: integer): boolean ;
 function Generate(n: integer):integer ;
 function GenOneProst: integer;
 procedure RandomBig(Const j: Cardinal; var x: TBigInt);
 procedure DestroyX(Var x: TBigInt);
 procedure XCopyY(Const x: TBigInt; var y: TBigInt);
 procedure StrtoBigInt(Var Str: String; Var x: TBigInt);
 procedure BigInttoStr(Const x: TBigInt;Var Str: string);
 procedure ClearNulls(Var x: TBigInt);
 procedure XsubY(Const x, y :TBigInt; Var z:TBigInt);
 procedure DectoBigHex(Const x: integer; Var z:TBigInt);
 procedure XdivY(Const x, y: TBigInt; Var v, z: TBigInt);
 procedure InvX(Var x: TBigInt);
const syssch = 16;
      ND=6;
implementation


procedure XMulY(Const x, y: TBigInt; Var z: TBigInt);
var  mul, sum, fl: word;
     i, j, k, sizeX, sizeY: cardinal;
begin
sizeX:=Length(x.Number);
sizeY:=Length(y.Number);
i:=sizeX+sizeY;
SetLength(z.Number,i);
for j:=0 to sizeY-1 do
 for i:=0 to sizeX-1 do
  begin
   mul:=x.Number[i]*y.Number[j];
   k:=i+j;
  if mul div syssch <>0
   then sum:= mul mod syssch
   else sum:= mul;
   fl:= mul div syssch;
    z.Number[k]:=z.Number[k]+sum;
    if z.Number[k] div syssch <> 0
     then
      begin
       fl:=fl+z.Number[k] div syssch;
       z.Number[k]:= z.Number[k] mod syssch;
      end;

   repeat
     z.Number[k+1]:=z.Number[k+1]+fl;
     if z.Number[k+1] div syssch <> 0
      then
      begin
       fl:=z.Number[k+1] div syssch;
       z.Number[k+1]:=z.Number[k+1] mod syssch;
       end
      else fl:=0;
      k:=k+1;
     until fl = 0  ;
 end;
 ClearNulls(z);
end;


procedure XmodY(Const x, y: TBigInt; Var z: TBigInt);
 Var i, j, k, r: cardinal;
     fl, val:byte;
     ost,temp: TBigInt;
begin
   i:=0;
   XCopyY(x,z);
   XCopyY(y,temp);
   setlength(temp.Number,length(temp.Number)+1);
   setlength(z.Number,length(z.Number)+1);
   if length(z.Number)>=length(temp.Number) then
  begin
   setlength(ost.Number,length(temp.Number));
   k:=high(z.Number); r:=high(temp.Number);
   repeat
    fl:=0;
    for j:=0 to high(temp.Number) do
     begin
      val:=z.Number[k-i-r+j]-temp.Number[j]-fl;
      if val>syssch-1 then
       begin
        val:=syssch+z.Number[k-i-r+j]-temp.Number[j]-fl;
        fl:=1
       end
      else fl:=0;
       ost.Number[j]:=val;

     end;
    if fl=0 then
     for j:=0 to high(ost.Number) do
      begin
       z.Number[k-i-r+j]:=ost.Number[j];
      end
    else i:=i+1;

   until i=length(z.Number)-high(temp.Number);
  end;
  DestroyX(ost);
  DestroyX(temp);
  ClearNulls(z);
 end;


 function STRHexToInt(s : String) : Cardinal;
var
    i: Integer;
    bit4 : Byte;
begin
  Result:= 0;
  for i:= 1 to Length(s) do
  begin
    case s[i] of
    '0'..'9' : bit4:= Byte(s[i]) - Byte('0');
    'A'..'F' : bit4:= Byte(s[i]) - $37; //Чтобы при A bit4 = 10
    else
      bit4:= 0;
    end;
    Result:= Result or (bit4 shl (4*(Length(s) - i)));
  end;
end;

procedure XpowerYmodN(Const x, y, n: TBigInt; var z: TBigInt);
Var xx, yy, nn, xsum, one,nul, temp: TBigInt;
    j,i,k, sizeX, sizeY, sizeZ: cardinal;
    s: string;
begin
 XCopyY(x,xx);
 XCopyY(y,yy);
// XCopyY(n,nn);
 sizeX:=Length(xx.Number);
 sizeY:=Length(yy.Number);
 s:='0';
 StrtoBigInt(s,nul);
 s:='1';
 StrtoBigInt(s,one);
 if (XCompareY(yy,one)=Eq) and (XCompareY(yy,one)=ls)
  then
   begin
    if XCompareY(yy,one)=Eq
     then
      begin
       setlength(z.Number,sizeX);
       XCopyY(xx,z);
      end
     else
      begin
       setlength(z.Number,1);
       z.Number[0]:=1;
      end;
   end
  else
   begin
    DestroyX(xsum);
    setlength(xsum.Number,sizeX);
    XCopyY(xx,xsum);
    repeat
     setlength(z.Number,0);
     k:=length(xsum.Number)+sizeX;
     SetLength(z.Number,k);
     XMulY(xsum,xx,z);
     XCopyY(z, temp);
     XmodY(temp,n,z);
     sizeZ:=length(z.Number);
     setLength(xsum.Number, sizeZ);
     XCopyY(z,xsum);
     XSubY(yy,one,temp);
     XCopyY(temp,yy);
    until XCompareY(yy,one)=Eq;
    DestroyX(xsum);
    DestroyX(xx);
   end;
    DestroyX(xsum);
    DestroyX(xx);
    DestroyX(yy);
end;


function XCompareY(Const x, y: TBigInt): TCompare;
var fl, c: byte;
    k,i: cardinal;
    j: integer;
begin
 fl:=0; c:=0;
 if length(x.Number)>length(y.Number) then Result:=Mr
  else
   if length(x.Number)<length(y.Number) then Result:=Ls
    else
     begin
      k:=length(x.Number);
      for i:=0 to k-1 do
       begin
        j:=x.Number[i]-y.Number[i]-fl;
        fl:=0;
        if j<0 then
          begin
            j:=syssch-x.Number[i]-y.Number[i]-fl;
            fl:=1;
          end;
        if j<>0 then c:=1;
       end;
   if fl=1 then Result:=Ls
    else
     if (fl=0) and (c=1) then Result:=Mr
      else Result:=Eq;
     end;
end;

{Наибольший общий делитель}
procedure NODXY(Const x, y : TBigInt; var z: TBigInt);
var nul, tempX, tempY: TBigInt;
    s: string;
begin
s:='0';
StrtoBigInt(s,nul);
XCopyY(x,tempX);
XCopyY(y,tempY);
while (XCompareY(tempX,nul)<>Eq ) and (XCompareY(tempY,nul)<>Eq) do
 begin
  if (XCompareY(tempX,tempY)=Mr)or(XCompareY(tempX,tempY)=Eq) then
   begin
    XmodY(tempX,tempY,z);
    XCopyY(z,tempX);
   end
   else
    begin
     XmodY(tempY,tempX,z);
     XCopyY(z,tempY);
    end;
 end;
 DestroyX(z);
 XsumY(tempX,tempY,z);
end;

{Суммирование}
procedure XsumY(Const x, y :TBigInt; Var z:TBigInt);
var fl,a,b:byte;
    i, sizeX, sizeY, sizeZ: Cardinal;
begin
 fl:=0;
 sizeX:=length(x.Number);
 sizeY:=length(y.Number);
 if sizeX>sizeY then SetLength(z.Number,sizeX)
  else SetLength(z.Number,sizeY);
 sizeZ:=length(z.Number);
 for i:=0 to sizeZ-1 do
  begin
   if i>high(x.Number) then a:=0 else a:=x.Number[i];
   if i>high(y.Number) then b:=0 else b:=y.Number[i];
   z.Number[i]:=a+b+fl;
   if z.Number[i]>=syssch then
    begin
     z.Number[i]:=a+b+fl-syssch;
     fl:=1;
    end
    else fl:=0;
  end;
 if fl=1 then
  begin
   setLength(z.Number,sizeZ+1);
   z.Number[sizeZ]:=1;
  end;
end;

function IsPrime(n: integer): boolean ; // для n >= 4
var i, j, h: integer;
begin
h := trunc(sqrt(n)) + 1 ;
i := 2 ; j := h ; //ограничение перебора
while i <> j do
if n mod i = 0 then j := i //если n делится на i то, n не простое
else
 if i=3 then inc(i,2) else inc(i) ;
IsPrime := (i = h)
end; // IsPrime

function Generate(n: integer):integer ;
var first, i, {s,} f, k : integer ;
const syss = 10;
begin
first := 1 ; k:=0;
for i := 1 to pred(ND) do first := syss*first ; // first = 10^(ND-1)
 i:= first+1;
 while i <> pred(syss*first) do
  if IsPrime(i) then
   begin
    f := i ; //s := i mod syssch ;
    while f >= syss do
     begin
      f := f div syss ;
      //s := s + f mod syssch;
     end ; //S = сумма цифр; f = первая цифра
     if n=k then
      begin
       Result:= i;
       break;
      end;
     k:=k+1;
     inc(i,2);
     //result:=k;
     end // if
   else inc(i,2);
end; // Generate

function GenOneProst: integer;
Const n1=143;
      n2=21;
var n, i, a1, a2: integer;
begin
 a1:=n1; a2:=n2;
 for i:=1 to ND-3 do
  begin
   n:=trunc(exp(2*ln(a1)-ln(a2)+0.06));
   a2:=a1; a1:=n;
  end;
n:=random(n);
Result:=generate(n);
end;


procedure RandomBig(Const j: Cardinal; var x: TBigInt);
var i,k: Cardinal;
    fl: boolean;
    a:byte;
begin
 fl:=false;
 if j<>0 then
  begin
   k:=j-1;
   Setlength(x.Number,j);
   for i:=0 to k do
    x.Number[i]:=syssch-1;
  end
  else k:=high(x.Number);

 for i:= k downto 0 do
  begin
   a:=random(x.Number[i]);
   if a<>x.Number[i] then fl :=true;
   if fl=false then x.Number[i]:=a
    else
     if i=0 then x.Number[i]:=random(Syssch-1)
      else x.Number[i]:=random(Syssch-1);
  end;
end;

// Удаление числа x из памяти
procedure DestroyX(Var x: TBigInt);
 begin
  X.Number := Nil;
 end;

//Копирование числа X в число Y
procedure XCopyY(Const x: TBigInt; var y: TBigInt);
var size: cardinal;
 begin
   Y.Sign := X.Sign;
   Y.Number := Nil;
   size:= length(X.Number);
   Y.Number := Copy(X.Number, 0, size);
 end;

//Преобразование строки в число
procedure StrtoBigInt(Var Str: String; Var x: TBigInt);
var
  i, size : longint;
begin
  While (Not (Str[1] In ['-', '0'..'9', 'A'..'F'])) And (length(Str) > 1) Do
      delete(Str, 1, 1);
   If copy(Str, 1, 1) = '-' Then
   Begin
      X.Sign := negative;
      delete(Str, 1, 1);
   End
   Else X.Sign := posetive;
  While (length(Str) > 1) And (copy(Str, 1, 1) = '0') Do delete(Str, 1, 1);
  size:=length(str);
  SetLength(X.Number, size);
  For i:=0 to size-1 do
   if byte(str[size-i])<=57 then X.Number[i]:=StrToInt(str[size-i])
    else X.Number[i]:= byte(Str[size-i])-$37;
  str:='';
end;

procedure BigInttoStr(Const x: TBigInt;Var Str: string);
var
  i, size: Cardinal;
begin
  size:=length(x.Number);
  for i:= size-1 downto 0 do
   if x.Number[i]<=9 then Str:=Str+IntToStr(x.Number[i])
    else Str:=str+Chr(x.Number[i]+$37); ;
end;

procedure ClearNulls(Var x: TBigInt);
Var
  i,sizeX: Cardinal;
begin
 sizeX:=Length(x.Number);
 i:=sizeX-1;
 while (x.Number[i]=0)and(sizeX<>1) do
  begin
   dec(sizeX);
   setLength(x.Number,sizeX);
   dec(i);
  end;
end;

procedure XsubY(Const x, y :TBigInt; Var z:TBigInt);
Var
  i, j,sizeX,sizeY: Cardinal;
  fl, a, b: Byte;
begin
 sizeX:=length(x.Number);
 sizeY:=length(y.Number);
 if sizeX>sizeY then i:=sizeX
  else i:=sizeY;
 setLength(z.Number,i);
 fl:=0;
 for j:=0 to i-1 do
  begin
   if j>sizeX-1 then a:=0 else a:=x.Number[j];
   if j>sizeY-1 then b:=0 else b:=y.Number[j];
   if a>=(b+fl) then
    begin
     z.Number[j]:=a-b-fl;
     fl:=0;
    end
    else
     begin
      z.Number[j]:=syssch+a-b-fl;
      fl:=1;
     end;
  end;
ClearNulls(z);
if fl=1 then
 begin
  z.Sign:=negative;
  for i:= 0 to high(z.Number) do
   begin
    if i>0 then fl:=1 else fl:=0;
    z.Number[i]:=syssch-z.Number[i]-fl;
   end;
 end;
end;

procedure DectoBigHex(Const x: integer; Var z:TBigInt);
Var xx, i : integer;
begin
 i:=0; xx:=x;
 while xx<>0 do
  begin
   setLength(z.Number,i+1);
   z.Number[i]:=xx mod 16;
   inc(i);
   xx:= xx div 16;
  end
end;

procedure XdivY(Const x, y: TBigInt; Var v, z: TBigInt);
 Var i, j, k, r: cardinal;
     fl, val, flag, l :byte;
     ost,temp: TBigInt;
begin
   i:=0; flag:=0; l:=0;
   XCopyY(x,z);
   XCopyY(y,temp);
   setlength(temp.Number,length(temp.Number)+1);
   setlength(z.Number,length(z.Number)+1);
   SetLength(v.Number,1);
   if length(z.Number)>=length(temp.Number) then
  begin
   setlength(ost.Number,length(temp.Number));
   k:=high(z.Number); r:=high(temp.Number);
   if length(z.Number)<>length(temp.Number) then
    setlength(v.Number,k);
   repeat
    fl:=0;
    for j:=0 to high(temp.Number) do
     begin
      val:=z.Number[k-i-r+j]-temp.Number[j]-fl;
      if val>syssch-1 then
       begin
        val:=syssch+z.Number[k-i-r+j]-temp.Number[j]-fl;
        fl:=1;
       end
      else fl:=0;
       ost.Number[j]:=val;
     end;
    if fl=0 then
     begin
       v.Number[i]:=v.Number[i]+1;
      for j:=0 to high(ost.Number) do
       begin
        z.Number[k-i-r+j]:=ost.Number[j];
       end;
      end
    else i:=i+1;
   until i=length(z.Number)-high(temp.Number);
  end;
  DestroyX(ost);
  DestroyX(temp);
  ClearNulls(z);
  InvX(v);
 end;


procedure InvX(Var x: TBigInt);
var temp: TBigInt;
    i,j: cardinal;
 begin
 j:=high(x.Number);
 setlength(temp.Number,j+1);
  For i := j downto 0 do
   temp.Number[j-i]:=x.Number[i];
  ClearNulls(temp);
  XCopyY(temp,x);
 end;
end.
