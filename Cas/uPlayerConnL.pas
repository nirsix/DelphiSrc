unit uPlayerConnL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD;

type
  TfrmPlayerConnL = class(TForm)
    stgPlayerConnLst: TStringGrid;
    stgFilter: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    dtpBeg: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadDataFBase;
    procedure InitstgPlayerConnLst;
    procedure InitstgFilter;
    procedure stgFiltering;
    procedure InitForm(InParam: PTParamForm);
    procedure stgFilterSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure stgPlayerConnLstDblClick(Sender: TObject);
    procedure dtpBegChange(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  входящий параметр от формы хозяина
     Sr: TStgArray;
  public
    { Public declarations }
  end;

var
  frmPlayerConnL: TfrmPlayerConnL;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmPlayerConnL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmPlayerConnL.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  dtpBeg.Date := now - 31;
  dtpEnd.Date := now+1;
  InitstgPlayerConnLst; // 1
  InitstgFilter;    // 2  порядок следования важен, смотри код
  stgFiltering;
end;

procedure TfrmPlayerConnL.InitstgPlayerConnLst;
begin
  with stgPlayerConnLst do begin
    SetNameColSTG(stgPlayerConnLst,Sr,10);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmPlayerConnL.InitstgFilter;
Var
    i: integer;
begin
  with stgFilter do begin
    ColCount := stgPlayerConnLst.ColCount;
    RowCount := 1;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 0;
    for i := 0 to ColCount - 1  do ColWidths[i] := stgPlayerConnLst.ColWidths[i];
    Height := 22;
    Width := stgPlayerConnLst.Width;
  end;
end;

procedure TfrmPlayerConnL.stgFiltering;
  var
    i,j,k: integer;
    s1, s2: string;
begin
  InitstgPlayerConnLst;
  if stgFilter.Cells[stgFilter.Col,0] = '' then exit;
  j:=1;
  with stgPlayerConnLst do begin
    for i := 1 to RowCount - 1 do begin
      s1 := AnsiUpperCase(stgFilter.Cells[stgFilter.Col,0]);
      s2 := AnsiUpperCase(Cells[stgFilter.Col,i]);
      if pos(s1,s2) > 0 then begin
        for k := 0 to ColCount-1 do
           Cells[k,j] := Cells[k,i];
        inc(j);
      end;
    end;
    RowCount := j;
  end;
end;

procedure TfrmPlayerConnL.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmPlayerConnL.LoadDataFBase;
  var
    i: integer;
    IBSQLG1: TIBSQL;
    db, de: string;
begin
  db :=''''+ FormatDateTime('dd.mm.yyyy 00:00', dtpBeg.Date)+'''';
  de :=''''+ FormatDateTime('dd.mm.yyyy 00:00', dtpEnd.Date)+'''';
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgPlayerConnLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := 'select userdata.login, playerconnect.idsession, '+
          ' playerconnect.datetimeconnect, playerconnect.idroul, playerconnect.idtable,'+
          ' playerconnect.ipaddress, playerconnect.macaddress '+
          ' from playerconnect  inner join userdata on (playerconnect.idplayer = userdata.iduser)'+
          ' where ( (DATETIMECONNECT >= '+db+') and (DATETIMECONNECT <= '+de+'))'+
          ' order by IDSESSION';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('IDSESSION').AsString;
        Cells[Sr[1],i] := FieldByName('LOGIN').AsString;
        Cells[Sr[2],i] := FormatDateTime('dd.mm.yyyy hh:nn:ss', FieldByName('DATETIMECONNECT').AsDateTime);
        Cells[Sr[3],i] := FieldByName('IDROUL').AsString;
        Cells[Sr[4],i] := FieldByName('IDTABLE').AsString;
        Cells[Sr[5],i] := FieldByName('IPADDRESS').AsString;
        Cells[Sr[6],i] := FieldByName('MACADDRESS').AsString;                
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

procedure TfrmPlayerConnL.FormResize(Sender: TObject);
begin
  stgPlayerConnLst.Height := Self.Height - 20;
  stgPlayerConnLst.Width := Self.Width - 10;
  stgFilter.Width := stgPlayerConnLst.Width;
end;

procedure TfrmPlayerConnL.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmPlayerConnL := nil;
end;

procedure TfrmPlayerConnL.stgPlayerConnLstDblClick(Sender: TObject);
begin
  if Assigned(FInParam.OnPushParam) then begin
    FInParam.rr[1] := stgPlayerConnLst.Cells[sr[1],stgPlayerConnLst.Row];
    FInParam.rr[2] := stgPlayerConnLst.Cells[sr[5],stgPlayerConnLst.Row];
    FInParam.rr[3] := stgPlayerConnLst.Cells[sr[6],stgPlayerConnLst.Row];
    FInParam.OnPushParam(nil);
    Close;
  end;
end;

procedure TfrmPlayerConnL.dtpBegChange(Sender: TObject);
begin
  LoadDataFBase;
end;

end.
