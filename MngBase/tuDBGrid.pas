unit tuDBGrid;

interface

uses
  Windows, SysUtils, Messages, Classes, Controls, Grids, DBGrids, StdCtrls;

const
  SymbolA: array[1..2] of char = (#112,#113);
  TypeSortA: array[1..2] of string = ('', ' desc');


type
  TDBGridForSort = procedure (Column: TColumn; FieldName, TypeSort: string) of object;

  TtuDBGrid = class(TDBGrid)
  private
    { Private declarations }
    FLastCol: integer;
    FInxSymb: byte;
    FOnDblClickCell: TDBGridClickEvent;
    FOnDBGridForSort: TDBGridForSort;
    procedure NewBitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer);
  protected
    FLabel: TLabel;
    { Protected declarations }
    function OkToWork: Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
    X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure MouseWheelHandler(var Msg: TMessage); override;
  published
    { Published declarations }
     property OnDblClickCell: TDBGridClickEvent read FOnDblClickCell write FOnDblClickCell;
     property OnDBGridForSort: TDBGridForSort read FOnDBGridForSort write FOnDBGridForSort;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TtuDBGrid]);
end;


constructor TtuDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabel := TLabel.Create(self);
  with FLabel do begin
    Parent := Self;
    Font.Name := 'Wingdings 3';
    Caption := '';
    Top := 3;
  end;
  FLabel.OnMouseUp := Self.NewBitMouseUp;
  FLastCol := 0;
  FInxSymb := 1;
end;


procedure TtuDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (ssDouble in Shift) and (Button = mbLeft) then
  begin
    Cell := MouseCoord(X, Y);
    // пока будем считать, что строка Title имеет координату Y = 0, но есть и другие случаи
    if (Cell.Y > 0) and (OkToWork) then
      begin
        if Assigned(FOnDblClickCell) then FOnDblClickCell(Columns[RawToDataColumn(Cell.X)]);
      end;
  end;
end;

function TtuDBGrid.OkToWork: Boolean;
begin
  Result := Assigned(DataSource)
        and Assigned(DataLink.DataSet)
        and (DataLink.DataSet.Active);
end;

// для работы колесом
procedure TtuDBGrid.MouseWheelHandler(var Msg: TMessage);
begin
  if (Msg.Msg = WM_MOUSEWHEEL) and OkToWork then begin
    if SmallInt(HiWord(Msg.wParam)) > 0
      then DataSource.DataSet.Prior
      else DataSource.DataSet.Next;
    Msg.Result := 1;
  end else
    inherited MouseWheelHandler(Msg);
end;


procedure TtuDBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  NewBitMouseUp(Self, Button, Shift, X, Y);
end;

procedure TtuDBGrid.NewBitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
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
  if Sender = FLabel then begin
    vY := FLabel.Top + Y;
    vX := FLabel.Left + X;
  end;
  Cell := MouseCoord(vX,vY);
  // (Cell.X > 0) - колонка индикатора состояния
  // (Cell.Y = 0) -  строка тайтлов
  if (Button = mbLeft) and (Cell.X > 0) and (Cell.Y = 0) then begin
    if FLastCol = Cell.X then begin
      inc(FInxSymb); if FInxSymb = 3 then FInxSymb := 1;
    end;
    FLastCol := Cell.X; // save last column
    FLabel.Caption := SymbolA[FInxSymb];
    vRect := CellRect(Cell.X, Cell.Y);
    FLabel.Left := vRect.Right - 15;
    vColumn := Columns[RawToDataColumn(Cell.X)];
    FOnDBGridForSort(vColumn, vColumn.FieldName,TypeSortA[FInxSymb]);
  end;
end;




end.
