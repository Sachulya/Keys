object SimpleEnForm: TSimpleEnForm
  Left = 144
  Top = 340
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1062#1080#1082#1083' '#1079#1072#1096#1080#1092#1088#1086#1074#1072#1085#1080#1103' '
  ClientHeight = 306
  ClientWidth = 698
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
    Top = 16
    Width = 681
    Height = 249
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object ButNext: TButton
    Left = 416
    Top = 272
    Width = 81
    Height = 25
    Caption = #1044#1072#1083#1077#1077
    TabOrder = 1
    OnClick = ButNextClick
  end
  object ButIN: TButton
    Left = 512
    Top = 272
    Width = 81
    Height = 25
    Caption = #1055#1086#1076#1088#1086#1073#1085#1077#1077
    TabOrder = 2
    OnClick = ButINClick
  end
  object Button1: TButton
    Left = 608
    Top = 272
    Width = 81
    Height = 25
    Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
end
