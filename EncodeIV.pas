unit EncodeIV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TEncodeIVForm = class(TForm)
    BlockSheme: TImage;
    CycleBox: TGroupBox;
    Step2S1Edit: TEdit;
    Step2S0Edit: TEdit;
    Step2Box: TComboBox;
    ScrollBar1: TScrollBar;
    S2InButton: TButton;
    S2NextButton: TButton;
    Step3T1Edit: TEdit;
    Step3T0Edit: TEdit;
    Step3T1ResEdit: TEdit;
    Step3T0ResEdit: TEdit;
    Step3TBox: TComboBox;
    Step3TResBox: TComboBox;
    EndButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    Timer4: TTimer;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Image1: TImage;
    procedure EndButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure S2NextButtonClick(Sender: TObject);
    procedure Step3TBoxChange(Sender: TObject);
    procedure Step3TResBoxChange(Sender: TObject);
  //  procedure Step2BoxChange(Sender: TObject);
    procedure UpdateProgress;
    procedure S2InButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer4Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EncodeIVForm: TEncodeIVForm;

implementation
uses SharedFunc, SimpleIV, encode;

var sync, SourceBlock, ReceiveBlock: CrBlock;

{$R *.dfm}

procedure TEncodeIVForm.EndButtonClick(Sender: TObject);
begin
close;
end;

procedure TEncodeIVForm.FormShow(Sender: TObject);
begin
  //Step2S1Edit.Text:= ''; Step2S0edit.Text:= '';
  Step3T1Edit.Text:= ''; Step3T0edit.Text:= '';
  Step3T1ResEdit.Text:= ''; Step3T0ResEdit.Text:= '';
  ReceiveBlock[0]:=0;
  ReceiveBlock[1]:=0;
  S2InButton.Enabled:= true;
  S2NextButton.Enabled:= true;
  Button1.Enabled:=true;
  Button2.Enabled:=true;
  ProgressBar1.Max:=SourceStream.Size;
  ProgressBar1.Position:=0;

  if BlockSheme.Visible=true then begin
  ProgressBar1.Visible:=true;
  EndButton.Visible:=false;
  CycleBox.Visible:=false;
  image1.Visible:=false;
  panel1.Visible:=true;
  EncodeIVForm.ClientWidth:=467;
  EncodeIVForm.ClientHeight:=271;
  timer4.Enabled:=false;
  end;

  if BlockSheme.Visible=false then begin
  CycleBox.Visible:=false;
  ProgressBar1.Visible:=true;
  image1.Visible:=false;
  EncodeIVForm.ClientWidth:=467;
  EncodeIVForm.ClientHeight:=50;
  timer4.Enabled:=true;
  end;

end;

procedure TEncodeIVForm.S2NextButtonClick(Sender: TObject);
begin
 SourceBlock[0]:=0;
 SourceBlock[1]:=0;
 SourceStream.Read(SourceBlock, sizeof(CrBlock));
 Step3T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step3TBox.ItemIndex);
 Step3T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step3TBox.ItemIndex);
 Sync:=ReceiveBlock;
 Step2S0Edit.Text:= CardinalToFmtStr(Sync[1], Step2Box.ItemIndex);
 Step2S1Edit.Text:= CardinalToFmtStr(Sync[0], Step2Box.ItemIndex);
 ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
 ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
 ReceiveBlock:= fSimpleIV(ReceiveBlock, lKey, false);
 Step3T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TResBox.ItemIndex);
 Step3T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TResBox.ItemIndex);
 DestStream.Write(ReceiveBlock, sizeof(CrBlock));
 UpdateProgress;
end;

procedure TEncodeIVForm.Step3TBoxChange(Sender: TObject);
begin
  Step3T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step3TBox.ItemIndex);
  Step3T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step3TBox.ItemIndex);
end;

procedure TEncodeIVForm.Step3TResBoxChange(Sender: TObject);
begin
  Step3T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TResBox.ItemIndex);
  Step3T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TResBox.ItemIndex);
end;

{procedure TEncodeIVForm.Step2BoxChange(Sender: TObject);
begin
 Step2S0Edit.Text:= CardinalToFmtStr(Sync[1], Step2Box.ItemIndex);
 Step2S1Edit.Text:= CardinalToFmtStr(Sync[0], Step2Box.ItemIndex);
end;}

procedure TEncodeIVForm.UpdateProgress;
var En : Boolean;
begin
  if TypeCode then
  begin
    ScrollBar1.Position:= SourceStream.Position*ScrollBar1.Max div SourceStream.Size;
    En:= not (SourceStream.Position = SourceStream.Size);
    ProgressBar1.Position:=SourceStream.Position;
  end
  else
  begin
    ScrollBar1.Position:= SourceStream.Position*ScrollBar1.Max div SourceStream.Size;
    En:= not (DestStream.Position = DestStream.Size);
    ProgressBar1.Position:=SourceStream.Position;
  end;
  S2InButton.Enabled:= En;
  S2NextButton.Enabled:= En;
  button1.Enabled:=En;
  Button2.Enabled:=En;
end;

procedure TEncodeIVForm.S2InButtonClick(Sender: TObject);
begin
  SourceBlock[0]:=0;
 SourceBlock[1]:=0;
 SourceStream.Read(SourceBlock, sizeof(CrBlock));
 //Step3T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step3TBox.ItemIndex);
 //Step3T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step3TBox.ItemIndex);
 Sync:=ReceiveBlock;
 //Step2S0Edit.Text:= CardinalToFmtStr(Sync[1], Step2Box.ItemIndex);
 //Step2S1Edit.Text:= CardinalToFmtStr(Sync[0], Step2Box.ItemIndex);
 ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
 ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);

 Step3T0Edit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TBox.ItemIndex);
 Step3T1Edit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TBox.ItemIndex);

 ReceiveBlock:= fSimpleIV(ReceiveBlock, lKey, true);
 Step3T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TResBox.ItemIndex);
 Step3T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TResBox.ItemIndex);
 DestStream.Write(ReceiveBlock, sizeof(CrBlock));
 UpdateProgress;
end;

procedure TEncodeIVForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 while SourceStream.Position < SourceStream.Size do
  begin
   SourceBlock[0]:=0;
   SourceBlock[1]:=0;
   SourceStream.Read(SourceBlock, sizeof(CrBlock));
   Sync:=ReceiveBlock;
   ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
   ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
   ReceiveBlock:= fSimpleIV(ReceiveBlock, lKey, false);
   DestStream.Write(ReceiveBlock, sizeof(CrBlock));
   ProgressBar1.Position:=SourceStream.Position;
  end;
  {»митовставка составл€ет последние 8 байт потока}
  DestStream.Clear;
  DestStream.Write(ReceiveBlock,sizeof(CrBlock));
end;

procedure TEncodeIVForm.Timer4Timer(Sender: TObject);
begin
Timer4.Enabled:=false;
close;
end;

procedure TEncodeIVForm.Button2Click(Sender: TObject);
begin
  panel1.Visible:=false;
  CycleBox.Visible:=true;
  //ProgressBar1.Visible:=false;
  BlockSheme.Visible:=false;
  EndButton.Visible:=true;
  Image1.Visible:=true;
  EncodeIVForm.ClientWidth:=776;
  EncodeIVForm.ClientHeight:=267;
end;

procedure TEncodeIVForm.Button3Click(Sender: TObject);
begin
close;
end;

procedure TEncodeIVForm.Button1Click(Sender: TObject);
begin
SourceBlock[0]:=0;
 SourceBlock[1]:=0;
 SourceStream.Read(SourceBlock, sizeof(CrBlock));
 Step3T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step3TBox.ItemIndex);
 Step3T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step3TBox.ItemIndex);
 Sync:=ReceiveBlock;
 Step2S0Edit.Text:= CardinalToFmtStr(Sync[1], Step2Box.ItemIndex);
 Step2S1Edit.Text:= CardinalToFmtStr(Sync[0], Step2Box.ItemIndex);
 ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
 ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
 ReceiveBlock:= fSimpleIV(ReceiveBlock, lKey, false);
 Step3T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TResBox.ItemIndex);
 Step3T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TResBox.ItemIndex);
 DestStream.Write(ReceiveBlock, sizeof(CrBlock));
 UpdateProgress;
end;

end.
