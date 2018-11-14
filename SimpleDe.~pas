unit SimpleDe; //Расшифровка 64-битного блока

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharedFunc, StdCtrls, ExtCtrls;

type
  TSimpleDeForm = class(TForm)
    MemoLog: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
      private
    { Private declarations }
    procedure InitSimpleDeControls;
    procedure NextStepTo;
  public
    { Public declarations }
  end;

var
  SimpleDeForm: TSimpleDeForm;
  Nx:byte;
  E,N:String;
  StepPos:byte;

function SimpleDecrypt64(Block64 : CrBlock; sKey : TKey; Detail : Boolean): CrBlock;

implementation

uses Math, uMainStep ,SimpleEn ,SimpleIV;

{$R *.dfm}

type TSimpleDeDetail = record //Структура для хранения промежуточных данных
       S0 : CrBlock;
       S1 : array [0..7] of CrBlock;
       S1Bool : array [0..7] of Boolean;
       S2 : array [1..3, 0..7] of CrBlock;
       S2Bool : array [1..3, 0..7] of Boolean;
       S3 : CrBlock;
       S3Bool : Boolean;
       CurStage, CurSubStage : Integer;
       sKey : TKey;
     end;

var
    SimpleDeDetail : TSimpleDeDetail;

//Обнуление структуры, для хранения промежуточных данных
procedure InitSimpleDeDetail(Block64 : CrBlock);
var k, j : Integer;
begin
  with SimpleDeDetail do
  begin
    S0:= Block64;
    for j:= 0 to 7 do
    begin
      S1[j][0]:= 0;
      S1[j][1]:= 0;
      S1Bool[j]:= False;
    end;
    for k:= 1 to 3 do
      for j:=0 to 7 do
      begin
        S2[k,j][0]:= 0;
        S2[k,j][1]:= 0;
        S2Bool[k,j]:= False;
      end;
    S3[0]:= 0;
    S3[1]:= 0;
    S3Bool:= False;
    CurStage:= 1;
    CurSubStage:= 0; //CurSubStage div 8 должно давать k = 1
                     //CurSubStage mod 8 должно давать j = 0
                     //Только для 2-й стадии
  end;
end;

//Зашифровка блока без показа процесса
function SimpleDecrypt64D(Block64 : CrBlock; sKey : TKey): CrBlock;
var k, j : Integer;
		N : CrBlock;
begin
	N:= Block64;

	for j:= 0 to MaxKeyLength do
		N:= MainStep(N, sKey[j], False);

	for k:= 1 to 3 do
		for j:= MaxKeyLength downto 0 do
			N:= MainStep(N, sKey[j], False);

	Result[0]:= N[1];
	Result[1]:= N[0];
end;

//Обработка очередного шага расшифровки
procedure ProcessDecrypt(Action : Cardinal);
var k, j : Integer;
		N : CrBlock;
    Detail : Boolean;
begin
  with SimpleDeDetail do
    case Action of
      peEnd : begin
                if CurStage <> 3 then
                begin
                  if CurStage = 1 then
                  begin
                    j:= CurSubStage;
                    if j = 0 then
                      N:= S0
                    else
                      N:= S1[j-1];
                    for j:= j to MaxKeyLength do
                    	N:= MainStep(N, sKey[j], False);

                    S1[7]:= N;
                    CurStage:= 2;
                    CurSubStage:= 8;
                  end;
                  if CurStage = 2 then
                  begin
                    k:= (CurSubStage-1) div 8;
                    j:= (CurSubStage-1) mod 8;
                    if k = 0 then
                      N:= S1[7]
                    else
                      N:= S2[k, j];
                    //Добиваем незаконченный цикл
                    for j:= (CurSubStage mod 8) to MaxKeyLength do
			                  N:= MainStep(N, sKey[MaxKeyLength - j], False);
                    //Доделываем работу, но кол-во k циклов уже до 2-х
                    for k:= (CurSubStage div 8) to 2 do
		                  for j:= 0 to MaxKeyLength do
			                  N:= MainStep(N, sKey[MaxKeyLength - j], False);
                    CurStage:= 3;
                    CurSubStage:= 0;
                    S3[0]:= N[1];
                    S3[1]:= N[0];
                    S3Bool:= True;
                  end;
                end;
              end;
      peSjIn, peSjOut:
              begin
                if CurStage <> 3 then  //Всегда будет True
                begin
                  Detail:= Action = peSjIn;
                  if CurStage = 1 then
                  begin
                    j:= CurSubStage;
                    if j = 0 then
                      N:= S0
                    else
                      N:= S1[j-1];
                    S1[j]:= MainStep(N, sKey[j], Detail);
                    S1Bool[j]:= True;
                    inc(CurSubStage);
                    if CurSubStage > 7 then
                    begin
                      CurStage:= 2;
                      CurSubStage:= 8;
                    end;
                  end
                  else
                  {if CurStage = 2 then} //Всегда 2
                  begin
                    if (CurSubStage-1) div 8 = 0 then
                      N:= S1[7]
                    else
                      N:= S2[(CurSubStage-1) div 8, (CurSubStage-1) mod 8];
                    k:= CurSubStage div 8;
                    j:= CurSubStage mod 8;
                    S2[k, j]:= MainStep(N, sKey[j], Detail);
                    S2Bool[k, j]:= True;
                    inc(CurSubStage);
                    if CurSubStage div 8 = 4  then
                    begin
                      CurStage:= 3;
                      CurSubStage:= 0;
                      S3[0]:= S2[k, j][1];
                      S3[1]:= S2[k, j][0];
                      S3Bool:= True;
                    end;
                  end;
                end;
              end;
    end;
end;

//Вывод окна расшифровки, если надо, и расшифровка блока
function SimpleDecrypt64(Block64 : CrBlock; sKey : TKey; Detail : Boolean): CrBlock;
begin
  with SimpleDeForm do
  begin
    if Detail then
    begin
      InitSimpleDeDetail(Block64);
      SimpleDeDetail.sKey:= sKey;
      InitSimpleDeControls;
     if Detail then ShowModal;
      ProcessDecrypt(peEnd); //Закончить расшифровку
      Result:= SimpleDeDetail.S3;
    end
    else
      Result:= SimpleDecrypt64D(Block64, sKey);
  end;
end;



//Установка всех объектов окна в начальное состояние
procedure TSimpleDeForm.InitSimpleDeControls;
begin
  E:=#13#10;N:='--------------------------------------------------'+#13#10;
  StepPos:=0;Nx:=0;SimpleEn.Nx:=80;SimpleIV.MX:=80;
      MemoLog.Text:='В алгоритме 32 цикла'+E+
  'Исходные значения:'+E+
  'N1=H['+CardinalToFmtStr(SimpleDeDetail.S0[0], 1)+']'+' A['+CardinalToFmtStr(SimpleDeDetail.S0[0], 2);
  MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleDeDetail.S0[1], 1)+']'+' A['+CardinalToFmtStr(SimpleDeDetail.S0[1], 2);
  MemoLog.Text:=MemoLog.Text+'] '+N;
  Button1.Enabled:=true;Button2.Enabled:=true;
 end;

procedure TSimpleDeForm.NextStepTo;
var k, j : Integer;
begin
      k:= StepPos div 8;
      j:= StepPos mod 8;
      if StepPos<8 then begin
      MemoLog.Text:=MemoLog.Text+Inttostr(StepPos+1)+' - N1=H['+CardinalToFmtStr(SimpleDeDetail.S1[StepPos][0], 1)+'] A['+CardinalToFmtStr(SimpleDeDetail.S1[StepPos][0], 2);
      MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleDeDetail.S1[StepPos][1], 1)+'] A['+CardinalToFmtStr(SimpleDeDetail.S1[StepPos][1], 2);
      MemoLog.Text:=MemoLog.Text+'] ';
      end else begin
      MemoLog.Text:=MemoLog.Text+Inttostr(StepPos+1)+' - N1=H['+CardinalToFmtStr(SimpleDeDetail.S2[k,j][0], 1)+'] A['+CardinalToFmtStr(SimpleDeDetail.S2[k,j][0], 2);
      MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleDeDetail.S2[k,j][1], 1)+'] A['+CardinalToFmtStr(SimpleDeDetail.S2[k,j][1], 2);
      MemoLog.Text:=MemoLog.Text+'] ';
      end;
      if (StepPos)<8 then begin MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(StepPos)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:= StepPos+1;
      if StepPos+1>7 then Nx:=7;
      end;
      if ((StepPos)>7) and ((StepPos)<16) then begin MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(15-StepPos)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:= 14-StepPos;
      if StepPos+1>15 then Nx:=7;
      end;
      if ((StepPos)>15) and ((StepPos)<24) then begin MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(23-StepPos)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:= 22-StepPos;
      if StepPos+1>23 then Nx:=7;
      end;
      if (StepPos)>23 then begin MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(31-StepPos)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:=30-StepPos;
      end;
      MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
      StepPos:=StepPos+1;
      if StepPos>31 then begin
      Button1.Enabled:=false;Button2.Enabled:=false;
      MemoLog.Text:=MemoLog.Text+N+'Результат преобразования:'+E;
      MemoLog.Text:=MemoLog.Text+'N1=H['+CardinalToFmtStr(SimpleDeDetail.S3[0], 1)+'] A['+CardinalToFmtStr(SimpleDeDetail.S3[0], 2);
      MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleDeDetail.S3[1], 1)+'] A['+CardinalToFmtStr(SimpleDeDetail.S3[1], 2);
      MemoLog.Text:=MemoLog.Text+']';
      //if (StepPos-8)<8 then MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(StepPos-8)+'=H['+uMainStep.MainStepForm.Edit1.Text+'] A['+uMainStep.MainStepForm.Edit2.Text+']';
      //if ((StepPos-8)>7) and ((StepPos-8)<16) then MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(16-StepPos)+'=H['+uMainStep.MainStepForm.Edit1.Text+'] A['+uMainStep.MainStepForm.Edit2.Text+']';
      //if ((StepPos-8)>15) and ((StepPos-8)<24) then MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(24-StepPos)+'=H['+uMainStep.MainStepForm.Edit1.Text+'] A['+uMainStep.MainStepForm.Edit2.Text+']';
      //if (StepPos-8)>23 then MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(StepPos-39)+'=H['+uMainStep.MainStepForm.Edit1.Text+'] A['+uMainStep.MainStepForm.Edit2.Text+']';
      MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
      end;
end;

procedure TSimpleDeForm.Button1Click(Sender: TObject);
begin
   ProcessDecrypt(peSjOut);
   NextStepTo;
end;

procedure TSimpleDeForm.Button2Click(Sender: TObject);
begin
ProcessDecrypt(peSjIn);
NextStepTo;
end;

procedure TSimpleDeForm.Button3Click(Sender: TObject);
begin
NX:=80;Close;
end;

end.
