object SimpleIVForm: TSimpleIVForm
  Left = 182
  Top = 302
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1062#1080#1082#1083' '#1074#1099#1088#1072#1073#1086#1090#1082#1080' '#1080#1084#1080#1090#1086#1074#1090#1072#1074#1082#1080' '
  ClientHeight = 277
  ClientWidth = 662
  Color = clInactiveBorder
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object EndButton: TButton
    Left = 568
    Top = 240
    Width = 75
    Height = 25
    Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100
    TabOrder = 0
    OnClick = EndButtonClick
  end
  object MemoLog: TMemo
    Left = 8
    Top = 8
    Width = 641
    Height = 225
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'MemoLog')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 376
    Top = 240
    Width = 73
    Height = 25
    Caption = #1044#1072#1083#1077#1077
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 456
    Top = 240
    Width = 105
    Height = 25
    Caption = #1055#1086#1076#1088#1086#1073#1085#1077#1077
    TabOrder = 3
    OnClick = Button2Click
  end
end
