object ChTabForm: TChTabForm
  Left = 322
  Top = 202
  BorderStyle = bsToolWindow
  Caption = #1058#1072#1073#1083#1080#1094#1072' '#1079#1072#1084#1077#1085' ('#1079#1085#1072#1095#1077#1085#1080#1077' '#1085#1072' '#1074#1099#1093#1086#1076#1077' '#1087#1086#1076#1073#1083#1086#1082#1072')'
  ClientHeight = 204
  ClientWidth = 487
  Color = clInactiveBorder
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 64
    Width = 34
    Height = 13
    Caption = #1053#1086#1084#1077#1088
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 48
    Height = 13
    Caption = #1087#1086#1076#1073#1083#1086#1082#1072
  end
  object Label3: TLabel
    Left = 16
    Top = 120
    Width = 27
    Height = 13
    Caption = '0 ... 7'
  end
  object Label4: TLabel
    Left = 112
    Top = 8
    Width = 176
    Height = 13
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1085#1072' '#1074#1093#1086#1076#1077' '#1087#1086#1076#1073#1083#1086#1082#1072' 0 ... F'
  end
  object ChTabGrid: TStringGrid
    Left = 63
    Top = 32
    Width = 290
    Height = 154
    ColCount = 17
    Ctl3D = False
    DefaultColWidth = 16
    DefaultRowHeight = 16
    RowCount = 9
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goEditing, goTabs]
    ParentCtl3D = False
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = True
    TabOrder = 0
    OnGetEditMask = ChTabGridGetEditMask
    OnKeyPress = ChTabGridKeyPress
    OnSetEditText = ChTabGridSetEditText
  end
  object LoadButton: TButton
    Left = 368
    Top = 24
    Width = 113
    Height = 33
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091
    TabOrder = 1
    OnClick = LoadButtonClick
  end
  object SaveButton: TButton
    Left = 368
    Top = 88
    Width = 113
    Height = 33
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091
    TabOrder = 2
    OnClick = SaveButtonClick
  end
  object ByDefButton: TButton
    Left = 368
    Top = 152
    Width = 113
    Height = 33
    Hint = #1047#1072#1075#1088#1091#1078#1072#1077#1090#1089#1103' '#1092#1072#1081#1083' ChTabDef.chf'
    Caption = #1048#1089#1093#1086#1076#1085#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = ByDefButtonClick
  end
  object ChtabOpenDialog: TOpenDialog
    DefaultExt = 'chf'
    Filter = #1060#1072#1081#1083' '#1090#1072#1073#1083#1080#1094#1099' '#1079#1072#1084#1077#1085'|*.chf'
    Title = #1054#1090#1082#1088#1099#1090#1080#1077' '#1090#1072#1073#1083#1080#1094#1099' '#1079#1072#1084#1077#1085
    Left = 4
    Top = 156
  end
  object ChTabSaveDialog: TSaveDialog
    DefaultExt = 'chf'
    Filter = #1060#1072#1081#1083' '#1090#1072#1073#1083#1080#1094#1099' '#1079#1072#1084#1077#1085'|*.chf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1090#1072#1073#1083#1080#1094#1099' '#1079#1072#1084#1077#1085
    Left = 16
    Top = 156
  end
end
