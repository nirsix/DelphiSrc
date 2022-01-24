unit uRangeStakRef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD;

type
  TfrmRangeStakRef = class(TForm)
    stgRangeStakLst: TStringGrid;
    stgFilter: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadDataFBase;
    procedure InitstgRangeStakLst;
    procedure InitstgFilter;
    procedure stgFiltering;
    procedure InitForm(InParam: PTParamForm);
    procedure stgFilterSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure stgRangeStakLstDblClick(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  входящий параметр от формы хозяина
     Sr: TStgArray;
  public
    { Public declarations }
  end;

var
  frmRangeStakRef: TfrmRangeStakRef;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmRangeStakRef.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRangeStakRef.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgRangeStakLst; // 1
  InitstgFilter;    // 2  порядок следования важен, смотри код
  stgFiltering;
end;

procedure TfrmRangeStakRef.InitstgRangeStakLst;
begin
  with stgRangeStakLst do begin
    SetNameColSTG(stgRangeStakLst,Sr,5);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmRangeStakRef.InitstgFilter;
Var
    i: integer;
begin
  with stgFilter do begin
    ColCount := stgRangeStakLst.ColCount;
    RowCount := 1;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 0;
    for i := 0 to ColCount - 1  do ColWidths[i] := stgRangeStakLst.ColWidths[i];
    Height := 22;
    Width := stgRangeStakLst.Width;
  end;
end;

procedure TfrmRangeStakRef.stgFiltering;
  var
    i,j,k: integer;
    s1, s2: string;
begin
  InitstgRangeStakLst;
  if stgFilter.Cells[stgFilter.Col,0] = '' then exit;
  j:=1;
  with stgRangeStakLst do begin
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

procedure TfrmRangeStakRef.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmRangeStakRef.LoadDataFBase;
  var
    i: integer;
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgRangeStakLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from RANGESTAK order by IDSTAK';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('IDSTAK').AsString;
        Cells[Sr[1],i] := FieldByName('MINS').AsString;
        Cells[Sr[2],i] := FieldByName('MAXS').AsString;
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

procedure TfrmRangeStakRef.FormResize(Sender: TObject);
begin
  stgRangeStakLst.Height := Self.Height - 20;
  stgRangeStakLst.Width := Self.Width - 10;
  stgFilter.Width := stgRangeStakLst.Width;
end;

procedure TfrmRangeStakRef.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmRangeStakRef := nil;
end;

procedure TfrmRangeStakRef.stgRangeStakLstDblClick(Sender: TObject);
begin
  if Assigned(FInParam.OnPushParam) then begin
    FInParam.rr[1] := stgRangeStakLst.Cells[sr[0],stgRangeStakLst.Row];
    FInParam.OnPushParam(nil);
    Close;
  end;
end;

end.
