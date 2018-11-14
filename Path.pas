unit Path;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPathF = class(TForm)
    BinPath: TEdit;
    BinL: TLabel;
    Ok: TButton;
    TextL: TLabel;
    TextPath: TEdit;
    Ok2: TButton;
    procedure OkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Ok2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PathF: TPathF;
  pathTex:Boolean;
  pathBin:Boolean;

implementation

uses Geerate;

{$R *.dfm}

procedure TPathF.OkClick(Sender: TObject);
begin
  if BinPath.Text='' then begin ShowMessage('¬ведите путь до папки.'); exit; end;
  if not DirectoryExists(BinPath.Text) then begin ForceDirectories(BinPath.text{pathAutoSavePer}); pathBin:=true; end;
  if DirectoryExists(BinPath.Text) then pathBin:=true;
  //else ShowMessage('ѕуть до папки не верный!');
  if ((PathTex) and (pathBin)) then PathF.Visible:=false;
end;

procedure TPathF.FormCreate(Sender: TObject);
var
  s:String;
begin
  pathBin:=false;
  pathTex:=false;
  s:=ExtractFilePath(Application.ExeName);
  //s:=ParamStr(0);
  //s:=copy(s,1, length(s)-12);
  s:=s+'keys';
  TextPath.Text:=s+'\text\';
  BinPath.Text:=s+'\binary\';
end;

procedure TPathF.Ok2Click(Sender: TObject);
begin
  if TextPath.Text='' then begin ShowMessage('¬ведите путь до папки.'); exit; end;
  if not DirectoryExists(TextPath.Text) then begin ForceDirectories(textpath.text{pathAutoSavePer}); {PathTex:=true;} pathTex:=true; end;
  if DirectoryExists(TextPath.Text) then pathTex:=true;
  //else ShowMessage('ѕуть до папки не верный!');
  if PathTex and pathBin then PathF.Visible:=false;
end;

procedure TPathF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//Action :=caNone;
end;

end.
