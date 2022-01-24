unit uClasses;

interface

uses
  Classes, StdCtrls, ExtCtrls, Controls, Forms;

const
  dayschan: array[1..14] of string[2] = ('пн','вт','ср','чт','пт','сб','вс','пн','вт','ср','чт','пт','сб','вс');
  CRLF = #13+#10;

type

  setday = set of byte;
  Psetday = ^setday;
  TArrDayDrv = array[1..14,1..2]of word; // массив для записи соотв. между днями недели и машинами
  TStgArray = array[0..100] of word;
  TFilterArray = array[0..100,1..2] of string;
  string250 = string[250];
  string100 = string[100];
  string20 = string[20];
  string5 = string[5];
  TParamet = class(TObject)
    rr: array[1..50] of string;
    PObj: Pointer;
    OnPushParam: TNotifyEvent;
    constructor Create;
  end;

  TParamForm = record   // запись для передачи параметров между формами
    rr: array[1..50] of string;
    PForm: TForm;
    PObj: Pointer;
    OnPushParam: TNotifyEvent;
  end;
  PTParamForm = ^TParamForm;

  TForSqlData = class(TObject)
    ntable: string; // имя таблицы
    cfield: integer;
    field: array[1..100,1..2] of string250;
    cwhere: integer;
    where: array[1..100] of string250;
    constructor Create;
  end;

  TObjInt = class(TObject)
     id: integer;
     constructor Create(pi: integer);
  end;

  TId2Class = class
    idn : integer;
    Name : string250;
    constructor Create(idn1 : integer; name1: string);
  end;
  
  T3Elem = class
    idn : integer;
    sprice: double;
    codesup: string20;
    cntfind: integer;
    pricearr: array[1..100] of double;
    constructor Create(idn1 : integer; sprice1: double; codesup1: string);
  end;


  TLocality = class
    idn : integer;
    Name : string250;
    pidcs : string5;
    idtloc: integer;
    nsub: string100;
    idsub: integer;
    nreg: string100;
    idreg: integer;
  end;


//////////////////////implementation//////////////////////
 implementation
//////////////////////implementation//////////////////////


constructor TParamet.Create;
begin
  inherited Create;
end;

constructor TForSqlData.Create;
begin
  inherited Create;
end;

constructor TId2Class.Create(idn1 : integer; name1: string);
begin
  inherited Create;
  idn := idn1;
  Name := name1;
end;

constructor T3Elem.Create(idn1 : integer; sprice1: double; codesup1: string);
begin
  inherited Create;
  idn := idn1;
  sprice := sprice1;
  codesup := codesup1;
end;


constructor TObjInt.Create(pi: integer);
begin
  inherited Create;
  id := pi;
end;


end.
