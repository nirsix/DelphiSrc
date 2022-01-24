unit uRoulStatRef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uMyUtils, Menus, Buttons, uTablesRef;

type
  TfrmRoulStatRef = class(TForm)
    stgRoulStatLst: TStringGrid;
    stgFilter: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    dtpBeg: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    PopupMenu1: TPopupMenu;
    miChangeColor: TMenuItem;
    miDelRedColor: TMenuItem;
    miCancelNumColor: TMenuItem;
    Label5: TLabel;
    sbTable: TSpeedButton;
    edTableName: TEdit;
    sbRefresh: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadDataFBase;
    procedure InitstgRoulStatLst;
    procedure InitstgFilter;
    procedure stgFiltering;
    procedure InitForm(InParam: PTParamForm);
    procedure stgFilterSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure dtpBegChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure stgRoulStatLstDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sbTableClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbRefreshClick(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  входящий параметр от формы хозяина
     pTablesRef: TParamForm; // параметр для передачи в форму "нового клиента"
     Sr: TStgArray;
     FSortUp: boolean;
     FFixedCol: integer;
     procedure ReloadData(Sender: TObject);
  public
    { Public declarations }
  end;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmRoulStatRef.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRoulStatRef.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
end;

procedure TfrmRoulStatRef.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgRoulStatLst; // 1
  InitstgFilter;    // 2  порядок следования важен, смотри код
  stgFiltering;
  dtpBeg.Date := now - 31;
  dtpEnd.Date := now+1;
end;

procedure TfrmRoulStatRef.InitstgRoulStatLst;
begin
  with stgRoulStatLst do begin
    SetNameColSTG(stgRoulStatLst,Sr,3);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
//  LoadDataFBase;
end;

procedure TfrmRoulStatRef.InitstgFilter;
Var
    i: integer;
begin
  with stgFilter do begin
    ColCount := stgRoulStatLst.ColCount;
    RowCount := 1;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 0;
    for i := 0 to ColCount - 1  do ColWidths[i] := stgRoulStatLst.ColWidths[i];
    Height := 22;
    Width := stgRoulStatLst.Width;
  end;
end;

procedure TfrmRoulStatRef.stgFiltering;
  var
    i,j,k: integer;
    s1, s2: string;
begin
  InitstgRoulStatLst;
  if stgFilter.Cells[stgFilter.Col,0] = '' then exit;
  j:=1;
  with stgRoulStatLst do begin
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

procedure TfrmRoulStatRef.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;                                    

procedure TfrmRoulStatRef.LoadDataFBase;
  var
    i: integer;
    IBSQLG1: TIBSQL;
    db, de: string;
begin
  if pTablesRef.rr[1]='' then begin
    ShowMessage('Не выбран стол!');
    Exit;
  end;
  edTableName.Text := pTablesRef.rr[2];
  db :=''''+ FormatDateTime('dd.mm.yyyy 00:00', dtpBeg.Date)+'''';
  de :=''''+ FormatDateTime('dd.mm.yyyy 00:00', dtpEnd.Date)+'''';
  ReConnectIBDataBase;
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgRoulStatLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from SESSIONS '+
                  ' where ( (BEGSTAK >= '+db+') and (BEGSTAK <= '+de+')'+
                  ' and(IDROUL='+pTablesRef.rr[1]+') ) order by IDSESSION';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('IDSESSION').AsString;
        Cells[Sr[1],i] := FormatDateTime('dd.mm.yyyy hh:nn:ss', FieldByName('BEGSTAK').AsDateTime);
        Cells[Sr[2],i] := FormatDateTime('dd.mm.yyyy hh:nn:ss', FieldByName('STARTROUL').AsDateTime);
        if FieldByName('STARTROUL').AsDateTime < StrToDate('01.01.2000') then Cells[Sr[2],i] := '';
        Cells[Sr[3],i] := FormatDateTime('dd.mm.yyyy hh:nn:ss', FieldByName('FINISHROUL').AsDateTime);
        if FieldByName('FINISHROUL').AsDateTime < StrToDate('01.01.2000') then Cells[Sr[3],i] := '';
        Cells[Sr[4],i] := FieldByName('VALUEROUL').AsString;
        if FieldByName('VALUEROUL').AsInteger >= 255 then Cells[Sr[4],i] := '';
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

procedure TfrmRoulStatRef.sbTableClick(Sender: TObject);
begin
  with pTablesRef do begin
    if PForm <> nil then begin
      (PForm as TfrmTablesRef).Show;
      Exit;
    end;
    OnPushParam := ReloadData;
    PForm := TfrmTablesRef.Create(Self);
    (PForm as TfrmTablesRef).InitForm(@pTablesRef);
  end;
end;

procedure TfrmRoulStatRef.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmRoulStatRef.dtpBegChange(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmRoulStatRef.FormResize(Sender: TObject);
begin
  stgRoulStatLst.Height := Self.Height - 120;
  stgRoulStatLst.Width := Self.Width - 35;
  stgFilter.Width := stgRoulStatLst.Width;
end;

procedure TfrmRoulStatRef.stgRoulStatLstDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
 var
   Rct: TRect;
   OldColor: integer;
begin
//
end;

procedure TfrmRoulStatRef.sbRefreshClick(Sender: TObject);
begin
  LoadDataFBase;
end;

end.
