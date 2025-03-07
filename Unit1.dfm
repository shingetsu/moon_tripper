object Form1: TForm1
  Left = 212
  Top = 197
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26376#12398#22269#12398#12392#12426#12387#12401#12540' v0.5 2004/08/14'
  ClientHeight = 506
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label2: TLabel
    Left = 308
    Top = 104
    Width = 100
    Height = 12
    Caption = 'search: 0 / found: 0'
  end
  object Label8: TLabel
    Left = 184
    Top = 92
    Width = 58
    Height = 12
    Caption = '0 keys/sec'
  end
  object Label9: TLabel
    Left = 308
    Top = 92
    Width = 78
    Height = 12
    Caption = '0 days 00:00:00'
  end
  object Label10: TLabel
    Left = 184
    Top = 104
    Width = 62
    Height = 12
    Caption = '0 sec/found'
  end
  object Label11: TLabel
    Left = 16
    Top = 72
    Width = 151
    Height = 12
    Caption = #32066#20102#12377#12427#12414#12391#12385#12423#12387#12392#24453#12385#12394#65374
    Color = clBtnFace
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object Label12: TLabel
    Left = 184
    Top = 80
    Width = 58
    Height = 12
    Caption = '0 keys/sec'
  end
  object Label13: TLabel
    Left = 284
    Top = 336
    Width = 93
    Height = 12
    Caption = #19968#33268#12488#12522#12483#12503'('#19968#37096')'
  end
  object GroupBoxKeyGen: TGroupBox
    Left = 12
    Top = 128
    Width = 425
    Height = 193
    Caption = 'Trip Key'
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 20
      Width = 60
      Height = 12
      Caption = #21069#32622#22266#23450#37096
    end
    object Label5: TLabel
      Left = 148
      Top = 20
      Width = 36
      Height = 12
      Caption = #21487#22793#37096
    end
    object Label7: TLabel
      Left = 288
      Top = 20
      Width = 60
      Height = 12
      Caption = #24460#32622#22266#23450#37096
    end
    object Label4: TLabel
      Left = 132
      Top = 40
      Width = 12
      Height = 12
      Caption = #65291
    end
    object Label6: TLabel
      Left = 272
      Top = 40
      Width = 12
      Height = 12
      Caption = #65291
    end
    object EditVarStr: TEdit
      Left = 148
      Top = 36
      Width = 121
      Height = 20
      TabOrder = 0
    end
    object EditPostFixed: TEdit
      Left = 288
      Top = 36
      Width = 121
      Height = 20
      TabOrder = 1
    end
    object EditPreFixed: TEdit
      Left = 8
      Top = 36
      Width = 121
      Height = 20
      TabOrder = 2
    end
    object RadioGroupType: TRadioGroup
      Left = 8
      Top = 72
      Width = 185
      Height = 105
      Caption = #21487#22793#37096#12395#20351#29992#12377#12427#25991#23383#31278
      ItemIndex = 0
      Items.Strings = (
        #25968#23383'(0-9)'
        #33521#25968'(a-zA-Z0-9)'
        #35352#21495#12434#21547#12416#33521#25968'(<>&&'#12434#38500#12367')'
        #12377#12409#12390'(0x00-0xff)')
      TabOrder = 3
    end
    object RadioGroupDir: TRadioGroup
      Left = 200
      Top = 76
      Width = 97
      Height = 53
      Caption = #26908#32034#26041#21521
      ItemIndex = 0
      Items.Strings = (
        #21069#26041#26908#32034
        #24460#26041#26908#32034)
      TabOrder = 4
    end
  end
  object GroupBoxSerch: TGroupBox
    Left = 12
    Top = 348
    Width = 253
    Height = 145
    Caption = #26908#32034#26465#20214
    TabOrder = 1
    OnClick = GroupBoxSerchClick
    object Label1: TLabel
      Left = 28
      Top = 96
      Width = 202
      Height = 12
      Caption = #20351#29992#12377#12427#12395#12399'BREGEXP.DLL'#12364#24517#35201#12391#12377
    end
    object RadioButton1: TRadioButton
      Left = 8
      Top = 20
      Width = 85
      Height = 17
      Caption = #21069#26041#19968#33268
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = GroupBoxSerchClick
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 40
      Width = 73
      Height = 17
      Caption = #24460#26041#19968#33268
      TabOrder = 1
      OnClick = GroupBoxSerchClick
    end
    object RadioButton3: TRadioButton
      Left = 8
      Top = 72
      Width = 69
      Height = 17
      Caption = #27491#35215#34920#29694
      Enabled = False
      TabOrder = 2
      OnClick = GroupBoxSerchClick
    end
    object EditSearchRegular: TEdit
      Left = 100
      Top = 72
      Width = 121
      Height = 20
      Enabled = False
      TabOrder = 3
      Text = 'm//'
    end
    object EditSerchClassical: TEdit
      Left = 100
      Top = 24
      Width = 121
      Height = 20
      TabOrder = 4
    end
  end
  object Button2: TButton
    Left = 16
    Top = 92
    Width = 75
    Height = 25
    Caption = #26908#32034
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 92
    Top = 92
    Width = 75
    Height = 25
    Caption = #20572#27490
    Enabled = False
    TabOrder = 3
    OnClick = Button3Click
  end
  object GroupBoxOutFile: TGroupBox
    Left = 12
    Top = 4
    Width = 289
    Height = 57
    Caption = #20986#21147#12501#12449#12452#12523
    TabOrder = 4
    object EditOutFileName: TEdit
      Left = 12
      Top = 20
      Width = 233
      Height = 20
      TabOrder = 0
    end
    object Button4: TButton
      Left = 244
      Top = 20
      Width = 25
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = Button4Click
    end
  end
  object RadioGroupPriority: TRadioGroup
    Left = 304
    Top = 4
    Width = 177
    Height = 85
    Caption = 'ThreadPriorty'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Idle'
      'Lowest'
      'Lower'
      'Normal'
      'Higher'
      'Highest'
      'TimeCritical')
    TabOrder = 5
  end
  object ListBox1: TListBox
    Left = 284
    Top = 352
    Width = 153
    Height = 137
    ItemHeight = 12
    TabOrder = 6
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 276
    Top = 60
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2001
    OnTimer = Timer1Timer
    Left = 248
    Top = 60
  end
end
