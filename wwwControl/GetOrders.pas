unit GetOrders;
{
Модуль приема данных заказов с базы сайта
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, IBSQL, IBCustomDataSet, IBTable,
  ComCtrls, uGLBProcBD, uClasses, uMyUtils, HttpsClient, IdMultipartFormData,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdHeaderList, IdCoder, IdCoder3to4, IdCoderMIME,
  IdMessageCoder, IdMessageCoderMIME;

  
function GetnOrders: integer;
procedure SentOrder_OK(idorder: string);
function ParseOrdersData(InData: string): integer;


implementation


function GetnOrders: integer;
var
  vUrl, s1: string;
  formData: TIdMultiPartFormDataStream;
  IBSQLG1: TIBSQL;
  i: integer;
  FHttpsClient: THttpsClient;
begin
  Result := 0;
  FHttpsClient := THttpsClient.Create(false); // false - без SSL
 try
  vUrl := 'http://'+GetParamValue('1')+'/'+GetParamValue('2');
  formData := TIdMultiPartFormDataStream.Create;
  formData.AddFormField('action','GetNewOrders');
  formData.AddFormField('dataaction','Get');
  try
    FHttpsClient.PostData(vUrl,formData);
  except
  end;
  Result := ParseOrdersData(FHttpsClient.Recv.Text);
  if Result = 0 then Exit;
  formData.Free;

{  // удаляем принятые заказы из базы сайта
  formData := TIdMultiPartFormDataStream.Create;
  formData.AddFormField('action','ExecuteSql');
  formData.AddFormField('dataaction','delete from orders');
  FHttpsClient.PostData(vUrl,formData);
  formData.Free;

  formData := TIdMultiPartFormDataStream.Create;
  formData.AddFormField('action','ExecuteSql');
  formData.AddFormField('dataaction','delete from articleoforder');
  FHttpsClient.PostData(vUrl,formData);
  formData.Free;}
  finally
    FHttpsClient.Free;
  end;
end;

function ParseOrdersData(InData: string): integer;
const
  c_ord = 6;
  c_art = 3;
  maxcnt = 20;
  endsql = '#end#####end#';
 var
  i, lene, bi, en, enq, CountRcvSql: integer;
  str, sql1, idor : string;
begin
  CountRcvSql := 0;
  Result := 0;
  str := InData;
  bi := pos('BEGIN_OK',InData);
  if bi > 5 then Exit;
  lene := Length(endsql);
  bi := bi + Length('BEGIN_OK');
  Delete(str, 1, bi);
  en := pos(endsql, str) - 1;
  while (en > 2) do begin
    sql1 := Utf8ToAnsi(copy(str,1,en));
    // в конце запроса находится ИД заказа, вырезаем ИД
    enq := Length(sql1); idor :='';
    while( (sql1[enq]<>';')and(enq > 0) ) do begin
      idor := sql1[enq]+idor;
      dec(enq);
    end;
    sql1 := copy(sql1,1,enq);
    if ExecSqlIB_EchoOff(sql1) <> '' then begin
//      ShowMessage('Ошибка получения заказов с сервера сайта!');
//      Exit;
    end;
    SentOrder_OK(idor);

    Delete(str, 1, en+lene+1);
    en := pos(endsql, str)-1;
    inc(CountRcvSql);
  end;
  Result := CountRcvSql;
end;


procedure SentOrder_OK(idorder: string);
var
  vUrl, s1: string;
  formData: TIdMultiPartFormDataStream;
  FHttpsClient: THttpsClient;
  IdEncoderMIME1: TIdEncoderMIME;
begin
  FHttpsClient := THttpsClient.Create(false); // false - без SSL
  IdEncoderMIME1 := TIdEncoderMIME.Create(nil);
 try
  vUrl := 'http://'+GetParamValue('1')+'/'+GetParamValue('2');

  // делаем апдейт принятых данных
  formData := TIdMultiPartFormDataStream.Create;
  formData.AddFormField('action','ExecuteSql');
  s1 := 'UPDATE `orders` SET `Sent_to_Seller` = ''1'' WHERE `orders`.`idorder` ='+idorder+';';
  s1 := IdEncoderMIME1.Encode(s1);  
  formData.AddFormField('dataaction', s1);
  FHttpsClient.PostData(vUrl,formData);
  formData.Free;
  finally
    FHttpsClient.Free;
    IdEncoderMIME1.Free;
  end;
end;




end.
