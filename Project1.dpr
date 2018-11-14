program Project1;

uses
  Forms,
  Geerate in 'Geerate.pas' {Kripto},
  Path in 'Path.pas' {PathF},
  ANSImod in 'ANSImod.pas' {ANSIX917},
  ImportKey in 'ImportKey.pas' {ImportKeyFromFileOrKeyboard},
  AboutProg in 'AboutProg.pas' {AboutPR},
  Help in 'Help.pas' {Help2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TKripto, Kripto);
  Application.CreateForm(TPathF, PathF);
  Application.CreateForm(TANSIX917, ANSIX917);
  Application.CreateForm(TImportKeyFromFileOrKeyboard, ImportKeyFromFileOrKeyboard);
  Application.CreateForm(TAboutPR, AboutPR);
  Application.CreateForm(THelp2, Help2);
  Application.Run;
end.
