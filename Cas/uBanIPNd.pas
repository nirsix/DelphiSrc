unit uBanIPNd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, IBSQL, IBCustomDataSet, IBTable,
  ComCtrls, uGLBProcBD, uClasses, uMyUtils, uPlayerConnL, uNirSec, HttpsClient;

type
  TfrmBanIpNd = class(TForm)
    btOK: TButton;
    btCancel: TButton;
    Label4: TLabel;
    edNum: TEdit;
    Label2: TLabel;
    edNote: TEdit;
    ed_ipaddress: TEdit;
    ed_login: TEdit;
    Label1: TLabel;
    btLoadPlayerConn: TButton;
    Label3: TLabel;
    Label5: TLabel;
    edMacAdd: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditSTB(Sender: TObject);
    procedure NewSTB(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure InitForEdit(InParam: PTParamForm);
    procedure InitForNew(InParam: PTParamForm);
    procedure FormDestroy(Sender: TObject);
    procedure LoadDataFBase;
    procedure btOKClick(Sender: TObject);
    procedure btLoadPlayerConnClick(Sender: TObject);
  private
    { Private declarations }
    FInParam: PTParamForm; //  входящий параметр от формы хозяина
    pPlayerConnL: TParamForm;
    FbtOKClick: TNotifyEvent;
    function TestOnRight: boolean;
    procedure ForDestroyForm;
    procedure ReloadData(Sender: TObject);
    procedure SendReloadServer;    
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses uMain, uDM;

procedure TfrmBanIPNd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmBanIPNd.InitForEdit(InParam: PTParamForm);
begin
  FInParam := InParam;
  edNum.Text := InParam.rr[1];
  LoadDataFBase;
  FbtOKClick := EditSTB;
end;

procedure TfrmBanIPNd.InitForNew(InParam: PTParamForm);
begin
  FInParam := InParam;
  edNum.Text := GetGenValue('GEN_IP_BAN_ID');
  FbtOKClick := NewSTB;
end;

procedure TfrmBanIPNd.LoadDataFBase;
  var
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from IP_BAN where IDIP='+FInParam.rr[1];
      ExecQuery;
      edNum.Text := FieldByName('IDIP').AsString;
      edNote.Text := FieldByName('NOTE').AsString;
      ed_login.Text := FieldByName('LOGIN').AsString;
      ed_ipaddress.Text := FieldByName('IPADDRESS').AsString;
      edMacAdd.Text := FieldByName('MAC').AsString;           
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmBanIPNd.EditSTB(Sender: TObject);
  var
   IBTable1: TIBTable;
begin
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'IP_BAN';
      Open;
      if not Locate('IDIP',VarArrayOf([FInParam.rr[1]]),[]) then begin
        ShowMessage('Ошибка вставки! IDIP не найдено!');
        close;
        Exit;
      end;
      Edit;
      FieldByName('NOTE').AsString := edNote.Text;
      FieldByName('LOGIN').AsString := ed_login.Text;
      FieldByName('IPADDRESS').AsString := ed_ipaddress.Text;
      FieldByName('MAC').AsString := edMacAdd.Text;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;

procedure TfrmBanIPNd.NewSTB(Sender: TObject);
  var
   IBTable1: TIBTable;
begin
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'IP_BAN';
      Open; Insert;
      FieldByName('IDIP').AsString := edNum.Text;      
      FieldByName('NOTE').AsString := edNote.Text;
      FieldByName('LOGIN').AsString := ed_login.Text;
      FieldByName('IPADDRESS').AsString := ed_ipaddress.Text;
      FieldByName('MAC').AsString := edMacAdd.Text;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;

function TfrmBanIPNd.TestOnRight: boolean;
begin
  Result := true;
  if (Length(ed_ipaddress.Text)< 1)
     and (Length(edMacAdd.Text)< 1) then begin
    ShowMessage('Ошибка ввода! Нужно чтобы хотябы одно из полей ip-адреса или mac-адреса не было пустым!');
    Result := false;
    exit;
  end;
end;

procedure TfrmBanIPNd.btOKClick(Sender: TObject);
begin
 if not TestOnRight then Exit;
 if Assigned(FbtOKClick) then begin
    FbtOKClick(Sender);
    SendReloadServer;
    Close;
    if Assigned (FInParam.OnPushParam) then FInParam.OnPushParam(nil);
 end
 else ShowMessage('Сбой btOKClick! Не могу сохранить данные!');
end;


procedure TfrmBanIPNd.SendReloadServer;
var
  PortChatServer, sUrl,
  ServerHost, aPost: string;
  HttpsClient1: THttpsClient;
begin
 PortChatServer := GetParamValue('10');
 ServerHost := GetParamValue('17');
 sUrl := 'https://'+ServerHost+':'+PortChatServer;
 aPost := '11&'+KeyChangeData+'&2';
 try
  HttpsClient1 := THttpsClient.Create;
 try
   HttpsClient1.Post(sUrl,aPost);
   if HttpsClient1.Recv.Strings[2] = 'OK' then ShowMessage('Изменения успешно были переданы на сервер!');
 except
   ShowMessage('Нет связи с сервером!');
 end;
 finally
   HttpsClient1.Free;
 end;
end;

procedure TfrmBanIPNd.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBanIPNd.FormDestroy(Sender: TObject);
begin
  ForDestroyForm;
end;

procedure TfrmBanIPNd.ForDestroyForm;
begin
  FInParam.PForm := nil; // для информирования формы хозяина, что мы Destroyed
end;


procedure TfrmBanIpNd.btLoadPlayerConnClick(Sender: TObject);
begin
 with pPlayerConnL do begin
   if PForm <> nil then begin
     (PForm as TfrmPlayerConnL).Show;
     Exit;
   end;
   OnPushParam := ReloadData;
   PForm := TfrmPlayerConnL.Create(Self);
   (PForm as TfrmPlayerConnL).InitForm(@pPlayerConnL);
 end;
end;

procedure TfrmBanIPNd.ReloadData(Sender: TObject);
begin
 // LoadDataFBase;
 ed_login.Text := pPlayerConnL.rr[1];
 ed_ipaddress.Text := pPlayerConnL.rr[2];
 edMacAdd.Text := pPlayerConnL.rr[3];
end;


end.
