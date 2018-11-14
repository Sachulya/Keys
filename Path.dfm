object PathF: TPathF
  Left = 660
  Top = 108
  Width = 607
  Height = 108
  BorderStyle = bsSizeToolWin
  Caption = 'Path'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BinL: TLabel
    Left = 0
    Top = 12
    Width = 228
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1087#1091#1090#1100' '#1076#1086' '#1087#1072#1087#1082#1080' '#1073#1080#1085#1072#1088#1085#1099#1084#1080' '#1092#1072#1081#1083#1072#1084#1080':'
  end
  object TextL: TLabel
    Left = 0
    Top = 40
    Width = 241
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1087#1091#1090#1100' '#1076#1086' '#1087#1072#1087#1082#1080' '#1089' '#1090#1077#1082#1089#1090#1086#1074#1099#1084#1080' '#1092#1072#1081#1083#1072#1084#1080':'
  end
  object BinPath: TEdit
    Left = 248
    Top = 8
    Width = 257
    Height = 21
    TabOrder = 0
  end
  object Ok: TButton
    Left = 512
    Top = 8
    Width = 75
    Height = 21
    Caption = #1054#1082
    TabOrder = 1
    OnClick = OkClick
  end
  object TextPath: TEdit
    Left = 248
    Top = 35
    Width = 257
    Height = 21
    TabOrder = 2
  end
  object Ok2: TButton
    Left = 512
    Top = 36
    Width = 75
    Height = 21
    Caption = 'Ok'
    TabOrder = 3
    OnClick = Ok2Click
  end
end
