unit Encode; //За/расшифровка ВСЕГО текста

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, SharedFunc, math, ImgList, jpeg;

type
  TEncodeForm = class(TForm)
    InButtonPZ: TButton;
    EndButton: TButton;
    NextButtonPZ: TButton;
    CryptProgress: TProgressBar;
    BlockSheme: TImage;
    Timer3: TTimer;
    procedure InButtonPZClick(Sender: TObject);
    procedure NextButtonPZClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    private
    { Private declarations }
    public
    { Public declarations }
    procedure UpdateProgress;

  end;

var
  EncodeForm: TEncodeForm;
  lKey : TKey;
  TypeCode : Boolean; //True - Зашифровка, False - Расшифровка
  Synchr: CrBlock;

procedure Crypt(Key: TKey; RCrypt: TChReg; Encrypt : Boolean; WorkType: Boolean);

implementation

uses SimpleEn, SimpleDe, EncodeGam, EncodeGOS, SimpleIV, EncodeIV;

{$R *.dfm}

//Обработка одного шага
procedure EncryptRoutine(Detail : Boolean);
var SBlock, DBlock : CrBlock;
begin
  SBlock[0]:= 0;
  SBlock[1]:= 0;
  SourceStream.Read(SBlock, sizeof(CrBlock));
  DBlock:= SimpleEncrypt64(SBlock, lKey, Detail);
  DestStream.Write(DBlock, sizeof(CrBlock));
end;

procedure DecryptRoutine(Detail : Boolean);
var SBlock, DBlock : CrBlock;
begin
  DBlock[0]:= 0;
  DBlock[1]:= 0;
  DestStream.Read(DBlock, sizeof(CrBlock));
  SBlock:= SimpleDecrypt64(DBlock, lKey, Detail);
  SourceStream.Write(SBlock, sizeof(CrBlock));
end;

//Вызов окна за/расшифрования
procedure Crypt(Key: TKey; RCrypt: TChReg; Encrypt : Boolean; WorkType: Boolean);
var path: string;
begin
  lKey:= Key;
  TypeCode:= Encrypt;
  SourceStream.Position:= 0;
  DestStream.Position:= 0;
  EncodeForm.UpdateProgress;
  path:=ExtractFilePath(paramstr(0));
  case RCrypt of
  RPZ:  begin
          if Encrypt then
           begin
            EncodeForm.Caption:= 'Шифрование данных в режиме простой замены';
            EncodeForm.BlockSheme.Picture.LoadFromFile(path+'RPZZ.bmp');
           end
          else
           begin
            EncodeForm.Caption:= 'Расшифрование данных в режиме простой замены';
            EncodeForm.BlockSheme.Picture.LoadFromFile(path+'RPZZ.bmp');
           end;
           if WorkType=true then begin
           EncodeForm.BlockSheme.Visible:=true;
         EncodeForm.BorderIcons:=[biSystemMenu];
           EncodeForm.ClientWidth:=446;
           EncodeForm.ClientHeight:=446;
         end else begin
        EncodeForm.BlockSheme.Visible:=false;
        EncodeForm.BorderIcons:=[];
        EncodeForm.Timer3.Enabled:=true;
          EncodeForm.ClientWidth:=446;
          EncodeForm.ClientHeight:=65;
         end;
         EncodeForm.ShowModal;
        end;
             
  RG:   begin
         Synchr[0]:=0; Synchr[1]:=0;
         SynchrPos(Synchr, lkey);
         if WorkType=true then begin
         EncodeGamForm.BlockSheme.Picture.LoadFromFile(path+'RG1.bmp');
         EncodeGamForm.Image1.Visible:=true;
         EncodeGamForm.BorderIcons:=[biSystemMenu];
         end else begin
        EncodeGamForm.Image1.Visible:=false;
        EncodeGamForm.BorderIcons:=[];
         end;
         if Encrypt then
          EncodeGamForm.Caption:= 'Шифрование данных в режиме гаммирования'
         else
          EncodeGamForm.Caption:= 'Расшифрование данных в режиме гаммирования';
         EncodeGamForm.ShowModal;
        end;

  RGOS: begin
         Synchr[0]:=0; Synchr[1]:=0;
         SynchrPos(Synchr, lkey);
         if WorkType=true then begin
         EncodeGOSForm.Image1.Picture.LoadFromFile(path+'RGOS2.bmp');
         EncodeGOSForm.Image1.Visible:=true;
         EncodeGOSForm.BorderIcons:=[biSystemMenu];
         end else begin
         EncodeGOSForm.Image1.Visible:=false;
         EncodeGOSForm.BorderIcons:=[];
         end;
         if Encrypt then
          EncodeGOSForm.Caption:= 'Шифрование данных в режиме гаммирования с обратной связью'
         else
          EncodeGOSForm.Caption:= 'Расшифрование данных в режиме гаммирования с обратной связью';
         EncodeGOSForm.ShowModal;
        end;

  RIV:  begin
         if WorkType=true then begin
         EncodeIVForm.BlockSheme.Picture.LoadFromFile(path+'RIV.bmp');
         EncodeIVForm.BlockSheme.Visible:=true;
         EncodeIVForm.BorderIcons:=[biSystemMenu];
         end else begin
         EncodeIVForm.BlockSheme.Visible:=false;
         EncodeIVForm.BorderIcons:=[];
         end;
         if Encrypt then
          begin
           EncodeIVForm.Caption:= 'Режим выработки имитовставки';
           EncodeIVForm.ShowModal;
          end; 
         end;
  end;
end;

//Один шаг, подробно
procedure TEncodeForm.InButtonPZClick(Sender: TObject);
begin
  if TypeCode then
    EncryptRoutine(True)
  else
    DecryptRoutine(True);
  UpdateProgress;
end;

//Один шаг, без деталей
procedure TEncodeForm.NextButtonPZClick(Sender: TObject);
begin
  if TypeCode then
    EncryptRoutine(False)
  else
    DecryptRoutine(False);
  UpdateProgress;
end;

//Обновление прогресс-бара
procedure TEncodeForm.UpdateProgress;
var En : Boolean;
begin
  if TypeCode then
  begin
    CryptProgress.Position:= SourceStream.Position*CryptProgress.Max div SourceStream.Size;
    En:= not (SourceStream.Position = SourceStream.Size);
  end
  else
  begin
    CryptProgress.Position:= DestStream.Position*CryptProgress.Max div DestStream.Size;
    En:= not (DestStream.Position = DestStream.Size);
  end;
  InButtonPZ.Enabled:= En;
  NextButtonPZ.Enabled:= En;
end;


procedure TEncodeForm.Timer3Timer(Sender: TObject);
begin
close;
end;

procedure TEncodeForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
 begin
  if TypeCode then
          begin
            while SourceStream.Position < SourceStream.Size do begin
              EncryptRoutine(False);
              CryptProgress.Position:= SourceStream.Position*EncodeForm.CryptProgress.Max div SourceStream.Size;
              end;
              end
         else
          begin
           while DestStream.Position < DestStream.Size do begin
             DecryptRoutine(False);
             CryptProgress.Position:= DestStream.Position*EncodeForm.CryptProgress.Max div DestStream.Size;
            end;
            end;
  Timer3.Enabled:=false;
 end;


 end.
