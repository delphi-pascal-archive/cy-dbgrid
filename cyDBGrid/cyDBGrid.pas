{   Component(s):
    tcyDBGrid

    Description:
    A DBGrid with
    - unhidden herited properties
    - OnSelectCell event
    - mouse wheel handling for navigate, selecting rows (with Shift key) , do nothing or do as original
    - 2 clicks for massive rows selection (with Shift key)
    - Both scrollbars disabling option
    - CheckBox for all records


    Author: Mauricio
    mail: mauricio_box@yahoo.com

    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    $  €€€ Accept any PAYPAL DONATION $$$  €
    $      to: mauricio_box@yahoo.com      €
    €€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

    Copyrights:
    You can use and distribute this component freely but you can' t remove
    this header
}
unit cyDBGrid;

interface

uses Classes, Windows, Controls, Grids, DBGrids, Messages, Db, cyBookmarkList;

type
//  TcyBookmarkList = class(TBookmarkList) // Just for accessing protected LinkActive procedure ...
//  end;

  TMouseWheelMode = (mwDoNothing, mwOriginal, mwNavigate, mwRowSelect);

  TcyCheckBoxes = class(TPersistent)
  private
    FSize: Word;
    FVisible: Boolean;
    FOnChange: TNotifyEvent;
    FColumn: Word;
    FReadOnly: Boolean;
    procedure SetSize(const Value: Word);
    procedure SetVisible(const Value: Boolean);
    procedure SetColumn(const Value: Word);
  protected
  public
    constructor Create(AOwner: TComponent); virtual;
  published
    property Column: Word read FColumn write SetColumn default 0;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default false;
    property Size: Word read FSize write SetSize default 16;
    property Visible: Boolean read FVisible write SetVisible default false;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TcyDBGrid = class(TDBGrid)
    private
      FIsLoaded: Boolean;
      FOnSelectCell: TSelectCellEvent;
      FHorizontalScrollBar: Boolean;
      FVerticalScrollBar: Boolean;
      FOldVerticalScrollBarState: Boolean;
      FOldHorizontalScrollBarState: Boolean;
      FMouseWheelMode: TMouseWheelMode;
      FCheckBoxes: TcyCheckBoxes;
      FCheckedList: TcyBookmarkList;
      procedure SetHorizontalScrollBar(const Value: Boolean);
      procedure SetVerticalScrollBar(const Value: Boolean);
      procedure SetCheckBoxes(Value: TcyCheckBoxes);
    protected
      procedure Loaded; override;
      function SelectCell(ACol, ARow: Longint): Boolean; override;
      procedure WndProc(var Message: TMessage); override;
      procedure MouseWheelDown(Sender: TObject; Shift: TShiftState;
        MousePos: TPoint; var Handled: Boolean);
      procedure MouseWheelUp(Sender: TObject; Shift: TShiftState;
        MousePos: TPoint; var Handled: Boolean);
      procedure CheckBoxesChanged(Sender: TObject);
      procedure LinkActive(Value: Boolean); override;
      procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); override;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer); override;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      property FixedCols;
      function CellRectX(ACol, ARow: Longint): TRect;
      procedure CheckSelectedRows(Value: Boolean);
    published
      property Col;              // Current column
      property LeftCol;          // First displayed column
      property Row;              // Current row
      property VisibleColCount;  // Visible normal columns (Not Fixed Columns)
      property VisibleRowCount;  // Visible normal rows (Not Fixed Rows)
      // property TopRow;  Not working, return always 1 ...
      // property Selection; Not working, return always Col e Row ...

      property MouseWheelMode: TMouseWheelMode read FMouseWheelMode write FMouseWheelMode default mwRowSelect;
      property HorizontalScrollBar: Boolean read FHorizontalScrollBar write SetHorizontalScrollBar default true;
      property VerticalScrollBar: Boolean read FVerticalScrollBar write SetVerticalScrollBar default true;
      property CheckBoxes: TcyCheckBoxes read FCheckBoxes write SetCheckBoxes;
      property CheckedList: TcyBookmarkList read FCheckedList;
      property OnSelectCell: TSelectCellEvent read FOnSelectCell write FOnSelectCell;
    end;

  TDBGrid = class(tcyDBGrid);
  // Let this line in order to overload dbgrids.TDBGrid class component in your projects
  // with tcyDBGRid (declare "cyDBGrid" in the uses of your unit after "DBGrids" declaration) :
  // Your old DBGrids will have the same properties/events/fonctions in your source code
  // and at run time but not visualized in the object inspector at design time.
  // Remove if you don' t want to.

const
  IsChecked : array[Boolean] of Integer = (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED);

procedure Register;

implementation

{ TcyCheckBoxes }
constructor TcyCheckBoxes.Create(AOwner: TComponent);
begin
  FColumn := 0;
  FReadOnly := false;
  FSize := 16;
  FVisible := false;
end;

procedure TcyCheckBoxes.SetColumn(const Value: Word);
begin
  FColumn := Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TcyCheckBoxes.SetSize(const Value: Word);
begin
  FSize := Value;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TcyCheckBoxes.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  if Assigned(FOnChange) then FOnChange(Self);  
end;

{ TcyDBGrid}
constructor TcyDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCheckedList := TcyBookmarkList.Create(self);
  FCheckedList.OnChange := CheckBoxesChanged;
  FMouseWheelMode := mwRowSelect;
  FOldVerticalScrollBarState := true;
  FOldHorizontalScrollBarState := true;
  FHorizontalScrollBar := true;
  FVerticalScrollBar := true;
  FCheckBoxes := TcyCheckBoxes.Create(self);
  FCheckBoxes.OnChange := CheckBoxesChanged;

  // Mouse wheel handling :
  OnMouseWheelDown := MouseWheelDown;
  OnMouseWheelUp := MouseWheelUp;
end;

destructor TcyDBGrid.Destroy;
begin
  Inherited;
  FCheckedList.Free;
  FCheckedList := nil;
end;

procedure TcyDBGrid.Loaded;
begin
  Inherited;
  FIsLoaded := not (csLoading In ComponentState);
end;

procedure TcyDBGrid.WndProc(var Message: TMessage);
begin
  if FIsLoaded and (not (csDestroying in ComponentState))
  then begin
    // Scrollbars visibility handling :
    if (not FHorizontalScrollBar) or (FHorizontalScrollBar <> FOldHorizontalScrollBarState)
    then
      if ShowScrollBar(Handle, SB_HORZ, FHorizontalScrollBar)
      then FOldHorizontalScrollBarState := FHorizontalScrollBar;

    if (not FVerticalScrollBar) or (FVerticalScrollBar <> FOldVerticalScrollBarState)
    then
      if ShowScrollBar(Handle, SB_VERT, FVerticalScrollBar)
      then FOldVerticalScrollBarState := FVerticalScrollBar;
  end;

  Inherited WndProc(Message);
end;

// Also called when DataSource property changes ...
procedure TcyDBGrid.LinkActive(Value: Boolean);
begin
  Inherited;

  if Value
  then FCheckedList.DataSource := DataSource;

  FCheckedList.LinkActive(Value);
end;

function TcyDBGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  Result := True;
  if Assigned(FOnSelectCell) then FOnSelectCell(Self, ACol, ARow, Result);
end;

function TcyDBGrid.CellRectX(ACol, ARow: Longint): TRect;
begin
  RESULT := CellRect(ACol, ARow);
end;

procedure TcyDBGrid.SetCheckBoxes(Value: TcyCheckBoxes);
begin
  CheckBoxes.Assign(Value);
end;

// CheckBoxes change notified :
procedure TcyDBGrid.CheckBoxesChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TcyDBGrid.SetHorizontalScrollBar(const Value: Boolean);
begin
  FHorizontalScrollBar := Value;
  Invalidate;
end;

procedure TcyDBGrid.SetVerticalScrollBar(const Value: Boolean);
begin
  FVerticalScrollBar := Value;
  Invalidate;
end;

procedure TcyDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Index, DrawState: Integer;
  DrawRect:  TRect;
  TextRect:  TRect;
begin
  if (DataCol = CheckBoxes.FColumn) and (CheckBoxes.FVisible)
  then begin
    Canvas.FillRect(Rect);

    // CheckBox area :
    DrawRect := classes.Rect(Rect.left+1, Rect.Top, Rect.left+CheckBoxes.FSize+1, Rect.Bottom);
    DrawState := ISChecked[FCheckedList.Find(Datalink.Datasource.Dataset.Bookmark, Index)];
    DrawFrameControl(Canvas.Handle, DrawRect, DFC_BUTTON, DrawState);
    TextRect := classes.Rect(Rect.left + CheckBoxes.FSize + 1, Rect.Top, Rect.Right, Rect.Bottom);

    // Field text area :
    if DefaultDrawing
    then DefaultDrawColumnCell(TextRect, DataCol, Column, State)
    else inherited DrawColumnCell(TextRect, DataCol, Column, State);
  end
  else
    inherited;
end;

procedure TcyDBGrid.MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  aKey: Word;

      procedure Navigate; // Don't use KeyDown because it opens a new record at the end of the Dataset ...
      begin
        if DataLink.Active
        then
          if not DataSource.DataSet.Eof
          then DataSource.DataSet.Next;
      end;

begin
  case FMouseWheelMode of
    mwRowSelect:
      begin
        Handled := true;

        if Shift <> []
        then begin
          aKey := vk_Down;
          KeyDown(aKey, Shift);
        end
        else
          Navigate;    // Avoid clearing selection ...
      end;

    mwNavigate:
      begin
        Handled := true;
        Navigate;
      end;

    mwDoNothing:
      Handled := true;
      
    mwOriginal:
      Handled := false;
  end;
end;

procedure TcyDBGrid.MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  aKey: Word;

      procedure Navigate;
      begin
        if DataLink.Active
        then
          if not DataSource.DataSet.Bof
          then DataSource.DataSet.Prior;
      end;

begin
  case FMouseWheelMode of
    mwRowSelect:
      begin
        Handled := true;

        if Shift <> []
        then begin
          aKey := vk_up;
          KeyDown(aKey, Shift);
        end
        else
          navigate;       // Avoid clearing selection ...
      end;

    mwNavigate:
      begin
        Handled := true;
        navigate;
      end;

    mwDoNothing:
      Handled := true;

    mwOriginal:
      Handled := false;
  end;
end;

procedure TcyDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, StartRow, FirstDataRow, FirstDataCol: Integer;
  ChangeCheckBoxState: Boolean;
  DownCell: TGridCoord;
  aKey: Word;
begin
  ChangeCheckBoxState := false;

  if (Button = mbLeft) and (DataLink.Active)
  then begin
    StartRow := Row;
    DownCell := MouseCoord(X, Y);

    if dgTitles in Options
    then FirstDataRow := 1
    else FirstDataRow := 0;

    if DownCell.Y >= FirstDataRow   // Not sizing columns ...
    then begin
      // CheckBox area ?  :
      if (not CheckBoxes.FReadOnly) and (CheckBoxes.FVisible)
      then begin
        if dgIndicator in Options
        then FirstDataCol := 1
        else FirstDataCol := 0;

        if (CheckBoxes.FColumn = DownCell.X - FirstDataCol)
        then ChangeCheckBoxState := X < CellRect(DownCell.X, DownCell.Y).Left + CheckBoxes.Size + 1;
      end;

      // MultiSelection rows :
      if (not ChangeCheckBoxState) and (ssShift in Shift) and (dgMultiSelect in Options)
      then begin
        if StartRow >= FirstDataRow
        then begin
          if StartRow < DownCell.Y
          then aKey := vk_Down
          else aKey := vk_Up;

          for i := 1 to abs(StartRow - DownCell.Y) - 1 do
            KeyDown(aKey, Shift);

          Include(Shift, ssCtrl);   // In order to enter in the Inherited with Ctrl key pressed and selected the record!
        end;
      end;
    end;
  end;

  if ChangeCheckBoxState      // Change checkBox state
  then begin
    if StartRow <> DownCell.Y
    then Inherited;               // Moving to the selected record ...

    FCheckedList.CurrentRecordBookmarked := not FCheckedList.CurrentRecordBookmarked;
  end
  else
    Inherited;
end;

procedure TcyDBGrid.CheckSelectedRows(Value: Boolean);
var i: Integer;
begin
  if DataLink.Active
  then
    for i := 0 to SelectedRows.Count-1 do
      if Value
      then FCheckedList.InsertBookmark(SelectedRows[i])
      else FCheckedList.DeleteBookmark(SelectedRows[i]);
end;

procedure Register;
begin
  RegisterComponents('Cindy DB', [TcyDBGrid]);
end;

end.
