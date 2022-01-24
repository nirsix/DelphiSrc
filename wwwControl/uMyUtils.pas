unit uMyUtils;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes, StrUtils;

const
 CRLF = #13+#10;
 mdayweek: array[1..7] of string[2] = ('вс','пн','вт','ср','чт','пт','сб');
 fdayweek: array[1..7] of string[15] = ('воскресенье','понедельник','вторник','среда','четверг','пятница','суббота');


function TestOnDate(str: string): boolean;
function TestOnReal(str: string):boolean;
function TestOnInt(str: string):boolean;
function SecToTime(val: integer):string;
function TimeToMin(val: TDateTime):integer;
function TruncDateToTime(val: TDateTime): TDateTime;
function TruncDateTimeToDate(val: TDateTime): TDateTime;
function NullDateTime: TDateTime;
procedure CorrInvertedCommas(var strval: string);
function PosM(const SubStr, S: string): Integer;
procedure DeleteSubStr(var aSource: string; aSubStr: string);
procedure ReplaceSubStr(var aSource: string; aSubStr: string; aNewSubStr: string);
function GetOnlyDigital(aSource: string): string;

implementation

function TruncDateToTime(val: TDateTime): TDateTime;
begin
 Result := StrToTime(FormatDateTime('hh:nn:ss',val));
end;

function TruncDateTimeToDate(val: TDateTime): TDateTime;
begin
 Result := StrToDate(FormatDateTime('dd.mm.yyyy',val));
end;


function NullDateTime: TDateTime;
begin
 Result:=StrToTime(FormatDateTime('hh:nn:ss',StrToTime('00:00:00')));
end;

function TestOnDate(str: string): boolean;
begin
 try
   StrToDate(str);
   Result:=True;
 except
   Result:=false;
 end;
end;


function TestOnReal(str: string):boolean;
const
  numc: set of char = ['0'..'9',' ','-'];
var
  i: integer;
  nums: set of char;
begin
  nums := numc + [decimalseparator];
  if length(str) = 0 then begin
    Result := false;
    Exit;
  end;
  for i := 1 to length(str) do
    if not (str[i] in nums) then begin
      Result := false;
      Exit;
    end;
 try
   StrToFloat(str);
   Result:=True;
 except
   Result:=false;
 end;
end;

function TestOnInt(str: string):boolean;
const
  numc: set of char = ['0'..'9',' ','-'];
var
  i: integer;
  nums: set of char;
begin
  if length(str) = 0 then begin
    Result := false;
    Exit;
  end;
  nums:=numc;
  for i := 1 to length(str) do
    if not (str[i] in nums) then begin
      Result := false;
      Exit;
    end;
 try
   StrToInt(str);
   Result:=True;
 except
   Result:=false;
 end;
end;

function TestOnTime(str: string):boolean;
const
  numc: set of char = ['0'..'9',' ',':'];
var
  i: integer;
  nums: set of char;
begin
  if length(str) = 0 then begin
    Result := false;
    Exit;
  end;
  nums:=numc;
  for i := 1 to length(str) do
    if not (str[i] in nums) then begin
      Result := false;
      Exit;
    end;
 try
   StrToTime(str);
   Result:=True;
 except
   Result:=false;
 end;
end;

function SecToTime(val: integer):string;
var
  h,m,s: integer;
begin
  // преобразовываем время в "время"
  m:=trunc(Val/60);
  s:=Val-m*60;
  h:=trunc(m/60);
  m:=m-h*60;
  Result:=Format('%d:%d:%d',[h,m,s]);
end;

function TimeToMin(val: TDateTime):integer;
var
  i,j: integer;
  sh,sm,ss: string;
begin
  // преобразовываем "время" в минуты
  ss:=FormatDateTime('hh:nn:ss',val);
  i:=1;
  while (ss[i]<>':') do inc(i);
  sh:=Copy(ss,1,2);
  j:=i+1;
  while (ss[j]<>':') do inc(j);
  sm:=Copy(ss,i+1,2);
  i:=j+1;
  while (ss[i]<>':')and(i<=Length(ss)) do inc(i);
  ss:=Copy(ss,j+1,2);
  Result:=StrToInt(sh)*3600+StrToInt(sm)*60+StrToInt(ss);
end;

procedure CorrInvertedCommas(var strval: string);
  var
    i: integer;
begin
    strval :=' '+strval+' '; // дополняем пробелами
    i := 2;
    while (i < Length(strval)) do begin
      if (strval[i-1]<>'"')and(strval[i]='"')and(strval[i+1]<>'"') then begin
        Insert('"',strval,i);
      end;
      inc(i);
    end;
    // убираем пробелы
    Delete(strval,1,1);
    Delete(strval,Length(strval),1);
end;

{procedure DeleteSubStr(var aSource: string; aSubStr: string);
var
  i: integer;
  pc: pchar;
begin
  pc := @aSource[1];
  i := PosEx(aSubStr, pc);
  while( i > 0) do begin
    Delete(aSource,i,Length(aSubStr));
    i := PosEx(aSubStr, aSource);
  end;
end; }

function PosM(const SubStr, S: string): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
    I := 1;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
end;  

procedure DeleteSubStr(var aSource: string; aSubStr: string);
var
  i: integer;
begin        
  i := Pos(aSubStr, aSource);
  while( i > 0) do begin
    Delete(aSource,i,Length(aSubStr));
    i := Pos(aSubStr, aSource);
  end;
end;

function GetOnlyDigital(aSource: string): string;
const
  numc: set of char = ['0'..'9'];
var
  i: integer;
  nums: set of char;
  s1: string;
begin
  nums := numc + [decimalseparator];
  s1 := '';
  for i := 1 to Length(aSource) do
    if (aSource[i] in nums) then s1 := s1 + aSource[i];
    
  Result := s1;  
end;



procedure ReplaceSubStr(var aSource: string; aSubStr: string; aNewSubStr: string);
var
  i: integer;
begin
  i := pos(aSubStr, aSource);
  while( i > 0) do begin
    Delete(aSource,i,Length(aSubStr));
    insert(aNewSubStr,aSource,i);
    i := pos(aSubStr, aSource);
  end;
end;


end.