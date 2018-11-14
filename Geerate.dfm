object Kripto: TKripto
  Left = 341
  Top = 81
  Width = 529
  Height = 606
  BorderStyle = bsSizeToolWin
  Caption = 'Key Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = Menu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object HexKeyW: TLabel
    Left = 16
    Top = 32
    Width = 210
    Height = 16
    Caption = #1064#1077#1089#1090#1085#1072#1076#1094#1072#1090#1080#1088#1080#1095#1085#1099#1081' '#1082#1086#1076' '#1082#1083#1102#1095#1072':'
  end
  object BinKeyW: TLabel
    Left = 153
    Top = 86
    Width = 139
    Height = 16
    Caption = #1044#1074#1086#1080#1095#1085#1099#1081' '#1082#1086#1076' '#1082#1083#1102#1095#1072':'
  end
  object Label3: TLabel
    Left = 115
    Top = 131
    Width = 258
    Height = 16
    Caption = #1055#1088#1086#1084#1077#1078#1091#1090#1086#1095#1085#1099#1081' '#1080' '#1082#1086#1085#1077#1095#1085#1099#1081' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
  end
  object DecKeyW: TLabel
    Left = 314
    Top = 36
    Width = 152
    Height = 16
    Caption = #1044#1077#1089#1103#1090#1080#1095#1085#1099#1081' '#1082#1086#1076' '#1082#1083#1102#1095#1072':'
  end
  object LengthW: TLabel
    Left = 15
    Top = 11
    Width = 301
    Height = 16
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1076#1083#1080#1085#1091' '#1075#1077#1085#1080#1088#1080#1088#1091#1077#1084#1086#1075#1086' '#1082#1083#1102#1095#1072' '#1074' '#1073#1080#1090#1072#1093':'
  end
  object HexKey: TEdit
    Left = 0
    Top = 56
    Width = 257
    Height = 24
    TabOrder = 0
  end
  object BinKey: TEdit
    Left = 0
    Top = 104
    Width = 513
    Height = 24
    TabOrder = 1
  end
  object InFo: TMemo
    Left = 0
    Top = 152
    Width = 513
    Height = 393
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object DecKey: TEdit
    Left = 264
    Top = 56
    Width = 249
    Height = 24
    TabOrder = 3
  end
  object Length_Of_Key: TEdit
    Left = 328
    Top = 8
    Width = 49
    Height = 24
    TabOrder = 4
    Text = '35'
  end
  object Menu: TMainMenu
    Left = 400
    Top = 8
    object N7: TMenuItem
      Caption = #1052#1077#1085#1102
      object SaveToBinary: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1073#1080#1085#1072#1088#1085#1099#1081' '#1092#1072#1081#1083
        OnClick = SaveToBinaryClick
      end
      object SaveToText: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083
        OnClick = SaveToTextClick
      end
      object PathAutoSave: TMenuItem
        Caption = #1055#1072#1087#1082#1072' '#1076#1083#1103' '#1072#1074#1090#1086#1089#1086#1093#1088#1072#1085#1077#1085#1080#1081
        OnClick = PathAutoSaveClick
      end
      object N2: TMenuItem
        Caption = #1042#1074#1086#1076' '#1082#1083#1102#1095#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1080#1083#1080' '#1089' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
        OnClick = N2Click
      end
    end
    object N1: TMenuItem
      Caption = #1040#1083#1075#1086#1088#1080#1090#1084#1099' '#1075#1077#1085#1077#1088#1072#1094#1080#1080' '#1082#1083#1102#1095#1072
      object GenANSIX9171: TMenuItem
        Caption = 'ANSI X9.17'
        OnClick = GenANSIX9171Click
      end
      object GenIntel: TMenuItem
        Caption = #1040#1083#1075#1086#1088#1080#1090#1084' '#1082#1086#1088#1087#1086#1088#1072#1094#1080#1080' Intel'
        OnClick = GenIntelClick
      end
      object GenRC4: TMenuItem
        Caption = 'RC4'
        OnClick = GenRC4Click
      end
    end
    object N4: TMenuItem
      Caption = #1040#1083#1075#1086#1088#1080#1090#1084#1099' '#1086#1094#1077#1085#1082#1080' '#1082#1072#1095#1077#1089#1090#1074#1072' '#1082#1083#1102#1095#1077#1081
      object ThreeStageTest: TMenuItem
        Caption = #1058#1088#1077#1093#1101#1090#1072#1087#1085#1099#1081' '#1090#1077#1089#1090
        OnClick = ThreeStageTestClick
      end
      object KnutsTest: TMenuItem
        Caption = #1058#1077#1089#1090#1099' '#1044'. '#1050#1085#1091#1090#1072
        OnClick = KnutsTestClick
      end
    end
    object N3: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object N5: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N5Click
      end
      object N6: TMenuItem
        Caption = #1055#1086#1084#1086#1097#1100
        OnClick = N6Click
      end
    end
  end
  object Saver: TSaveDialog
    Options = [ofHideReadOnly]
    Left = 440
    Top = 8
  end
end
