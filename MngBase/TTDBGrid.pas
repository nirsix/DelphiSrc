{$IFDEF VER130} { Borland Delphi 5.x }
  {$DEFINE D5}
{$ENDIF}

{$IFDEF VER140} { Borland Delphi 6.x }
  {$DEFINE D6}
{$ENDIF}

{$IFDEF VER150} { Borland Delphi 7.x }
  {$DEFINE D6}
  {$DEFINE D7}
{$ENDIF}

{$IFDEF VER170} { Borland Delphi 9.x (2005) }
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D9}
{$ENDIF}

unit TTDBGrid;

interface

uses
  Windows, Messages, Classes, Controls, DBGrids, Grids, Graphics;

type
  TToolTipsDBGrid = class(TDBGrid)
  private
    { Private declarations }
    FHintWnd: THintWindow;
    FLastCol, FLastRow: Integer;
    FToolTips: Boolean;
    FTitleFontColor: TColor;
    FGridFixedColor: TColor;
    FSelectedFixColor: TColor;
    FToolTipColor: TColor;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMKeyDown(var Msg: TMessage); message WM_KEYDOWN;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    procedure SetToolTipColor(const Value: TColor);
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function OkToWork: Boolean;
    procedure CloseToolTipWindow;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MouseWheelHandler(var Msg: TMessage); override;

    property RowCount;
    property TopRow;
  published
    property ToolTipColor: TColor read FToolTipColor write SetToolTipColor default clInfoBk;
    property ToolTips: Boolean read FToolTips write FToolTips default True;
  end;

procedure Register;

implementation

uses Forms, DB;

{$ifndef D6}
var
  clHotLight: Integer;
{$endif}

procedure Register;
begin
  RegisterComponents('Data Controls', [TToolTipsDBGrid]);
end;

{ TToolTipsDBGrid }

procedure TToolTipsDBGrid.CloseToolTipWindow;
begin
  if IsWindowVisible(FHintWnd.Handle) then begin
//    ShowWindow(FHintWnd.Handle, SW_HIDE);
    FHintWnd.ReleaseHandle;
    FLastCol := 0;
    FLastRow := 0;
  end;
end;

procedure TToolTipsDBGrid.CMFontChanged(var Msg: TMessage);
begin
  inherited;
  // шрифт, как у Ѕƒ√рида
  FHintWnd.Canvas.Font.Assign(Self.Font);
end;

procedure TToolTipsDBGrid.CMMouseLeave(var Msg: TMessage);
begin
  // убирание хинта при покидании мыши области Grid'а
  CloseToolTipWindow;
  inherited;
end;

constructor TToolTipsDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FToolTips := True;
  FLastCol := 0;
  FLastRow := 0;
  // хинт
  FToolTipColor :=  clInfoBk;
  FHintWnd := THintWindow.Create(Self);
  FHintWnd.Color := FToolTipColor;
  FHintWnd.Canvas.Font.Assign(Self.Font); // шрифт, как у Ѕƒ√рида
  // цвет Grida
  FTitleFontColor := TitleFont.Color;
  FGridFixedColor := FixedColor;
  FSelectedFixColor := ColorToRGB(FixedColor) + $080808;
end;

destructor TToolTipsDBGrid.Destroy;
begin
  FHintWnd.Free;
  inherited Destroy;
end;

procedure TToolTipsDBGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
begin
  inherited DrawCell(ACol, ARow, ARect, AState);
//  CloseToolTipWindow;
end;

procedure TToolTipsDBGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Cell: TGridCoord;
  iCurRec: Longint;
  R: TRect;
  P: TPoint;
  S: String;
begin
  inherited MouseMove(Shift, X, Y);

  Cell := MouseCoord(X, Y);

  // проверить, что не в редакторе!
  if not OkToWork or EditorMode or
    (DataLink.DataSet.State <> dsBrowse) or
    DataLink.DataSet.ControlsDisabled or
    (DataLink.DataSet.RecordCount = 0) or
    DataLink.DataSet.IsEmpty or
    ((dgIndicator in Options) and (Cell.X = 0)) {or (Cell.Y = 0)} then
  begin
    CloseToolTipWindow;
    Exit;
  end;

  if (FLastCol <> Cell.X) or (FLastRow <> Cell.Y) then begin
    // запомним последнюю €чейку с мышей...
    FLastCol := Cell.X;
    FLastRow := Cell.Y;
    if (Cell.X <= (LeftCol + VisibleColCount - 1)) and (Cell.X >= LeftCol) then begin
      // запомним текущую позицию...
      iCurRec := DataLink.ActiveRecord;
      if FLastRow > 0 then begin
        BeginUpdate;
        try
          // переместимс€ дл€ чтени€ данных в €чейке
          DataLink.ActiveRecord := Cell.Y - 1;
          // текст...
          if Assigned(Columns[RawToDataColumn(FLastCol)].Field)
            then S := Columns[RawToDataColumn(FLastCol)].Field.DisplayText
            else S := '';
        finally
          DataLink.ActiveRecord := iCurRec;
          EndUpdate;
        end;
      end
      else begin // попали на шапку!
        S := Columns[RawToDataColumn(FLastCol)].Title.Caption;
      end;

      // €чейка
      if (FHintWnd.Canvas.TextWidth(S) + 4) > Columns[RawToDataColumn(FLastCol)].Width then begin
        R := CellRect(Cell.X, Cell.Y);
        P := ClientToScreen(Point(R.Left, R.Top));
        // прибавл€ем по 2 пиксела слева и справа + 2 пиксела на левую и правую рамки
        R := Rect(P.X, P.Y, P.X + FHintWnd.Canvas.TextWidth(S) + 7,
          P.Y + RowHeights[Cell.Y] - 2);
        OffsetRect(R, -1, -1);
        FHintWnd.ActivateHint(R, S); // покажем хинт
//        FHintWnd.Canvas.TextRect(R, 0, 0, S);
//        FHintWnd.Canvas.Rectangle(R);
      end
      else CloseToolTipWindow;
    end;
  end;
end;

procedure TToolTipsDBGrid.MouseWheelHandler(var Msg: TMessage);
begin
  if (Msg.Msg = WM_MOUSEWHEEL) and OkToWork then begin
    CloseToolTipWindow;
    if SmallInt(HiWord(Msg.wParam)) > 0
      then DataSource.DataSet.Prior
      else DataSource.DataSet.Next;
    Msg.Result := 1;
  end else
    inherited MouseWheelHandler(Msg);
end;

function TToolTipsDBGrid.OkToWork: Boolean;
begin
  Result := FToolTips and Assigned(DataSource)
        and Assigned(DataLink.DataSet)
        and (DataLink.DataSet.Active);
end;

procedure TToolTipsDBGrid.SetToolTipColor(const Value: TColor);
begin
  if FToolTipColor <> Value then begin
    FToolTipColor := Value;
    FHintWnd.Color := Value;
    if FHintWnd.Visible then FHintWnd.Invalidate;
  end;
end;

procedure TToolTipsDBGrid.WMKeyDown(var Msg: TMessage);
begin
  inherited;
//  CloseToolTipWindow;
end;

procedure TToolTipsDBGrid.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  TitleFont.Color := FTitleFontColor;
  FixedColor := FGridFixedColor;
end;

procedure TToolTipsDBGrid.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  TitleFont.Color := clHotLight;
  FixedColor := FSelectedFixColor;
end;

procedure TToolTipsDBGrid.WMVScroll(var Msg: TWMVScroll);
begin
  inherited;
  // прокрутка грида при перет€гивании Thumb в ScrollBar'е
  // источник http://www.swissdelphicenter.ch/en/showcode.php?id=2035
  CloseToolTipWindow;
  if not OkToWork
    or (DataSource.DataSet.RecNo = -1)
    or (Msg.ScrollCode <> SB_THUMBTRACK)
  then Exit;
  DataSource.DataSet.RecNo := Msg.Pos;
end;

initialization

{$ifndef D6}
clHotLight := GetSysColor(26); // COLOR_HOTLIGHT
{$endif}

end.
