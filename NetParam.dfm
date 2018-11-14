object NetParamForm: TNetParamForm
  Left = 235
  Top = 156
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
  ClientHeight = 110
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IPLable: TLabel
    Left = 24
    Top = 8
    Width = 46
    Height = 13
    Caption = 'IP '#1072#1076#1088#1077#1089' '
  end
  object PortLable: TLabel
    Left = 24
    Top = 56
    Width = 25
    Height = 13
    Caption = #1055#1086#1088#1090
  end
  object IPEdit: TMaskEdit
    Left = 24
    Top = 24
    Width = 136
    Height = 28
    Hint = #1042#1074#1077#1076#1080#1090#1077' IP '#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072', '#1089' '#1082#1086#1090#1086#1088#1099#1084' '#1073#1091#1076#1077#1090' '#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1086' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077
    EditMask = '999.999.999.999;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = '   .   .   .   '
  end
  object PortEdit: TMaskEdit
    Left = 24
    Top = 72
    Width = 49
    Height = 28
    Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1087#1086#1088#1090#1072', '#1082#1086#1090#1086#1088#1099#1081' '#1073#1091#1076#1077#1090' '#1086#1090#1082#1088#1099#1090' '#1076#1083#1103' '#1086#1073#1084#1077#1085#1072' '#1076#1072#1085#1085#1099#1084#1080
    EditMask = '9999;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 4
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = '    '
  end
  object ApplyParButtom: TButton
    Left = 136
    Top = 72
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 2
    OnClick = ApplyParButtomClick
  end
end
