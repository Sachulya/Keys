unit MainStep;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, Math, ComCtrls, StdCtrls, ExtCtrls, Grids, IdGlobal;

type
  TMainStepForm = class(TForm)
    Image1: TImage;
    Step0Group: TGroupBox;
    Step1Group: TGroupBox;
    Step1Edit: TEdit;
    Step2Group: TGroupBox;
    Step2Edit: TEdit;
    Step3Group: TGroupBox;
    Step3Edit: TEdit;
    Step4Group: TGroupBox;
    Step4Edit: TEdit;
    Step0N0Edit: TEdit;
    Step0N1Edit: TEdit;
    Step6Group: TGroupBox;
    Step6N0Edit: TEdit;
    Step6N1Edit: TEdit;
    Step1Box: TComboBox;
    Step0Box: TComboBox;
    Step4Box: TComboBox;
    Step3Box: TComboBox;
    Step2Box: TComboBox;
    Step6Box: TComboBox;
    XGroup: TGroupBox;
		XEdit: TEdit;
    XBox: TComboBox;
    NextButton: TButton;
    procedure XBoxChange(Sender: TObject);
    procedure Step0BoxChange(Sender: TObject);
    procedure Step1BoxChange(Sender: TObject);
    procedure Step2BoxChange(Sender: TObject);
    procedure Step3BoxChange(Sender: TObject);
    procedure Step4BoxChange(Sender: TObject);
    procedure Step6BoxChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
	public
		{ Public declarations }
	end;

var
	MainStepForm: TMainStepForm;

implementation

{$R *.dfm}
{$R WindowsXP.res}

const MaxKeyLength = 7;
			FmtBinary = 0;
			FmtHex = 1;
			FmtAlpha = 2;

type
		CrBlock = array [0..1] of Cardinal;
		TKey = array[0..MaxKeyLength] of Cardinal;
		PCardinal = ^Cardinal;

		TMainStepDetail = record
			X : Cardinal;
			S0N0, S0N1 : Cardinal;
			S1 : Cardinal;
			S2 : Cardinal;
			S3 : Cardinal;
			S4 : Cardinal;
			S5 : Cardinal;
			S6N0, S6N1 : Cardinal;
		end;

var
		ChTab : array [0..127] of Byte;
		Key : TKey;
		MainStepDetail : TMainStepDetail;

function ROL(val: LongWord; shift: Byte): LongWord; assembler;
asm
	mov  eax, val;
	mov  cl, shift;
	rol  eax, cl;
end;

function MainStepD(N : CrBlock; X : Cardinal; var StepDet : TMainStepDetail): CrBlock;
var S : Cardinal;
		i : Integer;
begin
	StepDet.X:= X;
	StepDet.S0N0:= N[0];
	StepDet.S0N1:= N[1];
	S:= N[0]+X;
	StepDet.S1:= S;
	for i:= 0 to 7 do
	begin
		S:= (S and not($F shl(28-(i shl 2)))) or Cardinal(ChTab[(S and ($F shl(28-(i shl 2))))shr(28-(i shl 2))])shl(28-(i shl 2));
	end;
	StepDet.S2:= S;
	S:= ROL(S, 11);
	StepDet.S3:= S;
	S:= S xor N[1];
	StepDet.S4:= S;
	StepDet.S6N0:= S;
	StepDet.S6N1:= N[0];
	Result[0]:= S;
	Result[1]:= N[0];
end;

function MainStep(N : CrBlock; X : Cardinal; Detail : Boolean): CrBlock;

begin
	if Detail then
	begin
		Result:= MainStepD(N, X, MainStepDetail);
		MainStepForm.ShowModal;
	end
	else
		Result:= MainStepD(N, X, MainStepDetail);
end;

function SimpleEncrypt64(Block64 : CrBlock; sKey : TKey; len : Byte): CrBlock;
var k, j : Integer;
		N : CrBlock;
begin
	N:= Block64;

	for k:=1 to 3 do
		for j:= 0 to Min(len, MaxKeyLength) do
			N:= MainStep(N, sKey[j], False);

	for j:= Min(len, MaxKeyLength) downto 0 do
		N:= MainStep(N, sKey[j], False);

	Result[0]:= N[1];
	Result[1]:= N[0];
end;

function SimpleDecrypt64(Block64 : CrBlock; sKey : TKey; len : Byte): CrBlock;
var k, j : Integer;
		N : CrBlock;
begin
	N:= Block64;

	for j:= 0 to Min(len, MaxKeyLength) do
		N:= MainStep(N, sKey[j], False);

	for k:= 1 to 3 do
		for j:= Min(len, MaxKeyLength) downto 0 do
			N:= MainStep(N, sKey[j], False);

	Result[0]:= N[1];
	Result[1]:= N[0];
end;

function Gamma64(var S : CrBlock; sKey : TKey; KeyLen : Byte; T : CrBlock) : CrBlock;
const C1 = $01010101;
			C2 = $01010104;
//var i : Cardinal;
begin
//	S:= SimpleEncrypt64(S, sKey, KeyLen);
{	for i:= 0 to TextLen do
	begin}
		S[0]:= S[0] + C1;
		if S[1] < ($FFFFFFFF - C2) then
			S[1]:= S[1] + C2
		else
			S[1]:= S[1] + C2 + 1;
		S:= SimpleEncrypt64(S, sKey, KeyLen);
		T[0]:= T[0] xor S[0];
		T[1]:= T[1] xor S[1];
{	end;}
	Result:= T;
end;

function IntToAlpha(c : Cardinal): String;
type CAlpha = array[0..3] of Char;
var i : Integer;
begin
	Result:= '';
	for i:= 0 to 3 do
	begin
		Result:= Result + CAlpha(c)[i];
	end;
end;

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

procedure TMainStepForm.XBoxChange(Sender: TObject);
begin
	XEdit.Text:= CardinalToFmtStr(MainStepDetail.X, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.Step0BoxChange(Sender: TObject);
begin
	Step0N0Edit.Text:= CardinalToFmtStr(MainStepDetail.S0N0, TComboBox(Sender).ItemIndex);
	Step0N1Edit.Text:= CardinalToFmtStr(MainStepDetail.S0N1, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.Step1BoxChange(Sender: TObject);
begin
	Step1Edit.Text:= CardinalToFmtStr(MainStepDetail.S1, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.Step2BoxChange(Sender: TObject);
begin
	Step2Edit.Text:= CardinalToFmtStr(MainStepDetail.S2, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.Step3BoxChange(Sender: TObject);
begin
	Step3Edit.Text:= CardinalToFmtStr(MainStepDetail.S3, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.Step4BoxChange(Sender: TObject);
begin
  Step4Edit.Text:= CardinalToFmtStr(MainStepDetail.S4, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.Step6BoxChange(Sender: TObject);
begin
	Step6N0Edit.Text:= CardinalToFmtStr(MainStepDetail.S6N0, TComboBox(Sender).ItemIndex);
	Step6N1Edit.Text:= CardinalToFmtStr(MainStepDetail.S6N1, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.FormActivate(Sender: TObject);
begin
	XBox.OnClick(Sender);
end;

end.
