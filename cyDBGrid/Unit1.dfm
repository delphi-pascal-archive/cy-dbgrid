object Form1: TForm1
  Left = 221
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'TcyDBGrid'
  ClientHeight = 642
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 112
    Width = 557
    Height = 16
    Caption = 
      'OverLoaded TDBGrid (with '#39'cyDBGrid'#39' in the uses after dbgrids un' +
      'it declaration): '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SBCheckRecord: TSpeedButton
    Left = 296
    Top = 576
    Width = 81
    Height = 25
    Caption = 'Check'
    OnClick = SBCheckRecordClick
  end
  object SBCheckSelectedRows: TSpeedButton
    Left = 384
    Top = 576
    Width = 201
    Height = 25
    Caption = 'Check selected rows'
    OnClick = SBCheckSelectedRowsClick
  end
  object SBCheckAll: TSpeedButton
    Left = 592
    Top = 576
    Width = 97
    Height = 25
    Caption = 'Check All'
    OnClick = SBCheckAllClick
  end
  object SBUnCheckRecord: TSpeedButton
    Left = 296
    Top = 608
    Width = 81
    Height = 25
    Caption = 'Uncheck'
    OnClick = SBCheckRecordClick
  end
  object SBUnCheckSelectedRows: TSpeedButton
    Left = 384
    Top = 608
    Width = 201
    Height = 25
    Caption = 'Uncheck selected rows'
    OnClick = SBCheckSelectedRowsClick
  end
  object SpeedButton3: TSpeedButton
    Left = 592
    Top = 608
    Width = 97
    Height = 25
    Caption = 'Uncheck All'
    OnClick = SBCheckAllClick
  end
  object CBcyHSB: TCheckBox
    Left = 8
    Top = 584
    Width = 153
    Height = 17
    Caption = 'Horizontal ScrollBar'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = CBcyHSBClick
  end
  object CBcyVSB: TCheckBox
    Left = 8
    Top = 608
    Width = 153
    Height = 17
    Caption = 'Vertical ScrollBar'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = CBcyVSBClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 136
    Width = 681
    Height = 433
    DataSource = DataSource1
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -14
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        ReadOnly = True
        Width = 17
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FirstName'
        Width = 125
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LastName'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Salary'
        Width = 71
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PhoneExt'
        Width = 101
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'xxx'
        Visible = True
      end>
  end
  object CBcyBoxes: TCheckBox
    Left = 176
    Top = 600
    Width = 105
    Height = 17
    Caption = 'CheckBoxes'
    TabOrder = 3
    OnClick = CBcyBoxesClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 673
    Height = 97
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      ' - unhidden herited properties;'
      ' - OnSelectCell event;'
      
        ' - mouse wheel handling for navigate, selecting rows (with Shift' +
        ' key) , do nothing or do as original;'
      ' - 2 clicks for massive rows selection (with Shift key);'
      ' - both scrollbars disabling option;'
      ' - CheckBox for all records.')
    ReadOnly = True
    TabOrder = 4
    WordWrap = False
  end
  object Table1: TTable
    Active = True
    DatabaseName = 'DBDEMOS'
    TableName = 'employee.db'
    Left = 264
    Top = 232
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 352
    Top = 232
  end
end
