unit uStgConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, uMyUtils, uGLBProcBD, Menus, IBCustomDataSet, IBTable;

type
  TfrmStgConfig = class(TForm)
    stgObj: TStringGrid;
    stgName: TStringGrid;
    btSave: TButton;
    stgSettings: TStringGrid;
    Label3: TLabel;
    edStgName: TEdit;
    PopupMenu1: TPopupMenu;
    miadd: TMenuItem;
    miDel: TMenuItem;
    btNewStgName: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure InitstgName;
    procedure InitstgObj;
    procedure LoadFBase(id: integer);
    procedure InitForm;
    procedure FormDestroy(Sender: TObject);
    procedure stgObjMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure stgNameDblClick(Sender: TObject);
    procedure miaddClick(Sender: TObject);
    procedure miDelClick(Sender: TObject);
    procedure stgSettingsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stgSettingsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btSaveClick(Sender: TObject);
    procedure stgSettingsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btNewStgNameClick(Sender: TObject);
  private
    { Private declarations }
     function TestOnRight: boolean;
  public
    { Public declarations }
  end;

var
  frmStgConfig: TfrmStgConfig;

implementation

uses uMain, uDM;

{$R *.dfm}

procedure TfrmStgConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmStgConfig.InitForm;
begin
  InitstgName;
  LoadFBase(1);
end;

procedure TfrmStgConfig.InitstgName;
  var
    i: integer;
    IBSQLG1: TIBSQL;
begin
  stgName.Cells[0,0] := '№';
  stgName.Cells[1,0] := 'Name';
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgName do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from STG_NAME order by idstg';
      ExecQuery;
      i := 0;
      while not Eof do begin
        inc(i);
        Cells[0,i] := FieldByName('IDSTG').AsString;
        Cells[1,i] := FieldByName('NAMESTG').AsString;
        next;
      end;
      Close;
      RowCount := i+1;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmStgConfig.LoadFBase(id: integer);
  var
    i,j: integer;
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1, stgSettings do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from STG_PARAM Where idstg ='+IntToStr(id);
      ExecQuery;
      ColCount := 200;
      for i := 0 to 3 do Rows[i].Clear;
      i := 0;
      while not Eof do begin
        inc(i);
        j := FieldByName('IDC_VIEW').AsInteger;
        Cells[j,0] := FieldByName('IDC_VAL').AsString;
        Cells[j,1] := FieldByName('NAMECOL').AsString;
        Cells[j,2] := FieldByName('SIZECOL').AsString;
        next;
      end;
      Close;
      ColCount := i;
      if Cells[0,0] = '' then begin
         Cells[0,0] := '0';
         Cells[0,1] := 'Введите имя';
         Cells[0,2] := '30';
      end;
    end;
  finally
    IBSQLG1.Free;
  end;
  InitstgObj;
  edStgName.Text := stgName.cells[1,id];
end;

function TfrmStgConfig.TestOnRight: boolean;
var
  i: integer;
begin
  Result := true;
  for i := 0 to stgSettings.ColCount - 1 do
    if Not TestOnInt(stgSettings.Cells[i,2]) then begin
      Result := false;
      Exit;
    end;
end;

procedure TfrmStgConfig.InitstgObj;
  var
    i: integer;
begin
  if Not TestOnRight then Exit;
  stgObj.ColCount := stgSettings.ColCount;
  for i := 0 to stgSettings.ColCount - 1 do begin
     stgObj.ColWidths[i] := StrToInt(stgSettings.Cells[i,2]);
     stgObj.Cells[i,0]:=stgSettings.Cells[i,1];
  end;
end;

procedure TfrmStgConfig.FormDestroy(Sender: TObject);
begin
  frmStgConfig := nil;
end;

procedure TfrmStgConfig.stgObjMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 var
   i,b: integer;
begin
  for i := 0 to stgObj.ColCount - 1 do begin
     b := stgObj.ColWidths[i];
     stgSettings.Cells[i,2] := IntToStr(b);
  end;
end;

procedure TfrmStgConfig.stgNameDblClick(Sender: TObject);
var
  i: integer;
begin
  i := stgName.Row;
  if i >= 0 then LoadFBase(StrToInt(stgName.cells[0,i]));
end;

procedure TfrmStgConfig.miaddClick(Sender: TObject);
var
  i, max: integer;
begin
  max := 0;
  for i := 0 to stgSettings.ColCount - 1 do
    if StrToInt(stgSettings.Cells[i,0]) > max then max := StrToInt(stgSettings.Cells[i,0]);
  inc(max);
  i := stgSettings.ColCount;
  stgSettings.ColCount := i + 1;
  stgSettings.Cells[i,0] := IntToStr(max);
  stgSettings.Cells[i,2] := '30';
  InitstgObj;
end;

procedure TfrmStgConfig.miDelClick(Sender: TObject);
  var
   i, j: integer;
begin
   j := stgSettings.Col;
   if (j < 0) or (j >= stgSettings.ColCount)then Exit;
   for i := j to stgSettings.ColCount - 2 do begin
     stgSettings.Cells[i,0] := stgSettings.Cells[i+1,0];
     stgSettings.Cells[i,1] := stgSettings.Cells[i+1,1];
     stgSettings.Cells[i,2] := stgSettings.Cells[i+1,2];
   end;
   stgSettings.ColCount := stgSettings.ColCount - 1;
   InitstgObj;
end;

procedure TfrmStgConfig.stgSettingsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  miDel.Caption := 'Удалить колонку №'+stgSettings.Cells[stgSettings.Col,0];
end;

procedure TfrmStgConfig.stgSettingsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  InitstgObj;
end;

procedure TfrmStgConfig.btSaveClick(Sender: TObject);
  var
   IBTable1: TIBTable;
   i,j: integer;
begin
  i := stgName.Row;
  if i < 0 then Exit;
  ExecSqlIB('update stg_name set namestg='''+edStgName.Text+''' where idstg='+stgName.cells[0,i]);
  ExecSqlIB('delete from stg_param where idstg='+stgName.cells[0,i]);
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'STG_PARAM';
      Open;
      for j := 0 to stgSettings.ColCount - 1 do begin
        Insert;
        FieldByName('IDSTG').AsString := stgName.Cells[0,i];
        FieldByName('IDC_VIEW').AsString := IntToStr(j);
        FieldByName('IDC_VAL').AsString := stgSettings.Cells[j,0];
        FieldByName('SIZECOL').AsString := stgSettings.Cells[j,2];
        FieldByName('NAMECOL').AsString := stgSettings.Cells[j,1];
        Post;
      end;
      frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
  ShowMessage('Сохранили!');
end;

procedure TfrmStgConfig.stgSettingsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  InitstgObj;
end;

procedure TfrmStgConfig.btNewStgNameClick(Sender: TObject);
  var
   IBTable1: TIBTable;
   idstg: string;
begin
  if edStgName.Text = '' then Exit;
  idstg:= GetGenValue('GEN_STG_NAME_ID');
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'STG_NAME';
      Open; Insert;
      FieldByName('IDSTG').AsString := idstg;
      FieldByName('NameSTG').AsString := edStgName.Text;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
  InitstgName;
  LoadFBase(StrToInt(stgName.cells[0,stgName.rowcount-1]));
end;

end.
