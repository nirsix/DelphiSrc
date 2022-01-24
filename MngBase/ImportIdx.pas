unit ImportIdx;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  Dialogs,  ExtCtrls, StdCtrls, uClasses, IBSQL, uDM, Grids, uMyUtils,
  IBTable, DB, DBGrids, uGLBProcBD;

CONST
  MAXSTGA = 10000;


function ITB_SubRegion(namesr:string; regionid: integer):integer;
function Search_SubRegion(namesr:string; regionid: integer):integer;
function Search_CityLocality(namec, postidcs:string):integer;
procedure ITB_CityLocality(namec:string; postidcs,subregionid,typec: integer);

implementation


// ишет в базе район, если нашел - айди, иначе 0
function Search_SubRegion(namesr:string; regionid: integer):integer;
  var
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select IDSUBREGION from SUBREGION where(REGION_ID ='+IntToStr(regionid)+
                  ')and(NAMESR = '''+namesr+''' )';
      ExecQuery;
      if Not Eof then Result := FieldByName('IDSUBREGION').AsInteger else Result := 0;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;


// добавить в базу район, если такого нет 
function ITB_SubRegion(namesr:string; regionid: integer):integer;
  var
   IBTable1: TIBTable;
   id: integer;
begin
  Result := Search_SubRegion(namesr, regionid);
  if Result > 0 then Exit;
  Result := 1;
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'SUBREGION';
      id := StrToInt(GetGenValue('GEN_SUBREGION_ID'));
      Open; Insert;
      FieldByName('IDSUBREGION').AsInteger := id;
      FieldByName('NAMESR').AsString := namesr;
      FieldByName('REGION_ID').AsInteger := regionid;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
      Result := id;
    end;
  finally
    IBTable1.Free;
  end;
end;

// ищет населенный пункт в базе, если такого нет то 0, иначе айди
function Search_CityLocality(namec, postidcs:string):integer;
  var
    IBSQLG1: TIBSQL;
    id: integer;
    s1: string;
begin
  Result := 0;
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select IDCITY, NAMEC from city_locality where POSTINDECS = '+postidcs;
      ExecQuery;
      while not Eof do begin
        s1 := FieldByName('NAMEC').AsString;
        if AnsiUpperCase(s1) = AnsiUpperCase(namec)then begin
           Result := FieldByName('IDCITY').AsInteger;
           Break; 
        end;
        next;
      end;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

// добавляет в базу населенный пункт
procedure ITB_CityLocality(namec:string; postidcs,subregionid,typec: integer);
  var
   IBTable1: TIBTable;
   id: integer;
begin
  if Search_CityLocality(namec, IntToStr(postidcs)) > 0 then Exit; // чтобы исключить дубляж
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'CITY_LOCALITY';
      id := StrToInt(GetGenValue('GEN_CITY_LOCALITY_ID'));
      Open; Insert;
      FieldByName('IDCITY').AsInteger := id;
      FieldByName('NAMEC').AsString := namec;
      FieldByName('SUBREGION_ID').AsInteger := subregionid;
      FieldByName('POSTINDECS').AsInteger := postidcs;
      FieldByName('TYPELOCALITY').AsInteger := typec;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;


end.
