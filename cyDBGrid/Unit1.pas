unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, DBGrids, StdCtrls, Grids, ExtCtrls, cyDBGrid,
  Buttons;

type
  TForm1 = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;      
    CBcyHSB: TCheckBox;
    CBcyVSB: TCheckBox;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    CBcyBoxes: TCheckBox;
    Memo1: TMemo;
    SBCheckRecord: TSpeedButton;
    SBCheckSelectedRows: TSpeedButton;
    SBCheckAll: TSpeedButton;
    SBUnCheckRecord: TSpeedButton;
    SBUnCheckSelectedRows: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure CBcyHSBClick(Sender: TObject);
    procedure CBcyVSBClick(Sender: TObject);
    procedure CBcyBoxesClick(Sender: TObject);
    procedure SBCheckRecordClick(Sender: TObject);
    procedure SBCheckSelectedRowsClick(Sender: TObject);
    procedure SBCheckAllClick(Sender: TObject);

  private
    { Déclarations privées }
  public
   { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CBcyHSBClick(Sender: TObject);
begin
  DBGrid1.HorizontalScrollBar := CBcyHSB.Checked;
end;

procedure TForm1.CBcyVSBClick(Sender: TObject);
begin
  DBGrid1.VerticalScrollBar := CBcyVSB.Checked;
end;

procedure TForm1.CBcyBoxesClick(Sender: TObject);
begin 
  DBGrid1.CheckBoxes.Visible := CBcyBoxes.Checked;
end;

procedure TForm1.SBCheckRecordClick(Sender: TObject);
begin
  if not DBGrid1.CheckBoxes.Visible
  then DBGrid1.CheckBoxes.Visible := true;

  DBGrid1.CheckedList.CurrentRecordBookmarked := Sender = SBCheckRecord;
end;

procedure TForm1.SBCheckSelectedRowsClick(Sender: TObject);
begin
  if not DBGrid1.CheckBoxes.Visible
  then DBGrid1.CheckBoxes.Visible := true;

  DBGrid1.CheckSelectedRows(Sender = SBCheckSelectedRows);
end;

procedure TForm1.SBCheckAllClick(Sender: TObject);
begin
  if not DBGrid1.CheckBoxes.Visible
  then DBGrid1.CheckBoxes.Visible := true;

  Screen.Cursor := crHourGlass;
  Table1.First;
  while not Table1.Eof do
  begin
    DBGrid1.CheckedList.CurrentRecordBookmarked := Sender = SBCheckAll;
    Table1.Next;
  end;
  Screen.Cursor := crDefault;
end;

End.
