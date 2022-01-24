unit uPlayersRef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uPlayerNd, uNirSec;

type
  TfrmPlayersRef = class(TForm)
    stgPlayersLst: TStringGrid;
    stgFilter: TStringGrid;
    ToolBar1: TToolBar;
    tbNew: TToolButton;
    tbEdit: TToolButton;
    tbKey: TToolButton;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbNewClick(Sender: TObject);
    procedure LoadDataFBase;
    procedure InitstgPlayersLst;
    procedure tbEditClick(Sender: TObject);
    procedure InitstgFilter;
    procedure stgFiltering;
    procedure InitForm(InParam: PTParamForm);
    procedure stgFilterSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure stgPlayersLstDblClick(Sender: TObject);
    procedure stgPlayersLstDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
     FInParam: PTParamForm; //  вход€щий параметр от формы хоз€ина
     pPlayerNd: TParamForm;
     Sr: TStgArray;
     procedure ReloadData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmPlayersRef: TfrmPlayersRef;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmPlayersRef.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmPlayersRef.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgPlayersLst; // 1
  InitstgFilter;    // 2  пор€док следовани€ важен, смотри код
  stgFiltering;
end;

procedure TfrmPlayersRef.InitstgPlayersLst;
begin
  with stgPlayersLst do begin
    SetNameColSTG(stgPlayersLst,Sr,6);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmPlayersRef.InitstgFilter;
Var
    i: integer;
begin
  with stgFilter do begin
    ColCount := stgPlayersLst.ColCount;
    RowCount := 1;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 0;
    for i := 0 to ColCount - 1  do ColWidths[i] := stgPlayersLst.ColWidths[i];
    Height := 22;
    Width := stgPlayersLst.Width;
  end;
end;

procedure TfrmPlayersRef.stgFiltering;
  var
    i,j,k: integer;
    s1, s2: string;
begin
  InitstgPlayersLst;
  if stgFilter.Cells[stgFilter.Col,0] = '' then exit;
  j:=1;
  with stgPlayersLst do begin
    for i := 1 to RowCount - 1 do begin
      s1 := AnsiUpperCase(stgFilter.Cells[stgFilter.Col,0]);
      s2 := AnsiUpperCase(Cells[stgFilter.Col,i]);
      if pos(s1,s2)>0 then begin
        for k := 0 to ColCount-1 do
           Cells[k,j] := Cells[k,i];
        inc(j);
      end;
    end;
    RowCount := j;
  end;
end;

procedure TfrmPlayersRef.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmPlayersRef.LoadDataFBase;
  var
    i, sum, iduser: integer;
    IBSQLG1: TIBSQL;
    bs: string;
/////////    place2, place4: MD5Str16;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgPlayersLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from USERDATA order by IDUSER';
{    LOGIN      DTXT250 /* DTXT250 = VARCHAR(250) */,
    ADDRES     DTXT250 /* DTXT250 = VARCHAR(250) */,
    TELEPHON   DTXT250 /* DTXT250 = VARCHAR(250) */,
    EMAIL      DTXT250 /* DTXT250 = VARCHAR(250) */,
    NOTE       DTXT250 /* DTXT250 = VARCHAR(250) */,
    FIRSTNAME  DTXT250 /* DTXT250 = VARCHAR(250) */,
    PLACE1     DPHONE /* DPHONE = VARCHAR(40) */,
    PLACE2     DPHONE /* DPHONE = VARCHAR(40) */,
    PLACE3     DPHONE /* DPHONE = VARCHAR(40) */,
    PLACE4     DPHONE /* DPHONE = VARCHAR(40) */,
    DATEREG    DATE}

      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        IdUser := FieldByName('IDUSER').AsInteger;
        Cells[Sr[0],i] := IntToStr(IdUser);
        Cells[Sr[1],i] := FieldByName('DATEREG').AsString;
        Cells[Sr[2],i] := FieldByName('LOGIN').AsString;
        Cells[Sr[3],i] := FieldByName('FIRSTNAME').AsString;
      //  Cells[Sr[4],i] := FieldByName('NOTES').AsString;
        Cells[Sr[5],i] := FieldByName('EMAIL').AsString;
//////        place2 := FieldByName('PLACE2').AsString;
///////        place4 := FieldByName('PLACE4').AsString;
        if not GetUserAccount(sum,IdUser,'USER_AC') then begin
           Cells[Sr[4],i] := 'ERROR!!!';
        end
        else begin
           Cells[Sr[4],i] := IntToStr(sum);
        end;
        if not GetUserAccount(sum,IdUser,'USER_ACFUN') then begin
           Cells[Sr[6],i] := 'ERROR!!!';
        end
        else begin
           Cells[Sr[6],i] := IntToStr(sum);
        end;
        bs := 'ON';
        if FieldByName('OFFUSER').AsString = '1' then bs := 'OFF';
        Cells[Sr[7],i] := bs;

/////         IntToStr(DeCodeAccount(place4,place2));
        next;
      end;
      Close;
      RowCount := i + 1;
      if RowCount > 1 then FixedRows := 1;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmPlayersRef.tbNewClick(Sender: TObject);
begin
 with pPlayerNd do begin
   if PForm <> nil then begin
      (PForm as TfrmPlayerNd).Show;
      Exit;
   end;
   OnPushParam := ReloadData;
   PForm := TfrmPlayerNd.Create(Self);
   rr[1] := stgPlayersLst.Cells[sr[0],stgPlayersLst.Row];
   (PForm as TfrmPlayerNd).InitForNew(@pPlayerNd);
 end;
end;

procedure TfrmPlayersRef.tbEditClick(Sender: TObject);
begin
  with pPlayerNd do begin
    if PForm <> nil then begin
      (PForm as TfrmPlayerNd).Show;
      Exit;
    end;
    OnPushParam := ReloadData;
    PForm := TfrmPlayerNd.Create(Self);
    rr[1] := stgPlayersLst.Cells[sr[0],stgPlayersLst.Row];
    (PForm as TfrmPlayerNd).InitForEdit(@pPlayerNd);
  end;
end;

procedure TfrmPlayersRef.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmPlayersRef.FormResize(Sender: TObject);
begin
  stgPlayersLst.Height := Self.Height - 105;
  stgPlayersLst.Width := Self.Width - 10;
  stgFilter.Width := stgPlayersLst.Width;
end;

procedure TfrmPlayersRef.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmPlayersRef := nil;
end;

procedure TfrmPlayersRef.stgPlayersLstDblClick(Sender: TObject);
begin
  if Assigned(FInParam.OnPushParam) then begin
    FInParam.rr[1] := stgPlayersLst.Cells[sr[0],stgPlayersLst.Row];
    FInParam.rr[2] := stgPlayersLst.Cells[sr[2],stgPlayersLst.Row];
    FInParam.OnPushParam(nil);
    Close;
  end;
end;


procedure TfrmPlayersRef.stgPlayersLstDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
 var
   Rct: TRect;
   OldColor: integer;  
begin
 if (stgPlayersLst.Cells[Sr[7],ARow] = 'OFF')and(ARow > 0)then begin
// if (ACol = Sr[7])and(ARow > 0) then begin
   with stgPlayersLst, stgPlayersLst.Canvas do begin
     Rct := CellRect(ACol, ARow); // получаем размер €чейки
     OldColor := Font.Color;
     Font.Color := clBlack;
     Font.Style := [fsBold];
     Brush.Color := 16765388;
     FillRect(Rct);
     TextRect(Rct, Rct.Left + 2, Rct.Top + 2, Cells[aCol, aRow]);
     Font.Color := OldColor;
   end;
 end;
end;

end.
