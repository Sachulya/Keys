unit uChTab; //Таблица замен

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TChTabForm = class(TForm)
    ChTabGrid: TStringGrid;
    LoadButton: TButton;
    SaveButton: TButton;
    ByDefButton: TButton;
    ChtabOpenDialog: TOpenDialog;
    ChTabSaveDialog: TSaveDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ByDefButtonClick(Sender: TObject);
    procedure ChTabGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure ChTabGridGetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure ChTabGridKeyPress(Sender: TObject; var Key: Char);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateGrid;
  public
    { Public declarations }
  end;

var
  ChTabForm: TChTabForm;

implementation

uses SharedFunc;

const ChTabDefFile = 'ChTabDef.chf';  //Имя файла таблицы замен по умолчанию

{$R *.dfm}

//Преобразование таблицы из сжатого формата в обычный (128 байт)
procedure TranslateTmpChTab(TmpChTab : TChTab);
var i, j : Integer;
begin
  for j:= 0 to 7 do
    for i:= 0 to 15 do
      if i mod 2 = 0 then
    	  ChTab[i, j]:= TmpChTab[(j shl 3)+ (i div 2)] shr 4
      else
        ChTab[i, j]:= TmpChTab[(j shl 3)+ (i div 2)] and $0F;
end;

//Преобразование таблицы в зжатый формат (64 байта)
function TranslateToTmpChTab : TChTab;
var i, j : Integer;
begin
  for j:= 0 to 7 do
    for i:= 0 to 15 do
      if i mod 2 = 0 then
    	  Result[(j shl 3)+ (i div 2)]:= ChTab[i, j] shl 4
      else
        Result[(j shl 3)+ (i div 2)]:= Result[(j shl 3)+ (i div 2)] or ChTab[i, j];
end;

//Создание тривиальной таблицы
procedure FillChTabByDef;
var i, j : Integer;
begin
  for j:= 0 to 7 do
    for i:= 0 to 15 do
    	ChTab[i, j]:= i;
end;

//Чтение таблицы из файла
procedure LoadChTab(FileName : String);
var ChTabF : file of TChTab;
    TmpChTab : TChTab;
begin
  {$I-}
  AssignFile(ChTabF, FileName);
  FileMode := fmOpenRead;
  Reset(ChTabF);
  if (IOResult = 0)and(FileSize(ChTabF) >= 1) then
  begin
    Read(ChTabF, TmpChTab);
    TranslateTmpChTab(TmpChTab);
  end
  else
    FillChTabByDef;
  CloseFile(ChTabF);
  {$I+}
end;

//Сохранение таблицы в файл
procedure SaveChTab(FileName : String);
var ChTabF : file of TChTab;
    TmpChTab : TChTab;
begin
  {$I-}
  AssignFile(ChTabF, FileName);
  FileMode := fmOpenWrite;
  ReWrite(ChTabF);
  TmpChTab:= TranslateToTmpChTab;
  Write(ChTabF, TmpChTab);
  CloseFile(ChTabF);
  {$I+}
end;

//Обновление таблицы (в окне)
procedure TChTabForm.UpdateGrid;
var i, j : Integer;
begin
  for j:= 1 to 8 do
    for i:= 1 to 16 do
     ChTabGrid.Cells[i, j]:= IntToHex(ChTab[i-1, j-1], 1);
end;

procedure TChTabForm.FormCreate(Sender: TObject);
var i : Integer;
begin
  //Заполнение названий столюцов и строк
	for i:= 0 to 15 do
		ChTabGrid.Cells[i+1, 0]:= IntToHex(i, 1);
	for i:= 0 to 7 do
		ChTabGrid.Cells[0, i+1]:= IntToStr(i);

  //Загрузка таблицы по умолчанию
  ByDefButton.OnClick(ByDefButton);

  //Располагание формы в правом верхнем углу
  Top:= 25;
  Left:= Screen.WorkAreaWidth - Width + Screen.WorkAreaLeft;
end;

//Отображение таблицы
procedure TChTabForm.FormShow(Sender: TObject);
var i, j : Integer;
begin
  for j:= 1 to 8 do
    for i:= 1 to 16 do
     ChTabGrid.Cells[i, j]:= IntToHex(ChTab[i-1, j-1], 1);
end;

//Обработка нажатия кнопки "По умолчанию"
procedure TChTabForm.ByDefButtonClick(Sender: TObject);
begin
  LoadChTab(ExtractFilePath(Application.ExeName) + ChTabDefFile);
  UpdateGrid;
end;

//Внесение изменений в таблицу (которая в пямяти)
procedure TChTabForm.ChTabGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  ChTab[ACol-1, ARow-1]:= StrToIntDef(Value, 0);
end;

//Выдача маски
procedure TChTabForm.ChTabGridGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  Value:= 'A';
end;

//Проверка допустимости введенного символа
procedure TChTabForm.ChTabGridKeyPress(Sender: TObject; var Key: Char);
begin
  Key:= AnsiUpperCase(String(Key))[1];
  if not(((Key >= 'A')and(Key <= 'F'))or((Key >= '0') and (Key <= '9'))or (Key = #13) or (Key = #8)) then
    Key:= #0;
end;

//Обработка нажатия кнопки "Загрузить"
procedure TChTabForm.LoadButtonClick(Sender: TObject);
begin
  ChTabOpenDialog.FileName:= '';
  if ChTabOpenDialog.Execute then
  begin
    LoadChTab(ChTabOpenDialog.FileName);
    UpdateGrid;
  end;
end;

//Обработка нажатия кнопки "Сохранить"
procedure TChTabForm.SaveButtonClick(Sender: TObject);
begin
  ChTabSaveDialog.FileName:= '';
  if ChTabSaveDialog.Execute then
  begin
    SaveChTab(ChTabSaveDialog.FileName);
  end;
end;

end.
