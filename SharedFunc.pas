unit SharedFunc; //����� ������, ���������, �������

interface

uses Classes, Contnrs;

const
    MaxKeyLength = 7;  //����� ����� � ������ �� 32 ����
//����������, � ����� ���� ���������� 32 ������ ����
		FmtBinary 	 = 0;
		FmtHex       = 1;
		FmtAlpha     = 2;

//��� ����������� ��������, ������� ���� ��������� ��� ������� ������
    peS1kIn   = 20;
    peS1kOut  = 21;
    peSjIn    = 22;
    peSjOut   = 23;
    peEnd     = 26;

type
    CrBlock = array [0..1] of Cardinal; //64-� ������ ����
		TKey    = array [0..MaxKeyLength] of Cardinal; //��� �����
    TChTab = array [0..63] of Byte; //��� ������� �����
    TChReg = (RPZ, RG, RGOS, RIV);   //��� ������ (���)���������� 

    type TFKey = record //������ ������ �����
       Key : TKey;//����
       VType: Boolean; //True - Alpha; False - Hex
     end;

var
    ChTab : array [0..15,0..7] of Byte; //������� �����
    MainKey : TKey; //����
    SourceStream, DestStream : TMemoryStream; //������ �������� � ������������� ������

    ListChanges : TBucketList; //������������ ��� �������� ���� � ����������� ���������� �
                               //���������� ������. ������������ ����� ��� ���������.

function ROL(val: LongWord; shift: Byte): LongWord; assembler;

function IntToBin(Value: cardinal): string;

function HexToInt(s : String) : Cardinal;

function CardinalToFmtStr(c : Cardinal; Fmt : Integer): String;

function SumMudule2(x1, x2: cardinal):Cardinal;

procedure SynchrPos(var syn: CrBlock; lkey:TKey);

implementation

uses SysUtils, Math, main;

//����������� ����� �����
function ROL(val: LongWord; shift: Byte): LongWord; assembler;
asm
	mov  eax, val;
	mov  cl, shift;
	rol  eax, cl;
end;

//�������������� 32-������� ����� � ��������� ��� (4 ������� �� 8 ���)
function IntToAlpha(c : Cardinal): String;
type CAlpha = array[0..3] of Char;
var i : Integer;
begin
	Result:= '';
	for i:= 0 to 3 do
	begin
    if Byte(CAlpha(c)[i]) >= 32 then //���� ������, ����� ��� �� �����
		  Result:= Result + CAlpha(c)[i]
    else
      Result:= Result + '#';
	end;
end;

//�������������� ����� � �������� �����
function IntToBin(Value: cardinal): string;
var
  i: Integer;
begin
  SetLength(result, 32);
  for i := 1 to 32 do
  begin
    if ((Value shl (i - 1)) shr 31) = 0 then
      result[i] := '0'
    else
      result[i] := '1';
  end;
end;

//�������������� ����� � ����������������� �����
function HexToInt(s : String) : Cardinal;
var
    i: Integer;
    bit4 : Byte;
begin
  Result:= 0;
  for i:= 1 to Min(8, Length(s)) do
  begin
    case s[i] of
    '0'..'9' : bit4:= Byte(s[i]) - Byte('0');
    'A'..'F' : bit4:= Byte(s[i]) - $37; //����� ��� A bit4 = 10
    else
      bit4:= 0;
    end;
    Result:= Result or (bit4 shl (32 - 4*i));
  end;
end;

//�������������� ����� � ������ �����
function CardinalToFmtStr(c : Cardinal; Fmt : Integer): String;
begin
	case Fmt of
		FmtBinary : Result:= IntToBin(c);
		FmtHex : Result:= IntToHex(c, 8);
		FmtAlpha : Result:= IntToAlpha(c);
	else
		Result:= IntToHex(c, 8);
	end;
end;

function SumMudule2(x1, x2: cardinal):Cardinal;
var s1,s2: string;
    i: word;
    a: cardinal;
begin
 s1:=IntToBin(x1);
 s2:=IntToBin(x2);
 a:=0;
 for i:=1 to Length(s1) do
  begin
   if s1[i]=s2[i] then s1[i]:='0'
    else s1[i]:='1';
   a:=a+round(StrToInt(s1[i])*power(2,Length(s1)-i))
   end;
  Result:=a;
end;

{��������� ��������� �������������}
procedure SynchrPos(var syn: CrBlock; lkey:TKey);
var s, st, str, sync: string;
    i, j, k, sm: word;
    a: Extended;
begin
 sync:=''; a:=0;
 for i:= 0 to length(lKey)-1 do
  begin
    st:=''; str:='';
    s:=InttoBin(lKey[i]);
    for j:= 0 to 7 do
     begin
      sm:=0;
      st:=Copy(s,j*4+1,4);
      for k:=1 to 4 do
       if st[k]='1' then inc(sm);
      if sm mod 2 = 0 then str:=str+'0' else str:=str+'1';
     end;
   sync:=sync+str;
  end;
  for i:=1 to (length(sync)div 2) do
   begin
     syn[0]:=syn[0]+round(StrToInt(sync[i])*power(2,i-1));
     syn[1]:=syn[1]+round(StrToInt(sync[i*2])*power(2,i-1));
   end;
     syn:=SyncrManual;
end;


var i : Integer;
initialization //�������������
  for i:=0 to MaxKeyLength do
		MainKey[i]:= 0;

  SourceStream:= TMemoryStream.Create;
  DestStream:= TMemoryStream.Create;
  ListChanges:= TBucketList.Create;

finalization //������������ ��������
  SourceStream.Free;
  DestStream.Free;
  ListChanges.Free;
end.
