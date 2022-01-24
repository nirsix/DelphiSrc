unit ImportFold;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  Dialogs,  ExtCtrls, StdCtrls, uClasses, IBSQL, uDM, Grids, uMyUtils,
  IBTable, DB, DBGrids, uGLBProcBD, RegExpr;

CONST
  MAXSTGA = 10000;


function delete_string(src,shb: string): string;
procedure MainLoadProc;
procedure MainLoadProc2;
function ITB_GroupCat(namegroup: string):string;
function ITB_CatItem(catname, idgroup, levelT: string):string;
function ITB_ArticleData(nart, shnt, catid, picname: string):string;

var
  grpcatA: array[1..100, 1..2]of string[5];
  groupA: array[1..100, 1..2]of string[5];
  catA: array[1..100, 1..2]of string[10];  


implementation

function delete_string(src,shb: string): string;
var
  str :string;
  i: integer;
begin
  str := src;
  i := pos(shb,str);
  while i > 0 do begin
    delete(str,i,Length(shb));
    i := pos(shb,str);
  end;
  Result := str;
end;

function GetGroupIdByOldCatId(oCatID: string): string;
var
  i: integer;
  ri: string;
begin
  ri := ''; Result := '';
  for i:=1 to 100 do
    if grpcatA[i,2] = oCatID then begin
      ri := grpcatA[i,1];
      Break;
    end;
  for i:=1 to 100 do
    if groupA[i,1] = ri then begin
      Result := groupA[i,2];
      Break;
    end;
end;

function GetCatIdByOldCatId(OldCatId: string): string;
var
  i: integer;
  ri: string;
begin
  ri := ''; Result := '';
  for i:=1 to 100 do
    if catA[i,1] = OldCatId then begin
      ri := catA[i,2];
      Break;
    end;
  Result := ri;  
end;


procedure MainLoadProc;
var
  InData,OutData: TStringList;
  rgx1, rgx2 : TRegExpr;
  str, ids, dir, s1, s2, ps: string;
  i: integer;
begin
  ExecSqlIB('delete from groupcat');
  ExecSqlIB('ALTER SEQUENCE GEN_GROUPCAT_ID RESTART WITH 5;');
  ExecSqlIB('delete from CATEGORY');
  ExecSqlIB('ALTER SEQUENCE GEN_CATEGORY_ID RESTART WITH 5;');
  ExecSqlIB('delete from ARTICLEDATA');
  ExecSqlIB('ALTER SEQUENCE GEN_ARTICLEDATA_ID RESTART WITH 15;');


  rgx1 := TRegExpr.Create;
  InData := TStringList.Create;
  OutData := TStringList.Create;
  dir := 'D:\ProgWork\!WWWGamayun\wwwControl\bin\imt\';
  //    'C:\iv_prog\!WWWGamayun\wwwControl\bin\imt\pagesdata.csv';
  try
    // таблица принадлежности категории к группе
    InData.LoadFromFile(dir + 'catgroup.csv');
    str := InData.Text;
    rgx1.Expression := '\"(\d{1,3})\"\;\"(\d{1,3})\"';
    i:=0;
    if rgx1.Exec(str) then begin
      repeat
        inc(i);
        grpcatA[i,1] := rgx1.Match[1];
        grpcatA[i,2] := rgx1.Match[2];
      UNTIL not rgx1.ExecNext;
    end;
      
    // ГРУППЫ КАТАЛОГА
    InData.Clear; OutData.Clear; InData.LoadFromFile(dir + 'pagesdata.csv');
    str := InData.Text;
    rgx1.Expression := '\"(\d{1,3})\"\;\"(.*?)\"\;\"(.*?)\"\;\"(.*?)\"\;\"(.*?)\"\;\"(.*?)\"\;\"(.*?)\"\;\"(\d{1,3})\"';
    i:=0;
    if rgx1.Exec(str) then begin
      repeat
        s1 := delete_string(rgx1.Match[2],'\"');
        if rgx1.Match[8] = '1' then begin
          inc(i);
          groupA[i,1] := rgx1.Match[1];
          groupA[i,2] := ITB_GroupCat(s1);
        end;
        OutData.Add(rgx1.Match[1]+';'+s1+';'+rgx1.Match[8]+';');
      UNTIL not rgx1.ExecNext;
    end;
    OutData.SaveToFile('as1111.txt');

    // категории каталога
    i:=0; OutData.Clear;
    if rgx1.Exec(str) then begin
      repeat
        s1 := delete_string(rgx1.Match[2],'\"');
        if rgx1.Match[8] = '2' then begin
          inc(i);
          catA[i,1] := rgx1.Match[1];
          ids := GetGroupIdByOldCatId(catA[i,1]);
          if ids = '' then ids := '6';
          catA[i,2] := ITB_CatItem(s1, ids, '3');
          OutData.Add(rgx1.Match[1]+';'+s1+';'+ids+';');
        end;
      UNTIL not rgx1.ExecNext;
    end;
    OutData.SaveToFile('as1113.txt');

    InData.Clear; OutData.Clear;
    InData.LoadFromFile(dir + 'products.csv');
    str := InData.Text;
    rgx1.Expression := '\"(\d{1,3})\"\;\"(.*?)\"\;\"(.*?)\"\;\"(.*?)\"\;\"(\d{1,3})\"';
    if rgx1.Exec(str) then begin
      repeat
        s1 := delete_string(rgx1.Match[2],'\"');
        s2 := delete_string(rgx1.Match[3],'\"');
        ids := GetCatIdByOldCatId(rgx1.Match[5]);
        ps := delete_string(rgx1.Match[4],'./images/cat/');
        OutData.Add(s1+'}'+s2+'}'+ids+'}'+ps);
        ITB_ArticleData(s1,s2,ids,ps);
      UNTIL not rgx1.ExecNext;
    end;
    OutData.SaveToFile('as1112.txt');

  finally
    InData.Free;
    OutData.Free;
    rgx1.Free;
  end;

end;


function ITB_GroupCat(namegroup: string):string;
  var
   IBTable1: TIBTable;
   id: string;
begin
  Result := '';
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'GROUPCAT';
      id := GetGenValue('GEN_GROUPCAT_ID');
      Open; Insert;
      FieldByName('IDGROUPCAT').AsString := id;
      FieldByName('NAMEGROUP').AsString := namegroup;
      FieldByName('NOTEGROUP').AsString := 'Добавлено через импорт старой базы';
      FieldByName('DATE_UPDATE').AsDateTime := now;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
      Result := id;
    end;
  finally
    IBTable1.Free;
  end;
end;

function ITB_CatItem(catname, idgroup, levelT: string):string;
  var
   IBTable1: TIBTable;
   id: string;
begin
  Result := '';
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'CATEGORY';
      id := GetGenValue('GEN_CATEGORY_ID');
      Open; Insert;
      FieldByName('IDCATEGORY').AsString := id;
      FieldByName('PARENT_ID').AsString := idgroup;
      FieldByName('NAMECATEG').AsString := catname;
      FieldByName('LEVELTYPE').AsString := levelT;
      FieldByName('NOTECATEG').AsString := 'Добавлено через импорт старой базы';
      FieldByName('DATE_UPDATE').AsDateTime := now;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
      Result := id;
    end;
  finally
    IBTable1.Free;
  end;
end;

function ITB_ArticleData(nart, shnt, catid, picname: string):string;
  var
   IBTable1: TIBTable;
   id, dir: string;
begin
  dir := 'D:\ProgWork\!WWWGamayun\wwwControl\bin\imt\cat\';
  Result := '';
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'ARTICLEDATA';
      Open; Insert;
      id := GetGenValue('GEN_ARTICLEDATA_ID');
      FieldByName('IDARTICLE').AsString := id;
      FieldByName('DATE_ENTRY').AsDateTime := now;
      FieldByName('NAMEART').AsString := nart;
      FieldByName('DATE_UPDATE').AsDateTime := now;
      FieldByName('SHORTNOTE').AsString := AnsiToUtf8(shnt);
      FieldByName('FULLNOTE').AsString := '';
      FieldByName('CATEGORYID').AsString := catid;
      FieldByName('SUPPLIER_PRICE').AsString := '0';
      FieldByName('SELLING_COEFF').AsString := '0';

      (FieldByName('PICTART')as TBlobField).LoadFromFile(dir+picname);
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
      Result := id;
    end;
  finally
    IBTable1.Free;
  end;
end;

procedure MainLoadProc2;
  var
   IBTable1: TIBTable;
   id, oldID: string;
begin
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'GROUPCAT';
      Open; First;
      while not eof do begin
          id := ITB_CatItem(FieldByName('NAMEGROUP').AsString,'0', '1');
          oldID := FieldByName('IDGROUPCAT').AsString;
          ExecSqlIB('Update CATEGORY Set PARENT_ID = '+id+' Where PARENT_ID = '+oldID);
          next;
      end;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;


end.
