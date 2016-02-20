object Form2: TForm2
  Left = 0
  Top = 0
  ActiveControl = MaskEdit1
  BorderIcons = [biSystemMenu]
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 82
  ClientWidth = 274
  Color = clBtnFace
  Constraints.MaxHeight = 120
  Constraints.MaxWidth = 290
  Constraints.MinHeight = 120
  Constraints.MinWidth = 290
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 115
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' ID '#1087#1088#1086#1075#1088#1072#1084#1084#1099
  end
  object Button1: TButton
    Left = 191
    Top = 49
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object MaskEdit1: TMaskEdit
    Left = 16
    Top = 27
    Width = 247
    Height = 21
    EditMask = '!99999;1;_'
    MaxLength = 5
    TabOrder = 1
    Text = '     '
    OnKeyUp = MaskEdit1KeyUp
  end
end
