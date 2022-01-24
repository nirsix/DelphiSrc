unit uUsersStatRoul;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uMyUtils, Menus, Buttons, uPlayersRef;

type
  TfrmUsersStatRoul = class(TForm)
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
    edPlayerName: TEdit;
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
     FInParam: PTParamForm; //  вход€щий параметр от формы хоз€ина
     pPlayerRef: TParamForm; // параметр дл€ передачи в форму "нового клиента"
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

procedure TfrmUsersStatRoul.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmUsersStatRoul.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
end;

procedure TfrmUsersStatRoul.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgRoulStatLst; // 1
  InitstgFilter;    // 2  пор€док следовани€ важен, смотри код
  stgFiltering;
  dtpBeg.Date := now - 31;
  dtpEnd.Date := now+1;
end;

procedure TfrmUsersStatRoul.InitstgRoulStatLst;
begin
  with stgRoulStatLst do begin
    SetNameColSTG(stgRoulStatLst,Sr,7);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
//  LoadDataFBase;
end;

procedure TfrmUsersStatRoul.InitstgFilter;
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

procedure TfrmUsersStatRoul.stgFiltering;
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

procedure TfrmUsersStatRoul.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmUsersStatRoul.LoadDataFBase;
  var
    i, sum: integer;
    IBSQLG1: TIBSQL;
    db, de, cur: string;
begin
  if pPlayerRef.rr[1]='' then begin
    ShowMessage('Ќе выбран игрок!');
    Exit;
  end;
  edPlayerName.Text := pPlayerRef.rr[2];
  db :=''''+ FormatDateTime('dd.mm.yyyy 00:00', dtpBeg.Date)+'''';
  de :=''''+ FormatDateTime('dd.mm.yyyy 00:00', dtpEnd.Date)+'''';
  ReConnectIBDataBase;
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgRoulStatLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from STAKSPLAYERS '+
                  ' where ( (DT_STAK >= '+db+') and (DT_STAK <= '+de+')'+
                  ' and(IDPLAYER='+pPlayerRef.rr[1]+') ) order by IDSTAKPLAYER';

{    IDSTAKPLAYER     INTEGER NOT NULL,
    IDPLAYER         INTEGER,
    DT_STAK          TIMESTAMP,
    VALUESTAK        INTEGER,
    PLAYER_WIN_LOSE  INTEGER,
    IDSESSION        INTEGER,
    FUN              BOOLEAN DEFAULT 0 /* BOOLEAN = CHAR(1) */}

      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := FieldByName('IDSTAKPLAYER').AsString;
        Cells[Sr[1],i] := FormatDateTime('dd.mm.yyyy hh:nn:ss', FieldByName('DT_STAK').AsDateTime);
        if FieldByName('DT_STAK').AsDateTime < StrToDate('01.01.2000') then Cells[Sr[1],i] := '';
        Cells[Sr[2],i] := FieldByName('IDSESSION').AsString;
        if FieldByName('FUN').AsString = '1' then cur := ' FUN' else cur := ' $';
        if TestOnInt(FieldByName('VALUESTAK').AsString) then Cells[Sr[3],i] := FieldByName('VALUESTAK').AsString else Cells[Sr[3],i] := '—бой!';
        if TestOnInt(FieldByName('PLAYER_WIN_LOSE').AsString) then Cells[Sr[4],i] := FieldByName('PLAYER_WIN_LOSE').AsString else Cells[Sr[4],i] := '—бой!';
        Cells[Sr[5],i] := cur;
        next;
      end;
      Close;
      RowCount := i + 2;
      for i:=0 to ColCount-1 do Cells[i,RowCount-1] := '';
      Cells[Sr[2],RowCount-1] := '»того:';
      sum := 0;
      for i:=1 to RowCount - 2 do if TestOnInt(Cells[Sr[3],i])and(Cells[Sr[5],i]='$') then sum := sum + StrToInt(Cells[Sr[3],i]);
      Cells[Sr[3],RowCount-1] := IntToStr(sum);
      sum := 0;
      for i:=1 to RowCount - 2 do if TestOnInt(Cells[Sr[4],i])and(Cells[Sr[5],i]='$') then sum := sum + StrToInt(Cells[Sr[4],i]);
      Cells[Sr[4],RowCount-1] := IntToStr(sum);
      if RowCount > 1 then FixedRows := 1;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmUsersStatRoul.sbTableClick(Sender: TObject);
begin
  with pPlayerRef do begin
    if PForm <> nil then begin
      (PForm as TfrmPlayersRef).Show;
      Exit;
    end;
    OnPushParam := ReloadData;
    PForm := TfrmPlayersRef.Create(Self);
    (PForm as TfrmPlayersRef).InitForm(@pPlayerRef);
  end;
end;

procedure TfrmUsersStatRoul.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmUsersStatRoul.dtpBegChange(Sender: TObject);
begin
  if pPlayerRef.rr[1]<>'' then LoadDataFBase;
end;

procedure TfrmUsersStatRoul.FormResize(Sender: TObject);
begin
  stgRoulStatLst.Height := Self.Height - 120;
  stgRoulStatLst.Width := Self.Width - 35;
  stgFilter.Width := stgRoulStatLst.Width;
end;

procedure TfrmUsersStatRoul.stgRoulStatLstDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
 var
   Rct: TRect;
   OldColor: integer;
begin
//
end;

procedure TfrmUsersStatRoul.sbRefreshClick(Sender: TObject);
begin
  LoadDataFBase;
end;

end.
