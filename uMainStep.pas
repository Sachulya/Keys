unit uMainStep;  //Основной шаг

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, Math, ComCtrls, StdCtrls, ExtCtrls, SharedFunc;

type
  TMainStepForm = class(TForm)
    BlockSheme: TImage;
    Step0Group: TGroupBox;
    Step1Group: TGroupBox;
    Step1Edit: TEdit;
    Step2Group: TGroupBox;
    Step2Edit: TEdit;
    Step3Group: TGroupBox;
    Step3Edit: TEdit;
		Step4Group: TGroupBox;
    Step4Edit: TEdit;
    Step0N2Edit: TEdit;
    Step5Group: TGroupBox;
    Step5N2Edit: TEdit;
    Step1Box: TComboBox;
    Step0Box: TComboBox;
    Step4Box: TComboBox;
    Step3Box: TComboBox;
    Step2Box: TComboBox;
    Step5Box: TComboBox;
    XGroup: TGroupBox;
		XEdit: TEdit;
    XBox: TComboBox;
    EndButton: TButton;
    Step5N1Edit: TEdit;
    Step0N1Edit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure XBoxChange(Sender: TObject);
		procedure Step0BoxChange(Sender: TObject);
		procedure Step1BoxChange(Sender: TObject);
    procedure Step2BoxChange(Sender: TObject);
    procedure Step3BoxChange(Sender: TObject);
    procedure Step4BoxChange(Sender: TObject);
    procedure Step5BoxChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EndButtonClick(Sender: TObject);
  private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
  XX1,XX2:string;
	MainStepForm: TMainStepForm;

//Основной шаг. N - 64-х битный блок, X - 32-х разрядный сегмент ключа
//Detail - показывать ли этот шаг подробно, с результатом на каждом этапе обработки
//Возвращает зашифрованный блок.
function MainStep(N : CrBlock; X : Cardinal; Detail : Boolean): CrBlock;

implementation

uses SimpleEn,SimpleDe, SimpleIV;

{$R *.dfm}

type
		TMainStepDetail = record  //Структура для хранения значений на каждом шаге
			X : Cardinal;
			S0N1, S0N2 : Cardinal;
			S1 : Cardinal;
			S2 : Cardinal;
			S3 : Cardinal;
			S4 : Cardinal;
			S5N1, S5N2 : Cardinal;
		end;
   var
  		MainStepDetail : TMainStepDetail;

//Основной шаг. В MainStepDetail записывается результат работы на каждом шаге.
function MainStepD(N : CrBlock; X : Cardinal): CrBlock;
var S : Cardinal;
		i : Integer;
begin
	MainStepDetail.X:= X;
	MainStepDetail.S0N1:= N[0];
	MainStepDetail.S0N2:= N[1];
	S:= N[0]+X;
	MainStepDetail.S1:= S;
	for i:= 0 to 7 do
	begin
		S:= (S and not($F shl(28-(i shl 2)))) or Cardinal(ChTab[(S and ($F shl(28-(i shl 2))))shr(28-(i shl 2)), i])shl(28-(i shl 2));
	end;
	MainStepDetail.S2:= S;
	S:= ROL(S, 11);
	MainStepDetail.S3:= S;
	S:= S xor N[1];
	MainStepDetail.S4:= S;
	MainStepDetail.S5N1:= S;
	MainStepDetail.S5N2:= N[0];
	Result[0]:= S;
	Result[1]:= N[0];
  end;

//Основной шаг. Выдает только результат.
function MainStepS(N : CrBlock; X : Cardinal): CrBlock;
var S : Cardinal;
		i : Integer;
begin
	S:= N[0]+X;
	for i:= 0 to 7 do
	begin
		S:= (S and not($F shl(28-(i shl 2)))) or Cardinal(ChTab[(S and ($F shl(28-(i shl 2))))shr(28-(i shl 2)), i])shl(28-(i shl 2));
	end;
	S:= ROL(S, 11);
	S:= S xor N[1];
	Result[0]:= S;
	Result[1]:= N[0];
 end;

//Выполнение основного шага. Показ окна, если необходимо.
function MainStep(N : CrBlock; X : Cardinal; Detail : Boolean): CrBlock;
begin
	if Detail then
	begin
		Result:= MainStepD(N, X);
    if SimpleEn.Nx<15 then MainStepForm.Edit1.Text:=inttostr(SimpleEn.Nx);
    if SimpleDe.Nx<15 then MainStepForm.Edit1.Text:= inttostr(SimpleDe.Nx);
    if SimpleIV.MX<15 then MainStepForm.Edit1.Text:= inttostr(SimpleIV.MX);
		MainStepForm.ShowModal;
	end
	else
		Result:= MainStepD(N, X);
    XX1:=CardinalToFmtStr(MainStepDetail.X, 1);
    XX2:=CardinalToFmtStr(MainStepDetail.X, 2);
   end;

//Изменение типа представления данных
procedure TMainStepForm.XBoxChange(Sender: TObject);
begin
  XEdit.Text:= CardinalToFmtStr(MainStepDetail.X, TComboBox(Sender).ItemIndex);
end;

procedure TMainStepForm.Step0BoxChange(Sender: TObject);
begin
	Step0N1Edit.Text:= CardinalToFmtStr(MainStepDetail.S0N1, TComboBox(Sender).ItemIndex);
	Step0N2Edit.Text:= CardinalToFmtStr(MainStepDetail.S0N2, TComboBox(Sender).ItemIndex);
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

procedure TMainStepForm.Step5BoxChange(Sender: TObject);
begin
	Step5N1Edit.Text:= CardinalToFmtStr(MainStepDetail.S5N1, TComboBox(Sender).ItemIndex);
	Step5N2Edit.Text:= CardinalToFmtStr(MainStepDetail.S5N2, TComboBox(Sender).ItemIndex);
end;

//Инициализация окна.
procedure TMainStepForm.FormActivate(Sender: TObject);
begin
  XBox.OnChange(XBox);
  Step0Box.OnChange(Step0Box);
  Step1Box.OnChange(Step1Box);
  Step2Box.OnChange(Step2Box);
  Step3Box.OnChange(Step3Box);
  Step4Box.OnChange(Step4Box);
  Step5Box.OnChange(Step5Box);
end;

procedure TMainStepForm.EndButtonClick(Sender: TObject);
begin
close;
end;

end.
