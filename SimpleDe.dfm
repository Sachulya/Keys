object SimpleDeForm: TSimpleDeForm
  Left = 225
  Top = 258
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1062#1080#1082#1083' '#1088#1072#1089#1096#1080#1092#1088#1086#1074#1072#1085#1080#1103' '
  ClientHeight = 304
  ClientWidth = 697
  Color = clInactiveBorder
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MemoLog: TMemo
    Left = 8
    Top = 8
    Width = 681
    Height = 257
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'MemoLog')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 424
    Top = 272
    Width = 81
    Height = 25
    Caption = #1044#1072#1083#1077#1077
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 520
    Top = 272
    Width = 81
    Height = 25
    Caption = #1055#1086#1076#1088#1086#1073#1085#1077#1077
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 616
    Top = 272
    Width = 73
    Height = 25
    Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100
    TabOrder = 3
    OnClick = Button3Click
  end
end
