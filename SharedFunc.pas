unit SharedFunc; //Общие данные, процедуры, функции

interface

uses Classes, Contnrs;

const
    MaxKeyLength = 7;  //Длина ключа в блоках по 32 бита
//Определяет, в каком виде отобразить 32 битный блок
		FmtBinary 	 = 0;
		FmtHex       = 1;
		FmtAlpha     = 2;

//Для определения действий, которые надо выполнять при нажатии кнопки
    peS1kIn   = 20;
    peS1kOut  = 21;
    peSjIn    = 22;
    peSjOut   = 23;
    peEnd     = 26;

type
    CrBlock = array [0..1] of Cardinal; //64-х битный блок
		TKey    = array [0..MaxKeyLength] of Cardinal; //Тип ключа
    TChTab = array [0..63] of Byte; //Тип таблицы замен
    TChReg = (RPZ, RG, RGOS, RIV);   //Тип режима (рас)шифрования 

    type TFKey = record //Формат записи файла
       Key : TKey;//Ключ
       VType: Boolean; //True - Alpha; False - Hex
     end;

var
    ChTab : array [0..15,0..7] of Byte; //Таблица замен
    MainKey : TKey; //Ключ
    SourceStream, DestStream : TMemoryStream; //Потоки исходных и зашифрованных данных

    ListChanges : TBucketList; //Предназначен для хранения мест и содержимого измененных в
                               //шивртексте байтов. Используются также для подсветки.

function ROL(val: LongWord; shift: Byte): LongWord; assembler;

function IntToBin(Value: cardinal): string;

function HexToInt(s : String) : Cardinal;

function CardinalToFmtStr(c : Cardinal; Fmt : Integer): String;

function SumMudule2(x1, x2: cardinal):Cardinal;

procedure SynchrPos(var syn: CrBlock; lkey:TKey);

implementation

uses SysUtils, Math, main;

//Циклический сдвиг влево
function ROL(val: LongWord; shift: Byte): LongWord; assembler;
asm
	mov  eax, val;
	mov  cl, shift;
	rol  eax, cl;
end;

//Преобразования 32-битного числа в текстовый вид (4 символа по 8 бит)
function IntToAlpha(c : Cardinal): String;
type CAlpha = array[0..3] of Char;
var i : Integer;
begin
	Result:= '';
	for i:= 0 to 3 do
	begin
    if Byte(CAlpha(c)[i]) >= 32 then //Есть момент, когда это не нужно
		  Result:= Result + CAlpha(c)[i]
    else
      Result:= Result + '#';
	end;
end;

//Преобразование числа в двоичную форму
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

//Преобразование числа в шестнадцатеричную форму
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
    'A'..'F' : bit4:= Byte(s[i]) - $37; //Чтобы при A bit4 = 10
    else
      bit4:= 0;
    end;
    Result:= Result or (bit4 shl (32 - 4*i));
  end;
end;

//Преобразование числа в НУЖНУЮ форму
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

{Генерация начальной синхропосылки}
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
initialization //Инициализация
  for i:=0 to MaxKeyLength do
		MainKey[i]:= 0;

  SourceStream:= TMemoryStream.Create;
  DestStream:= TMemoryStream.Create;
  ListChanges:= TBucketList.Create;

finalization //Освобождение ресурсов
  SourceStream.Free;
  DestStream.Free;
  ListChanges.Free;
end.
