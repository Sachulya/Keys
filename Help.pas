unit Help;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  THelp2 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    Memo2: TMemo;
    Label3: TLabel;
    Memo3: TMemo;
    Label4: TLabel;
    Memo4: TMemo;
    Memo5: TMemo;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Help2: THelp2;

implementation

{$R *.dfm}

procedure THelp2.FormCreate(Sender: TObject);
begin
  Help2.Visible:=false;
  Memo1.ReadOnly:=true;
  Memo2.ReadOnly:=true;
  Memo3.ReadOnly:=true;
  Memo4.ReadOnly:=true;
  Memo5.ReadOnly:=true;
end;

end.
