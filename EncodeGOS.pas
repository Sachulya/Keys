unit EncodeGOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Encode, SharedFunc, SimpleEn, ComCtrls;

type
  TEncodeGOSForm = class(TForm)
    BlockSheme: TImage;
    Step0Group: TGroupBox;
    Step0S1Edit: TEdit;
    Step0S0Edit: TEdit;
    Step0Box: TComboBox;
    CycleGroup: TGroupBox;
    Step1T1Edit: TEdit;
    Step1T0Edit: TEdit;
    Step1S1Edit: TEdit;
    Step1S0Edit: TEdit;
    Step1Z1Edit: TEdit;
    Step1Z0Edit: TEdit;
    Step1T1ResEdit: TEdit;
    Step1T0ResEdit: TEdit;
    InButton: TButton;
    NextButton: TButton;
    Step1TBox: TComboBox;
    Step1ZBox: TComboBox;
    Step1SBox: TComboBox;
    Step1TResBox: TComboBox;
    ScrollBar1: TScrollBar;
    EndButton: TButton;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    procedure Step0BoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Step1TBoxChange(Sender: TObject);
    procedure Step1SBoxChange(Sender: TObject);
    procedure Step1ZBoxChange(Sender: TObject);
    procedure Step1TResBoxChange(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure UpdateProgress;
    procedure CryptGOS(Fl: Boolean);
    procedure InButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EndButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EncodeGOSForm: TEncodeGOSForm;
  Sync, ZSynchr, SourceBlock, ReceiveBlock: CrBlock;
  Flprog: boolean;

implementation

uses EncodeGam;
{$R *.dfm}

procedure TEncodeGOSForm.Step0BoxChange(Sender: TObject);
begin
  Step0S0Edit.Text:= CardinalToFmtStr(Synchr[1], Step0Box.ItemIndex);
  Step0S1Edit.Text:= CardinalToFmtStr(Synchr[0], Step0Box.ItemIndex);
end;

procedure TEncodeGOSForm.FormShow(Sender: TObject);
begin
  Step0S0Edit.Text:= CardinalToFmtStr(Synchr[1], Step0Box.ItemIndex);
  Step0S1Edit.Text:= CardinalToFmtStr(Synchr[0], Step0Box.ItemIndex);
  Step1S1Edit.Text:= ''; Step1S0edit.Text:= '';
  Step1T1Edit.Text:= ''; Step1T0edit.Text:= '';
  Step1Z1Edit.Text:= ''; Step1Z0edit.Text:= '';
  Step1T1ResEdit.Text:= ''; Step1T0Resedit.Text:= '';
  InButton.Enabled:=true;
  NextButton.Enabled:=true;
  Button1.Enabled:=true;
  Sync:=Synchr;
  if TypeCode then
  ProgressBar1.Max:=SourceStream.Size else ProgressBar1.Max:=DestStream.Size;
  ProgressBar1.Position:=0;

  if Image1.Visible=false then begin
  CycleGroup.Visible:=false;
  Step0Group.Visible:=false;
  GroupBox1.Visible:=false;
  BlockSheme.Visible:=false;
  ProgressBar1.Visible:=true;
  EncodeGOSForm.ClientWidth:=450;
  EncodeGOSForm.ClientHeight:=65;
  Timer1.Enabled:=true;

    end else begin
 EncodeGOSForm.ClientWidth:=450;
 EncodeGOSForm.ClientHeight:=320;
 CycleGroup.Visible:=false;Step0Group.Visible:=false;
 BlockSheme.Visible:=true;
 GroupBox1.Visible:=true;
 EndButton.Visible:=false;
 ProgressBar1.Visible:=true;
 Image1.Visible:=true;
 Timer1.Enabled:=false;
 end;
end;

procedure TEncodeGOSForm.Step1TBoxChange(Sender: TObject);
begin
  Step1T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step1TBox.ItemIndex);
  Step1T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step1TBox.ItemIndex);
end;

procedure TEncodeGOSForm.Step1SBoxChange(Sender: TObject);
begin
  Step1S0Edit.Text:= CardinalToFmtStr(Synchr[1], Step1SBox.ItemIndex);
  Step1S1Edit.Text:= CardinalToFmtStr(Synchr[0], Step1SBox.ItemIndex);
end;

procedure TEncodeGOSForm.Step1ZBoxChange(Sender: TObject);
begin
  Step1Z0Edit.Text:= CardinalToFmtStr(ZSynchr[1], Step1ZBox.ItemIndex);
  Step1Z1Edit.Text:= CardinalToFmtStr(ZSynchr[0], Step1ZBox.ItemIndex);
end;

procedure TEncodeGOSForm.Step1TResBoxChange(Sender: TObject);
begin
  Step1T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step1TResBox.ItemIndex);
  Step1T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step1TResBox.ItemIndex);
end;

procedure TEncodeGOSForm.NextButtonClick(Sender: TObject);
Begin
 CryptGOS(false);
end;

procedure TEncodeGOSForm.UpdateProgress;
var En : Boolean;
begin
  if TypeCode then
  begin
    ScrollBar1.Position:= SourceStream.Position*ScrollBar1.Max div SourceStream.Size;
    En:= not (SourceStream.Position = SourceStream.Size);
  end
  else
  begin
    ScrollBar1.Position:= SourceStream.Position*ScrollBar1.Max div SourceStream.Size;
    En:= not (DestStream.Position = DestStream.Size);
  end;
  InButton.Enabled:= En;
  NextButton.Enabled:= En;
  Button1.Enabled:=En;
end;

procedure TEncodeGOSForm.CryptGOS(Fl: Boolean);
begin
 SourceBlock[0]:=0;
 SourceBlock[1]:=0;
 If TypeCode then SourceStream.Read(SourceBlock, sizeof(CrBlock))
  else DestStream.Read(SourceBlock, sizeof(CrBlock));
 Step1T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step1TBox.ItemIndex);
 Step1T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step1TBox.ItemIndex);

 Step1S0Edit.Text:= CardinalToFmtStr(Sync[1], Step1SBox.ItemIndex);
 Step1S1Edit.Text:= CardinalToFmtStr(Sync[0], Step1SBox.ItemIndex);
 ZSynchr:=SimpleEncrypt64(Sync, lKey, Fl);
 Step1Z0Edit.Text:= CardinalToFmtStr(ZSynchr[1], Step1ZBox.ItemIndex);
 Step1Z1Edit.Text:= CardinalToFmtStr(ZSynchr[0], Step1ZBox.ItemIndex);

 ReceiveBlock[0]:=SumMudule2(ZSynchr[0],SourceBlock[0]);
 ReceiveBlock[1]:=SumMudule2(ZSynchr[1],SourceBlock[1]);
 Step1T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step1TResBox.ItemIndex);
 Step1T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step1TResBox.ItemIndex);
 if TypeCode then Sync:= ReceiveBlock
  else Sync:=SourceBlock;


 if TypeCode then DestStream.Write(ReceiveBlock, sizeof(CrBlock))
  else SourceStream.Write(ReceiveBlock, sizeof(CrBlock));
  ProgressBar1.Position:=DestStream.Position;
 UpdateProgress;
end;

procedure TEncodeGOSForm.InButtonClick(Sender: TObject);
begin
 CryptGOS(true);
end;

procedure TEncodeGOSForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if TypeCode then
  while SourceStream.Position < SourceStream.Size do
   begin
    SourceBlock[0]:=0;
    SourceBlock[1]:=0;
    SourceStream.Read(SourceBlock, sizeof(CrBlock));
    ReceiveBlock:= SimpleEncrypt64(Sync, lKey, false);
    ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
    ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
    Sync:=ReceiveBlock;
    DestStream.Write(ReceiveBlock, sizeof(CrBlock));
    ProgressBar1.Position:=DestStream.Position;
   end
  else
   while DestStream.Position < DestStream.Size do
    begin
     SourceBlock[0]:=0;
     SourceBlock[1]:=0;
     DestStream.Read(SourceBlock, sizeof(CrBlock));
     ReceiveBlock:= SimpleEncrypt64(Sync, lKey, false);
     ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
     ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
     Sync:=SourceBlock;
     SourceStream.Write(ReceiveBlock, sizeof(CrBlock));
     ProgressBar1.Position:=SourceStream.Position;
    end;
    Timer1.Enabled:=false;
end;

procedure TEncodeGOSForm.EndButtonClick(Sender: TObject);
begin
close;
end;

procedure TEncodeGOSForm.Timer1Timer(Sender: TObject);
begin
close;
end;

procedure TEncodeGOSForm.Button2Click(Sender: TObject);
begin
 Image1.Visible:=false;
 EncodeGOSForm.ClientWidth:=670;
 EncodeGOSForm.ClientHeight:=287;
 CycleGroup.Visible:=True;Step0Group.Visible:=True;
 ProgressBar1.Visible:=False;
 GroupBox1.Visible:=false;Image1.Visible:=false;
 EndButton.Visible:=true;
 Timer1.Enabled:=false;
end;

procedure TEncodeGOSForm.Button1Click(Sender: TObject);
begin
 CryptGOS(false);
end;

procedure TEncodeGOSForm.Button3Click(Sender: TObject);
begin
close;
end;

end.
