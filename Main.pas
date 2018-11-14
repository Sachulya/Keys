unit Main;  //Главное окно

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, Menus, ComCtrls, Mask, Buttons, ScktComp, matham, netparam,
  SharedFunc, ExtCtrls;

type
  TMainForm = class(TForm)
    EncryptButton: TButton;
    SourceMemo: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    ExitProg: TMenuItem;
    OpenText: TMenuItem;
    SaveText: TMenuItem;
    OpenEncryptText: TMenuItem;
    SaveEncryptText: TMenuItem;
    KeyGroup: TGroupBox;
    N9: TMenuItem;
    HexRadio: TRadioButton;
    AlphaRadio: TRadioButton;
    HexEdit: TMaskEdit;
    AlphaEdit: TEdit;
    DecryptButton: TButton;
    FileOpenDialog: TOpenDialog;
    FileSaveDialog: TSaveDialog;
    EncrEditButton: TButton;
    SaveKeyButton: TSpeedButton;
    LoadKeyButton: TSpeedButton;
    EnCryptMemo: TRichEdit;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    StatusBar1: TStatusBar;
    CaseAlg: TComboBox;
    Memo1: TMemo;
    Panel1: TPanel;
    MaskEdit1: TMaskEdit;
    LoadSyncButton: TSpeedButton;
    SaveSyncButton: TSpeedButton;
    N5: TMenuItem;
    N6: TMenuItem;
    N12: TMenuItem;
    N11: TMenuItem;
    About: TMenuItem;
    C_Memo: TMenuItem;
    C_Virtual: TMenuItem;
    Label1: TLabel;
    N7: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    procedure EncryptButtonClick(Sender: TObject);
    procedure ExitProgClick(Sender: TObject);
    procedure HexRadioClick(Sender: TObject);
    procedure AlphaRadioClick(Sender: TObject);
    procedure AlphaEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HexEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HexEditKeyPress(Sender: TObject; var Key: Char);
    procedure AboutClick(Sender: TObject);
    procedure OpenTextClick(Sender: TObject);
    procedure SaveTextClick(Sender: TObject);
    procedure OpenEncryptTextClick(Sender: TObject);
    procedure SaveEncryptTextClick(Sender: TObject);
    procedure DecryptButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ShowChTabButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EncrEditButtonClick(Sender: TObject);
    procedure LoadKeyButtonClick(Sender: TObject);
    procedure SaveKeyButtonClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure CaseAlgChange(Sender: TObject);
    //procedure CheckBox1Click(Sender: TObject);
    procedure MaskEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure MaskEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoadSyncButtonClick(Sender: TObject);
    procedure SaveSyncButtonClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    function ContentIsText(MemoText:String): Boolean;
    procedure C_MemoClick(Sender: TObject);
    procedure C_VirtualClick(Sender: TObject);
    procedure OpenFileLog;
    procedure N8Click(Sender: TObject);
   private
    { Private declarations }
    procedure FilterEncrData;
  public
    { Public declarations }
  end;

Const KeyKol=16;

var
  MainForm: TMainForm;
  StrReceive, SKey, Sk, NIP: String;
  SyncrManual: CrBlock;
  NKey, GKey: TBigInt;
  NP: Boolean;
  KKey: array of TBigInt;
  OKey: array of TBigInt;
  NPort: word;
  regCrypt: TChReg;
  WType:Boolean;
  FileStreamVirtual:TMemoryStream;
  FilePath:String;
  FileNameW:string;
LengthFileW:Integer;
  function MGetFileSize(const FileName:string):longint;
implementation

uses SimpleDe, About, Encode, uChTab, uEditEnText, Wait;

{$R *.dfm}

//CallBack процедура, выделяющая красным цветом измененнные символы шифртекста
procedure MarkChars(AInfo, AItem, AData: Pointer; out AContinue: Boolean);
begin
  MainForm.EnCryptMemo.SelStart:= Integer(AItem);
  MainForm.EnCryptMemo.SelLength:= 1;
  MainForm.EnCryptMemo.SelAttributes.Color:= clRed;
end;

//"Загрузка" шифртекста в EnCryptMemo с заменой непечатаемых символов на '#'
procedure TMainForm.FilterEncrData;
var
  Size, i,K: Integer;
  S1,S: string;
  tmp : Char;

begin
  DestStream.Position:= 0;
  EnCryptMemo.Lines.Clear;
  K:=0;
  //if RegCrypt=RIV then EnCryptMemo.Text:=EnCryptMemo.Text+'Результат вычисления:'+#13#10;
  with EnCryptMemo.Lines do
  begin
    BeginUpdate;
    try
      Size := DestStream.Size - DestStream.Position;
      SetString(S, nil, Size);
      {if RegCrypt=RIV then begin
      S1:='Результат вычисления: ';
      SetString(S, nil, Size+21);K:=21;
      for i:= 1 to 21 do  S[i]:=S1[i];
      end; }

      for i:= 1 to Size do
      begin
        DestStream.Read(tmp, 1);
        if tmp >= #32 then
          S[i]:= tmp
        else
          S[i]:= '#';
      end;
//      end;
         SetText(PChar(S));
    finally
      EndUpdate;
    end;
  end;
  //Помечаем символы, которые были изменены.
  ListChanges.ForEach(MarkChars);
end;

//Обработка нажатия кнопки "Зашифровать"
procedure TMainForm.EncryptButtonClick(Sender: TObject);
var S:string;
begin
  SourceStream.Clear;
  if  C_Memo.Checked=true then
  SourceMemo.Lines.SaveToStream(SourceStream) else
  SourceStream.LoadFromStream(FileStreamVirtual);
  if SourceStream.Size > 0 then //А есть ли что преобразовывать?
  begin
    DestStream.Clear;
    Crypt(MainKey, RegCrypt, True, WType); //Зашифровка
    ListChanges.Clear;  //Удаление меток об исправлениях в шифртексте, если они были
    FilterEncrData;
    S:=EnCryptMemo.Text;
    if RegCrypt=RIV then begin EnCryptMemo.Text:='Результат преобразования: '+S+#13#10;
    EnCryptMemo.Text:=EnCryptMemo.Text+'Имитовставка по ГОСТ 28147-89: '+S[1]+S[2]+S[3]+S[4];
    end;

  end;
end;

//Обработка нажатия кнопки "Расшифровать"
procedure TMainForm.DecryptButtonClick(Sender: TObject);
begin
   if DestStream.Size > 0 then   //А есть ли что преобразовывать?
  begin
    SourceStream.Clear;
    Crypt(MainKey, RegCrypt, False, WType); //Расшифровка
    SourceMemo.Lines.Clear;
    SourceStream.Position:= 0;
    if  C_Memo.Checked=true then
    SourceMemo.Lines.LoadFromStream(SourceStream) else  begin
    SourceMemo.Text:='Текущий файл для шифрования:'+#13#10+FileNameW;
    SourceMemo.Text:=SourceMemo.Text+#13#10+'Длнинна файла:'+IntToStr(LengthFileW)+' (байт).';
    end;
  end;
end;

//Обработка нажатия кнопки "Редактировать шифртекст"
procedure TMainForm.EncrEditButtonClick(Sender: TObject);
//var a: crBlock;
begin
  if (DestStream.Size > 0){and(DestStream.Size > EnCryptMemo.SelStart)} then
    if EditEnText(EnCryptMemo.SelStart) then
      FilterEncrData;
end;

procedure TMainForm.ExitProgClick(Sender: TObject);
begin
  Application.Terminate; //Выход
end;

//Переключаемся на ввод ключа в шестнадцатеричном виде
procedure TMainForm.HexRadioClick(Sender: TObject);
var Key : Word;
begin
  HexEdit.Enabled:= True;
  HexEdit.SetFocus;
  Key:= 0;
  HexEdit.OnKeyUp(HexEdit, Key, []);
  AlphaEdit.Enabled:= False;
end;

//Переключаемся на ввод ключа в текстовом виде
procedure TMainForm.AlphaRadioClick(Sender: TObject);
var Key : Word;
begin
  HexEdit.Enabled:= False;
  AlphaEdit.Enabled:= True;
  AlphaEdit.SetFocus;
  Key:= 0;
  AlphaEdit.OnKeyUp(AlphaEdit, Key, []);
end;

//Обработка нажатия клавиши для "текстового" ключа
procedure TMainForm.AlphaEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
type V = array[0..3] of Char;
var i, base, len : Integer;
    FF : V;
begin
  len:= Length(AlphaEdit.Text);
  for base:= 0 to MaxKeyLength do
  begin
    for i:= 1 to 4 do
      if (base*4+i <= len) then
        FF[i-1]:= AlphaEdit.Text[base*4 + i]
      else
        FF[i-1]:= #0;
    MainKey[Base]:= Cardinal(FF);
  end;
end;

//Обработка нажатия клавиши для "шестнадцатеричного" ключа
procedure TMainForm.HexEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i, base, len : Integer;
    FF : Cardinal;
    tmp : String;
begin
  len:= Length(HexEdit.Text);
  for base:= 0 to MaxKeyLength do
  begin
    tmp:= '';
    for i:= 1 to 8 do
    begin
      if base*8 + i <= len then
      if HexEdit.Text[(base*8) + i] <> ' ' then
      begin
        tmp:= tmp + HexEdit.Text[(base*8)+ i];
        Continue;
      end;
      tmp:= tmp + '0';
    end;
    FF:= HexToInt(tmp);
    MainKey[Base]:= FF;
  end;
end;

//Допускаем для ввода "шестнадцатеричного" ключа символы 0-9 и A-F
procedure TMainForm.HexEditKeyPress(Sender: TObject; var Key: Char);
begin
  Key:= UpCase(Key);
  if not(((Key >= 'A')and(Key <= 'F'))or((Key >= '0') and (Key <= '9'))or (Key = #8)) then
    Key:= '_';
end;

//Окно "О программе..."
procedure TMainForm.AboutClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

//Обработка пунктов меню "Файл". (Открытие, сохранение)
procedure TMainForm.OpenTextClick(Sender: TObject);
begin
OpenFileLog;
end;

procedure TMainForm.OpenFileLog;
var i:byte;
begin
FileOpenDialog.Title:= 'Загрузка открытого текста';
FileOpenDialog.Filter:='Текстовый файл (*.txt)|*.txt|'+'Все файлы (*.*)|*.*';
FileOpenDialog.InitialDir:=FilePath;
if FileOpenDialog.Execute and FileExists (FileOpenDialog.FileName)
   then begin
   if MGetFileSize(FileOpenDialog.FileName)>1000000 then
   Application.MessageBox('Файл имеет очень большой размер!'+#13#10+'Обработка этого файла может привести к нестабильой работе системы!','Ошибка!', mb_IconHand+mb_Ok)
   else begin
   if C_Memo.Checked=true then SourceMemo.Lines.LoadFromFile(FileOpenDialog.FileName);
    FileNameW:=FileOpenDialog.FileName;i:=6;
    FilePath:=ExtractFilePath(FileNameW);
    If not ContentIsText(SourceMemo.Text) then
    i:=Application.MessageBox('В открываемом вами файле содержаться непечатаемые символы!'+#13#10+
    'При открытии этого файла в текстовой форме может неверно интерпретироваться имеющаяся в нем информация.'+
    #13#10+'Открыть этот файл в текстовой форме?','Внимание!', mb_IconQuestion+mb_YesNo);
    if C_Virtual.Checked=true then i:=7;
    if i=6 then begin SourceMemo.ReadOnly:=False;
    C_Memo.Checked:=true;C_Virtual.Checked:=false;end;
    if i=7 then begin
    FileStreamVirtual.LoadFromFile(FileNameW);
    LengthFileW:=FileStreamVirtual.Size;
    SourceMemo.Text:='Текущий файл для шифрования:'+#13#10+FileNameW;
    SourceMemo.Text:=SourceMemo.Text+#13#10+'Длнинна файла:'+IntToStr(LengthFileW)+' (байт).';
    C_Virtual.Checked:=true;SourceMemo.ReadOnly:=true;
    C_Memo.Checked:=false;
    end;end;end;
 end;



function TMainForm.ContentIsText(MemoText:String): Boolean;
Var i, CountRead :integer;
    TempStr:string;
    LastD:Boolean;
begin
  Result:=False; i:=0;
  while (i<=31) and ((i in [9,10,13,20])or(Pos(Chr(i), MemoText)=0)) do i:=i+1;
  if i<32 then Exit; i:=1; LastD:=False; CountRead:=255;
  while i<=Length(MemoText) do
  begin  TempStr:=Copy(MemoText, i, CountRead);
  if LastD then begin
  if TempStr[1]<>#10 then Break else Delete(TempStr, 1, 1);LastD:=False;end;
  While ((Pos(#10,TempStr)-1)=Pos(#13,TempStr)) do begin Delete (TempStr, 1, Pos(#10,TempStr));end;
  if not ((Pos(#10,TempStr)=0)and(Pos(#13,TempStr)=0)) then begin
  if (Pos(#10,TempStr)=0)and(TempStr[Length(TempStr)]=#13) then LastD:=True else Break;
  end;
  Inc(i, CountRead);
  end;
  if ((i>=Length(MemoText)) or(MemoText=''))and(not LastD) then result:=True;
end;

procedure TMainForm.SaveTextClick(Sender: TObject);
begin
  FileSaveDialog.Title:= 'Сохранение открытого текста';
  FileSaveDialog.Filter:='Текстовый файл (*.txt)|*.txt|'+'Все файлы (*.*)|*.*';
  FileSaveDialog.DefaultExt:= 'txt';
  FileSaveDialog.FileName:= '';
  if FileSaveDialog.Execute then
  begin
    if C_Virtual.Checked=true then SourceStream.SaveToFile(FileSaveDialog.FileName) else
    SourceMemo.Lines.SaveToFile(FileSaveDialog.FileName);
  end;
end;

//Процедура чтения ключа из файла
procedure LoadKey(FileName : String);//Чтение ключа
var FKeyF : file of TFKey;
    FKey : TFKey;
    S : String;
    i : Integer;
begin
  {$I-}
  AssignFile(FKeyF, FileName);
  FileMode := fmOpenRead;
  Reset(FKeyF);
    Read(FKeyF, FKey);
    MainKey:= FKey.Key;
    if FKey.VType then
    begin
      //Загрузка ключа в Alpha форме
      S:= '';
      for i:= 0 to MaxKeyLength do
        S:= S + CardinalToFmtStr(FKey.Key[i], FmtAlpha);
      MainForm.AlphaEdit.Text:= S;
    end
    else
    begin
      //Загрузка ключа в Hex форме
      S:= '';
      for i:= 0 to MaxKeyLength do
      begin
        S:= S + CardinalToFmtStr(FKey.Key[i], FmtHex);
      end;
      MainForm.HexEdit.Text:= S;
    end;
    MainForm.AlphaRadio.Checked:= FKey.VType;
    MainForm.HexRadio.Checked:= not FKey.VType;
  CloseFile(FKeyF);
  {$I+}
end;

//Процедура сохранения ключа в файл
procedure SaveKey(FileName : String);
var FKeyF : file of TFKey;
    FKey : TFKey;
begin
  {$I-}
  AssignFile(FKeyF, FileName);
  FileMode := fmOpenWrite;
  ReWrite(FKeyF);
  FKey.Key:= MainKey;
  FKey.VType:= MainForm.AlphaRadio.Checked;
  Write(FKeyF, FKey);
  CloseFile(FKeyF);
  {$I+}
end;

procedure TMainForm.LoadKeyButtonClick(Sender: TObject);
begin
  FileOpenDialog.Title:= 'Открытие ключа шифрования';
  FileOpenDialog.Filter:= 'Ключи шифрования (*.eck)|*.eck';
  FileOpenDialog.DefaultExt:= 'eck';
  FileOpenDialog.FileName:= '';
  if FileOpenDialog.Execute then
  begin
    LoadKey(FileOpenDialog.FileName);
  end;
end;

procedure TMainForm.SaveKeyButtonClick(Sender: TObject);
begin
  FileSaveDialog.Title:= 'Сохранение ключа шифрования';
  FileSaveDialog.Filter:= 'Ключи шифрования (*.eck)|*.eck';
  FileSaveDialog.DefaultExt:= 'eck';
  FileSaveDialog.FileName:= '';
  if FileSaveDialog.Execute then
  begin
    SaveKey(FileSaveDialog.FileName);
  end;
end;

procedure TMainForm.OpenEncryptTextClick(Sender: TObject);
begin
  FileOpenDialog.Title:= 'Открытие шифрованного файла';
  FileOpenDialog.Filter:= 'Шифрованные файлы (*.ecf)|*.ecf';
  FileOpenDialog.DefaultExt:= 'ecf';
  FileOpenDialog.FileName:= '';
  if FileOpenDialog.Execute then
  begin
    DestStream.Clear;
    DestStream.LoadFromFile(FileOpenDialog.FileName);
    ListChanges.Clear;  //Удаление меток об исправлениях в шифртексте, если они были
    FilterEncrData;
    if FileExists(ChangeFileExt(FileOpenDialog.FileName, '.eck')) then
      if MessageBox(Handle,'Вы желаете открыть ключ (де)шифрования?', 'Открытие ключа (де)шифрования', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = IDYES then
        LoadKey(ChangeFileExt(FileOpenDialog.FileName, '.eck'));
  end;
end;

procedure TMainForm.SaveEncryptTextClick(Sender: TObject);
begin
  FileSaveDialog.Title:= 'Сохранение шифрованного файла';
  FileSaveDialog.Filter:= 'Шифрованные файлы (*.ecf)|*.ecf';
  FileSaveDialog.DefaultExt:= 'ecf';
  FileSaveDialog.FileName:= '';
  if FileSaveDialog.Execute then
  begin
    DestStream.SaveToFile(FileSaveDialog.FileName);
    if MessageBox(Handle,'Вы желаете сохранить ключ (де)шифрования?', 'Сохранение ключа (де)шифрования', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = IDYES then
      SaveKey(ChangeFileExt(FileSaveDialog.FileName, '.eck'));
  end;
end;

//Обработка изменения размеров формы
procedure TMainForm.FormResize(Sender: TObject);
var wdt : Integer;
begin
  wdt:= (ClientWidth - EncryptButton.Width - 8) div 2;
  //EnCryptMemo.Width:= wdt;
  //SourceMemo.Width:= wdt;
  //EnCryptMemo.Left:= ClientWidth - wdt;
  //EnCryptMemo.Height:= ClientHeight - 65;
  //EncryptButton.Left:= SourceMemo.Width + 5;
  //DecryptButton.Left:= SourceMemo.Width + 5;
  //EncrEditButton.Left:=SourceMemo.Width + 5;
  //CaseAlg.Left:=SourceMemo.Width+5;
end;

//Показать окно таблицы замен
procedure TMainForm.ShowChTabButtonClick(Sender: TObject);
begin
  ChTabForm.Visible:= True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var FileNet: TextFile;
    s: String;
begin
//  EnCryptMemo.Height:= ClientHeight - KeyGroup.Height;
  Randomize;
  RegCrypt:=RPZ;
  CaseAlg.Hint:='Режим простой замены';
  //MaskEdit1.Enabled := false;
  Panel1.Visible:=false;
  //EnCryptMemo.Top:= 60;
  //LoadSyncButton.Enabled:=false;
  //SaveSyncButton.Enabled:=false;
  WType:=true;
  FileStreamVirtual:=TMemoryStream.Create;
end;


procedure TMainForm.N3Click(Sender: TObject);
Var sx, temps :string;
    gg, nn, zz1, one, two, temp, key1: TBigInt;
    x, base, len: integer;
    StrStream: TStringStream;
    i: cardinal;
    FF : Cardinal;
    tmp : String;
begin
     HexRadio.Checked:=true;
     HexRadio.SetFocus;
     RandomBig(64,key1);
     BigInttoStr(key1,temps);
     HexEdit.Text:=temps;
     len:=length(HexEdit.Text);
     for base:= 0 to MaxKeyLength do
      begin
        tmp:= '';
        for i:= 1 to 8 do
          begin
            if (base*8 + i) <= len then
              if HexEdit.Text[(base*8) + i] <> ' ' then
                begin
                  tmp:= tmp + HexEdit.Text[(base*8)+ i];
                  Continue;
                end;
            tmp:= tmp + '0';
          end;
        FF:= HexToInt(tmp);
        MainKey[Base]:= FF;
      end;
     Abort;
 WaitForm.Show;
 DestroyX(Nkey);
 DestroyX(Gkey);
 KKey:=nil; OKey:=nil;
 SetLength(Kkey,KeyKol);  SetLength(Okey,KeyKol);
 sx:='1'; StrtoBigInt(sx,one);
 sx:='2'; StrtoBigInt(sx,two);
 x:=GenOneProst;
 DectoBigHex(x,nn);
 XCopyY(nn,NKey);
 XSubY(nn,one,gg);
 XCopyY(gg,temp);
 destroyX(gg);
 XdivY(temp,two,gg,zz1);
 XCopyY(gg,GKey);
 DestroyX(zz1);
 NP:=true;
end;

{Изменение режима криптографического преобразования}
procedure TMainForm.CaseAlgChange(Sender: TObject);
var a: byte;
begin
 a:=CaseAlg.ItemIndex;
 case a of
  0: Begin
      RegCrypt:=RPZ;
      CaseAlg.Hint:='Режим простой замены';
      Panel1.Visible:=false;
      //EnCryptMemo.Top:= 60;
      DecryptButton.Enabled:=true;
      DecryptButton.Visible:=false;
      EncrEditButton.Visible:=false;
      DecryptButton.Visible:=true;
      EncrEditButton.Visible:=true;

      end;
  1: Begin
      RegCrypt:=RG;
      CaseAlg.Hint:='Режим гаммирования';
      Panel1.Visible:=true;
      //EnCryptMemo.Top:= 89;
      DecryptButton.Visible:=false;
      EncrEditButton.Visible:=false;
      DecryptButton.Visible:=true;
      EncrEditButton.Visible:=true;
      EncryptButton.Caption:='Зашифровать ';
     end;
  2: Begin
      RegCrypt:=RGOS;
      CaseAlg.Hint:='Режим гаммирования с обратной связью';
      Panel1.Visible:=true;
      //EnCryptMemo.Top:= 89;
      DecryptButton.Visible:=true;
      EncrEditButton.Visible:=true;
      EncryptButton.Caption:='Зашифровать ';
     end;
  3: Begin
      RegCrypt:=RIV;
      CaseAlg.Hint:='Режим выработки имитовставки';
      Panel1.Visible:=false;
      //EnCryptMemo.Top:= 60;
      DecryptButton.Visible:=false;
      EncrEditButton.Visible:=false;
      EncryptButton.Caption:='Вычислить';
     end;
 end; {case}
end;

{procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
If CheckBox1.Checked = false
   then
    begin
     MaskEdit1.Enabled:=false;
     MaskEdit1.Text:='';
     //LoadSyncButton.Enabled:=false;
     //SaveSyncButton.Enabled:=false;
    end
   else
    begin
     MaskEdit1.Enabled:=true;
     //LoadSyncButton.Enabled:=true;
     //SaveSyncButton.Enabled:=true;
    end;
end; }

procedure TMainForm.MaskEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  Key:= UpCase(Key);
  if not(((Key >= 'A')and(Key <= 'F'))or((Key >= '0') and (Key <= '9'))or (Key = #8)) then
    Key:= '_';
end;

procedure TMainForm.MaskEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i, base, len : Integer;
    FF : Cardinal;
    tmp : String;
begin
  len:= Length(MaskEdit1.Text);
  for base:= 0 to 1 do
  begin
    tmp:= '';
    for i:= 1 to 8 do
    begin
      if base*8 + i <= len then
      if MaskEdit1.Text[(base*8) + i] <> ' ' then
      begin
        tmp:= tmp + MaskEdit1.Text[(base*8)+ i];
        Continue;
      end;
      tmp:= tmp + '0';
    end;
    FF:= HexToInt(tmp);
    SyncrManual[Base]:= FF;
  end;
end;


//Процедура сохранения синхропосылки в файл
procedure SaveSync(FileName : String);
var FSyncrF : file of CrBlock;
    FSyncr{,Synctemp}: CrBlock;
begin
  {$I-}
  AssignFile(FSyncrF, FileName);
  FileMode := fmOpenWrite;
  ReWrite(FSyncrF);
  FSyncr:= SyncrManual;
  Write(FSyncrF, FSyncr);
  CloseFile(FSyncrF);
  {$I+}
end;

//Процедура загрузки синхропосылки из файл
procedure LoadSync(FileName : String);//Чтение ключа
var FSyncrF : file of CrBlock;
    FSyncr : CrBlock;
  //  S : String;
  //  i : Integer;
begin
  {$I-}
  AssignFile(FSyncrF, FileName);
  FileMode := fmOpenRead;
  Reset(FSyncrF);
  Read(FSyncrF, FSyncr);
  SyncrManual := FSyncr;
  MainForm.MaskEdit1.Text := CardinalToFmtStr(SyncrManual[0], 1) + CardinalToFmtStr(SyncrManual[1], 1);
  CloseFile(FSyncrF);
  {$I+}
end;

procedure TMainForm.LoadSyncButtonClick(Sender: TObject);
begin
 FileOpenDialog.Title:= 'Загрузка синхропосылки';
  FileOpenDialog.Filter:= 'Синхропосылки (*.snc)|*.snc';
  FileOpenDialog.DefaultExt:= 'snc';
  FileOpenDialog.FileName:= '';
  if FileOpenDialog.Execute then
   begin
    LoadSync(FileOpenDialog.FileName);
   end;
end;

procedure TMainForm.SaveSyncButtonClick(Sender: TObject);
begin
  FileSaveDialog.Title:= 'Сохранение синхропосылки';
  FileSaveDialog.Filter:= 'Синхропосылки (*.snc)|*.snc';
  FileSaveDialog.DefaultExt:= 'snc';
  FileSaveDialog.FileName:= '';
  if FileSaveDialog.Execute then
  begin
    SaveSync(FileSaveDialog.FileName);
  end;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
N5.Checked:=false;
N6.Checked:=True;
WType:=false;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
N6.Checked:=false;
N5.Checked:=True;
WType:=true;
end;

function MGetFileSize(const FileName:string):longint;
var
SearchRec:TSearchRec;
begin
if FindFirst(ExpandFileName(FileName),faAnyFile,SearchRec)=0
then Result:=SearchRec.Size else result:=-1;
FindClose(SearchRec);
end;



procedure TMainForm.C_MemoClick(Sender: TObject);
begin
C_Memo.Checked:=true;
C_Virtual.Checked:=False;
SourceMemo.ReadOnly:=false;
end;

procedure TMainForm.C_VirtualClick(Sender: TObject);
begin
C_Memo.Checked:=False;
C_Virtual.Checked:=True;
SourceMemo.ReadOnly:=true;
if LengthFileW=0 then OpenFileLog;
if LengthFileW=0 then begin
Application.MessageBox('Файл не выбран!','Ошибка!', mb_IconHand+mb_Ok);
C_Memo.Checked:=true;C_Virtual.Checked:=False;SourceMemo.ReadOnly:=false;
end else begin
SourceMemo.Text:='Текущий файл для шифрования:'+#13#10+FileNameW;
SourceMemo.Text:=SourceMemo.Text+#13#10+'Длина файла:'+IntToStr(LengthFileW)+' (байт).';
end;end;

procedure TMainForm.N8Click(Sender: TObject);
begin
ChTabForm.Visible:= True;
end;

end.
