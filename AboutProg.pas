unit AboutProg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAboutPR = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutPR: TAboutPR;

implementation

uses Help, Geerate;

{$R *.dfm}

procedure TAboutPR.FormCreate(Sender: TObject);
begin
  AboutPR.Visible:=false;
end;

end.
