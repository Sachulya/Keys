unit SimpleEn;  //Зашифровка 64-битного блока

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharedFunc, ExtCtrls, StdCtrls, ComCtrls;

type
  TSimpleEnForm = class(TForm)
    MemoLog: TMemo;
    ButNext: TButton;
    ButIN: TButton;
    Button1: TButton;
    procedure ButNextClick(Sender: TObject);
    procedure ButINClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitSimpleEnControls;
    procedure NextStepTo;
  public
    { Public declarations }
  end;

var
  Nx:byte;
  SimpleEnForm: TSimpleEnForm;

function SimpleEncrypt64(Block64 : CrBlock; sKey : TKey; Detail : Boolean): CrBlock;

implementation

uses Math, uMainStep ,SimpleIV ,SimpleDE;

{$R *.dfm}

type TSimpleEnDetail = record //Структура для хранения промежуточных данных
       S0 : CrBlock;
       S1 : array [1..3, 0..7] of CrBlock;
       S1Bool : array [1..3, 0..7] of Boolean;
       S2 : array [0..7] of CrBlock;
       S2Bool : array [0..7] of Boolean;
       S3 : CrBlock;
       S3Bool : Boolean;
       CurStage, CurSubStage : Integer;
       sKey : TKey;
     end;

var
    SimpleEnDetail : TSimpleEnDetail;
    E,N:String;
    StatBar:byte;

//Обнуление структуры, для хранения промежуточных данных
procedure InitSimpleEnDetail(Block64 : CrBlock);
var k, j : Integer;
begin
  with SimpleEnDetail do
  begin
    S0:= Block64;
    for k:= 1 to 3 do
      for j:=0 to 7 do
      begin
        S1[k,j][0]:= 0;
        S1[k,j][1]:= 0;
        S1Bool[k,j]:= False;
      end;
    for j:= 0 to 7 do
    begin
      S2[j][0]:= 0;
      S2[j][1]:= 0;
      S2Bool[j]:= False;
    end;
    S3[0]:= 0;
    S3[1]:= 0;
    S3Bool:= False;
    CurStage:= 1;
    CurSubStage:= 8; //CurSubStage div 8 должно давать k = 1
                     //CurSubStage mod 8 должно давать j = 0
                     //Только для 1-й стадии
  end;
end;

//Зашифровка без показа процесса
function SimpleEncrypt64D(Block64 : CrBlock; sKey : TKey): CrBlock;
var k, j : Integer;
		N : CrBlock;
begin
	N:= Block64;

	for k:=1 to 3 do
		for j:= 0 to MaxKeyLength do
			N:= MainStep(N, sKey[j], False);

	for j:= MaxKeyLength downto 0 do
		N:= MainStep(N, sKey[j], False);

	Result[0]:= N[1];
	Result[1]:= N[0];
end;

//Обработка очередного шага зашифровки
procedure ProcessEncrypt(Action : Cardinal);
var k, j : Integer;
		N : CrBlock;
    Detail : Boolean;
begin
  with SimpleEnDetail do
    case Action of
      peEnd : begin
                if CurStage <> 3 then
                begin
                  if CurStage = 1 then
                  begin
                    k:= (CurSubStage-1) div 8;
                    j:= (CurSubStage-1) mod 8;
                    if k = 0 then
                      N:= S0
                    else
                      N:= S1[k, j];
                    //Добиваем незаконченный цикл
                    for j:= (CurSubStage mod 8) to MaxKeyLength do
			                  N:= MainStep(N, sKey[j], False);
                    //Доделываем работу, но кол-во k циклов уже до 2-х
                    for k:= (CurSubStage div 8) to 2 do
		                  for j:= 0 to MaxKeyLength do
			                  N:= MainStep(N, sKey[j], False);
                    S1[3, 7]:= N;
                    CurStage:= 2;
                    CurSubStage:= 0;
                  end;
                  if CurStage = 2 then
                  begin
                    j:= CurSubStage;
                    if j = 0 then
                      N:= S1[3, 7]
                    else
                      N:= S2[j-1];
                    for j:= j to MaxKeyLength do
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
                    if (CurSubStage-1) div 8 = 0 then
                      N:= S0
                    else
                      N:= S1[(CurSubStage-1) div 8, (CurSubStage-1) mod 8];
                    k:= CurSubStage div 8;
                    j:= CurSubStage mod 8;
                    S1[k, j]:= MainStep(N, sKey[j], Detail);
                    S1Bool[k, j]:= True;
                    inc(CurSubStage);
                    if CurSubStage div 8 = 4  then
                    begin
                      CurStage:= 2;
                      CurSubStage:= 0;
                    end;
                  end
                  else
                  {if CurStage = 2 then} //Всегда 2
                  begin
                    j:= CurSubStage;
                    if j = 0 then
                      N:= S1[3, 7]
                    else
                      N:= S2[j-1];
                    S2[j]:= MainStep(N, sKey[MaxKeyLength - j], Detail);
                    S2Bool[j]:= True;
                    inc(CurSubStage);
                    if CurSubStage > 7 then
                    begin
                      CurStage:= 3;
                      CurSubStage:= 0;
                      S3[0]:= S2[j][1];
                      S3[1]:= S2[j][0];
                      S3Bool:= True;
                    end;
                  end;
                end;
              end;
    end;
end;

//Вывод окна зашифровки, если надо, и зашифровка блока
function SimpleEncrypt64(Block64 : CrBlock; sKey : TKey; Detail : Boolean): CrBlock;
begin
  with SimpleEnForm do
  begin
    if Detail then
    begin
      InitSimpleEnDetail(Block64);
      SimpleEnDetail.sKey:= sKey;
      InitSimpleEnControls;
      ButNext.Enabled:=true;ButIN.Enabled:=true;
      ShowModal;
      ProcessEncrypt(peEnd);//Закончить зашифровку
      Result:= SimpleEnDetail.S3;
    end
    else
     Result:= SimpleEncrypt64D(Block64, sKey);
  end;
end;



//Инициализация объектов
procedure TSimpleEnForm.InitSimpleEnControls;
begin
   Nx:=0;
   E:=#13#10;N:='--------------------------------------------------'+#13#10;
   StatBar:=8;SimpleIV.MX:=80;SimpleDE.Nx:=80;
  MemoLog.Text:='В алгоритме 32 цикла'+E+
  'Исходные значения:'+E+
  'N1=H['+CardinalToFmtStr(SimpleEnDetail.S0[0], 1)+']'+' A['+CardinalToFmtStr(SimpleEnDetail.S0[0], 2);
  MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleEnDetail.S0[1], 1)+']'+' A['+CardinalToFmtStr(SimpleEnDetail.S0[1], 2);
  MemoLog.Text:=MemoLog.Text+'] '+E+N;
end;



procedure TSimpleEnForm.ButNextClick(Sender: TObject);
begin
  ProcessEncrypt(peSjOut);
  //ProcessEncrypt(peSjIn);
  NextStepTo;
  end;

procedure TSimpleEnForm.ButINClick(Sender: TObject);
begin
ProcessEncrypt(peSjIn);
  NextStepTo;
  end;


procedure TSimpleEnForm.NextStepTo;
var k, j : Integer;
begin
      k:= StatBar div 8;
      j:= StatBar mod 8;
      if StatBar>31 then begin
      MemoLog.Text:=MemoLog.Text+Inttostr(StatBar-7)+' - N1=H['+CardinalToFmtStr(SimpleEnDetail.S2[StatBar-32][0], 1)+'] A['+CardinalToFmtStr(SimpleEnDetail.S2[StatBar-32][0], 2);
      MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleEnDetail.S2[StatBar-32][1], 1)+'] A['+CardinalToFmtStr(SimpleEnDetail.S2[StatBar-32][1], 2);
      MemoLog.Text:=MemoLog.Text+'] ';
      end else begin
      MemoLog.Text:=MemoLog.Text+Inttostr(StatBar-7)+' - N1=H['+CardinalToFmtStr(SimpleEnDetail.S1[k,j][0], 1)+'] A['+CardinalToFmtStr(SimpleEnDetail.S1[k,j][0], 2);
      MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleEnDetail.S1[k,j][1], 1)+'] A['+CardinalToFmtStr(SimpleEnDetail.S1[k,j][1], 2);
      MemoLog.Text:=MemoLog.Text+'] ';
      end;
      if (StatBar-8)<8 then begin
      MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(StatBar-8)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:= StatBar-7;
      if StatBar-7>7 then Nx:=0;
      end;
      if ((StatBar-8)>7) and ((StatBar-8)<16) then begin
      MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(StatBar-16)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:=StatBar-15;
      if StatBar-15>7 then Nx:=0;
      end;
      if ((StatBar-8)>15) and ((StatBar-8)<24) then begin
      MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(StatBar-24)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:=StatBar-23;
      if StatBar-23>7 then Nx:=7;
      end;
      if (StatBar-8)>23 then begin
      MemoLog.Text:=MemoLog.Text+'; X'+Inttostr(39-StatBar)+'=H['+uMainStep.XX1+'] A['+uMainStep.XX2+']';
      Nx:=38-StatBar;
      end;

      MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
      StatBar:=StatBar+1;
      if StatBar>39 then begin
      ButNext.Enabled:=false;ButIN.Enabled:=false;
      MemoLog.Text:=MemoLog.Text+N+'Результат преобразования:'+E;
      MemoLog.Text:=MemoLog.Text+'N1=H['+CardinalToFmtStr(SimpleEnDetail.S3[0], 1)+'] A['+CardinalToFmtStr(SimpleEnDetail.S3[0], 2);
      MemoLog.Text:=MemoLog.Text+'] ; N2=H['+CardinalToFmtStr(SimpleEnDetail.S3[1], 1)+'] A['+CardinalToFmtStr(SimpleEnDetail.S3[1], 2);
      MemoLog.Text:=MemoLog.Text+']';
      MemoLog.SelStart:=MemoLog.GetTextLen;MemoLog.SelText:=E;
      end;
end;

procedure TSimpleEnForm.Button1Click(Sender: TObject);
begin
Nx:=80;Close;
end;

end.
