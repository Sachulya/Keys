unit About;  //ќкно о программе

interface

uses Windows, SysUtils, Classes, Controls, StdCtrls, Forms,
  Buttons, ShellAPI, ExtCtrls, Graphics;

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    Label1: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    Label2: TLabel;
    FreeRes: TLabel;
    PhysMem: TLabel;
    Image1: TImage;
    Label5: TLabel;
    Label4: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.FormPaint(Sender: TObject);
var
  MS: TMemoryStatus;
begin
  GlobalMemoryStatus(MS);
  PhysMem.Caption := FormatFloat('##,###"  байт"', MS.dwTotalPhys / 1024);
  FreeRes.Caption := Format('свободно %d %%', [100-MS.dwMemoryLoad]);
end;

procedure TAboutBox.Label7Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','http://www.sinor.ru/~kvetkin','','',SW_SHOW);
end;

end.
