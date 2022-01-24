unit uParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD;

type
  TfrmParams = class(TForm)
    stgParamsLst: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadDataFBase;
    procedure InitstgParamsLst;
    procedure InitForm(InParam: PTParamForm);
    procedure FormDestroy(Sender: TObject);
    procedure stgParamsLstDblClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  вход€щий параметр от формы хоз€ина
     Sr: TStgArray;
     procedure ReloadData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmParams: TfrmParams;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmParams.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmParams.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgParamsLst; // 1
end;

procedure TfrmParams.InitstgParamsLst;
begin
  with stgParamsLst do begin
    SetNameColSTG(stgParamsLst,Sr,2);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmParams.LoadDataFBase;
  var
    i: integer;
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgParamsLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from PARAMETERS order by ID';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('ID').AsString;
        Cells[Sr[1],i] := FieldByName('NAMEP').AsString;
        Cells[Sr[2],i] := FieldByName('VALUEP').AsString;
        Cells[Sr[3],i] := FieldByName('Note').AsString;        
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

procedure TfrmParams.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmParams.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmParams := nil;
end;

procedure TfrmParams.stgParamsLstDblClick(Sender: TObject);
  Var
    ClickedOK: boolean;
    sval, ssql, idd1, idd2: string;
    srw: integer;
begin
  if (stgParamsLst.Row > 0)and(stgParamsLst.Col = Sr[2]) then begin
   srw := stgParamsLst.Row;
   sval := stgParamsLst.Cells[Sr[2],stgParamsLst.Row];
   ClickedOK := InputQuery('”становить значение дл€', stgParamsLst.Cells[Sr[1],stgParamsLst.Row],sval);
   if ClickedOK then begin
       ssql := 'Update PARAMETERS Set VALUEP = '''+sval+''' Where (ID = '+
                stgParamsLst.Cells[Sr[0],stgParamsLst.Row]+')';
       if ExecSqlIB(ssql) then begin
         LoadDataFBase;
         stgParamsLst.Row := srw;
       end;
   end;//if ClickedOK then begin
  end; 
end;

procedure TfrmParams.btCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmParams.FormResize(Sender: TObject);
begin
  stgParamsLst.Height := Self.Height - 40;
  stgParamsLst.Width := Self.Width - 10;
end;

end.
