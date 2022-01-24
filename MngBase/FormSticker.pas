unit FormSticker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ImgList, ComCtrls, ToolWin, IBSQL, DB,
  uClasses, Menus, WordXP, OleServer, ComObj, ulog, Buttons;

type
  TArrayStr = array[1..50000]of string;

  TSticker = record   // стикер
    nameo: array[1..10] of string; //наим. организации
    adr: array[1..10] of string; // адрес
    in_nameo: string;
    ind_adr: string;
    maxl: word; // миксимальное кол-во строк стикере
    maxs: word; // максимальна€ длина строки
    maxno: word; // максимальное кол-во строк наименов
    maxad: word; // максимальное кол-во строк в адресе
    minno: word; // мимальное кол-во строк в наименовании
    curnm: word; // текущее в наименовании кол-во строк
    curad: word; // текущее в адресе кол-во строк
    bad: boolean; // если есть слово длиннее чем maxs
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
 // формируем наименование в строки -------
  st := Stck.in_nameo;
  // собираем все слова в строке
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
  Stck.curnm := k; // кол-во сформиров. строк наим.
  // ищем длинные строки(слова) и отрезаем их с конца
  // если не получаетс€ то отбраковываем
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

 // формируем адрес в строки -------
  st := Stck.ind_adr;
  // собираем все слова в строке
  l := Length(st); j := 0; k := 1;
  for i := 1 to l do begin
    if (st[i]=',')and(i < l) then begin
      inc(j); arrst[j] := Copy(st,k,i-k+1);
      k := i + 1;
    end;
    if i = l then begin inc(j); arrst[j] := Copy(st,k,l-k+1); end;
  end;
  mx := Stck.maxs;
  // ищем длинное слово в адресе и отбраковываем
  for i := 1 to j do
    if Length(arrst[i]) > mx then begin
      Stck.bad := True;
      Exit;
    end;
  // если все ок, то подгон€ем под допустимое кол-во строк
  // в начале склеиваем улицу и номер дома
  if Length(arrst[j-1]+arrst[j]) <= mx then begin
    arrst[j-1] := arrst[j-1]+arrst[j]; // улица и номер дома
    arrst[j]:=''; dec(j);
  end;
  // склеиваем и остальные элементы адреса
  k := 0;
  while (j + k > Stck.maxad)and(j > 1) do begin // если не укладываемс€ то..
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
  // будем отбраковывать если адрес не будет вмещатьс€ (чтобы не заморачиватьс€)
  if k > Stck.maxad then begin
    Stck.bad := True;
    Exit;
  end;
  Stck.curad := k;
  // удал€ем в конце зап€тые
  for i := 2 to k do begin
    j := Length(Stck.adr[i]);
    delete(Stck.adr[i],j,1);
  end;
  // удал€ем в начале пробелы
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
     WordApp.connectkind:=ckNewInstance;//„тобы всегда новое приложение запускалось
     WordApp.Connect;
     FileName := ExtractFilePath(ParamStr(0)) + 'test.doc';
     ov1 := OleVariant(FileName);
     WordApp.Documents.Add(ov1,EmptyParam,EmptyParam,EmptyParam);
     i1 := 0; // здесь будет реальное импортированное число стикеров
     for i := 1 to CountItem do begin
       Stck.in_nameo := NameArr[i];
       // (2)39300, (3)ѕолтавська обл., (4)сел. Ќов≥ —анжари, вул. ∆овтнева, 23
       // 57055, ћиколањвська обл.,  ¬еселин≥вський р-н, с. Ќовосв≥тл≥вка, вул. Ћен≥на, 143
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
