unit FormSticker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, Menus, WordXP, OleServer, ComObj, ulog, Buttons;

type
  TArrayStr = array[1..50000]of string;

  TSticker = record   // ������
    nameo: array[1..10] of string; //����. �����������
    adr: array[1..10] of string; // �����
    in_nameo: string;
    ind_adr: string;
    maxl: word; // ������������ ���-�� ����� �������
    maxs: word; // ������������ ����� ������
    maxno: word; // ������������ ���-�� ����� ��������
    maxad: word; // ������������ ���-�� ����� � ������
    minno: word; // ��������� ���-�� ����� � ������������
    curnm: word; // ������� � ������������ ���-�� �����
    curad: word; // ������� � ������ ���-�� �����
    bad: boolean; // ���� ���� ����� ������� ��� maxs
  end;

procedure StrToSticker(var Stck: TSticker);
function ImportStickerToWord(NameArr, AddrArr: TArrayStr; CountItem: integer): integer;


implementation

uses uMain, uDM;


procedure StrToSticker(var Stck: TSticker);
var
  i,j,k,mx,l: integer;
  st: string;
  arrst: array[1..100] of string;
begin
  Stck.bad := false;
 // ��������� ������������ � ������ -------
  st := Stck.in_nameo;
  // �������� ��� ����� � ������
  l := Length(st); j := 0; k := 1;
  for i := 1 to l do begin
    if (st[i]=' ')and(i < l) then begin
      inc(j); arrst[j] := Copy(st,k,i-k+1);
      k := i + 1;
    end;
    if i = l then begin inc(j); arrst[j] := Copy(st,k,l-k+1); end;
  end;
  mx := Stck.maxs; st:=arrst[1]; k:=0; i:=2;
  with Stck do
    while i <= j do begin
      if Length(st+arrst[i])<= mx then
        st := st + arrst[i]
      else begin
        inc(k); nameo[k] := st;
        st := arrst[i];
      end;
      inc(i);
    end; //   while i <= j do begin
  inc(k); Stck.nameo[k] := st;
  Stck.curnm := k; // ���-�� ���������. ����� ����.
  // ���� ������� ������(�����) � �������� �� � �����
  // ���� �� ���������� �� �������������
  i := 1;
  while i <= Stck.curnm do begin
    if (Length(Stck.nameo[i]) > mx)and(i>Stck.minno) then begin
      Stck.curnm := i-1;
      Break;
    end;
    if (Length(Stck.nameo[i]) > mx)and(i<=Stck.minno) then begin
      Stck.bad := true;
      Exit;
    end;
    inc(i);
  end;// while i <= Stck.curnm do begin
  if Stck.curnm > Stck.maxno then Stck.curnm := Stck.maxno;

 // ��������� ����� � ������ -------
  st := Stck.ind_adr;
  // �������� ��� ����� � ������
  l := Length(st); j := 0; k := 1;
  for i := 1 to l do begin
    if (st[i]=',')and(i < l) then begin
      inc(j); arrst[j] := Copy(st,k,i-k+1);
      k := i + 1;
    end;
    if i = l then begin inc(j); arrst[j] := Copy(st,k,l-k+1); end;
  end;
  mx := Stck.maxs;
  // ���� ������� ����� � ������ � �������������
  for i := 1 to j do
    if Length(arrst[i]) > mx then begin
      Stck.bad := True;
      Exit;
    end;
  // ���� ��� ��, �� ��������� ��� ���������� ���-�� �����
  // � ������ ��������� ����� � ����� ����
  if Length(arrst[j-1]+arrst[j]) <= mx then begin
    arrst[j-1] := arrst[j-1]+arrst[j]; // ����� � ����� ����
    arrst[j]:=''; dec(j);
  end;
  // ��������� � ��������� �������� ������
  k := 0;
  while (j + k > Stck.maxad)and(j > 1) do begin // ���� �� ������������ ��..
    if Length(arrst[j-1]+arrst[j])<= mx then begin
      arrst[j-1] := arrst[j-1]+arrst[j];
      arrst[j]:='';
    end
    else begin
       inc(k); Stck.adr[k]:= arrst[j];
    end;
    dec(j);
  end;
  if j=0 then inc(j);
  for i:=j downto 1 do begin
    inc(k);
    Stck.adr[k]:= arrst[i];
  end;
  // ����� ������������� ���� ����� �� ����� ��������� (����� �� ��������������)
  if k > Stck.maxad then begin
    Stck.bad := True;
    Exit;
  end;
  Stck.curad := k;
  // ������� � ����� �������
  for i := 2 to k do begin
    j := Length(Stck.adr[i]);
    delete(Stck.adr[i],j,1);
  end;
  // ������� � ������ �������
  for i := 1 to k do begin
    if length(Stck.adr[i]) > 0 then
         while Stck.adr[i][1] = ' ' do Delete(Stck.adr[i],1,1);
  end;

end;


function ImportStickerToWord(NameArr, AddrArr: TArrayStr; CountItem: integer): integer;
var
  FileName: String;
  ov1: OleVariant;
  i,i1,j, k, h: integer;
  Stck: TSticker;
  WordApp: TWordApplication;
//  WordApp1: TWordDocument;
begin

     WordApp := TWordApplication.Create(nil);
   try
     WordApp.connectkind:=ckNewInstance;//����� ������ ����� ���������� �����������
     WordApp.Connect;
     FileName := ExtractFilePath(ParamStr(0)) + 'test.doc';
     ov1 := OleVariant(FileName);
     WordApp.Documents.Add(ov1,EmptyParam,EmptyParam,EmptyParam);
     i1 := 0; // ����� ����� �������� ��������������� ����� ��������
     for i := 1 to CountItem do begin
       Stck.in_nameo := NameArr[i];
       // (2)39300, (3)���������� ���., (4)���. ��� �������, ���. ��������, 23
       // 57055, ����������� ���.,  ������������� �-�, �. �����������, ���. �����, 143
//       Stck.ind_adr := Cells[Sr[2],i]+cm+Cells[Sr[3],i]+cm+Cells[Sr[4],i];
       Stck.ind_adr := AddrArr[i];
       Stck.minno := 4;
       Stck.maxs := 35;
       if (i1 mod 8) = 0 then begin
         Stck.maxno := 5;
         Stck.maxad := 4;
       end
       else begin
         Stck.maxno := 5;
         Stck.maxad := 5;
       end;
       StrToSticker(Stck);
       if not(Stck.bad) then begin
         inc(i1);
         Writelog('-----------------------------------------');         
         Writelog(IntToStr(i1));         
         try
         k := Stck.maxno - Stck.curnm;
         h := Stck.maxad - Stck.curad;
         Writelog('k='+IntToStr(k));
         Writelog('h='+IntToStr(h));
         WordApp.Selection.Font.Size := 7;
         WordApp.Selection.Font.Bold := 1;
         WordApp.Selection.ParagraphFormat.LineSpacing := 12;
         for j:=1 to k do WordApp.Selection.TypeText(' '+#13#10);
         for j:=1 to Stck.curnm do begin
           WordApp.Selection.TypeText(Stck.nameo[j]+#13#10);
           Writelog(Stck.nameo[j]);
         end;
         WordApp.Selection.Font.Size := 10;
         WordApp.Selection.Font.Bold := 0;
         WordApp.Selection.ParagraphFormat.LineSpacing := 10.6;
         for j:=1 to Stck.curad do begin
           WordApp.Selection.TypeText(Stck.adr[j]+#13#10);
           Writelog(Stck.adr[j]);
         end;
         for j:=1 to h do WordApp.Selection.TypeText(' '+#13#10);
         WordApp.Selection.Font.Size := 12;
         WordApp.Selection.TypeText(' '+#13#10);
         except
           Writelog('ERROR!!! '+inttostr(Stck.maxad));
           Writelog('ERROR!!! '+inttostr(i1));
         end;
       end;
      // if i = 30 then Break;
     end;
     WordApp.Visible := True;
     WordApp.WindowState := 1;
     WordApp.Activate;
     WordApp.Disconnect;
   finally
     WordApp.Free;
   end;
   Result := i1;
end;

end.
