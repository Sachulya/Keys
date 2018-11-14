object ANSIX917: TANSIX917
  Left = 104
  Top = 127
  Width = 645
  Height = 166
  BorderStyle = bsSizeToolWin
  Caption = 'Modify ANSI X9.17'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Consist: TLabel
    Left = 240
    Top = 48
    Width = 47
    Height = 13
    Caption = 'Some text'
  end
  object CHOISE: TRadioGroup
    Left = 16
    Top = 8
    Width = 217
    Height = 105
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1074#1072#1088#1080#1072#1085#1090' '#1089#1086#1089#1090#1072#1074#1085#1086#1075#1086' '#1082#1083#1102#1095#1072
    Items.Strings = (
      #1057#1086#1089#1090#1072#1074#1085#1086#1081' '#1082#1083#1102#1095' '#1080#1079' '#1086#1076#1085#1086#1075#1086' '#1082#1083#1102#1095#1072
      #1057#1086#1089#1090#1072#1074#1085#1086#1081' '#1082#1083#1102#1095' '#1080#1079' '#1076#1074#1091#1093' '#1082#1083#1102#1095#1077#1081
      #1057#1086#1089#1090#1072#1074#1085#1086#1081' '#1082#1083#1102#1095' '#1080#1079' '#1095#1077#1090#1099#1088#1077#1093' '#1082#1083#1102#1095#1077#1081)
    TabOrder = 0
    OnClick = CHOISEClick
  end
  object OKBut: TButton
    Left = 544
    Top = 96
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 1
    OnClick = OKButClick
  end
  object ANSIKEY: TEdit
    Left = 240
    Top = 21
    Width = 385
    Height = 21
    TabOrder = 2
  end
  object Refrash: TButton
    Left = 240
    Top = 64
    Width = 137
    Height = 25
    Caption = #1042#1099#1074#1077#1089#1090#1080' '#1082#1083#1102#1095' '#1085#1072' '#1101#1082#1088#1072#1085
    TabOrder = 3
    OnClick = RefrashClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 584
    Top = 56
  end
end
