{***************************************************************
* Project : <This is the name of your project>
* Unit Name: HTTPS Client Kernel 
* Purpose : <This is a description of the project>
* Author : <Your Name>
* Date : <Date submitted to indy demo team>
* Other Info : <Anything else>
* History :
*           <History list>
****************************************************************}

unit HttpsClient;

interface

uses
  SysUtils, Variants, Classes, Controls, IdServerIOHandler, IdSSL,
  IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdBaseComponent, IdComponent,  IdTCPConnection, IdTCPClient,
  IdHTTP, StdCtrls, IdMultipartFormData;



const
  crosdname111 = 'crossdomain.xml';

type
  TOnRecvData = procedure(var Answer: string; AData: TStrings) of object;
  THttpsClient = class(TObject)
  private
    { Private declarations }
    FOnHeadersAvailable: TIdHTTPOnHeadersAvailable;
    FOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    FOnRecvData: TOnRecvData;
    FRecv: TStringList;
  protected
    procedure SetHeadersAvailable(AIdHTTPOnHeadersAvailable: TIdHTTPOnHeadersAvailable);
  public
    { Public declarations }
    FClient: TIdHTTP;
    constructor Create(IO_SSL: boolean);
    destructor Destroy; override;
    procedure Post(aUrl, aPost: string);
    procedure PostData(aUrl: string; ASource: TIdMultiPartFormDataStream);
    procedure DeleteSubStr(var Source: string; SubStr: string);
    procedure ParseResult(Res: String);
  published
   { Published declarations }
    property OnRecvData: TOnRecvData read FOnRecvData write FOnRecvData;
    property OnHeadersAvailable: TIdHTTPOnHeadersAvailable read FOnHeadersAvailable write SetHeadersAvailable;
    property Recv: TStringList read FRecv;
  end;


implementation


// ------ BEGIN of init------------------
constructor THttpsClient.Create(IO_SSL: boolean);
begin
  inherited Create;
  FClient := TIdHTTP.Create;
  FClient.ProtocolVersion := pv1_1;
  FClient.AllowCookies := false;
  FOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create;
  FOpenSSL.SSLOptions.Method := sslvSSLv3;
  if IO_SSL then FClient.IOHandler := FOpenSSL;
  FRecv := TStringList.Create;
end;

procedure THttpsClient.SetHeadersAvailable(AIdHTTPOnHeadersAvailable:TIdHTTPOnHeadersAvailable);
begin
  FOnHeadersAvailable := AIdHTTPOnHeadersAvailable;
  FClient.OnHeadersAvailable := AIdHTTPOnHeadersAvailable;
end;

procedure THttpsClient.PostData(aUrl: string; ASource: TIdMultiPartFormDataStream);
var
  Stream1:TMemoryStream;
  sr : string;
  Size: integer;
begin
  Stream1 := TMemoryStream.Create;
  try
   FClient.Post(aUrl, ASource, Stream1);
   Stream1.Position := 0;
   Size := Stream1.Size - Stream1.Position;
   SetString(sr, nil, Size);
   Stream1.Read(Pointer(sr)^, Size);
//   DeleteSubStr(sr, #10);
//   DeleteSubStr(sr, #13);
   ParseResult(sr);
  finally
   Stream1.Free;
  end;
end;

procedure THttpsClient.Post(aUrl, aPost: string);
var
  dataa:TStringList;
  sr: string;
begin
  dataa := TStringList.Create;
  dataa.Text := aPost;
  sr := FClient.Post(aUrl,dataa);
  DeleteSubStr(sr, #10);
  DeleteSubStr(sr, #13);
  ParseResult(sr);
  dataa.Free;
end;

procedure THttpsClient.DeleteSubStr(var Source: string; SubStr: string);
var
  i: integer;
begin
  i := pos(SubStr, Source);
  while( i > 0) do begin
    Delete(Source,i,Length(SubStr));
    i := pos(SubStr, Source);
  end;
end;

procedure THttpsClient.ParseResult(Res: String);
var
  i: integer;
  tm, s: string;
begin
  tm := Res;
  FRecv.Clear;
  s := '&';
  i := pos(s,tm);
  while( i > 0) do begin
    FRecv.Add(Copy(tm,1,i-1));
    Delete(tm,1,i);
    i := pos(s, tm);
  end;
  if tm <> '' then FRecv.Add(tm);
end;

                    

destructor THttpsClient.Destroy;
begin
  FRecv.Free;
  FClient.Free;
  FOpenSSL.Free;
  inherited Destroy;
end;

end.
