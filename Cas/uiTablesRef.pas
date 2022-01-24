unit uiTablesRef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uRangeStakRef;

type
  TfrmiTablesRef = class(TForm)
    stgiTablesLst: TStringGrid;
    stgFilter: TStringGrid;
    lIDRoul: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadDataFBase;
    procedure InitstgiTablesLst;
    procedure InitstgFilter;
    procedure stgFiltering;
    procedure InitForm(InParam: PTParamForm);
    procedure stgFilterSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure stgiTablesLstDblClick(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  входящий параметр от формы хозяина
     Sr: TStgArray;
     pRangeRef:TParamForm;
     procedure ReloadData(Sender: TObject);
     procedure FillTables;
  public
    { Public declarations }
  end;

var
  frmiTablesRef: TfrmiTablesRef;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmiTablesRef.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmiTablesRef.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  lIDRoul.Caption :='Столы рулетки №'+FInParam.rr[1];
  InitstgiTablesLst; // 1
  InitstgFilter;    // 2  порядок следования важен, смотри код
  stgFiltering;
end;

procedure TfrmiTablesRef.InitstgiTablesLst;
begin
  with stgiTablesLst do begin
    SetNameColSTG(stgiTablesLst,Sr,4);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmiTablesRef.InitstgFilter;
Var
    i: integer;
begin
  with stgFilter do begin
    ColCount := stgiTablesLst.ColCount;
    RowCount := 1;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 0;
    for i := 0 to ColCount - 1  do ColWidths[i] := stgiTablesLst.ColWidths[i];
    Height := 22;
    Width := stgiTablesLst.Width;
  end;
end;

procedure TfrmiTablesRef.stgFiltering;
  var
    i,j,k: integer;
    s1, s2: string;
begin
  InitstgiTablesLst;
  if stgFilter.Cells[stgFilter.Col,0] = '' then exit;
  j:=1;
  with stgiTablesLst do begin
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

procedure TfrmiTablesRef.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmiTablesRef.FillTables;
var
  i:integer;
   cp,ct, idr, sql: string;
begin
  ct := GetParamValue('7'); // кол-во столов
  cp := GetParamValue('8'); // кол-во игроков
  idr := FInParam.rr[1];
  for i := 1 to StrToInt(ct) do begin
    sql := 'INSERT INTO TABLES (IDTABLE, IDROUL, COUNTPLAYERS, IDRANGE) VALUES (';
    sql := sql + IntToStr(i)+','+FInParam.rr[1] + ','+cp+',1)';
    ExecSqlIB(sql);
  end;
  LoadDataFBase;
end;

procedure TfrmiTablesRef.LoadDataFBase;
  var
    i: integer;
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgiTablesLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := 'select tables.idtable, tables.idroul, tables.countplayers,'+
                  ' rangestak.MINS, rangestak.MAXS from tables '+
                  ' inner join rangestak on (tables.idrange = rangestak.idstak)'+
                  ' where (tables.idroul = '+FInParam.rr[1]+')';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('IDROUL').AsString;
        Cells[Sr[1],i] := FieldByName('IDTABLE').AsString;
        Cells[Sr[2],i] := FieldByName('COUNTPLAYERS').AsString;
        Cells[Sr[3],i] := FieldByName('MINS').AsString+'-'+FieldByName('MAXS').AsString;
        next;
      end;
      Close;
      if i = 0 then FillTables;
      RowCount := i + 1;
      if RowCount > 1 then FixedRows := 1;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmiTablesRef.ReloadData(Sender: TObject);
var
 sql: string;
begin
  sql := 'UPDATE TABLES SET TABLES.IDRANGE = '+pRangeRef.rr[1];
  sql := sql +' Where ((TABLES.IDTABLE = '+pRangeRef.rr[2]+')and(TABLES.IDRoul = ';
  sql := sql +FInParam.rr[1]+'))';
  ExecSqlIB(sql);
  LoadDataFBase;
end;

procedure TfrmiTablesRef.FormResize(Sender: TObject);
begin
  stgiTablesLst.Height := Self.Height - 105;
  stgiTablesLst.Width := Self.Width - 10;
  stgFilter.Width := stgiTablesLst.Width;
end;

procedure TfrmiTablesRef.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmiTablesRef := nil;
end;

procedure TfrmiTablesRef.stgiTablesLstDblClick(Sender: TObject);
begin
 if stgiTablesLst.Col = Sr[3] then begin
  with pRangeRef do begin
    if PForm <> nil then begin
      (PForm as TfrmRangeStakRef).Show;
      Exit;
    end;
    OnPushParam := ReloadData;
    PForm := TfrmRangeStakRef.Create(Self);
    rr[1] := stgiTablesLst.Cells[sr[0],stgiTablesLst.Row];
    rr[2] := stgiTablesLst.Cells[sr[1],stgiTablesLst.Row];
    (PForm as TfrmRangeStakRef).InitForm(@pRangeRef);
  end;
 end;// if 
end;


end.
