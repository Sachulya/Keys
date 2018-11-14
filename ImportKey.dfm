object ImportKeyFromFileOrKeyboard: TImportKeyFromFileOrKeyboard
  Left = 131
  Top = 117
  Width = 476
  Height = 278
  BorderStyle = bsSizeToolWin
  Caption = #1048#1084#1087#1086#1088#1090' '#1082#1083#1102#1095#1072
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
  object Label1: TLabel
    Left = 272
    Top = 0
    Width = 118
    Height = 13
    Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1089' '#1082#1083#1102#1095#1086#1084
  end
  object Label2: TLabel
    Left = 120
    Top = 80
    Width = 189
    Height = 13
    Caption = #1050#1083#1102#1095' '#1074' '#1096#1077#1089#1090#1085#1072#1076#1094#1072#1090#1080#1088#1080#1095#1085#1086#1084' '#1092#1086#1088#1084#1072#1090#1077
  end
  object Label3: TLabel
    Left = 120
    Top = 120
    Width = 135
    Height = 13
    Caption = #1050#1083#1102#1095' '#1074' '#1076#1074#1086#1080#1095#1085#1086#1084' '#1092#1086#1088#1084#1072#1090#1077
  end
  object Label4: TLabel
    Left = 120
    Top = 160
    Width = 146
    Height = 13
    Caption = #1050#1083#1102#1095' '#1074' '#1076#1077#1089#1103#1090#1080#1095#1085#1086#1084' '#1092#1086#1088#1084#1072#1090#1077
  end
  object Label5: TLabel
    Left = 0
    Top = 200
    Width = 67
    Height = 13
    Caption = #1044#1083#1080#1085#1072' '#1082#1083#1102#1095#1072
  end
  object PathToKeyTextFile: TEdit
    Left = 216
    Top = 16
    Width = 241
    Height = 21
    TabOrder = 0
  end
  object ChoiseImportKey: TRadioGroup
    Left = 0
    Top = 8
    Width = 185
    Height = 73
    Items.Strings = (
      #1048#1084#1087#1086#1088#1090' '#1082#1083#1102#1095#1072' '#1080#1079' '#1092#1072#1081#1083#1072
      #1042#1074#1086#1076' '#1082#1083#1102#1095#1072' '#1089' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099)
    TabOrder = 1
    OnClick = ChoiseImportKeyClick
  end
  object HexKeyText: TEdit
    Left = 0
    Top = 96
    Width = 457
    Height = 21
    TabOrder = 2
  end
  object BinaryKeyText: TEdit
    Left = 0
    Top = 136
    Width = 457
    Height = 21
    TabOrder = 3
  end
  object DecTextKey: TEdit
    Left = 0
    Top = 176
    Width = 457
    Height = 21
    TabOrder = 4
  end
  object apply: TButton
    Left = 360
    Top = 200
    Width = 97
    Height = 33
    Caption = #1054#1050
    TabOrder = 5
    OnClick = applyClick
  end
  object lengthOfImportkey: TEdit
    Left = 0
    Top = 216
    Width = 225
    Height = 21
    TabOrder = 6
  end
  object reImport: TButton
    Left = 232
    Top = 200
    Width = 121
    Height = 33
    Caption = #1042#1074#1077#1089#1090#1080' '#1082#1083#1102#1095' '#1079#1072#1085#1086#1074#1086
    TabOrder = 7
    OnClick = reImportClick
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 184
  end
  object OpenDialog1: TOpenDialog
    Left = 184
    Top = 32
  end
end
