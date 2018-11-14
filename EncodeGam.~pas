unit EncodeGam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, math, matham, SharedFunc, encode, ComCtrls;

type
  TEncodeGamForm = class(TForm)
    BlockSheme: TImage;
    Step0Group: TGroupBox;
    Step0S1Edit: TEdit;
    Step0S0Edit: TEdit;
    Step0Box: TComboBox;
    Step1Group: TGroupBox;
    Step1S1Edit: TEdit;
    Step1S0Edit: TEdit;
    Step1Box: TComboBox;
    InButtonG: TButton;
    NextButtonG: TButton;
    CycleBox: TGroupBox;
    EndButton: TButton;
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
    ProgressBar1: TProgressBar;
    Timer2: TTimer;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Step0BoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Step1BoxChange(Sender: TObject);
    procedure NextButtonGClick(Sender: TObject);
    procedure InButtonGClick(Sender: TObject);
    procedure Step2BoxChange(Sender: TObject);
    procedure Step3TBoxChange(Sender: TObject);
    procedure Step3TResBoxChange(Sender: TObject);
    procedure S2NextButtonClick(Sender: TObject);
    procedure UpdateProgress;
    procedure S2InButtonClick(Sender: TObject);
    procedure EndButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    Procedure StepPress;
    Procedure Step2Press;
    procedure Timer2Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EncodeGamForm: TEncodeGamForm;
  SyncStep1, SyncStep2, SourceBlock, ReceiveBlock: CrBlock;
  Flprog: boolean;
implementation
uses SimpleEn, SimpleDe;
{$R *.dfm}
procedure TEncodeGamForm.Step0BoxChange(Sender: TObject);
begin
  Step0S0Edit.Text:= CardinalToFmtStr(Synchr[1], Step0Box.ItemIndex);
  Step0S1Edit.Text:= CardinalToFmtStr(Synchr[0], Step0Box.ItemIndex);
end;

procedure TEncodeGamForm.FormShow(Sender: TObject);
begin
  Step0S0Edit.Text:= CardinalToFmtStr(Synchr[1], Step0Box.ItemIndex);
  Step0S1Edit.Text:= CardinalToFmtStr(Synchr[0], Step0Box.ItemIndex);
  Step1S1Edit.Text:= ''; Step1S0edit.Text:= '';
  Step2S1Edit.Text:= ''; Step2S0edit.Text:= '';
  Edit1.Text:='';Edit2.Text:='';
  NextButtonG.Enabled:=true;
  InButtonG.Enabled:=true;button2.Enabled:=true;

  S2NextButton.Enabled:=false;
  S2InButton.Enabled:=false;
  ScrollBar1.Position:=0;
  Step3T1Edit.Text:=''; Step3T0Edit.Text:='';
  Step3T1ResEdit.Text:=''; Step3T0ResEdit.Text:='';
  Flprog:=false;
  if TypeCode then
  ProgressBar1.Max:=SourceStream.Size else ProgressBar1.Max:=DestStream.Size;
  ProgressBar1.Position:=0;
  blocksheme.Visible:=false;
  Timer2.Enabled:=false;Button2.Visible:=false;Button4.Visible:=true;

  if Image1.Visible=false then begin
  CycleBox.Visible:=false;Step1Group.Visible:=false;
  Step0Group.Visible:=false;
  ProgressBar1.Visible:=true;
  EncodeGamForm.ClientWidth:=450;
  EncodeGamForm.ClientHeight:=65;
  GroupBox1.Visible:=false;
  Timer2.Enabled:=true;

    end else begin
   EncodeGamForm.ClientWidth:=450;
   EncodeGamForm.ClientHeight:=390;
   GroupBox1.Visible:=true;
   ProgressBar1.Visible:=true;
   CycleBox.Visible:=false;Step1Group.Visible:=false;
  Step0Group.Visible:=false;
  EndButton.Visible:=false;
 end;
end;

procedure TEncodeGamForm.Step1BoxChange(Sender: TObject);
begin
  Step1S0Edit.Text:= CardinalToFmtStr(SyncStep1[1], Step1Box.ItemIndex);
  Step1S1Edit.Text:= CardinalToFmtStr(SyncStep1[0], Step1Box.ItemIndex);
end;

procedure TEncodeGamForm.NextButtonGClick(Sender: TObject);
begin
StepPress;
end;

procedure TEncodeGamForm.InButtonGClick(Sender: TObject);
begin
 SyncStep1:= SimpleEncrypt64(Synchr, lKey, true);
 Step1S0Edit.Text:= CardinalToFmtStr(SyncStep1[1], Step0Box.ItemIndex);
 Step1S1Edit.Text:= CardinalToFmtStr(SyncStep1[0], Step0Box.ItemIndex);
 NextButtonG.Enabled:=false;
 InButtonG.Enabled:=False;
 S2NextButton.Enabled:=true;
 S2InButton.Enabled:=true;
 SyncStep2[0]:=SyncStep1[0];
 SyncStep2[1]:=SyncStep1[1];
 FlProg:=true;
end;

procedure TEncodeGamForm.Step2BoxChange(Sender: TObject);
begin
  Step2S0Edit.Text:= CardinalToFmtStr(SyncStep2[1], Step2Box.ItemIndex);
  Step2S1Edit.Text:= CardinalToFmtStr(SyncStep2[0], Step2Box.ItemIndex);
end;

procedure TEncodeGamForm.Step3TBoxChange(Sender: TObject);
begin
  Step3T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step3TBox.ItemIndex);
  Step3T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step3TBox.ItemIndex);
end;

procedure TEncodeGamForm.Step3TResBoxChange(Sender: TObject);
begin
  Step3T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TResBox.ItemIndex);
  Step3T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TResBox.ItemIndex);
end;

procedure TEncodeGamForm.S2NextButtonClick(Sender: TObject);
begin
Step2Press;
end;

procedure TEncodeGamForm.UpdateProgress;
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
  S2InButton.Enabled:= En;
  S2NextButton.Enabled:= En;
  Button2.Enabled:=En;
end;

procedure TEncodeGamForm.S2InButtonClick(Sender: TObject);
Const C1 = $1010101;
      C2 = $1010104;
begin
 SyncStep2[0]:=(SyncStep2[0]+C1)mod 4294967296;
 SyncStep2[1]:=((SyncStep2[1]+C2-1)mod 4294967295)+1;
 Step2S0Edit.Text:= CardinalToFmtStr(SyncStep2[1], Step2Box.ItemIndex);
 Step2S1Edit.Text:= CardinalToFmtStr(SyncStep2[0], Step2Box.ItemIndex);
 SourceBlock[0]:=0;
 SourceBlock[1]:=0;
 If TypeCode then SourceStream.Read(SourceBlock, sizeof(CrBlock))
  else DestStream.Read(SourceBlock, sizeof(CrBlock));
 Step3T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step3TBox.ItemIndex);
 Step3T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step3TBox.ItemIndex);
 ReceiveBlock:= SimpleEncrypt64(SyncStep2, lKey, true);
 Edit1.Text:= CardinalToFmtStr(ReceiveBlock[0], ComboBox1.ItemIndex);
 Edit2.Text:= CardinalToFmtStr(ReceiveBlock[1], ComboBox1.ItemIndex);
 ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
 ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
 Step3T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TResBox.ItemIndex);
 Step3T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TResBox.ItemIndex);
 if TypeCode then DestStream.Write(ReceiveBlock, sizeof(CrBlock))
  else SourceStream.Write(ReceiveBlock, sizeof(CrBlock));
 UpdateProgress;
end;

procedure TEncodeGamForm.EndButtonClick(Sender: TObject);
begin
Close;
end;

procedure TEncodeGamForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Const C1 = $1010101;
      C2 = $1010104;
begin
 IF Flprog = false then
  begin
   SyncStep1:= SimpleEncrypt64(Synchr, lKey, false);
   SyncStep2[0]:=SyncStep1[0];
   SyncStep2[1]:=SyncStep1[1];
  end;
 if TypeCode then
  while SourceStream.Position < SourceStream.Size do
   begin
    SyncStep2[0]:=(SyncStep2[0]+C1)mod 4294967296;
    SyncStep2[1]:=((SyncStep2[1]+C2-1)mod 4294967295)+1;
    SourceBlock[0]:=0;
    SourceBlock[1]:=0;
    SourceStream.Read(SourceBlock, sizeof(CrBlock));
    ReceiveBlock:= SimpleEncrypt64(SyncStep2, lKey, false);
    ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
    ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
    DestStream.Write(ReceiveBlock, sizeof(CrBlock));
    ProgressBar1.Position:=DestStream.Position;
   end
  else
   while DestStream.Position < DestStream.Size do
    begin
     SyncStep2[0]:=(SyncStep2[0]+C1)mod 4294967296;
     SyncStep2[1]:=((SyncStep2[1]+C2-1)mod 4294967295)+1;
     SourceBlock[0]:=0;
     SourceBlock[1]:=0;
     DestStream.Read(SourceBlock, sizeof(CrBlock));
     ReceiveBlock:= SimpleEncrypt64(SyncStep2, lKey, false);
     ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
     ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
     SourceStream.Write(ReceiveBlock, sizeof(CrBlock));
     ProgressBar1.Position:=SourceStream.Position;
    end;
    Timer2.Enabled:=false;
end;

Procedure TEncodeGamForm.StepPress;
begin
SyncStep1:= SimpleEncrypt64(Synchr, lKey, false);
 Step1S0Edit.Text:= CardinalToFmtStr(SyncStep1[1], Step0Box.ItemIndex);
 Step1S1Edit.Text:= CardinalToFmtStr(SyncStep1[0], Step0Box.ItemIndex);
 NextButtonG.Enabled:=false;
 InButtonG.Enabled:=False;
 Button4.Visible:=false;Button2.Visible:=true;
 S2NextButton.Enabled:=true;
 S2InButton.Enabled:=true;
 SyncStep2[0]:=SyncStep1[0];
 SyncStep2[1]:=SyncStep1[1];
 FlProg:=true;
end;

Procedure TEncodeGamForm.Step2Press;
Const C1 = $1010101;
      C2 = $1010104;
begin
 SyncStep2[0]:=(SyncStep2[0]+C1)mod 4294967296;
 SyncStep2[1]:=((SyncStep2[1]+C2-1)mod 4294967295)+1;
 Step2S0Edit.Text:= CardinalToFmtStr(SyncStep2[1], Step2Box.ItemIndex);
 Step2S1Edit.Text:= CardinalToFmtStr(SyncStep2[0], Step2Box.ItemIndex);
 SourceBlock[0]:=0;
 SourceBlock[1]:=0;
 If TypeCode then SourceStream.Read(SourceBlock, sizeof(CrBlock))
  else DestStream.Read(SourceBlock, sizeof(CrBlock));
 Step3T0Edit.Text:= CardinalToFmtStr(SourceBlock[1], Step3TBox.ItemIndex);
 Step3T1Edit.Text:= CardinalToFmtStr(SourceBlock[0], Step3TBox.ItemIndex);
 ReceiveBlock:= SimpleEncrypt64(SyncStep2, lKey, false);
 Edit1.Text:= CardinalToFmtStr(ReceiveBlock[0], ComboBox1.ItemIndex);
 Edit2.Text:= CardinalToFmtStr(ReceiveBlock[1], ComboBox1.ItemIndex);
 ReceiveBlock[0]:=SumMudule2(ReceiveBlock[0],SourceBlock[0]);
 ReceiveBlock[1]:=SumMudule2(ReceiveBlock[1],SourceBlock[1]);
 Step3T0ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[1], Step3TResBox.ItemIndex);
 Step3T1ResEdit.Text:= CardinalToFmtStr(ReceiveBlock[0], Step3TResBox.ItemIndex);
 if TypeCode then DestStream.Write(ReceiveBlock, sizeof(CrBlock))
  else SourceStream.Write(ReceiveBlock, sizeof(CrBlock));
 UpdateProgress;
end;

procedure TEncodeGamForm.Timer2Timer(Sender: TObject);
begin
Close;
end;

procedure TEncodeGamForm.Button3Click(Sender: TObject);
begin
close;
end;

procedure TEncodeGamForm.Button1Click(Sender: TObject);
begin
    Image1.Visible:=false;
    EncodeGamForm.ClientWidth:=683;
   EncodeGamForm.ClientHeight:=370;
   GroupBox1.Visible:=false;
 CycleBox.Visible:=True;Step1Group.Visible:=True;
  Step0Group.Visible:=True;
  ProgressBar1.Visible:=False;
  Blocksheme.Visible:=true;
    EndButton.Visible:=true;
end;

procedure TEncodeGamForm.Button4Click(Sender: TObject);
begin
StepPress;
ProgressBar1.Position:=DestStream.Position;
end;

procedure TEncodeGamForm.Button2Click(Sender: TObject);
begin
Step2Press;
ProgressBar1.Position:=DestStream.Position;
end;

procedure TEncodeGamForm.ComboBox1Change(Sender: TObject);
begin
 Edit1.Text:= CardinalToFmtStr(ReceiveBlock[0], ComboBox1.ItemIndex);
 Edit2.Text:= CardinalToFmtStr(ReceiveBlock[1], ComboBox1.ItemIndex);
end;

end.
