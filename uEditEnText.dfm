object EditEnTextForm: TEditEnTextForm
  Left = 401
  Top = 232
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1096#1080#1092#1088#1090#1077#1082#1089#1090#1072
  ClientHeight = 204
  ClientWidth = 315
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
  object Label1: TLabel
    Left = 32
    Top = 16
    Width = 99
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object Label2: TLabel
    Left = 176
    Top = 16
    Width = 103
    Height = 13
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1085#1072' '#1079#1072#1084#1077#1085#1091
  end
  object PosGroup: TGroupBox
    Left = 160
    Top = 36
    Width = 151
    Height = 41
    TabOrder = 0
    object PosEdit: TEdit
      Left = 8
      Top = 12
      Width = 97
      Height = 21
      MaxLength = 1
      TabOrder = 0
      OnChange = PosEditChange
      OnKeyPress = PosEditKeyPress
    end
    object PosBox: TComboBox
      Left = 109
      Top = 12
      Width = 36
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      MaxLength = 1
      TabOrder = 1
      Text = 'H'
      OnChange = PosBoxChange
      Items.Strings = (
        'H'
        'A')
    end
  end
  object CloselButton: TButton
    Left = 208
    Top = 163
    Width = 86
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 1
  end
  object SaveButton: TButton
    Left = 20
    Top = 163
    Width = 86
    Height = 25
    Caption = #1055#1088#1080#1085#1103#1090#1100
    TabOrder = 2
    OnClick = SaveButtonClick
  end
  object SourceGroup: TGroupBox
    Left = 4
    Top = 36
    Width = 151
    Height = 41
    TabOrder = 3
    object SourceEdit: TEdit
      Left = 8
      Top = 12
      Width = 97
      Height = 21
      MaxLength = 1
      ReadOnly = True
      TabOrder = 0
    end
    object SourceBox: TComboBox
      Left = 109
      Top = 12
      Width = 36
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      MaxLength = 1
      TabOrder = 1
      Text = 'H'
      OnChange = SourceBoxChange
      Items.Strings = (
        'H'
        'A')
    end
  end
  object SPosScroll: TScrollBar
    Left = 28
    Top = 130
    Width = 257
    Height = 17
    Hint = #1055#1086#1079#1080#1094#1080#1103' '#1082#1091#1088#1089#1086#1088#1072' '#1074' '#1096#1080#1092#1088#1090#1077#1082#1089#1090#1077
    PageSize = 0
    TabOrder = 4
    OnChange = SPosScrollChange
  end
  object SPosEdit: TEdit
    Left = 140
    Top = 96
    Width = 41
    Height = 21
    Hint = #1057#1084#1077#1097#1077#1085#1080#1077' '#1086#1090' '#1085#1072#1095#1072#1083#1072
    ReadOnly = True
    TabOrder = 5
    OnChange = SPosEditChange
  end
end
