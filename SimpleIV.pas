unit SimpleIV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SharedFunc,uMainStep;

type
  TSimpleIVForm = class(TForm)
    EndButton: TButton;
    MemoLog: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure EndButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MX:byte;
  SimpleIVForm: TSimpleIVForm;

function fSimpleIV(Block64 : CrBlock; sKey : TKey; Detail : Boolean): CrBlock;

implementation

Var SimpleN, SimpleN0, SimpleN1: crBlock;
    NCycle: word;
    sfKey: TKey;
    flag,NC: byte;
    E,N:string;

{$R *.dfm}
function SimpleIVD(Block64 : CrBlock; sKey : TKey): CrBlock;
 var k, j : Integer;
		N : CrBlock;
begin
	N:= Block64;

	for k:=1 to 2 do
		for j:= 0 to MaxKeyLength do
			N:= MainStep(N, sKey[j], False);

	Result[0]:= N[0];
	Result[1]:= N[1];
end;


function fSimpleIV(Block64 : CrBlock; sKey : TKey; Detail : Boolean): CrBlock;
begin
  with SimpleIVForm do
  begin
    if Detail then
    begin
      SimpleN0:=Block64;
      SimpleN:=SimpleN0;
      SfKey:=sKey;
      ShowModal;
      Result:= SimpleN;
    end
    else
      Result:= SimpleIVD(Block64, sKey);
  end;
end;


procedure TSimpleIVForm.FormShow(Sender: TObject);
begin
  E:=#13#10;N:='--------------------------------------------------'+#13#10;
  NC:=0;
  Button1.Enabled:=true;
  Button2.Enabled:=true;
  NCycle:=0; flag:=0;
  MemoLog.Text:='';
  MemoLog.Text:='В алгоритме 16 циклов'+E+
  'Исходные значения:'+E+
  'N1=H['+CardinalToFmtStr(SimpleN0[0],1)+']'+' A['+CardinalToFmtStr(SimpleN0[0],2);
  MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleN0[1],1)+']'+' A['+CardinalToFmtStr(SimpleN0[1],2);
  MemoLog.Text:=MemoLog.Text+'] '+E+N;
 end;

procedure TSimpleIVForm.EndButtonClick(Sender: TObject);
begin
MX:=80;close;
end;


procedure TSimpleIVForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var k, j : Integer;
    n: word;
begin
   n:=NCycle;
 	for k:=flag+1 to 2 do
   begin
		for j:= n to MaxKeyLength do
			SimpleN:= MainStep(SimpleN, sfKey[j], False);
    n:=0;
   end;
end;



procedure TSimpleIVForm.Button1Click(Sender: TObject);
begin

 SimpleN1:=SimpleN;
 SimpleN:=MainStep(SimpleN1, sfKey[NCycle], false);
  MX:=NCycle;
inc(NCycle);inc(NC);
 if (NCycle=8)and(flag<>1) then
  begin
   flag:=1; NCycle:=0;
  end;
 if (NCycle=8)and(flag=1)then
  begin
   Button1.Enabled:=false;
   Button2.Enabled:=false;
   end;
  MemoLog.Text:=MemoLog.Text+Inttostr(NC)+' - N1=H['+CardinalToFmtStr(SimpleN[0],1)+'] A['+CardinalToFmtStr(SimpleN[0],2);
  MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleN[1],1)+'] A['+CardinalToFmtStr(SimpleN[1],2);
  MemoLog.Text:=MemoLog.Text+'] ';
   MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(MX)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
 MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
 if Button1.Enabled=false then begin
 MemoLog.Text:=MemoLog.Text+E+N+'Результат преобразования:'+E+'N1=H['+CardinalToFmtStr(SimpleN[0],1)+'] A['+CardinalToFmtStr(SimpleN[0],2);
  MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleN[1],1)+'] A['+CardinalToFmtStr(SimpleN[1],2);
  MemoLog.Text:=MemoLog.Text+'] ';
   MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
 end;
 end;

procedure TSimpleIVForm.Button2Click(Sender: TObject);
begin
 MX:=NCycle;
 SimpleN1:=SimpleN;
 SimpleN:=MainStep(SimpleN1, sfKey[NCycle], true);
  inc(NCycle);inc(NC);
 if (NCycle=8)and(flag<>1) then
  begin
   flag:=1; NCycle:=0;
  end;
 if (NCycle=8)and(flag=1)then
  begin
   Button1.Enabled:=false;
   Button2.Enabled:=false;
   end;
  MemoLog.Text:=MemoLog.Text+Inttostr(NC)+' - N1=H['+CardinalToFmtStr(SimpleN[0],1)+'] A['+CardinalToFmtStr(SimpleN[0],2);
  MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleN[1],1)+'] A['+CardinalToFmtStr(SimpleN[1],2);
  MemoLog.Text:=MemoLog.Text+'] ';
  MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(MX)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';

 MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
 if Button1.Enabled=false then begin
 MemoLog.Text:=MemoLog.Text+E+N+'Результат преобразования:'+E+'N1=H['+CardinalToFmtStr(SimpleN[0],1)+'] A['+CardinalToFmtStr(SimpleN[0],2);
  MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleN[1],1)+'] A['+CardinalToFmtStr(SimpleN[1],2);
  MemoLog.Text:=MemoLog.Text+'] ';
    MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
 end;
 end;

end.
