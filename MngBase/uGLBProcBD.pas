unit uGLBProcBD;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  Dialogs,  ExtCtrls, StdCtrls, uClasses, IBSQL, uDM, Grids, uMyUtils,
  RegExpr, IBTable, DB, DBGrids, Provider, DBClient;

CONST
  MAXSTGA = 10000;

function GetGenValue(NGEN: String): string;
function ExecSqlIB(tsql: string): boolean;
function GetSqlIB(tsql: string): string;
function GetParamValue(idv: String): string;
procedure SetGSetting(id:integer; val: string);
procedure SetNameColSTG(stg1: TStringGrid; var arr: Tstgarray; id:integer);
procedure SortStringGrid(StrGr: TStringGrid; nums: integer; par: boolean; bypar: boolean);
function SortByNumber(List: TStringList; Index1, Index2: Integer): Integer;
procedure CopyStringGrid(Var Src, Dest: TStringGrid);
function GetIdRegionByIdSubRegion(id: integer): integer;
procedure SetNameColDBG(dbg1: TDBGrid; var arr: Tstgarray; id:integer);
procedure ImportDbGridInExcelCSV(ADBGrid:TDBGrid; ADataSet: TDataSet; filename: string);
procedure SetParamStr(var Src: string; ParamName, Value: string);
function GetTextSQLByID(id: integer): string;
function LoadTableDataFromCDSFile(aFileName, aTableName: string): boolean;

implementation


procedure SetParamStr(var Src: string; ParamName, Value: string);
var
 i, j: integer;
begin
  i := pos(ParamName,Src);
  if i > 0 then begin
    Insert(Value,Src,i);
    i := pos(ParamName,Src);
    j := Length(ParamName);
    Delete(Src,i,j);
  end
  else begin
    Src := 'Error - not found: '+ParamName;
  end;
end;

function GetGenValue(NGEN: String): string;
 var
   IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'SELECT GEN_ID('+NGEN+', 1) FROM RDB$DATABASE';
      ExecQuery;
      Result := Fields[0].AsString;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;


function ExecSqlIB(tsql: string): boolean;
 var
   IBSQLG1: TIBSQL;
begin
  Result := False;
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := tsql;
      ExecQuery;
      frmDM.IBTransactionG.CommitRetaining;
      Close;
      Result := True;
    end;
  finally
    IBSQLG1.Free;
    if not Result then ShowMessage('Ошибка в ExecSqlIB(tsql: string): boolean!');
  end;
end;

function GetSqlIB(tsql: string): string;
 var
   IBSQLG1: TIBSQL;
begin
  Result := '';
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := tsql;
      ExecQuery;
      Result := Fields[0].AsString;
      Close;
    end;
  finally
    IBSQLG1.Free;
//    if Result = '' then ShowMessage('Ошибка в function GetSqlIB(tsql: string): string;');
  end;
end;


function GetParamValue(idv: String): string;
 var
   IBSQLG1: TIBSQL;
begin
  Result := '';
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'SELECT ValueP FROM PARAMETERS WHERE ID ='+idv;
      ExecQuery;
      Result := Fields[0].AsString;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;


function GetIdRegionByIdSubRegion(id: integer): integer;
 var
   IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'select subregion.REGION_ID from subregion where subregion.idsubregion = '+IntToStr(id);
      ExecQuery;
      Result := StrToInt(Fields[0].AsString);
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;


procedure SetGSetting(id:integer; val: string);
begin
  ExecSqlIB('Update settingsoft.val Set settingsoft.val = '+val+' Where settingsoft.id = '+IntToStr(id));
end;

procedure SetNameColSTG(stg1: TStringGrid; var arr: Tstgarray; id:integer);
 var
   IBSQLG1: TIBSQL;
   i: integer;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'SELECT * FROM STG_PARAM Where IDSTG='+IntToStr(id);
      ExecQuery;
      stg1.ColCount := 40;
      i := 0;
      while not eof do begin
        stg1.Cells[FieldByName('IDC_VIEW').AsInteger,0] := FieldByName('NAMECOL').AsString;
        stg1.ColWidths[FieldByName('IDC_VIEW').AsInteger] := FieldByName('SizeCol').AsInteger;
        arr[FieldByName('IDC_Val').AsInteger] := FieldByName('IDC_VIEW').AsInteger;
        Inc(i);
        next;
      end;
      stg1.ColCount := i;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure SetNameColDBG(dbg1: TDBGrid; var arr: Tstgarray; id:integer);
 var
   IBSQLG1: TIBSQL;
   i, h, k: integer;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      // вычисляем кол-во столбцов и добавляем их -->
      SQL.Text := 'select count(idstg) as count1 from stg_param where IDSTG='+IntToStr(id);
      ExecQuery;
      k := FieldByName('COUNT1').AsInteger;
      Close;
      for i := 1 to k  do dbg1.Columns.Add;
      // дальше, формируем столбцы -->
      SQL.Text := 'SELECT * FROM STG_PARAM Where IDSTG='+IntToStr(id);
      ExecQuery;
      while not eof do begin
        h := FieldByName('IDC_VIEW').AsInteger;
        dbg1.Columns.Items[h].Title.Caption := FieldByName('NAMECOL').AsString;
        dbg1.Columns.Items[h].FieldName := FieldByName('NAMEFIELD').AsString;
        dbg1.Columns.Items[h].Width := FieldByName('SizeCol').AsInteger;
        arr[FieldByName('IDC_Val').AsInteger] := FieldByName('IDC_VIEW').AsInteger;
        next;
      end;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;


function SortByNumber(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if (Not TestOnReal(List.Strings[Index1])) or (Not TestOnReal(List.Strings[Index2]))
    then begin
       Result := 0;
       Exit;
    end;
  If StrToFloat(List.Strings[Index1]) > StrToFloat(List.Strings[Index2]) then Result := 1;
  If StrToFloat(List.Strings[Index1]) < StrToFloat(List.Strings[Index2]) then Result := -1;
  If StrToFloat(List.Strings[Index1]) = StrToFloat(List.Strings[Index2]) then Result := 0;
end;

procedure SortStringGrid(StrGr: TStringGrid; nums: integer; par: boolean; bypar: boolean);
  var
    SSort, SSav :TStringList;
    i,j,l,ic: integer;
    ns:  TId2Class;
begin
  SSort := TStringList.Create;
  SSav := TStringList.Create;
//  if bypar then SSort.CustomSort(SortByNumber);
  for i := 1 to StrGr.RowCount - 1 do
    SSort.AddObject(StrGr.Cells[nums, i],TId2Class.Create(i-1,''));
  if bypar then SSort.CustomSort(SortByNumber) else SSort.Sort;
  for i := 0 to StrGr.ColCount - 1 do begin
    SSav.Assign(StrGr.Cols[i]);
    SSav.Delete(0);
    if par then begin
      ic := 1;
      l := 1;
    end
    else begin
      ic := -1;
      l := StrGr.RowCount - 1;
    end;
    for j := 0 to StrGr.RowCount - 2 do begin
      ns := SSort.Objects[j] as TId2Class;
      StrGr.Cells[i,l] := SSav.Strings[ns.idn];
      l := l + ic;
    end;
    SSav.Clear;
  end;
  for i := 0 to SSort.Count - 1 do SSort.Objects[i].Destroy;
  SSort.Free;
  SSav.Free;
end;

procedure CopyStringGrid(Var Src, Dest: TStringGrid);
var
 i,j: integer;
begin
  Dest.RowCount :=  Src.RowCount;
  Dest.ColCount :=  Src.ColCount;
  for i := 0 to Src.RowCount - 1 do
    for j := 0 to Src.ColCount - 1 do dest.Cells[j,i] := src.Cells[j,i];
  Dest.FixedCols := Src.FixedCols;
  Dest.FixedRows := Src.FixedRows;
end;

procedure ImportDbGridInExcelCSV(ADBGrid:TDBGrid; ADataSet: TDataSet; filename: string);
var
  ListStr: TStringList;
  si: string;
  i, k: integer;
  arrf: array[0..300]of string;
  AF:TField;
begin
  if ADataSet.Eof then Exit;
  try
    ListStr := TStringList.Create;
    with ADataSet do begin
       for i:=0 to ADBGrid.Columns.Count - 1 do begin
         AF := ADataSet.Fields.FindField(ADBGrid.Columns.Items[i].FieldName);
         k := ADataSet.Fields.IndexOf(AF);
         arrf[k] := ADBGrid.Columns.Items[i].Title.Caption;
       end;
       si := '';
       for i:=0 to ADataSet.Fields.Count - 1 do si := si + arrf[i]+';';
       ListStr.Add(si);
       First;
       while not Eof do begin
          si := '';
          for i:=0 to ADataSet.Fields.Count - 1 do si := si + ADataSet.Fields[i].AsString+';';
          ListStr.Add(si);
          next;
       end;
    end;
    ListStr.SaveToFile(filename);
  finally
    ListStr.Free;
  end;
end;

function GetTextSQLByID(id: integer): string;
 var
   IBSQLG1: TIBSQL;
   Stream1 : TMemoryStream;
   StrLst1: TStringList;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  Stream1 := TMemoryStream.Create;
  StrLst1 := TStringList.Create;
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'select TEXTSQL from QUERYLST where IDQUERY = '+IntToStr(id);
      ExecQuery;
      FieldByName('TEXTSQL').SaveToStream(Stream1);
      Stream1.Position := 0;
      StrLst1.LoadFromStream(Stream1);
      Result := StrLst1.Text;
      Close;
    end;
  finally
    IBSQLG1.Free;
    Stream1.Free;
    StrLst1.Free;
  end;
end;


function LoadTableDataFromCDSFile(aFileName, aTableName: string): boolean;
var
 cds1: TClientDataSet;
 ibt1: TIBTable;
 i: integer;
begin
  Result := false;
  cds1 := TClientDataSet.Create(nil);
  ibt1 := TIBTable.Create(nil);
  try
    ibt1.TableName := aTableName;
    ibt1.Database := frmDM.IBDatabaseG;
    cds1.LoadFromFile(aFileName); cds1.Open;
    cds1.First;
    ExecSqlIB('delete from '+aTableName);
    ibt1.Open;
    while not cds1.Eof do begin
      ibt1.Insert;
      for i:=0 to cds1.FieldCount-1 do begin
        ibt1.Fields[i].AsVariant := cds1.Fields[i].AsVariant;
      end;
      ibt1.Post;
      cds1.Next;
    end; //while not cds1.Eof do begin
    cds1.Close;   ibt1.Close;
    frmDM.IBTransactionG.CommitRetaining;
    Result := true;
  finally
    cds1.Free;
    ibt1.Free;
  end;
end;



end.
