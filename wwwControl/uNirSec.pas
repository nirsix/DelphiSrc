unit uNirSec;
{
������ ����� ����������������� �������

}


interface

uses Windows, SysUtils, Classes, uMD5;

const
   LenSalt = 32; // ���-�� �������� � Salt - ������
   KeyChangeData = '5efQM324saj45qznSAsfg';  // ���� ��� �������������� ������� �� ��������� ������ � ���� � �������.
   KeyChatCroup = 'gh30MbqP8rs1zfqo![aI52';  // ���� ��� �������������� ������� ��������� ���� ��� �� ������

type
   MD5Str16 = String[16];
   MD5Str32 = String[32];



procedure SaltPassMD5ForBase(var p1, p2, ps3: MD5Str32; const pass: string);
function TestPassMD5ForBase(p1, p2, md5ps: MD5Str32; const entered: string):Boolean;
// ������ ���������� ������ ��� �������� � ����
function GetPassMD5ForBase(p1, p2: MD5Str32; const pass: string): MD5Str32;



// ������������� ����(����) ��� "�������" ������ � ����
function GenerateSalt: MD5Str32;

// ��������������� ������ � ������ ������������������ ���� ���� ������
// ��������: "�[ǣ7" -> "CA5BC7A337" ("CA 5B C7 A3 37") ��� ord('�')=202=CA;
function SaltToHex(src: string): string;
// �������� �������������� SaltToHex
function HexToSalt(src: string): string;

// �� ��������� ����� ������ ���� ������-255
function MyMix1Key(ikey: string): string;

// �����������=(src[i] XOR mkey[i]) ��� mkey[i]=MyMix1Byte(key[i],3)
function CodeWithKey(src, key: string): string;


procedure CodeAccount(var p1, p2: MD5Str32; SumAccount: integer; sTime:String);
function TestPackAccount(p1, p2: MD5Str32; SumAccount: integer; sTime:String): Boolean;


implementation


function GetPassMD5ForBase(p1, p2: MD5Str32; const pass: string): MD5Str32;
var
  s: string;
begin
  s := MD5DigestToStr(MD5String(pass));
  s := s + HexToSalt(p1);
  s := MD5DigestToStr(MD5String(s));
  s := s + HexToSalt(p2);
  Result := MD5DigestToStr(MD5String(s));
end;

function TestPassMD5ForBase(p1, p2, md5ps: MD5Str32; const entered: string):Boolean;
var
 p3: string;
begin
  p3 := GetPassMD5ForBase(p1,p2,entered);
  Result := (p3 = md5ps);
end;

procedure SaltPassMD5ForBase(var p1, p2, ps3: MD5Str32; const pass: string);
begin
  p1 := GenerateSalt;   p2 := GenerateSalt;
  ps3 := GetPassMD5ForBase(p1,p2,pass);  
end;


function GenerateSalt: MD5Str32;
 var
   i:integer;
   s: string;
   b: byte;
begin
  Randomize;
  s := '';
//  for i:=1 to LenSalt do s := s + chr(random(254)+1);
  for i:=1 to LenSalt do begin
    b := random(255);     
    s := s + IntToHex(b,2);
  end;
  Result := s;
end;

function SaltToHex(src: string): string;
 var
   i:integer;
   res: string;
begin
  res := '';
  for i:=1 to Length(src) do res := res + IntToHex(ord(src[i]),2);
  Result := res;
end;

function HexToSalt(src: string): string;
 var
   i:integer;
   res, s1: string;
begin
  res := '';
  i := 1;
  while ( i < Length(src)) do begin
    s1 := src[i]+src[i+1];
    res := res + chr(StrToInt('$'+s1));
    inc(i,2);
  end;
  Result := res;
end;


function MyMix1Key(ikey: string): string;
const
  cntMix = 7;
var
  DG: TMD5Digest;
  i,j,k,x,f: integer;
  str: string;
  key1, key2: Array [1..255] of char;
begin
  for i := 1 to 255 do key2[i] := chr(i); // � ������ ����� �� �������
  for f := 1 to cntMix do begin // ���-�� "�������������"
    for i := 1 to 255 do key1[i] := key2[i]; // ������������� ��������� "�����"
    // ������ "������" 
    k := 255; i:=1;
    while k > 0 do begin
       DG := MD5String(ikey[i]);
       j := 0;
       while((k > 0)and(j <= 15)) do begin
         x := DG.v[j] mod k;
         key2[255-k+1] := key1[x];
         key1[x] := key1[k];
         dec(k); inc(j);
       end;
       inc(i); if i > Length(ikey) then i := 1; // ���� ��������� ����� �� �������, �������� � ��� ������
    end;
  end; // for  
  str := '';
  for i:=1 to 255 do str := str + key2[i];
  Result := str;
end;


function CodeWithKey(src, key: string): string;
var
  i, ik:integer;
  mkey, str: string;
begin

  mkey := MyMix1Key(key);
  //��������
  ik := 1; str :='';
  for i := 1 to Length(src) do begin
    str := str + chr(ord(src[i]) xor ord(mkey[ik]));
    inc(ik);
    if ik > Length(mkey) then ik := 1;
  end;
  Result := str;
end;


procedure CodeAccount(var p1, p2: MD5Str32; SumAccount: integer; sTime:String);
var
  sr: string;
begin
  sr := IntToStr(SumAccount-17)+sTime; // ��� ����������� ���������
  p1 := MD5DigestToStr(MD5String(sr));
  p2 := SaltToHex(CodeWithKey(p1, sr));
end;


function TestPackAccount(p1, p2: MD5Str32; SumAccount: integer; sTime:String): Boolean;
var
  sp1, sp2: MD5Str32;
begin
  CodeAccount(sp1, sp2, SumAccount, sTime);
  Result := (sp1 = p1)and(sp2 = p2);
end;




end.
