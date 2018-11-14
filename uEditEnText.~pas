unit uEditEnText; //Редактирование шифртекста

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEditEnTextForm = class(TForm)
    PosGroup: TGroupBox;
    PosEdit: TEdit;
    PosBox: TComboBox;
    CloselButton: TButton;
    SaveButton: TButton;
    SourceGroup: TGroupBox;
    SourceEdit: TEdit;
    SourceBox: TComboBox;
    SPosScroll: TScrollBar;
    SPosEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure PosBoxChange(Sender: TObject);
    procedure PosEditChange(Sender: TObject);
    procedure PosEditKeyPress(Sender: TObject; var Key: Char);
    procedure SourceBoxChange(Sender: TObject);
    procedure SPosScrollChange(Sender: TObject);
    procedure SPosEditChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditEnTextForm: TEditEnTextForm;

function EditEnText(Pos : Integer) : Boolean;

implementation

uses SharedFunc, Math;

var PosChar, SourceChar : Char; //Оригинальный и символ для замены
    ResFunc : Boolean; //Возращаемый результат. Были ли изменения внесены?

{$R *.dfm}

//Отображение окна замены
function EditEnText(Pos : Integer) : Boolean;
begin
  ResFunc:= False;
  EditEnTextForm.SPosScroll.Max:= DestStream.Size;
  EditEnTextForm.SPosScroll.Position:= Pos;
  EditEnTextForm.ShowModal;
  Result:= ResFunc;
end;

//Изменение типа отображения/ввода данных
procedure TEditEnTextForm.PosBoxChange(Sender: TObject);
begin
  if PosBox.ItemIndex = 0 then
  begin
    PosEdit.MaxLength:= 2;
    PosEdit.CharCase:= ecUpperCase;
    PosEdit.OnChange:= Nil;
    PosEdit.OnKeyPress:= Nil;
    PosEdit.Text:= IntToHex(Byte(PosChar), 2);
    PosEdit.OnChange:= PosEditChange;
    PosEdit.OnKeyPress:= PosEditKeyPress;
  end
  else
  begin
    PosEdit.CharCase:= ecNormal;
    PosEdit.OnKeyPress:= Nil;
    PosEdit.OnChange:= Nil;
    PosEdit.Text:= PosChar;
    PosEdit.OnChange:= PosEditChange;
    PosEdit.MaxLength:= 1;
  end;
end;

//Обработка ввода данных
procedure TEditEnTextForm.PosEditChange(Sender: TObject);
//Преобразование шестандцатеричного числа (2 символа) в код символа (1)
  function HexToChar(s : String) : Char;
  var
    i: Integer;
    bit4 : Byte;
  begin
    Result:= #0;
    for i:= 1 to Min(2, Length(s)) do
    begin
      case s[i] of
        '0'..'9' : bit4:= Byte(s[i]) - Byte('0');
        'A'..'F' : bit4:= Byte(s[i]) - $37; //Чтобы при A bit4 = 10
      else
        bit4:= 0;
      end;
      Result:= Char(Byte(Result) or (bit4 shl (8 - 4*i)));
    end;
  end;

begin
  if PosBox.ItemIndex = 0 then
  begin
    PosChar:= HexToChar(PosEdit.Text);
  end
  else
  begin
    if Length(PosEdit.Text) > 0 then
      PosChar:= PosEdit.Text[1]
    else
      PosChar:= #0;
  end;
end;

//Пролверка допустимости нажатия определенных клавиш
procedure TEditEnTextForm.PosEditKeyPress(Sender: TObject; var Key: Char);
begin
  Key:= UpCase(Key);
  if not(((Key >= 'A')and(Key <= 'F'))or((Key >= '0')and(Key <= '9'))or(Key = #8)) then
    Key:= #0;
end;

//Изменение типа отображения ИСХОДНОГО символа
procedure TEditEnTextForm.SourceBoxChange(Sender: TObject);
begin
  if SourceBox.ItemIndex = 0 then
    SourceEdit.Text:= IntToHex(Byte(SourceChar), 2)
  else
    SourceEdit.Text:= SourceChar;
end;

//Перемещение по шифртексту
procedure TEditEnTextForm.SPosScrollChange(Sender: TObject);
begin
  SPosEdit.Text:= IntToStr(SPosScroll.Position);
  DestStream.Position:= SPosScroll.Position;
  DestStream.Read(PosChar, 1);
  if ListChanges.Exists(Pointer(SPosScroll.Position)) then
    SourceChar:= Char(ListChanges.Data[Pointer(SPosScroll.Position)])
  else
    SourceChar:= PosChar;
  SourceBox.OnChange(SourceBox);
  PosBox.OnChange(PosBox);
end;

//Никогда не исполнится. Заблокировано.
procedure TEditEnTextForm.SPosEditChange(Sender: TObject);
begin
  SPosScroll.Position:= StrToIntDef((Sender as TEdit).Text, 0)
end;

//Сохранение изменения шифртекста
procedure TEditEnTextForm.SaveButtonClick(Sender: TObject);
begin
  ResFunc:= True; //Вероятно были сделаны изменения
  //Если символы не совпадают, делаем пометку об этом, если это не было сделано ранее
  if PosChar <> SourceChar then
  begin
    if not ListChanges.Exists(Pointer(SPosScroll.Position)) then
      ListChanges.Add(Pointer(SPosScroll.Position), Pointer(SourceChar));
  end
  else
  //Если совпадают - убираем пометку, если она есть
    if ListChanges.Exists(Pointer(SPosScroll.Position)) then ListChanges.Remove(Pointer(SPosScroll.Position));
  //Делаем замено в потоке шифртекста
  DestStream.Position:= SPosScroll.Position;
  DestStream.WriteBuffer(PosChar, 1);
end;

end.
