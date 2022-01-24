unit extDBGrid;

interface

uses
  Windows, SysUtils, Messages, Classes, Controls, Grids, DBGrids,
  Graphics, StdCtrls, Forms, Menus;

const
  MaxArrayFlter = 400;
  TypeSortA: array[1..2] of string = ('', ' desc');
  CountOper = 5;
  OperList: array[0..CountOper] of string = ('Содержит', ' равно ', 'не равно', 'больше', 'меньше', 'пусто');
  SqlOperList: array[0..CountOper] of string = (' containing ', ' = ', ' <> ', ' > ', ' < ', ' is null');

  ALIGN_FLAGS: array[TAlignment] of Integer =
  (DT_LEFT or DT_SINGLELINE or DT_EXPANDTABS or DT_NOPREFIX,
    DT_RIGHT or DT_SINGLELINE or DT_EXPANDTABS or DT_NOPREFIX,
    DT_CENTER or DT_SINGLELINE or DT_EXPANDTABS or DT_NOPREFIX);



type
  TDBGridForSort = procedure (Column: TColumn; FieldName, TypeSort: string) of object;
  TDBGridFilterChange = procedure (CondFilter: string) of object;
  TArrayFlter = array[1..MaxArrayFlter]of string[250];

  TextDBGrid = class(TDBGrid)
  private
    { Private declarations }
    FOperColAr: TArrayFlter; // массив имен операций фильтра
    FOperColSqlAr: TArrayFlter; // массив SQL операций фильтра
    FValFlterAr: TArrayFlter; // массив значений фильтра
    FLastCol: integer;
    FHeightHead: integer;
    FFilterOn: boolean;
    FTitleHeight: Integer;
    FInxTypeSort: byte;
    FOnDblClickCell: TDBGridClickEvent;
    FOnDBGridForSort: TDBGridForSort;
    FOnDBGridFilterChange: TDBGridFilterChange;
    procedure NewBitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
    function MouseToTitleLines(X, Y: Integer): integer;
    procedure EditValExit(Sender: TObject);
    procedure CreateComboBox(AOwner: TComponent);
    procedure cmbOperCondExit(Sender: TObject);
    procedure FilterValChange(Sender: TObject);
    procedure FormFilterStr;
    procedure CreatePpMenu(AOwner: TComponent);
    procedure ClearFilter(Sender: TObject);
    procedure FilterOn(Sender: TObject);
  protected
    { Protected declarations }
    function OkToWork: Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DrawCell(ACol, ARow: Integer; ARect: TRect;
      State: TGridDrawState); override;
  public
    { Public declarations }
    EditVal: TEdit;
    cmbOperCond: TComboBox;
    FPpMenu: TPopupMenu;
    constructor Create(AOwner: TComponent); override;
    procedure MouseWheelHandler(var Msg: TMessage); override;
  published
    { Published declarations }
     property OnDblClickCell: TDBGridClickEvent read FOnDblClickCell write FOnDblClickCell;
     property OnDBGridForSort: TDBGridForSort read FOnDBGridForSort write FOnDBGridForSort;
     property OnDBGridFilterChange: TDBGridFilterChange read FOnDBGridFilterChange write FOnDBGridFilterChange;
     property HeightHead: integer read FHeightHead write FHeightHead default 18;
     property Filter_On: boolean read FFilterOn write FFilterOn default false;
  end;

procedure Register;

implementation

uses Types;

procedure Register;
begin
  RegisterComponents('Samples', [TextDBGrid]);
end;


//**************************************************************************************************

procedure WriteText(ACanvas: TCanvas; ARect: TRect; const Text: string;
  Alignment: TAlignment);
var
  DrawRect: TRect;
begin
  DrawRect := Rect(ARect.Left + 1, ARect.Top + 1, ARect.Right, ARect.Bottom);
  DrawText(ACanvas.Handle, PChar(Text), Length(Text), DrawRect,
    ALIGN_FLAGS[Alignment] or DT_VCENTER or DT_END_ELLIPSIS);
end;
//--------------------------------------------------------------------------------------------------

function RectHeight(R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;
//--------------------------------------------------------------------------------------------------

function RectWidth(R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;
//--------------------------------------------------------------------------------------------------

//Рамочка вокруг заданного прямоугольника
procedure Paint3dRect(DC: HDC; ARect: TRect);
begin
  InflateRect(ARect, 1, 1);
  DrawEdge(DC, ARect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
  DrawEdge(DC, ARect, BDR_RAISEDINNER, BF_TOPLEFT);
end;

procedure MoveRectH(var vRect: TRect; DH: integer);
begin
  vRect.Top := vRect.Top + DH;
  vRect.Bottom := vRect.Bottom + DH;
end;

//**************************************************************************************************


constructor TextDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreatePpMenu(AOwner);
  EditVal := TEdit.Create(TextDBGrid(Self));
  with EditVal do begin
    Name := 'EditVal';
    Text := '';
    Parent := TWinControl(AOwner);
    Visible := false;
    Ctl3D := false;
    OnExit := EditValExit;
    OnChange := FilterValChange;
    PopupMenu := FPpMenu;
    BringToFront;
  end;
  CreateComboBox(AOwner);
  FFilterOn := false;
  FHeightHead := 18;
  FTitleHeight := 18;
  FLastCol := 1;
  FInxTypeSort := 0;
end;

procedure TextDBGrid.CreatePpMenu(AOwner: TComponent);
var
 mii: TMenuItem;
begin
  if (csDesigning in ComponentState) then Exit;
  FPpMenu := TPopupMenu.Create(AOwner);
  with FPpMenu do begin
   Name := 'aassasas12121';
   mii := TMenuItem.Create(Self);
   mii.Name := 'D222222';
   mii.Caption := 'Очистить поля фильтра';
   mii.OnClick := ClearFilter;
   Items.Insert(0, mii);

   mii := TMenuItem.Create(Self);
   mii.Name := 'D1111111';
   mii.Caption := 'Включить фильтр';
   mii.OnClick := FilterOn;
   Items.Insert(0, mii);
  end;
end;

procedure TextDBGrid.ClearFilter(Sender: TObject);
var
  i: integer;
begin
  for i:=1 to Self.ColCount - 1 do begin
    FOperColAr[i] := '';
    FOperColSqlAr[i] := '';
    FValFlterAr[i] := '';
  end;
  FFilterOn := false;
  FormFilterStr; 
  Self.Repaint;
end;

procedure TextDBGrid.FilterOn(Sender: TObject);
begin
  (FPpMenu.Items[0] as TMenuItem).Checked := not ((FPpMenu.Items[0] as TMenuItem).Checked);
  FFilterOn := (FPpMenu.Items[0] as TMenuItem).Checked;
  Self.Repaint;
  FormFilterStr;
end;

procedure TextDBGrid.CreateComboBox(AOwner: TComponent);
var
  i: integer;
begin
  cmbOperCond := TComboBox.Create(TextDBGrid(Self));
  with cmbOperCond do begin
//    Parent := TextDBGrid(Self);
    Parent := TWinControl(AOwner);
    Name := 'cmbOperCond';
    Text := '';
    for i := 0 to CountOper do cmbOperCond.Items.Add(OperList[i]);
    OnExit := cmbOperCondExit;
    OnChange := FilterValChange;
    PopupMenu := FPpMenu;
    Visible := false;
    BringToFront;
  end;
end;

procedure TextDBGrid.cmbOperCondExit(Sender: TObject);
begin
  cmbOperCond.Visible := false;
end;

procedure TextDBGrid.EditValExit(Sender: TObject);
begin
  EditVal.Visible := false;
end;

procedure TextDBGrid.FilterValChange(Sender: TObject);
var
  vCmb: TComboBox;
  vEd: TEdit;
begin
  if Sender is TComboBox then begin
    vCmb := TComboBox(Sender);
    if vCmb.Tag > 0 then begin
      FOperColAr[vCmb.Tag] := vCmb.Text;
      FOperColSqlAr[vCmb.Tag] := SqlOperList[vCmb.ItemIndex];
    end;
  end;
  if Sender is TEdit then begin
    vEd := TEdit(Sender);
    if vEd.Tag > 0 then begin
      FValFlterAr[vEd.Tag] := vEd.Text;
    end;
  end;
end;

procedure TextDBGrid.FormFilterStr;
var
  i: integer;
  vColumn: TColumn;
  FCond, s1: string;
begin
  FCond := '';
  for i := 1 to Self.ColCount-1 do begin
    vColumn := Columns[RawToDataColumn(i)];
    if (FOperColSqlAr[i] <> '')and(FValFlterAr[i] <> '') then begin
      s1 := '(' + vColumn.FieldName + ' '+FOperColSqlAr[i];
      if SqlOperList[5] <> FOperColSqlAr[i] then s1 := s1 + ' '+ QuotedStr(FValFlterAr[i]);
      s1 := s1 + ')';
      if FCond <> '' then FCond := FCond + ' and ';
      FCond := FCond + s1;
    end;
  end;
  if not FFilterOn then FCond := '';
  if Assigned(FOnDBGridFilterChange) then FOnDBGridFilterChange(FCond);
end;


function TextDBGrid.MouseToTitleLines(X, Y: Integer): integer;
var
  Cell: TGridCoord;
  vRect : TRect;
  b: integer;
begin
  Cell := MouseCoord(X, Y);
  vRect := CellRect(Cell.X, Cell.Y);
  b := Y - vRect.Top;
  Result := b div FTitleHeight;
end;

procedure TextDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
  vRect: TRect;
begin
  inherited MouseDown(Button, Shift, X, Y);
  FHeightHead := MouseToTitleLines(X, Y);
  Cell := MouseCoord(X, Y);
  if (Button = mbLeft) then  if (Cell.Y = 0) and (OkToWork) then begin
    if (MouseToTitleLines(X,Y) = 1) then begin
      with EditVal do begin
        vRect := CellRect(Cell.X, Cell.Y);
        Top := TextDBGrid(Self).Top + vRect.Top + FTitleHeight+2;
        Left := TextDBGrid(Self).Left + vRect.Left+2;
        Width := vRect.Right - vRect.Left;
        Height := FTitleHeight;
        Tag := Cell.X;
        Visible := true;
        Text := FValFlterAr[Cell.X];
        BringToFront;
        SetFocus;
       end;
    end;  // if (MouseToTitleLines(X,Y) = 1) then begin
    if (MouseToTitleLines(X,Y) = 0) then begin
      with cmbOperCond do begin
        vRect := CellRect(Cell.X, Cell.Y);
        Top := TextDBGrid(Self).Top + vRect.Top+2;
        Left := TextDBGrid(Self).Left + vRect.Left+2;
        Width := vRect.Right - vRect.Left;
        Height := FTitleHeight;
        Tag := Cell.X;
        Text := FOperColAr[Cell.X];
        Visible := true;
        BringToFront;
        SetFocus;
      end;
    end; //     if (MouseToTitleLines(X,Y) = 0) then begin
  end; //   if (Button = mbLeft) then  if (Cell.Y = 0) and (OkToWork) then begin

  if (ssDouble in Shift) and (Button = mbLeft) then
  begin
    // пока будем считать, что строка Title имеет координату Y = 0, но есть и другие случаи
    if (Cell.Y > 0) and (OkToWork) then
      begin
        if Assigned(FOnDblClickCell) then FOnDblClickCell(Columns[RawToDataColumn(Cell.X)]);
      end;
  end;
end;

function TextDBGrid.OkToWork: Boolean;
begin
  Result := Assigned(DataSource)
        and Assigned(DataLink.DataSet)
        and (DataLink.DataSet.Active);
end;

// для работы колесом
procedure TextDBGrid.MouseWheelHandler(var Msg: TMessage);
begin
  if (Msg.Msg = WM_MOUSEWHEEL) and OkToWork then begin
    if SmallInt(HiWord(Msg.wParam)) > 0
      then DataSource.DataSet.Prior
      else DataSource.DataSet.Next;
    Msg.Result := 1;
  end else
    inherited MouseWheelHandler(Msg);
end;


procedure TextDBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  NewBitMouseUp(Self, Button, Shift, X, Y);
end;

procedure TextDBGrid.NewBitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
  vRect: TRect;
  vColumn: TColumn;
  vX, vY: integer;
begin
  if not OkToWork then Exit;
  if Not Assigned(FOnDBGridForSort) then Exit;
  vX := X; vY := Y;
  Cell := MouseCoord(vX,vY);
  // (Cell.X > 0) - колонка индикатора состояния
  // (Cell.Y = 0) -  строка тайтлов
  if (Button = mbLeft) and (Cell.X > 0) and (Cell.Y = 0)
     and(MouseToTitleLines(X,Y) = 2)   then begin
    vRect := CellRect(Cell.X, Cell.Y);
    vColumn := Columns[RawToDataColumn(Cell.X)];
    if FLastCol = Cell.X then begin
      inc(FInxTypeSort); if FInxTypeSort = 3 then FInxTypeSort := 1;
    end
    else begin
      FInxTypeSort := 1;
      FLastCol := Cell.X; // save last column
    end;
    Repaint;
    FOnDBGridForSort(vColumn, vColumn.FieldName,TypeSortA[FInxTypeSort]);
  end;
end;

procedure TextDBGrid.DrawCell(ACol, ARow: Integer; ARect: TRect; State:
  TGridDrawState);
var
  DataCol: Integer;
  Rect1, Rect2, Rect3 : TRect;
  AColor: TColor;
  vColumn: TColumn;
begin
  RowHeights[0] := FTitleHeight*3+2;
  inherited DrawCell(ACol, ARow, ARect, State);
  if csDesigning in ComponentState then
    Exit;

  Rect1 := ARect; Rect1.Bottom := FTitleHeight;
  Rect2 := Rect1; MoveRectH(Rect2, FTitleHeight);
  Rect3 := Rect2; MoveRectH(Rect3, FTitleHeight);
  if {(gdFixed in State) and }(ARow = 0) and (ACol <> 0) then begin
    Canvas.Brush.Color := clWindow;
    Canvas.Font.Color:=clBtnText;
   //--111-------------------------------------
    Canvas.FillRect(Rect1);
    WriteText(Canvas, Rect1, FOperColAr[ACol], taCenter);
    InflateRect(Rect1, 1, 0);
    FrameRect(Canvas.Handle, Rect1, GetStockObject(BLACK_BRUSH));

   //--222----------------------------------------

    Canvas.FillRect(Rect2);
    WriteText(Canvas, Rect2, FValFlterAr[ACol], taCenter);
    InflateRect(Rect2, 1, 1);
    FrameRect(Canvas.Handle, Rect2, GetStockObject(BLACK_BRUSH));

    //--333---------------------------------------
    Canvas.Brush.Color:=clBtnFace;
    Canvas.Font.Color:=clBtnText;
    if FFilterOn then Canvas.Font.Color:=clBlue;
    vColumn := Columns[RawToDataColumn(ACol)];
    WriteText(Canvas, Rect3, vColumn.Title.Caption , taCenter);


    // --- маркер сортировки---------------
  if ACol = FLastCol then begin
    if FInxTypeSort > 0 then begin
      InflateRect(Rect3, 0, -1);
      Canvas.Brush.Color := clBlack;
    end;
    case FInxTypeSort of
      1: Canvas.Polygon([Point(Rect3.Left, Rect3.Top), Point(Rect3.Left+12, Rect3.Top),
         Point(Rect3.Left+6, Rect3.Top+6)]);
      2: Canvas.Polygon([Point(Rect3.Left, Rect3.Top+6), Point(Rect3.Left+12, Rect3.Top+6),
         Point(Rect3.Left+6, Rect3.Top)]);
    end;
  end;

  end //if
  else begin
    // Стандартное действие DBGrid
    Canvas.Brush.Color := AColor;
    Canvas.Font := Font;
//    inherited DrawCell(ACol, ARow, ARect, State);
  end;

end;





end.
