unit uTranslit;
{
Модуль транслитерации
русский - английский
}


interface

uses Windows, SysUtils, Classes;

const
   CountSRu = 2;
   CountRu = 35;
   ConfRuToEng: array[1..CountRu,1..3]of string[3] =
(

('а','a','1'),
('б','b','2'),
('в','v','2'),
('г','g','2'),
('д','d','2'),
('е','e','1'),
('ё','yo','1'),
('ж','zh','2'),
('з','z','2'),
('и','i','1'),
('й','j','2'),
('к','k','2'),
('л','l','2'),
('м','m','2'),
('н','n','2'),
('о','o','1'),
('п','p','2'),
('р','r','2'),
('с','s','2'),
('т','t','2'),
('у','u','1'),
('ф','f','2'),
('х','h','2'),
('ц','ts','2'),
('ч','ch','2'),
('ш','sh','2'),
('щ','sch','2'),
('ы','y','1'),
('ь','','2'),
('ъ','','2'),
('э','e','1'),
('ю','yu','1'),
('я','ya','1'),
(' ','_','2'),
('/','_','2')
);


ConfSRuToEng: array[1..CountSRu,1..3]of string[10] =
(
// '10' - после гласной, '20' - после согласной, '01' - перед гласной, '02' - перед согласной
('ь','j','01'),
('ъ','j','01')
);


type
   MD5Str16111 = String[16];
   MD5Str32111 = String[32];



function TranslitRuToEng(Ainstr: string): string;
function SConf(astr: string; atyp: byte): string;
function PreTranslitRuToEng(Ainstr: string): string;
function GetTypeCh(aChr: string): string;
function TestOnTranslit(aStr: string): Boolean;


implementation

function TestOnTranslit(aStr: string): Boolean;
const
 OkLitter: set of char = ['a'..'z','0'..'9','_'];
var
  i: integer;
  ch: char;
begin
  Result := False;
  for i:=1 to Length(aStr) do begin
    ch := aStr[i];
    if not (ch in OkLitter) then Exit;
  end;
  Result := True;
end;


function SConf(astr: string; atyp: byte): string;
var
 i: integer;
begin
  Result := astr;
  for i:=1 to CountRu do begin
    if ConfRuToEng[i,1] = astr then begin
      Result := ConfRuToEng[i,atyp];
      Break;
    end;
  end;
end;

function GetTypeCh(aChr: string): string;
var
 i: integer;
begin
  Result := '';
  for i:=1 to CountRu do begin
    if ConfRuToEng[i,1] = aChr then begin
      Result := ConfRuToEng[i,3];
      Break;
    end;
  end;
end;


// транслит сочетаний
function PreTranslitRuToEng(Ainstr: string): string;
var
  i, p: integer;
  rs, s1: string;
begin
   rs := Ainstr;
   for i:=1 to CountSRu do begin
     p := pos(ConfSRuToEng[i,1],rs);
     if (p > 0) then begin
       // перед гласной
       if (ConfSRuToEng[i,3] = '01')and(p < Length(rs)) then
         if GetTypeCh(rs[p+1]) = '1' then begin
           delete(rs,p,1);
           insert(ConfSRuToEng[i,2],rs,p);
         end;
       // перед согласной
       if (ConfSRuToEng[i,3] = '02')and(p < Length(rs)) then
         if GetTypeCh(rs[p+1]) = '2' then begin
           delete(rs,p,1);
           insert(ConfSRuToEng[i,2],rs,p);
         end;
     end; // if (p > 0) then begin
   end;
   Result := rs;
end;

function TranslitRuToEng(Ainstr: string): string;
var
 s, s1,s2, src: string;
 i, typ: integer;
begin
  src := PreTranslitRuToEng(Ainstr);
  s := '';
  for i:=1 to Length(src) do begin
       s := s + SConf(src[i],2);
  end;
  Result := s;
end;






end.
