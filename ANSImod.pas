unit ANSImod;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, Menus, ComCtrls, Mask, Buttons, ScktComp, matham, netparam,
  SharedFunc, ExtCtrls, Math, DES, KOLBlockCipher, UMathServices;

type
  TANSIX917 = class(TForm)
    CHOISE: TRadioGroup;
    OKBut: TButton;
    ANSIKEY: TEdit;
    Refrash: TButton;
    Consist: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure OKButClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CHOISEClick(Sender: TObject);
    procedure RefrashClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SaveBinKey(i:integer; str:string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ANSIX917: TANSIX917;
  saveFlag:boolean;
  ModAnsiKey:array of string;
  Index:integer;
  NumOfVar:integer;
  temp2:Int64;
  massOfVar4:array[0..23] of array [0..3] of integer = ((0,1,2,3),(0,1,3,2),(0,2,1,3),(0,2,3,1),(0,3,1,2),(0,3,2,1),(1,0,2,3),(1,0,3,2),(1,2,0,3),(1,2,3,0),(1,3,0,2),(1,3,2,0),(2,0,1,3),(2,0,3,1),(2,1,0,3),(2,1,3,0),(2,3,0,1),(2,3,1,0),(3,0,1,2),(3,0,2,1),(3,1,0,2),(3,1,2,0),(3,2,0,1),(3,2,1,0));
  massOfVar2:array[0..5]  of array [0..3] of integer = ((0,0,1,1),(0,1,0,1),(0,1,1,0),(1,0,0,1),(1,0,1,0),(1,1,0,0));
implementation

uses Geerate, Path;

{$R *.dfm}

procedure TANSIX917.Timer1Timer(Sender: TObject);   //��������� ������������ �������
var
  i:Integer;
  key:String;
begin
  if(CHOISE.ItemIndex=0)then
    begin
      Inc(NumOfVar);
      SetLength(ModAnsiKey, 1);
      Timer1.Enabled:=false;
      Refrash.Enabled:=false;
      Kripto.GenANSIX9171.Click;
      key:=Kripto.IntToHex(temp);
      key:=key+key+key+key;
      Consist.Caption:='��������� �����: 1';
      ANSIKEY.Text:=key;
      if saveFlag then SaveBinKey(NumOfVar, ANSIKEY.Text);
      saveFlag:=false;
      Index:=CHOISE.ItemIndex;
      temp2:=temp;
    end;
  if(CHOISE.ItemIndex=1)then
    begin
      Inc(NumOfVar);
      SetLength(ModAnsiKey, 2);
      Consist.Caption:='��������� �����: 6';
      Refrash.Enabled:=true;
      Timer1.Enabled:=false;
      for i:=0 to CHOISE.ItemIndex do
        begin
          Kripto.GenANSIX9171.Click;
          while temp=temp2 do
            begin
              Kripto.GenANSIX9171.Click;
            end;
          ModAnsiKey[i]:=Kripto.IntToHex(temp);
        end;
    end;
    if(CHOISE.ItemIndex=2)then
    begin
      Inc(NumOfVar);
      SetLength(ModAnsiKey, 4);
      Consist.Caption:='��������� �����: 24';
      Refrash.Enabled:=true;
      Timer1.Enabled:=false;
      for i:=0 to CHOISE.ItemIndex+1 do
        begin
          Kripto.GenANSIX9171.Click;
          while temp=temp2 do
            begin
              Kripto.GenANSIX9171.Click;
            end;
          ModAnsiKey[i]:=Kripto.IntToHex(temp);
        end;
    end;
end;

procedure TANSIX917.OKButClick(Sender: TObject);   //��������� ��� ������������� ������ ����� 
var
  k1:key;
  i,numm:integer;
  s,s1:string;
begin
  k1:=key.Create;
  if(ANSIKEY.Text='') then begin ShowMessage('�� ������� ��������� ����.'); exit; end;
  AnsiModd:=false;
  Kripto.HexKey.Text:=ANSIKEY.Text;
  s1:=ANSIKEY.Text;
  k1.toBinnnn;

  Kripto.DecKey.Text:=Kripto.toDec(ANSIKEY.Text);

  Kripto.Info.Lines.Add('����: '+ Kripto.HexKey.Text);
  ready:=true;
  ANSIX917.Visible:=false;

  Kripto.SaveBinKey;
end;

procedure TANSIX917.FormDestroy(Sender: TObject);
begin
  AnsiModd:=false;
  NumOfVar:=0;
end;

procedure TANSIX917.CHOISEClick(Sender: TObject);      
begin
  if(CHOISE.ItemIndex<>Index)then begin Timer1.Enabled:=true; NumOfVar:=0; ANSIKEY.Text:=''; end;
  saveFlag:=true;
end;

procedure TANSIX917.RefrashClick(Sender: TObject);
var
  i,q:Integer;
  s:string;
begin
q:=length(Consist.Caption);
s:=Consist.Caption;
  if((CHOISE.ItemIndex+1)=2) then
    begin
     if(NumOfVar=5) then begin ShowMessage('��� �������� �����������. �������� �������.'); NumOfVar:=0; saveFlag:=false; end;
      ANSIKEY.Text:='';
      for i:=0 to 3 do
      begin
       ANSIKEY.Text:=ANSIKEY.Text+modAnsiKey[massOfVar2[numOfVar][i]];
      end;
      if saveFlag then SaveBinKey(NumOfVar, ANSIKEY.Text);
       if (ANSIKEY.Text<>'') and (q > 18) then Inc(NumOfVar);
       Insert(' ',s,19);
       Consist.Caption:=s;
    end;
    if((CHOISE.ItemIndex+1)=3) then
    begin
     if(NumOfVar=23) then begin ShowMessage('��� �������� �����������. �������� �������.'); NumOfVar:=0; end;
     ANSIKEY.Text:='';
      for i:=0 to 3 do
       begin
        ANSIKEY.Text:=ANSIKEY.Text+modAnsiKey[massOfVar4[numOfVar][i]];
       end;
       if saveFlag then SaveBinKey(NumOfVar, ANSIKEY.Text);
       if (ANSIKEY.Text<>'') and (q > 19) then Inc(NumOfVar);
       Insert(' ',s,20);
       Consist.Caption:=s;
    end;
end;

procedure TANSIX917.FormActivate(Sender: TObject);
begin
   AnsiModd:=true;
   Timer1.Enabled:=true;
   Index:=0;
end;

procedure TANSIX917.SaveBinKey(i:integer; str:string);       //��������� ��� ���������� ����� � �������� ����
var
  bs:SaveToFile;
begin
  pathAutoSavePer:=PathF.BinPath.Text;
  if not DirectoryExists(pathAutoSavePer) then ForceDirectories(pathAutoSavePer);
  AssignFile(bf, pathAutoSavePer+'D '+FormatDateTime('yyyy_mm_dd', Now)+IntToStr(i)+' T '+FormatDateTime('hh_nn_ss_zzz', Now)+'.bin');
  Rewrite(bf);
  bs.s:=str;
  BlockWrite(bf,bs.s,1);
  CloseFile(bf);
end;

end.
