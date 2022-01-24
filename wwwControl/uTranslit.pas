unit uTranslit;
{
������ ��������������
������� - ����������
}


interface

uses Windows, SysUtils, Classes;

const
   CountSRu = 2;
   CountRu = 35;
   ConfRuToEng: array[1..CountRu,1..3]of string[3] =
(

('�','a','1'),
('�','b','2'),
('�','v','2'),
('�','g','2'),
('�','d','2'),
('�','e','1'),
('�','yo','1'),
('�','zh','2'),
('�','z','2'),
('�','i','1'),
('�','j','2'),
('�','k','2'),
('�','l','2'),
('�','m','2'),
('�','n','2'),
('�','o','1'),
('�','p','2'),
('�','r','2'),
('�','s','2'),
('�','t','2'),
('�','u','1'),
('�','f','2'),
('�','h','2'),
('�','ts','2'),
('�','ch','2'),
('�','sh','2'),
('�','sch','2'),
('�','y','1'),
('�','','2'),
('�','','2'),
('�','e','1'),
('�','yu','1'),
('�','ya','1'),
(' ','_','2'),
('/','_','2')
);


ConfSRuToEng: array[1..CountSRu,1..3]of string[10] =
(
// '10' - ����� �������, '20' - ����� ���������, '01' - ����� �������, '02' - ����� ���������
('�','j','01'),
('�','j','01')
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


// �������� ���������
function PreTranslitRuToEng(Ainstr: string): string;
var
  i, p: integer;
  rs, s1: string;
begin
   rs := Ainstr;
   for i:=1 to CountSRu do begin
     p := pos(ConfSRuToEng[i,1],rs);
     if (p > 0) then begin
       // ����� �������
       if (ConfSRuToEng[i,3] = '01')and(p < Length(rs)) then
         if GetTypeCh(rs[p+1]) = '1' then begin
           delete(rs,p,1);
           insert(ConfSRuToEng[i,2],rs,p);
         end;
       // ����� ���������
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
