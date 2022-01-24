unit uTotalUsersRoul;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uGLBProcBD, uMyUtils, Buttons;

type
  TfrmTotalUsersRoul = class(TForm)
    stgPlayersLst: TStringGrid;
    stgFilter: TStringGrid;
    sbRefresh: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadDataFBase;
    procedure InitstgPlayersLst;
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
    procedure sbRefreshClick(Sender: TObject);
  private
    { Private declarations }
     FInParam: PTParamForm; //  вход€щий параметр от формы хоз€ина
     Sr: TStgArray;
     procedure ReloadData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmTotalUsersRoul: TfrmTotalUsersRoul;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmTotalUsersRoul.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmTotalUsersRoul.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  InitstgPlayersLst; // 1
  InitstgFilter;    // 2  пор€док следовани€ важен, смотри код
  stgFiltering;
end;

procedure TfrmTotalUsersRoul.InitstgPlayersLst;
begin
  with stgPlayersLst do begin
    SetNameColSTG(stgPlayersLst,Sr,8);
    RowCount := 2;
    DefaultRowHeight := 18;
    FixedCols := 0;
    FixedRows := 1;
  end;
  LoadDataFBase;
end;

procedure TfrmTotalUsersRoul.InitstgFilter;
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

procedure TfrmTotalUsersRoul.stgFiltering;
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

procedure TfrmTotalUsersRoul.stgFilterSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 stgFiltering;
end;

procedure TfrmTotalUsersRoul.LoadDataFBase;
  var
    i, sum, iduser: integer;
    IBSQLG1: TIBSQL;
    bs: string;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgPlayersLst do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := 'select userdata.login, sum( staksplayers.valuestak ) sum_of_valuestak, '+
           ' sum( staksplayers.player_win_lose ) sum_of_player_win_lose'+
           ' from staksplayers inner join userdata on (staksplayers.idplayer = userdata.iduser) '+
           ' where (staksplayers.fun <> 1) group by userdata.login';
      ExecQuery;
      i := 1;
      while not Eof do begin
        inc(i);
        Cells[Sr[0],i] := IntToStr(i);
        Cells[Sr[1],i] := FieldByName('LOGIN').AsString;
        Cells[Sr[2],i] := FieldByName('SUM_OF_VALUESTAK').AsString;
        Cells[Sr[3],i] := FieldByName('SUM_OF_PLAYER_WIN_LOSE').AsString;
        next;
      end;
      Close;
      RowCount := i + 1;
      for i:=0 to ColCount-1 do Cells[i,1] := '';
      Cells[Sr[1],1] := '»того:';
      sum := 0;
      for i:=2 to RowCount - 1 do if TestOnInt(Cells[Sr[2],i]) then sum := sum + StrToInt(Cells[Sr[2],i]);
      Cells[Sr[2],1] := IntToStr(sum);
      sum := 0;
      for i:=2 to RowCount - 1 do if TestOnInt(Cells[Sr[3],i]) then sum := sum + StrToInt(Cells[Sr[3],i]);
      Cells[Sr[3],1] := IntToStr(sum);      
      if RowCount > 1 then FixedRows := 1;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmTotalUsersRoul.ReloadData(Sender: TObject);
begin
  LoadDataFBase;
end;

procedure TfrmTotalUsersRoul.FormResize(Sender: TObject);
begin
  stgPlayersLst.Height := Self.Height - 105;
  stgPlayersLst.Width := Self.Width - 10;
  stgFilter.Width := stgPlayersLst.Width;
end;

procedure TfrmTotalUsersRoul.FormDestroy(Sender: TObject);
begin
  FInParam.PForm := nil;
  frmTotalUsersRoul := nil;
end;

procedure TfrmTotalUsersRoul.stgPlayersLstDblClick(Sender: TObject);
begin
  Exit;/////!!!!!!!!!!!!!!!!!!!
  if Assigned(FInParam.OnPushParam) then begin
    FInParam.rr[1] := stgPlayersLst.Cells[sr[0],stgPlayersLst.Row];
    FInParam.rr[2] := stgPlayersLst.Cells[sr[2],stgPlayersLst.Row];
    FInParam.OnPushParam(nil);
    Close;
  end;
end;


procedure TfrmTotalUsersRoul.stgPlayersLstDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
 var
   Rct: TRect;
   OldColor: integer;  
begin
{ if (stgPlayersLst.Cells[Sr[7],ARow] = 'OFF')and(ARow > 0)then begin
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
 end;}
end;

procedure TfrmTotalUsersRoul.sbRefreshClick(Sender: TObject);
begin
 LoadDataFBase;
end;

end.
