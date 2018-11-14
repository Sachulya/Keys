unit ImportKey;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, Menus, ComCtrls, Mask, Buttons, ScktComp, matham, netparam,
  SharedFunc, ExtCtrls, Math, DES, KOLBlockCipher, UMathServices;


type
  TImportKeyFromFileOrKeyboard = class(TForm)
    PathToKeyTextFile: TEdit;
    ChoiseImportKey: TRadioGroup;
    Label1: TLabel;
    Timer1: TTimer;
    HexKeyText: TEdit;
    Label2: TLabel;
    BinaryKeyText: TEdit;
    Label3: TLabel;
    DecTextKey: TEdit;
    Label4: TLabel;
    apply: TButton;
    OpenDialog1: TOpenDialog;
    lengthOfImportkey: TEdit;
    Label5: TLabel;
    reImport: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GetPathClick(Sender: TObject);
    procedure toBinnImport();
    procedure ChoiseImportKeyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure applyClick(Sender: TObject);
    procedure reImportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportKeyFromFileOrKeyboard: TImportKeyFromFileOrKeyboard;
  countOfZero, countOfOne:integer;
  a:array[1..51] of string = ('G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','.','?',',','/','|','\','(',')','<','>',' ');
  FileType:String;

implementation

uses Geerate;

{$R *.dfm}

procedure TImportKeyFromFileOrKeyboard.Timer1Timer(Sender: TObject);
var
  numm,i:integer;
  s:string;
begin
  if(HexKeyText.Text<>'') and (BinaryKeyText.Text<>'') and (DecTextKey.Text<>'') and (lengthOfImportkey.Text<>'') then begin apply.Enabled:=true; reImport.Enabled:=true; end;
  IF(ChoiseImportKey.ItemIndex=0) then
    begin
     // GetPath.Enabled:=true;
      HexKeyText.ReadOnly:=true;
    end;
    IF(ChoiseImportKey.ItemIndex=1) then
    begin
      HexKeyText.ReadOnly:=false;
    end;
end;

procedure TImportKeyFromFileOrKeyboard.FormCreate(Sender: TObject);
begin
 ImportKeyFromFileOrKeyboard.Visible:=false;
 PathToKeyTextFile.ReadOnly:=true;
 HexKeyText.ReadOnly:=true;
 DecTextKey.ReadOnly:=true;
 BinaryKeyText.ReadOnly:=true;
 apply.Enabled:=false;
 reImport.Enabled:=false;
 lengthOfImportkey.ReadOnly:=true;
end;

procedure TImportKeyFromFileOrKeyboard.GetPathClick(Sender: TObject);
begin
  OpenDialog1.Execute;
  PathToKeyTextFile.Text:=OpenDialog1.FileName;
  
end;

procedure TImportKeyFromFileOrKeyboard.toBinnImport;
var
  arrKey:array[0..256] of Char;
  i:integer;
begin
countOfOne:=0;
countOfZero:=0;
if(HexKeyText.Text='') then exit;
BinaryKeyText.Text:='';
for i:=0 to length(HexKeyText.Text) do
  begin
    arrKey[i]:= HexKeyText.text[i];
    case arrKey[i] of
      '0': begin BinaryKeyText.text:=BinaryKeyText.text+ '0000'; countOfZero:=countOfZero+4; end;
      '1': begin BinaryKeyText.text:=BinaryKeyText.text+ '0001'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '2': begin BinaryKeyText.text:=BinaryKeyText.text+ '0010'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '3': begin BinaryKeyText.text:=BinaryKeyText.text+ '0011'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      '4': begin BinaryKeyText.text:=BinaryKeyText.text+ '0100'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '5': begin BinaryKeyText.text:=BinaryKeyText.text+ '0101'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      '6': begin BinaryKeyText.text:=BinaryKeyText.text+ '0110'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      '7': begin BinaryKeyText.text:=BinaryKeyText.text+ '0111'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      '8': begin BinaryKeyText.text:=BinaryKeyText.text+ '1000'; countOfZero:=countOfZero+3; Inc(countOfOne);end;
      '9': begin BinaryKeyText.text:=BinaryKeyText.text+ '1001'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'A': begin BinaryKeyText.text:=BinaryKeyText.text+ '1010'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'B': begin BinaryKeyText.text:=BinaryKeyText.text+ '1011'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'C': begin BinaryKeyText.text:=BinaryKeyText.text+ '1100'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'D': begin BinaryKeyText.text:=BinaryKeyText.text+ '1101'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'E': begin BinaryKeyText.text:=BinaryKeyText.text+ '1110'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'F': begin BinaryKeyText.text:=BinaryKeyText.text+ '1111'; countOfOne:=countOfOne+4;end;
      'a': begin BinaryKeyText.text:=BinaryKeyText.text+ '1010'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'b': begin BinaryKeyText.text:=BinaryKeyText.text+ '1011'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'c': begin BinaryKeyText.text:=BinaryKeyText.text+ '1100'; countOfZero:=countOfZero+2; countOfOne:=countOfOne+2;end;
      'd': begin BinaryKeyText.text:=BinaryKeyText.text+ '1101'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'e': begin BinaryKeyText.text:=BinaryKeyText.text+ '1110'; Inc(countOfZero); countOfOne:=countOfOne+3;end;
      'f': begin BinaryKeyText.text:=BinaryKeyText.text+ '1111'; countOfOne:=countOfOne+4;end;
    end;
  end;
  lengthOfImportkey.Text:=IntToStr(length(BinaryKeyText.Text));
end;

procedure TImportKeyFromFileOrKeyboard.ChoiseImportKeyClick(
  Sender: TObject);
var
  numm:Int64;
  i,j,q,r:integer;
  s,s1,a1:string;
  tf:TextFile;
  bf:file of SaveToFile;
  bs:SaveToFile;
begin
  if(ChoiseImportKey.ItemIndex=1) then
    begin
      s:=InputBox('Enter key.','Введите шестнадцатиричное значение ключа','');
      HexKeyText.Text:=s;
    end;

  if(ChoiseImportKey.ItemIndex=0) then
    begin
      OpenDialog1.Filter:='*.txt;*.bin';
      OpenDialog1.Execute;
      if(FileExists(OpenDialog1.FileName))then
        begin
          PathToKeyTextFile.Text:=OpenDialog1.FileName;
          if(pos('.txt', OpenDialog1.FileName)>0) then
            begin
              FileType:='Текстовый';
              AssignFile(tf, OpenDialog1.FileName);
              Reset(tf);
              while (not EOF(tf)) do begin
                Readln(tf, s);
              end;
              HexKeyText.Text:=s;
              CloseFile(tf);
            end;
           if(pos('.bin', OpenDialog1.FileName)>0) then
            begin
              FileType:='Бинарный';
              AssignFile(bf, OpenDialog1.FileName);
              reset(bf);
              Read(bf, bs);
              HexKeyText.Text:=bs.s;
              CloseFile(bf);
            end;
        end;
    end;

DecTextKey.Text:='';
s1:='';s:='';
s1:=HexKeyText.Text;
j:=1;
while j<>0 do
begin
  for i:=1 to length(a) do
    begin
     j:=pos(a[i],s1);
       if(j>0) then
         begin
           delete(s1,j,1);
           break;
         end;
    end;
end;

HexKeyText.Text:=s1;
HexKeyText.Text:=UpperCase(HexKeyText.Text);
toBinnImport;
DecTextKey.Text:=Kripto.Todec(HexKeyText.Text);

If(HexKeyText.Text='') then begin BinaryKeyText.Text:=''; DecTextKey.Text:='';  end;
end;

procedure TImportKeyFromFileOrKeyboard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  HexKeyText.Text:='';
  BinaryKeyText.Text:='';
  DecTextKey.Text:='';
  lengthOfImportkey.Text:='';
  PathToKeyTextFile.Text:='';
  ChoiseImportKey.ItemIndex:=-1;
end;

procedure TImportKeyFromFileOrKeyboard.applyClick(Sender: TObject);
begin
if(ChoiseImportKey.ItemIndex=1) then
 begin
  Kripto.InFo.Lines.Clear;
  Kripto.InFo.Lines.Add('Ключ написан от руки');
  Kripto.InFo.Lines.Add('Длина ключа: '+ lengthOfImportkey.Text+' бит');
  Kripto.InFo.Lines.Add('Ключ: '+HexKeyText.Text);
  Kripto.HexKey.Text:=HexKeyText.Text;
  Kripto.BinKey.Text:=BinaryKeyText.Text;
  Kripto.DecKey.Text:=DecTextKey.Text;
  Kripto.Length_Of_Key.Text:=lengthOfImportkey.Text;
  Kripto.countOfOne:=countOfOne;
  Kripto.countOfZero:=countOfZero;
  ImportKeyFromFileOrKeyboard.Visible:=false;
  HexKeyText.Text:='';
  BinaryKeyText.Text:='';
  DecTextKey.Text:='';
  lengthOfImportkey.Text:='';
  PathToKeyTextFile.Text:='';
  ChoiseImportKey.ItemIndex:=-1;
 end;
 if(ChoiseImportKey.ItemIndex=0) then
 begin
  Kripto.InFo.Lines.Clear;
  Kripto.InFo.Lines.Add('Файл: '+ExtractFileName(OpenDialog1.FileName));
  Kripto.InFo.Lines.Add('Длина ключа: '+ lengthOfImportkey.Text+' бит');
  Kripto.InFo.Lines.Add('Ключ: '+HexKeyText.Text);
  Kripto.HexKey.Text:=HexKeyText.Text;
  Kripto.BinKey.Text:=BinaryKeyText.Text;
  Kripto.DecKey.Text:=DecTextKey.Text;
  Kripto.Length_Of_Key.Text:=lengthOfImportkey.Text;
  Kripto.countOfOne:=countOfOne;
  Kripto.countOfZero:=countOfZero;
  ImportKeyFromFileOrKeyboard.Visible:=false;
    HexKeyText.Text:='';
  BinaryKeyText.Text:='';
  DecTextKey.Text:='';
  lengthOfImportkey.Text:='';
  PathToKeyTextFile.Text:='';
  ChoiseImportKey.ItemIndex:=-1;
 end;
end;

procedure TImportKeyFromFileOrKeyboard.reImportClick(Sender: TObject);
begin
  HexKeyText.Text:='';
  BinaryKeyText.Text:='';
  DecTextKey.Text:='';
  lengthOfImportkey.Text:='';
  PathToKeyTextFile.Text:='';
  ChoiseImportKey.ItemIndex:=-1;
  reImport.Enabled:=false;
  apply.Enabled:=false;
  HexKeyText.ReadOnly:=true;
  lengthOfImportkey.ReadOnly:=true;
end;

end.
