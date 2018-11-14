unit Geerate;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, Menus, ComCtrls, Mask, Buttons, ScktComp, matham, netparam,
  SharedFunc, ExtCtrls, Math, DES, KOLBlockCipher, UMathServices;
type
  SaveToFile = Record
      s:string[255];
  end;
type
  TKripto = class(TForm)
    HexKeyW: TLabel;
    BinKeyW: TLabel;
    HexKey: TEdit;
    BinKey: TEdit;
    InFo: TMemo;
    Label3: TLabel;
    Menu: TMainMenu;
    N1: TMenuItem;
    GenANSIX9171: TMenuItem;
    N4: TMenuItem;
    ThreeStageTest: TMenuItem;
    DecKeyW: TLabel;
    GenIntel: TMenuItem;
    LengthW: TLabel;
    Length_Of_Key: TEdit;
    GenRC4: TMenuItem;
    KnutsTest: TMenuItem;
    N7: TMenuItem;
    SaveToBinary: TMenuItem;
    SaveToText: TMenuItem;
    PathAutoSave: TMenuItem;
    DecKey: TEdit;
    Saver: TSaveDialog;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    procedure GenANSIX9171Click(Sender: TObject);
    procedure ThreeStageTestClick(Sender: TObject);
    function  IntToBin2(d: Int64): string;
    function  IntToHex(N : int64):string;
    procedure Swapp(arr:array of int64; ind1:integer; ind2:Integer);
    Function  Fuctor(i:Integer):Integer;
    procedure KnutsTestClick(Sender: TObject);
    procedure GenIntelClick(Sender: TObject);
    procedure GenRC4Click(Sender: TObject);
    procedure SaveToBinaryClick(Sender: TObject);
    procedure SaveToTextClick(Sender: TObject);
    procedure PathAutoSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveBinKey();
    procedure N2Click(Sender: TObject);
    Function  toDec(s:string):String;
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
  public
    countOfOne:integer;
    countOfZero:integer;
  end;
  key = class
      hex:string[255];
      dec:String[255];
      bin:String[255];
      characteristicOfKey:string;
      procedure toBinnnn();
  end;
var
  Kripto: TKripto;
  countOfOne:integer;
  countOfZero:integer;
  temp:Int64;
  varr3:array[1..3] of Int64;
  pathAutoSavePer:String;
  bf:File of SaveToFile;
  AnsiModd:boolean;
  ready:boolean;
  ThreeTestFlag:boolean;
  KnutTestFlag:boolean;

implementation

uses Path, ANSImod, ImportKey, AboutProg, Help;

{$R *.dfm}

procedure TKripto.GenANSIX9171Click(Sender: TObject);   //В этой процедуре происходит генерация криптографического ключа с помощью алгоритма ANSI X9.17
const
  m=3;
var
varr:int64;
s,s2,s3, s4, keyOsn:string;
key1:TBigInt;
text:T3DES;
i:Integer;
bf:File of SaveToFile;
bs:SaveToFile;
K1:key;
begin
  if(StrToInt(Length_Of_Key.Text)=256) and not (ANSIX917.Visible) then begin ANSIX917.Visible:=true; exit; end
  else
begin
  info.Clear;
  if (StrToInt(Length_Of_Key.Text) <> 64) and (StrToInt(Length_Of_Key.Text) <> 256) then begin ShowMessage('Алгоритм ANSI X9.17 генерирует ключ размером только 64 бита.'); Length_Of_Key.Text:='64'; end;
  K1 := key.Create;
  InFo.Clear;
  InFo.Lines.Add('//------------------------------------------------------------//');
  InFo.Lines.Add('Алгоритм генерации ключа: ANSI X9.17');
  ThreeTestFlag:=false;
  KnutTestFlag:=false;
  if(strToInt(Length_Of_Key.Text)=256) then InFo.Lines.Add('Ключ составнной.');
  InFo.Lines.Add('Длина ключа: '+Length_Of_Key.Text+' бит');
  ThreeTestFlag:=false;
  KnutTestFlag:=false;
  s:=TimeToStr(Date);
  s:=FormatDateTime('ddmmyyyyhhnnsszzz', Now);
  s4:=copy(s,1,8);
  s2:=copy(s,9,9);
  varr:=StrToInt64(s4);
  s3:=BinToStr(IntToBin(varr));
  varr:=StrToInt64(s2);
  s3:=s3+BinToStr(IntToBin(varr));
  RandomBig(17, key1);
  BigInttoStr(key1,keyOsn);
  if ((StrToInt(Length_Of_Key.Text) <> 64) and (StrToInt(Length_Of_Key.Text) <> 256)) then
  begin
  HexKey.Text:=keyOsn;
  k1.toBinnnn;
  end;
  varr3[1]:=STRHexToInt(keyOsn);
  for i:=1 to length(varr3) do
  begin
  if(i>1) then varr3[i]:=temp;
    text.EncryptECB(s3,temp);
    varr3[i]:= varr3[i] xor temp;
    varr:=varr3[i];
    text.EncryptECB(varr,varr3[i]);
    temp:=temp xor varr3[i];
    varr:=temp;
    text.EncryptECB(varr,temp);
  end;
  temp:=abs(temp);
  if (ANSIX917.Visible) then exit;
  DecKey.Text := IntToStr(temp);
  HexKey.Text:= IntToHex(temp);
  K1.toBinnnn;
  Info.Lines.Add('Ключ: '+ HexKey.Text);
if ((StrToInt(Length_Of_Key.Text) <> 64) and (StrToInt(Length_Of_Key.Text) <> 256)) then
begin
  DecKey.Text := IntToStr(temp);
  k1.dec:=DecKey.Text;
  HexKey.Text:= IntToHex(temp);
  K1.hex:=HexKey.Text;
  K1.toBinnnn;
  k1.bin:=BinKey.Text;
  Info.Lines.Add('Ключ: '+ HexKey.Text); 

  pathAutoSavePer:=PathF.BinPath.Text;
  if not DirectoryExists(pathAutoSavePer) then ForceDirectories(pathAutoSavePer);
  AssignFile(bf, pathAutoSavePer+'D '+FormatDateTime('yyyy_mm_dd', Now)+' T '+FormatDateTime('hh_nn_ss_zzz', Now)+'.bin');
  Rewrite(bf);
  bs.s:=HexKey.Text;
  BlockWrite(bf,bs.s,1);
  CloseFile(bf);
  k1.Destroy;
end;
end;
k1.Destroy;
end;

procedure TKripto.ThreeStageTestClick(Sender: TObject);   //В этой процедуре происходит тестирование криптографического ключа с помощью трехэтапного теста
var
  n,i,count,count2,Kmax:Integer;
  key2:array [0..256] of integer;
  s,s2:string;
  p,p2,p3,kVich,kLap,q,M,sigma,Vkr:double;
  tf:TextFile;
begin
 s2:='//---------------------------------------------//';
 if ThreeTestFlag then exit;
 for i:=0 to length(key2)-1 do
 key2[i]:=0;
  Kmax:=1;
  count:=0;
  count2:=0;
  n:=length(BinKey.Text);
  p:=0.5;
  q:=0.5;
  kLap:=1.96;
  kVich:=(((countOfOne/n)-p)*Sqrt(n))/(Sqrt(p*q));
  Info.Lines.Add(' ');
  Info.Lines.Add(s2);
  Info.Lines.Add('Алгоритм оценки качества криптографических ключей: трехэтапный алгоритм.');
  InFo.Lines.Add('                    Этап 1:            ');
  InFo.Lines.Add('      Условие прохождения теста: ');
  InFo.Lines.Add('наблюдаемое значение Кнабл по модулю меньше критического значения Ккр.');
  InFo.Lines.Add('Значение критической точки Kкр = '+FloatToStrF(kLap,ffFixed, 8, 3));
  InFo.Lines.Add('Рассчитанное значение Кнабл = ' + FloatToStrF(abs(kVich),ffFixed,8,3));
  InFo.Lines.Add(FloatToStrF(abs(kVich),ffFixed,8,3) + ' < ' + FloatToStrF(kLap,ffFixed,8,3));
  if(abs(kVich)<kLap)then
  begin
    Info.Lines.Add('Результат: этап пройден. Ключевая последовательность является случайной.');
  end
  else Info.Lines.Add('Результат: этап не пройден. Ключевая последовательность не является случайной.');

  s:=BinKey.Text;
  
  for i:=2 to length(s)-1 do
    begin
      if (s[i]='0') and (s[i-1]='1') and (s[i+1]='1') then Inc(count);
      if (s[i]='1') and (s[i-1]='0') and (s[i+1]='0') then Inc(count);
    end;
    
  M:=(2/3)*(n-2);
  sigma:=(16*n-29)/90;
  p2:=M-1.96*Sqrt(sigma);
  Info.Lines.Add(' ');
  Info.Lines.Add('                   Этап 2:               ');
  Info.Lines.Add('        Условие прохождения теста: ');
  Info.Lines.Add('общее число полученных точек поворота Р в двоичной последовательности меньше критического значения числа точек поворота Ркр.');
  Info.Lines.Add('Число точек поворота Р = ' +FloatToStrF(count,ffFixed,8,3));
  Info.Lines.Add('Критическое значение числа точек поворота Ркр = ' +FloatToStrF(p2,ffFixed,8,3));
  Info.Lines.Add(FloatToStrF(count,ffFixed,8,3)+' < ' +FloatToStrF(p2,ffFixed,8,3));
  if(count<Ceil(p2))then Info.Lines.Add('Результат: этап пройден')
  else Info.Lines.Add('Результат: этап не пройден');

  for i:=2 to length(s) do
    begin
      if s[i]=s[i-1] then
      Kmax:=Kmax+1
      else begin key2[i]:=Kmax; Kmax:=1; end;
    end;

    Kmax:=MaxIntValue(key2);

    for i:=0 to length(key2)-1 do
      begin
        if(key2[i]>1)then Inc(count2);
      end;
  p3:=3.3*(Log10(n)+1);
  Vkr:=0.5*(n+1-1.96*Sqrt(n-1));
  Info.Lines.Add('                         Этап 3:               ');
  Info.Lines.Add('        Условие прохождения теста: ');
  Info.Lines.Add('критическое значение общего числа серий Vкр меньше общего числа следующих подряд друг за другом серий единиц V, а также протяженность самой длинной серии Кмах меньше критического значения числа единиц в самой длинной серии Ккр.');
  Info.Lines.Add('Критическое значение общего числа серий Vкр = '+FloatToStrF(Vkr,ffFixed,8,3));
  Info.Lines.Add('Количество следующих подряд друг за другом единиц V = '+FloatToStr(count2));
  Info.Lines.Add('Длина максимальной серии Kmax = '+FloatToStrF(Kmax,ffFixed,8,3));
  Info.Lines.Add('Критическое значение числа единиц в серии K = '+FloatToStrF(p3,ffFixed,8,3));
  Info.Lines.Add(FloatToStrF(Kmax,ffFixed,8,3)+' < '+FloatToStrF(p3,ffFixed,8,3)+' ; '+FloatToStrF(count2,ffFixed,8,3)+' > ' + FloatToStrF(Vkr,ffFixed,8,3));
  if(Kmax<p3) and (count2>Vkr) then
  Info.Lines.Add('Результат: этап пройден.')
  else Info.Lines.Add('Результат: этап не пройден.');
  ThreeTestFlag:=true;

  pathAutoSavePer:=PathF.TextPath.Text;

  if not DirectoryExists(pathAutoSavePer) then ForceDirectories(pathAutoSavePer);
  AssignFile(tf, pathAutoSavePer+'D '+FormatDateTime('yyyy_mm_dd', Now)+' T '+FormatDateTime('hh_nn_ss_zzz', Now)+'.txt');
  Rewrite(TF);
  Writeln(TF,Info.Lines.GetText);
  CloseFile(TF);
end;

function TKripto.IntToBin2(d: Int64): string;         //Это функция для перевода десятичного числа в двоичное число
 var
   x: Integer;
   bin: string;
 begin
   bin := '';
   for x := 1 to 8 * SizeOf(d) do
   begin
     if Odd(d) then bin := '1' + bin
     else
       bin := '0' + bin;
     d := d shr 1;
   end;
   Delete(bin, 1, 8 * ((Pos('1', bin) - 1) div 8));
   Result := bin;
 end;

function TKripto.IntToHex(N : Int64):string;           //Эта функция для перевода десятичного числа в шестнадцатеричное
const
Hex : array[0..15] of char = '0123456789ABCDEF';
var
j, k : int64;
i:integer;
Result2, s : string;
begin
Result2 := '';
k := n;
repeat
j := k div 16;
i := k mod 16;
Result2 := Result2 + Hex[i];
k := j;
until j = 0;
S := Result2;
for i := 1 to Length(Result2) do
S[Length(S)-i+1] := Result2[i];

Result:=s;
end;

procedure TKripto.KnutsTestClick(Sender: TObject);      //Процедура для тестирования ключа с помощью тестов Д. Кнута.
var
  s,s2:String;
  pred1,pred2:Double;
  arrOfNumSeries:array [0..7] of integer;
  arrOfSum:array [0..2] of integer;
  pos1,pos2,j:Integer;
  ksiSQUARE,ksiSQUARE2,TN,phi,GammaSqu,third,c:Double;
  i,n,t,symb1,symb2:Integer;
  TF:TextFile;
begin
  //------------------------Проверка несцепленных серий----------------------------//
  if KnutTestFlag then exit;
  SetLength(s,length(BinKey.Text));
  for i:=0 to 7 do
    begin
      arrOfNumSeries[i]:=0;
    end;

    s:=BinKey.Text;
    for i:=2 to length(s) do
    begin
      if((s[i]='0') and (s[i-1]='0') and (s[i]='0')) then inc(arrOfNumSeries[0]);
      if((s[i]='0') and (s[i-1]='0') and (s[i]='1')) then inc(arrOfNumSeries[1]);
      if((s[i]='0') and (s[i-1]='1') and (s[i]='0')) then inc(arrOfNumSeries[2]);
      if((s[i]='0') and (s[i-1]='1') and (s[i]='1')) then inc(arrOfNumSeries[3]);
      if((s[i]='1') and (s[i-1]='0') and (s[i]='0')) then inc(arrOfNumSeries[4]);
      if((s[i]='1') and (s[i-1]='0') and (s[i]='1')) then inc(arrOfNumSeries[5]);
      if((s[i]='1') and (s[i-1]='1') and (s[i]='0')) then inc(arrOfNumSeries[6]);
      if((s[i]='1') and (s[i-1]='1') and (s[i]='1')) then inc(arrOfNumSeries[7]);
    end;
    ksiSQUARE:=0;
    ksiSQUARE:=(Power((arrOfNumSeries[0]-2),2)+Power((arrOfNumSeries[1]-2),2)+Power((arrOfNumSeries[2]-2),2)+Power((arrOfNumSeries[3]-2),2)+Power((arrOfNumSeries[4]-2),2)+Power((arrOfNumSeries[5]-2),2)+Power((arrOfNumSeries[6]-2),2)+Power((arrOfNumSeries[7]-2),2))/2;
    TN:=14.067;
    Info.Lines.Add('  ');
    Info.Lines.Add('//------------------------------------------------------------//');
    Info.Lines.Add('Алгоритм оценки качества криптографических ключей: Тесты Д. Кнута.');
    Info.Lines.Add('тесты Д. Кнута.');
    Info.Lines.Add('      Тест1. Проверка несцепленных серий');
    Info.Lines.Add('      Условие прохождения теста:');
    Info.Lines.Add('табличное значение хи-квадрат (хи-т) меньше, чем расчетное значение хи-квадрат (хи_р).');
    Info.Lines.Add('хи_т = '+ floatToStrF(TN,ffFixed,8,3));
    Info.Lines.Add('Расчетное значение хи_р = '+ floatToStrF(ksiSQUARE,ffFixed,8,3));
    Info.Lines.Add(floatToStrF(TN,ffFixed,8,3)+' < '+ floatToStrF(ksiSQUARE,ffFixed,8,3));
    if(ksiSQUARE>TN)then Info.Lines.Add('Результат: тест пройден.')
    else Info.Lines.Add('Результат: тест не пройден.');
  //---------------------------Проверка перестановок---------------------------------------//
    ksiSQUARE2:=0;
    pos1:=0;pos2:=0;
    s:=DecKey.Text;
    n:=Length(DecKey.Text);
    t:=2;
    for i:=1 to length(DecKey.Text)-1 do
      begin
        s2:=s[i];
        symb1:=StrToInt(s2);
        s2:=s[i+1];
        symb2:=StrToInt(s2);
        if(symb1>symb2) then Inc(pos1);
        if(symb1<symb2) then Inc(pos2);
      end;
     ksiSQUARE2:=(1/((n/t)*(1/Fuctor(t))))*Power((pos1-(n/t)*(1/Fuctor(t))),2)+Power((pos2-(n/t)*(1/Fuctor(t))),2);
     TN:=3.841;
     Info.Lines.Add(' ');
     Info.Lines.Add('       Тест2. Проверка перестановок');
     Info.Lines.Add('       Условие прохождение теста:');
     Info.Lines.Add('табличное значение хи-квадрат (хи-т) меньше, чем расчетное значение (хи-р).');
     Info.Lines.Add('Расчетное значение хи_р = '+FloatToStrF(ksiSQUARE2,ffFixed,8,3));
     Info.Lines.Add(floatToStrF(TN,ffFixed,8,3)+' < '+ floatToStrF(ksiSQUARE2,ffFixed,8,3));
     if(ksiSQUARE2>TN)then Info.Lines.Add('Результат: тест пройден.')
     else Info.Lines.Add('Результат: тест не пройден.');
    //----------------------------------Проверка кареляций---------------------------//
     for i:=0 to length(arrOfSum)-1 do arrOfSum[i]:=0; third:=0;
     s:=DecKey.Text;
     n:=Length(DecKey.Text);
     phi:=-(1/n-1);
     GammaSqu:=Power(n,2)/(Power(n-1,2)*(n-2));
     pred1:=(phi -(2.43*GammaSqu));
     pred2:=(phi +(2.43*GammaSqu));
     j:=2;
     
     for i:=1 to n-j-1 do
      begin
        if (i<n-1)then arrOfSum[0]:=arrOfSum[0]+StrToInt(s[i])*StrToInt(s[(j+i) mod n])
        else begin arrOfSum[0]:=arrOfSum[0]+StrToInt(s[i])*StrToInt(s[n]); arrOfSum[1]:=arrOfSum[1]+StrToInt(s[n]); third:=third+Power(StrToInt(s[n]),2); third:=third+Power(StrToInt(s[n]),2); end;
        arrOfSum[1]:=arrOfSum[1]+StrToInt(s[i]);
        third:=third+Power(StrToInt(s[i]),2);
      end;
     c:=abs((n*(arrOfSum[0])-Power(arrOfSum[1],2))/(n*(third)-Power(arrOfSum[1],2)));
     Info.Lines.Add(' ');
     Info.Lines.Add('     Тест3. Проверка корреляции');
     Info.Lines.Add('     Условие прохождения теста:');
     Info.Lines.Add('расчетное значение корреляции (рк) попадает в расcчитанный предел от пр1 до пр2.');
     Info.Lines.Add('Раcсчитанное значение начального предела пр1 = '+ FloatToStrF(pred1,ffFixed,8,3));
     Info.Lines.Add('Расcчитанное значение конечного предела пр2 = '+ FloatToStrF(pred2,ffFixed,8,3));
     Info.Lines.Add('Расcчитанное значение корреляции рк = '+ FloatToStrF(c,ffFixed,8,3));
     Info.Lines.Add(FloatToStrF(pred1,ffFixed,8,3)+ ' < '+ FloatToStrF(c,ffFixed,8,3)+' < '+FloatToStrF(pred2,ffFixed,8,3));
     if(c>pred1) and (c<pred2) then Info.Lines.Add('Результат: тест пройден.')
     else Info.Lines.Add('Результат: тест не пройден.');
     KnutTestFlag:=true;

     pathAutoSavePer:=PathF.TextPath.Text;
     if not DirectoryExists(pathAutoSavePer) then ForceDirectories(pathAutoSavePer);
     AssignFile(TF, pathAutoSavePer+'D '+FormatDateTime('yyyy_mm_dd', Now)+' T '+FormatDateTime('hh_nn_ss_zzz', Now)+'.txt');
     Rewrite(TF);
     Writeln(TF,Info.Lines.GetText);
     CloseFile(TF);
end;

procedure TKripto.GenIntelClick(Sender: TObject);      //Процедура для генерирования ключа методом, предложенным компанией Intel          
var
  key1:TBigInt;
  keyOsn,s:String;
  i,q34, numm:integer;
  bf:File of SaveToFile;
  bs:SaveToFile;
  k1:Key;
begin
if (StrToInt(Length_Of_Key.Text)> 256) then begin ShowMessage('Длина ключа должна быть не больше 256 бит. Введите другое значение.'); exit; end;
info.Clear;
K1 := key.Create;
Info.Lines.Add('//------------------------------------------------------------//');
Info.Lines.Add('Алгоритм генерации ключа: Алгоритм корпорации Intel.');
ThreeTestFlag:=false;
KnutTestFlag:=false;
Info.Lines.Add('Длина ключа: '+Length_Of_Key.Text+' бит');
hexKey.Text:=''; Binkey.Text:='';decKey.Text:='';
  if(Length_Of_Key.Text='') then begin ShowMessage('Введите размер ключа!'); exit; end
  else q34:=(Abs(trunc(StrToInt(Length_Of_Key.Text)/4)));
  RandomBig(q34, key1);
  BigInttoStr(key1,keyOsn);
  HexKey.Text:=keyOsn;
  k1.hex:=keyOsn;
  BinKey.Text:='';
  DecKey.Text:=toDec(HexKey.Text);
  k1.dec:=DecKey.Text;
  k1.toBinnnn;
  k1.bin:=BinKey.Text;
  Info.Lines.Add('Ключ: '+ HexKey.Text);

  pathAutoSavePer:=PathF.BinPath.Text;
  if not DirectoryExists(pathAutoSavePer) then ForceDirectories(pathAutoSavePer);
  AssignFile(bf, pathAutoSavePer+'D '+FormatDateTime('yyyy_mm_dd', Now)+' T '+FormatDateTime('hh_nn_ss_zzz', Now)+'.bin');
  Rewrite(bf);
  bs.s:=HexKey.Text;
  BlockWrite(bf,bs.s,1);
  CloseFile(bf);
  k1.Destroy;
end;

procedure key.toBinnnn();               //Процедура для перевода шестнадцатеричного числа из поля: HexKey в двоичное число в поле binKey
var
  arrKey:array[0..256] of Char;
  i:integer;
begin
countOfOne:=0;
countOfZero:=0;
if(Kripto.HexKey.Text='') then begin ShowMessage('Нет значения для перевода!.');exit; end;
Kripto.BinKey.Text:='';
for i:=0 to length(Kripto.HexKey.Text) do
  begin
    arrKey[i]:= Kripto.HexKey.text[i];
    case arrKey[i] of
      '0': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0000'; countOfZero:=countOfZero+4; end;
      '1': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0001'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '2': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0010'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '3': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0011'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      '4': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0100'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '5': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0101'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      '6': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0110'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      '7': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '0111'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      '8': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1000'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '9': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1001'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'A': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1010'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'B': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1011'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'C': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1100'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'D': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1101'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'E': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1110'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'F': begin Kripto.BinKey.text:=Kripto.BinKey.text+ '1111';countOfOne:=countOfOne+4;end;
    end;
  end;
end;

procedure TKripto.GenRC4Click(Sender: TObject);          //Процедура для генерации ключа с помощью алгоритма RC4
var
  tt,q,e,i:Integer;
  arrKey:array of byte;
  s:array [0..255] of int64;
  s2:string;
  bf:File of SaveToFile;
  bs:SaveToFile;
  k1:key;
begin
info.Clear;
if (StrToInt(Length_Of_Key.Text)> 256) then begin ShowMessage('Длина ключа должна быть не больше 256 бит. Введите другое значение.'); exit; end;
K1 := key.Create;
Info.Lines.Add('//------------------------------------------------------------//');
Info.Lines.Add('Алгоритм генерации ключа: RC4');
ThreeTestFlag:=false;
KnutTestFlag:=false;
Info.Lines.Add('Длина ключа: '+Length_Of_Key.Text+' бит');
HexKey.Text:='';
s2:='';
  SetLength(arrKey, StrToInt(Length_Of_Key.Text) div 4);
  q:=0;
  e:=0;
  for q:=0 to 255 do
  begin
    s[q]:=q;
  end;
  for q:=0 to 255 do
  begin
    e:=(e+s[q]+arrkey[q]) mod 256;
    Swapp(s, q,e);
  end;
  q:=0;
  e:=0;
  for i:=0 to length(arrKey)-1 do
    begin
      q:=(q+1) mod 256;
      e:=(e+s[q]) mod 256;
      Swapp(s,q,e);
      tt:=(s[q]+s[e]) mod 256;
      arrKey[i]:=s[tt];
      HexKey.Text:=HexKey.Text+IntToHex(arrkey[i]);
      s2:=s2+IntToStr(arrkey[i]);
    end;
    k1.hex:=HexKey.Text;
    DecKey.text:=toDec(HexKey.Text);
    k1.dec:=DecKey.Text;
    k1.toBinnnn;
    k1.bin:=BinKey.Text;
    Info.Lines.Add('Ключ: '+ HexKey.Text);

    pathAutoSavePer:=PathF.BinPath.Text;
    if not DirectoryExists(pathAutoSavePer) then ForceDirectories(pathAutoSavePer);
    AssignFile(bf, pathAutoSavePer+'D '+FormatDateTime('yyyy_mm_dd', Now)+' T '+FormatDateTime('hh_nn_ss_zzz', Now)+'.bin');
    Rewrite(bf);
    bs.s:=HexKey.Text;
    BlockWrite(bf,bs.s,1);
    CloseFile(bf);
    k1.Destroy;
end;

Procedure TKripto.Swapp(arr:array of int64; ind1:Integer; ind2:Integer);    //Процедура для обмена значениями массива
var
  temp:integer;
begin
  temp:=arr[ind1];
  arr[ind1]:=arr[ind2];
  arr[ind2]:=temp;
end;

Function TKripto.Fuctor(i:Integer):Integer;     //Процедура для нахождения факториала числа
var
  j,q:Integer;
begin
q:=1;
  for j:=2 to i do
    begin
      q:=q+q*j;
    end;
    Result:=q;
end;
procedure TKripto.SaveToBinaryClick(Sender: TObject);          //Процедура для сохранения ключа в бинарный файл
var
  bf:File of SaveToFile;
  bs:SaveToFile;
begin
  if(HexKey.Text='')then begin ShowMessage('Ключевое поле пустое! Сгенирируйте ключ!'); exit; end;
  Saver.Filter:='.bin';
  Saver.Execute;
  AssignFile(bf, Saver.FileName);
  if not DirectoryExists(Saver.FileName) then exit;
  Rewrite(bf);
  bs.s:=HexKey.Text;
  BlockWrite(bf,bs.s,1);
  CloseFile(bf);
end;

procedure TKripto.SaveToTextClick(Sender: TObject);    //Процедура для сохранения ключа в текстовый файл
var
  TF:TextFile;
  s:String;
begin
  s:='//-------------------------------------------------------------------------//';
  if(HexKey.Text='') and (length(Info.Text)=0) then begin ShowMessage('Ключевое поле и поле проверки - пустые. Сгенерируйте ключ и проведите проверку ключа.');exit;end;
  Saver.Filter:='.txt';
  Saver.Execute;
  AssignFile(TF, Saver.FileName);
  if not DirectoryExists(Saver.FileName) then exit;
  Rewrite(TF);
  Writeln(TF,Info.Lines.GetText);
  CloseFile(TF);
end;

procedure TKripto.PathAutoSaveClick(Sender: TObject);   //Процедура для установки пути автосохранения ключей
begin
     PathF.Visible:=true;
end;

procedure TKripto.FormCreate(Sender: TObject);    //Процедура инициализаций главного окна 
begin
  HexKey.ReadOnly:=true;
  BinKey.ReadOnly:=true;
  DecKey.ReadOnly:=true;
  InFo.ReadOnly:=true;
  temp:=0;
  ready:=false;
  pathAutoSavePer:=ExtractFilePath(Application.ExeName);
  ThreeTestFlag:=false;
  KnutTestFlag:=false;
end;

procedure TKripto.SaveBinKey;       //Процедура для сохранения ключа в бинарный файл
var
  bs:SaveToFile;
begin
  pathAutoSavePer:=PathF.BinPath.Text;
  if not DirectoryExists(pathAutoSavePer) then ForceDirectories(pathAutoSavePer);
  AssignFile(bf, pathAutoSavePer+'D '+FormatDateTime('yyyy_mm_dd', Now)+' T '+FormatDateTime('hh_nn_ss_zzz', Now)+'.bin');
  Rewrite(bf);
  bs.s:=HexKey.Text;
  BlockWrite(bf,bs.s,1);
  CloseFile(bf);
end;

procedure TKripto.N2Click(Sender: TObject);
begin
  ImportKeyFromFileOrKeyboard.Visible:=true;
end;

function TKripto.toDec(s:string):string;
var
  i,i2,len:integer;
  s2,s3:string;
begin
  len:=length(s);
  for i:=1 to length(s) do
    begin
      s2:=s[i];
      i2:=STRHexToInt(s2);
      //s3:=ulPower(IntToStr(16),IntToStr(len-i));
      s3:=ulSum(s3,(ulMPL(IntToStr(i2),ulPower(IntToStr(16),IntToStr(len-i)))));
    end;
    result:=s3;
end;
procedure TKripto.N5Click(Sender: TObject);
begin
  AboutPR.Visible:=true;
end;

procedure TKripto.N6Click(Sender: TObject);
begin
  Help2.Visible:=true;
end;

end.
