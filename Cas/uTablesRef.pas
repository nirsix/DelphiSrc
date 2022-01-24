unit uTablesRef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uTableNd, uiTablesRef;

type
  TfrmTablesRef = class(TForm)
    stgTablesLst: TStringGrid;
    stgFilter: TStringGrid;
    ToolBar1: TToolBar;
    tbNew: TToolButton;
    tbEdit: TToolButton;
    tbKey: TToolButton;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbNewClick(Sender: TObject);
    procedure LoadDataFBase;
    procedure InitstgTablesLst;
    procedure tbEditClick(Sender: TObject);
    procedure InitstgFilter;
    procedure stgFiltering;
    procedure InitForm(InParam: PTParamForm);
    procedure stgFilterSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure stgTablesLstDblClick(Sender: TObject);
    procedure tbKeyClick(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  входящий параметр от формы хозяина
     pTableNd: TParamForm;
     piTablesRef: TParamForm;
     Sr: TStgArray;
     procedure ReloadData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmTablesRef: TfrmTablesRef;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmTablesRef.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmTablesRef.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgTablesLst; // 1
  InitstgFilter;    // 2  порядок следования важен, смотри код
  stgFiltering;
end;

procedure TfrmTablesRef.InitstgTablesLst;
begin
  with stgTablesLst do begin
    SetNameColSTG(stgTablesLst,Sr,1);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmTablesRef.InitstgFilter;
Var
    i: integer;
begin
  with stgFilter do begin
    ColCount := stgTablesLst.ColCount;
    RowCount := 1;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 0;
    for i := 0 to ColCount - 1  do ColWidths[i] := stgTablesLst.ColWidths[i];
    Height := 22;
    Width := stgTablesLst.Width;
  end;
end;

procedure TfrmTablesRef.stgFiltering;
  var
    i,j,k: integer;
    s1, s2: string;
begin
  InitstgTablesLst;
  if stgFilter.Cells[stgFilter.Col,0] = '' then exit;
  j:=1;
  with stgTablesLst do begin
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

procedure TfrmTablesRef.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmTablesRef.LoadDataFBase;
  var
    i: integer;
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgTablesLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from ROULETTES order by IDROUL';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('IDROUL').AsString;
        Cells[Sr[1],i] := FieldByName('NAMER').AsString;
        Cells[Sr[2],i] := FieldByName('IPADDRESS').AsString;
        Cells[Sr[3],i] := FieldByName('IDENTITY').AsString;
        Cells[Sr[4],i] := FieldByName('NOTES').AsString;
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

procedure TfrmTablesRef.tbNewClick(Sender: TObject);
begin
 with pTableNd do begin
   if PForm <> nil then begin
      (PForm as TfrmTableNd).Show;
      Exit;
   end;
   OnPushParam := ReloadData;
   PForm := TfrmTableNd.Create(Self);
   rr[1] := stgTablesLst.Cells[sr[0],stgTablesLst.Row];
   (PForm as TfrmTableNd).InitForNew(@pTableNd);
 end;
end;

procedure TfrmTablesRef.tbEditClick(Sender: TObject);
begin
  with pTableNd do begin
    if PForm <> nil then begin
      (PForm as TfrmTableNd).Show;
      Exit;
    end;
    OnPushParam := ReloadData;
    PForm := TfrmTableNd.Create(Self);
    rr[1] := stgTablesLst.Cells[sr[0],stgTablesLst.Row];
    (PForm as TfrmTableNd).InitForEdit(@pTableNd);
  end;
end;

procedure TfrmTablesRef.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmTablesRef.FormResize(Sender: TObject);
begin
  stgTablesLst.Height := Self.Height - 105;
  stgTablesLst.Width := Self.Width - 10;
  stgFilter.Width := stgTablesLst.Width;
end;

procedure TfrmTablesRef.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmTablesRef := nil;
end;

procedure TfrmTablesRef.stgTablesLstDblClick(Sender: TObject);
begin
  if Assigned(FInParam.OnPushParam) then begin
    FInParam.rr[1] := stgTablesLst.Cells[sr[0],stgTablesLst.Row];
    FInParam.rr[2] := stgTablesLst.Cells[sr[1],stgTablesLst.Row];
    FInParam.OnPushParam(nil);
    Close;
  end;
end;


procedure TfrmTablesRef.tbKeyClick(Sender: TObject);
begin
  with piTablesRef do begin
    if PForm <> nil then begin
      (PForm as TfrmiTablesRef).Show;
      Exit;
    end;
    OnPushParam := ReloadData;
    PForm := TfrmiTablesRef.Create(Self);
    rr[1] := stgTablesLst.Cells[sr[0],stgTablesLst.Row];
    (PForm as TfrmiTablesRef).InitForm(@piTablesRef);
  end;
end;

end.
