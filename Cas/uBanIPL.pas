unit uBanIPL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uBanIPNd, uNirSec;

type
  TfrmBanIPL = class(TForm)
    stgBanIPLst: TStringGrid;
    stgFilter: TStringGrid;
    ToolBar1: TToolBar;
    tbNew: TToolButton;
    tbEdit: TToolButton;
    tbDel: TToolButton;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbNewClick(Sender: TObject);
    procedure LoadDataFBase;
    procedure InitstgBanIPLst;
    procedure tbEditClick(Sender: TObject);
    procedure InitstgFilter;
    procedure stgFiltering;
    procedure InitForm(InParam: PTParamForm);
    procedure stgFilterSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure stgBanIPLstDblClick(Sender: TObject);
    procedure stgBanIPLstDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure tbDelClick(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  вход€щий параметр от формы хоз€ина
     pBanIPNd: TParamForm;
     Sr: TStgArray;
     procedure ReloadData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmBanIPL: TfrmBanIPL;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmBanIPL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmBanIPL.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgBanIPLst; // 1
  InitstgFilter;    // 2  пор€док следовани€ важен, смотри код
  stgFiltering;
end;

procedure TfrmBanIPL.InitstgBanIPLst;
begin
  with stgBanIPLst do begin
    SetNameColSTG(stgBanIPLst,Sr,9);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmBanIPL.InitstgFilter;
Var
    i: integer;
begin
  with stgFilter do begin
    ColCount := stgBanIPLst.ColCount;
    RowCount := 1;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 0;
    for i := 0 to ColCount - 1  do ColWidths[i] := stgBanIPLst.ColWidths[i];
    Height := 22;
    Width := stgBanIPLst.Width;
  end;
end;

procedure TfrmBanIPL.stgFiltering;
  var
    i,j,k: integer;
    s1, s2: string;
begin
  InitstgBanIPLst;
  if stgFilter.Cells[stgFilter.Col,0] = '' then exit;
  j:=1;
  with stgBanIPLst do begin
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

procedure TfrmBanIPL.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmBanIPL.LoadDataFBase;
  var
    i, sum, iduser: integer;
    IBSQLG1: TIBSQL;
    bs: string;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgBanIPLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from IP_BAN order by IDIP';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('IDIP').AsString;
        Cells[Sr[1],i] := FieldByName('LOGIN').AsString;
        Cells[Sr[2],i] := FieldByName('IPADDRESS').AsString;
        Cells[Sr[3],i] := FieldByName('MAC').AsString;
        Cells[Sr[4],i] := FieldByName('NOTE').AsString;        
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

procedure TfrmBanIPL.tbNewClick(Sender: TObject);
begin
 with pBanIPNd do begin
   if PForm <> nil then begin
      (PForm as TfrmBanIpNd).Show;
      Exit;
   end;
   OnPushParam := ReloadData;
   PForm := TfrmBanIpNd.Create(Self);
   rr[1] := stgBanIPLst.Cells[sr[0],stgBanIPLst.Row];
   (PForm as TfrmBanIpNd).InitForNew(@pBanIPNd);
 end;
end;

procedure TfrmBanIPL.tbEditClick(Sender: TObject);
begin
  with pBanIPNd do begin
    if PForm <> nil then begin
      (PForm as TfrmBanIpNd).Show;
      Exit;
    end;
    OnPushParam := ReloadData;
    PForm := TfrmBanIpNd.Create(Self);
    rr[1] := stgBanIPLst.Cells[sr[0],stgBanIPLst.Row];
    (PForm as TfrmBanIpNd).InitForEdit(@pBanIPNd);
  end;
end;

procedure TfrmBanIPL.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmBanIPL.FormResize(Sender: TObject);
begin
  stgBanIPLst.Height := Self.Height - 105;
  stgBanIPLst.Width := Self.Width - 10;
  stgFilter.Width := stgBanIPLst.Width;
end;

procedure TfrmBanIPL.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmBanIPL := nil;
end;

procedure TfrmBanIPL.stgBanIPLstDblClick(Sender: TObject);
begin
  if Assigned(FInParam.OnPushParam) then begin
    FInParam.rr[1] := stgBanIPLst.Cells[sr[0],stgBanIPLst.Row];
    FInParam.rr[2] := stgBanIPLst.Cells[sr[2],stgBanIPLst.Row];
    FInParam.OnPushParam(nil);
    Close;
  end;
end;


procedure TfrmBanIPL.stgBanIPLstDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
 var
   Rct: TRect;
   OldColor: integer;  
begin
 if (stgBanIPLst.Cells[Sr[7],ARow] = 'OFF')and(ARow > 0)then begin
// if (ACol = Sr[7])and(ARow > 0) then begin
   with stgBanIPLst, stgBanIPLst.Canvas do begin
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

procedure TfrmBanIPL.tbDelClick(Sender: TObject);
 var
  ClickedOK: boolean;
  ips, macs: string;
begin
  ips := stgBanIPLst.Cells[Sr[2], stgBanIPLst.Row];
  macs := stgBanIPLst.Cells[Sr[3], stgBanIPLst.Row];
  if MessageDlg('”далить пару IP ='+ips+',Mac = '+macs+' ?', mtWarning, [mbYes, mbNo], 0) = mrYes then begin
    ExecSqlIB('Delete from IP_BAN where IDIP='+stgBanIPLst.Cells[Sr[0], stgBanIPLst.Row]);
    LoadDataFBase;
  end;
end;

end.
