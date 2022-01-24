unit ImptLife;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBDatabase, DB, IBCustomDataSet, IBQuery, Grids, DBGrids,
  RegExpr, StdCtrls, uClasses,
  IBSQL, IBTable, uMyUtils, uGLBProcBD, ComCtrls, IBScript;

procedure ClearStringListID2(aTC: TStringList);
procedure LoadTypeCalls(aTC: TStringList);
procedure LoadTypeDIRECT(aTC: TStringList);
procedure LoadEmplPhone(aTC: TStringList);
function GetID_TypeCalls(NTC: string; aTC: TStringList): string;
function GetID_TypeDIRECT(NTC: string; aTC: TStringList): string;
function GetID_EmplPhone(NTC: string; aTC: TStringList): string;
function ExtractDuration(aIn: string): string;
function GetMaxCallID: integer;
function TestExistsData(DateMin, DateMax: string): boolean;
procedure LoadLifeCallsToScript(FileName: string; aIBScript: TIBScript);
procedure ImportLifeCalls(FileName: string; aIBScript: TIBScript);

implementation

uses uDM;

procedure ClearStringListID2(aTC: TStringList);
var
  i: integer;
  vObj: TId2Class;
begin
  for i := 0 to aTC.Count - 1 do begin
    vObj := aTC.Objects[i] as TId2Class;
    vObj.Free;
  end;
  aTC.Clear;
end;

procedure LoadTypeCalls(aTC: TStringList);
 var
   IBSQLG1: TIBSQL;
   i, id1: integer;
   s1: string;
begin
  ClearStringListID2(aTC);
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'SELECT * FROM  TYPE_CALL order by IDTYPECALL';
      ExecQuery;
      while not eof do begin
        id1 := FieldByName('IDTYPECALL').AsInteger;
        s1 := FieldByName('TYPECALL').AsString;
        aTC.AddObject(s1,TId2Class.Create(id1,s1));
        next;
      end;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure LoadTypeDIRECT(aTC: TStringList);
 var
   IBSQLG1: TIBSQL;
   i, id1: integer;
   s1: string;
begin
  ClearStringListID2(aTC);
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'SELECT * FROM  TYPE_DIRECT order by IDTYPEDIRECT';
      ExecQuery;
      while not eof do begin
        id1 := FieldByName('IDTYPEDIRECT').AsInteger;
        s1 := FieldByName('TYPEDIRECT').AsString;
        aTC.AddObject(s1,TId2Class.Create(id1,s1));
        next;
      end;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure LoadEmplPhone(aTC: TStringList);
 var
   IBSQLG1: TIBSQL;
   i, id1: integer;
   s1: string;
begin
  ClearStringListID2(aTC);
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'SELECT * FROM  EMPLOYEE order by IDEMPL';
      ExecQuery;
      while not eof do begin
        id1 := FieldByName('IDEMPL').AsInteger;
        s1 := FieldByName('PHONEEMPL').AsString;
        aTC.AddObject(s1,TId2Class.Create(id1,s1));
        next;
      end;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

function GetID_TypeCalls(NTC: string; aTC: TStringList): string;
var
  vObj: TId2Class;
  i, id: integer;
  IBTable1: TIBTable;
begin
  i := aTC.IndexOf(NTC);
  if i >= 0 then begin
    vObj := aTC.Objects[i] as TId2Class;
    Result := IntToStr(vObj.idn);
  end
  else begin
    IBTable1 := TIBTable.Create(nil);
    try
      with IBTable1 do begin
        Database := frmDM.IBDatabaseG;
        TableName := 'TYPE_CALL';
        id := StrToInt(GetGenValue('GEN_TYPE_CALL_ID'));
        Open; Insert;
        FieldByName('IDTYPECALL').AsInteger := id;
        FieldByName('TYPECALL').AsString := NTC;
        Post; frmDM.IBTransactionG.CommitRetaining;
        Close;
        LoadTypeCalls(aTC);
        Result := IntToStr(id);
    end;
    finally
      IBTable1.Free;
    end;
  end;// else
end;


function GetID_TypeDIRECT(NTC: string; aTC: TStringList): string;
var
  vObj: TId2Class;
  i, id: integer;
  IBTable1: TIBTable;
begin
  i := aTC.IndexOf(NTC);
  if i >= 0 then begin
    vObj := aTC.Objects[i] as TId2Class;
    Result := IntToStr(vObj.idn);
  end
  else begin
    IBTable1 := TIBTable.Create(nil);
    try
      with IBTable1 do begin
        Database := frmDM.IBDatabaseG;
        TableName := 'TYPE_DIRECT';
        id := StrToInt(GetGenValue('GEN_TYPE_DIRECT_ID'));
        Open; Insert;
        FieldByName('IDTYPEDIRECT').AsInteger := id;
        FieldByName('TYPEDIRECT').AsString := NTC;
        Post; frmDM.IBTransactionG.CommitRetaining;
        Close;
        LoadTypeDIRECT(aTC);
        Result := IntToStr(id);
    end;
    finally
      IBTable1.Free;
    end;
  end;// else
end;

function GetID_EmplPhone(NTC: string; aTC: TStringList): string;
var
  vObj: TId2Class;
  i, id: integer;
  IBTable1: TIBTable;
begin
  Result := '';
  i := 0;
  while i <= aTC.Count do begin
    vObj := aTC.Objects[i] as TId2Class;
    if pos(NTC,vObj.Name) > 0 then begin
      Result := IntToStr(vObj.idn);
      break;
    end;
    inc(i);
  end;
end;

// извлекает время звонка
function ExtractDuration(aIn: string): string;
var
   rgx1, rgx2 : TRegExpr;
   hour, min, sec: integer;
begin
  Result := '0:0:0';
  rgx1 := TRegExpr.Create;
  try
    rgx1.Expression := '(\d{1,3})\:.*?(\d{1,2})'; // 20: 52
    if rgx1.Exec(aIn) then begin
      min := StrToInt(rgx1.Match[1]);
      sec := StrToInt(rgx1.Match[2]);
      hour := min div 60;
      min := min mod 60;
      Result := IntToStr(hour)+':'+IntToStr(min)+':'+IntToStr(sec);
    end;
  finally
    rgx1.Free;
  end;
end;


function GetMaxCallID: integer;
 var
   IBSQLG1: TIBSQL;
begin
  Result := 0;
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      SQL.Text := 'select max(IDCALL) as MaxID from CALLS_LIFE';
      ExecQuery;
      if not Eof then Result := Fields[0].AsInteger;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

function TestExistsData(DateMin, DateMax: string): boolean;
 var
   IBSQLG1: TIBQuery;
   Sql1: string;
begin
  Result := False;
  IBSQLG1 := TIBQuery.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql1 := 'select IDCALL from CALLS_LIFE where (DATETIME >= _Date1)and(DATETIME <= _Date2)';
      SetParamStr(Sql1,'_Date1',QuotedStr(DateMin));
      SetParamStr(Sql1,'_Date2',QuotedStr(DateMax));
      SQL.Text := Sql1;
      Open;
      if not Eof then Result := true;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure LoadLifeCallsToScript(FileName: string; aIBScript: TIBScript);
var
   rgx1, rgx2    :TRegExpr;
   MaxIDCall, i   :integer;
   s1, s2, PhoneEmpl, idTCall, idTDirect,idEmpl, SqlTxt1, SqlSrc :string;
   MaxDate, MinDate, CurDateTime  :TDateTime;
   LTypeCall, LTypeDirect, LPhoneEmpl, DataSrc :TStringList;
   SaveCursor: TCursor;
begin
   aIBScript.Script.Clear;
// 'INSERT INTO CALLS_LIFE (IDCALL, DATETIME, REC_PHONE, DURATION, TYPECALL_ID, TYPEDIRECT_ID, IDPHONE) VALUES (1, '2009-12-01 08:12:19', '380967094584', '0:00:36', 1, 1, 3);'
  SqlSrc :='INSERT INTO CALLS_LIFE (IDCALL, DATETIME, REC_PHONE, DURATION, TYPECALL_ID, TYPEDIRECT_ID, IDPHONE) VALUES (:IDCALL, :DATETIME, :REC_PHONE, :DURATION, :TYPECALL_ID, :TYPEDIRECT_ID, :IDPHONE);';
  // инит предельных дат для дальнейшего выяснения наличия в базе
  MaxDate := StrToDate('01.01.1800');  MinDate := StrToDate('01.01.4000');
  MaxIDCall := GetMaxCallID; // максимальное ид, будем использовать вместо генератора
  //используем списки для скорости, что с каждой итерацией не обращаться к базе
  LTypeCall := TStringList.Create;  LTypeDirect := TStringList.Create;  LPhoneEmpl := TStringList.Create;
  LoadTypeCalls(LTypeCall);  LoadTypeDIRECT(LTypeDirect);  LoadEmplPhone(LPhoneEmpl);

  DataSrc := TStringList.Create; // список csv файла (входные данные)
  // регулярные выражения
  rgx1 := TRegExpr.Create;  rgx2 := TRegExpr.Create;
  rgx1.Expression := '.*?Телефонний.*?номер.*? (\d{9,12})';
  rgx2.Expression := '(\d{2}\.\d{2}\.\d{4}.\d{2}\:\d{2}\:\d{2})\;(.*?)\;(.*?)\;(.*?)\;(.*?)\;(.*?)';
  PhoneEmpl := ''; // будем запоминать телефон сотрудника из входного файла
  try
     DataSrc.LoadFromFile(FileName);
     for i:=0 to DataSrc.Count - 1 do begin
      s1 := DataSrc.Strings[i];
      if rgx1.Exec(s1) then begin
        PhoneEmpl := rgx1.Match[1];
      end
      else
      if rgx2.Exec(s1) then
       if (rgx2.Match[3]<>'АП')and(rgx2.Match[4]<>'АП')then begin // первая - итоговая строка, ее пропускаем
        idTCall := GetID_TypeCalls(rgx2.Match[3], LTypeCall);
        idTDirect := GetID_TypeDIRECT(rgx2.Match[4], LTypeDirect);
        idEmpl := GetID_EmplPhone(PhoneEmpl, LPhoneEmpl);
        if idEmpl = '' then begin
          ShowMessage('Импорт детального отчета звонков прерван! Не найден сотрудник с телефоном '+PhoneEmpl);
          aIBScript.Script.Clear;
          Exit;
        end;
        CurDateTime := StrToDateTime(rgx2.Match[1]);
        if CurDateTime > MaxDate then MaxDate := CurDateTime;
        if CurDateTime < MinDate then MinDate := CurDateTime;
        inc(MaxIDCall);
        // Формируем оператор вставки
        SqlTxt1 := SqlSrc; // возобновляем шаблон 
        SetParamStr(SqlTxt1,':IDCALL',IntToStr(MaxIDCall));
        SetParamStr(SqlTxt1,':DATETIME',QuotedStr(FormatDateTime('mm-dd-yyyy hh:nn:ss',CurDateTime)));
        // в случае длинного телефона > 12 обрезаем, чтобы = 12
        s2 := rgx2.Match[2]; if Length(s2) > 12 then s2 := Copy(rgx2.Match[2],1,12);
        SetParamStr(SqlTxt1,':REC_PHONE',QuotedStr(s2));
        SetParamStr(SqlTxt1,':DURATION',QuotedStr(ExtractDuration(rgx2.Match[5])));
        SetParamStr(SqlTxt1,':TYPECALL_ID',idTCall);
        SetParamStr(SqlTxt1,':TYPEDIRECT_ID',idTDirect);
        SetParamStr(SqlTxt1,':IDPHONE',idEmpl);
        aIBScript.Script.Add(SqlTxt1);
      end; //if rgx2.Exec(s1) then begin
    end; // for i:=0 to DataSrc.Count - 1 do begin
    aIBScript.Script.SaveToFile('tempSql.sql');
  finally
   DataSrc.Free;
   rgx1.Free; rgx2.Free;
   ClearStringListID2(LTypeCall); LTypeCall.Free;
   ClearStringListID2(LTypeDirect); LTypeDirect.Free;
   ClearStringListID2(LPhoneEmpl); LPhoneEmpl.Free;
  end;
  s1 := FormatDateTime('mm-dd-yyyy',MinDate);
  s2 := FormatDateTime('mm-dd-yyyy',MaxDate);
  if TestExistsData(s1,s2) then begin
    s1 := FormatDateTime('dd-mm-yyyy',MinDate);
    s2 := FormatDateTime('dd-mm-yyyy',MaxDate);
    SaveCursor := Screen.Cursor;
    Screen.Cursor := crDefault;
    if MessageDlg('Внимание! В базе уже есть данные за период: '+CRLF+
    s1 +' по '+ s2+CRLF+'Продолжить импорт в любом случае?', mtWarning, [mbYes, mbNo], 0) = mrNo then aIBScript.Script.Clear;
    Screen.Cursor := SaveCursor;
  end;
end;

procedure ImportLifeCalls(FileName: string; aIBScript: TIBScript);
begin
  LoadLifeCallsToScript(FileName, aIBScript);
  if aIBScript.Script.Count < 1 then Exit;
  aIBScript.Database := frmDM.IBDatabaseG;
  aIBScript.Transaction := frmDM.IBTransactionG;
  try
    aIBScript.ExecuteScript;
    frmDM.IBTransactionG.CommitRetaining;
  except
    on E: Exception do begin
     if frmDM.IBTransactionG.InTransaction then
        frmDM.IBTransactionG.RollbackRetaining;
     raise Exception.CreateFmt('Импорт детального отчета звонков прерван! Ошибка: %s',[E.Message]);
    end; // on E: Exception do begin
  end;
end;

end.
