unit uPass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uCripPrk;

type
  TfrmPass = class(TForm)
    stgPassLst: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadDataFBase;
    procedure InitstgPassLst;
    procedure InitForm(InParam: PTParamForm);
    procedure FormDestroy(Sender: TObject);
    procedure stgPassLstDblClick(Sender: TObject);
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
  frmPass: TfrmPass;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmPass.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmPass.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgPassLst; // 1
end;

procedure TfrmPass.InitstgPassLst;
begin
  with stgPassLst do begin
    SetNameColSTG(stgPassLst,Sr,2);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmPass.LoadDataFBase;
  var
    i, k: integer;
    IBSQLG1: TIBSQL;
    s: string;
    pc: pchar;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgPassLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from SAAP order by ID';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('ID').AsString;
        Cells[Sr[1],i] := FieldByName('NAMEP').AsString;
        Cells[Sr[2],i] := DeCodeStrS(FieldByName('VALUEP').AsString);
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

procedure TfrmPass.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmPass.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmPass := nil;
end;

procedure TfrmPass.stgPassLstDblClick(Sender: TObject);
  Var
    ClickedOK: boolean;
    sval, ssql, idd1, idd2: string;
    srw: integer;
begin
  if (stgPassLst.Row > 0)and(stgPassLst.Col = Sr[2]) then begin
   srw := stgPassLst.Row;
   sval := stgPassLst.Cells[Sr[2],stgPassLst.Row];
   ClickedOK := InputQuery('”становить значение дл€', stgPassLst.Cells[Sr[1],stgPassLst.Row],sval);
   if ClickedOK then begin
       sval := CodeStrS(sval);
       ssql := 'Update SAAP Set VALUEP = '''+sval+''' Where (ID = '+
                stgPassLst.Cells[Sr[0],stgPassLst.Row]+')';
       if ExecSqlIB(ssql) then begin
         LoadDataFBase;
         stgPassLst.Row := srw;
       end;
   end;//if ClickedOK then begin
  end; 
end;

procedure TfrmPass.btCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPass.FormResize(Sender: TObject);
begin
  stgPassLst.Height := Self.Height - 40;
  stgPassLst.Width := Self.Width - 10;
end;

end.
