unit uPlayerNd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, IBSQL, IBCustomDataSet, IBTable,
  ComCtrls, uGLBProcBD, uClasses, uMyUtils, uNirSec, HttpsClient;

type
  TfrmPlayerNd = class(TForm)
    btOK: TButton;
    btCancel: TButton;
    Label4: TLabel;
    edNum: TEdit;
    Label2: TLabel;
    edNote: TEdit;
    Label3: TLabel;
    edLogin: TEdit;
    ed_Password: TEdit;
    Label5: TLabel;
    ed_FirstName: TEdit;
    Label6: TLabel;
    ed_DateReg: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    ed_LastName: TEdit;
    Label1: TLabel;
    ed_email: TEdit;
    ed_account: TEdit;
    Label9: TLabel;
    chbChangePassword: TCheckBox;
    bt_AddToAccount: TButton;
    Label10: TLabel;
    edCity: TEdit;
    Label11: TLabel;
    edPhone: TEdit;
    cbSex: TComboBox;
    Label12: TLabel;
    cbCountry: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    cbLang: TComboBox;
    dtpBirthDay: TDateTimePicker;
    Label15: TLabel;
    Label16: TLabel;
    edFun: TEdit;
    btAddToFUN: TButton;
    chkEnabledAccount: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditSTB(Sender: TObject);
    procedure NewSTB(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure InitForEdit(InParam: PTParamForm);
    procedure InitForNew(InParam: PTParamForm);
    procedure FormDestroy(Sender: TObject);
    procedure LoadDataFBase;
    procedure btOKClick(Sender: TObject);
    procedure chbChangePasswordClick(Sender: TObject);
    procedure bt_AddToAccountClick(Sender: TObject);
    procedure btAddToFUNClick(Sender: TObject);
  private
    { Private declarations }
    FInParam: PTParamForm; //  входящий параметр от формы хозяина
    FbtOKClick: TNotifyEvent;
    Place1: MD5Str32;
    Place2: MD5Str32;
    Place3: MD5Str32;
//////    Place4: MD5Str32;
    function TestOnRight: boolean;
    procedure ForDestroyForm;
    procedure LoadAccount;
    procedure LoadcbLang;
    procedure LoadFUNAccount;
    procedure SendReloadServer;          
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses uMain, uDM;

procedure TfrmPlayerNd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmPlayerNd.InitForEdit(InParam: PTParamForm);
begin
  FInParam := InParam;
  chbChangePassword.Checked := false;
  chbChangePasswordClick(Self);
  edNum.Text := InParam.rr[1];
  LoadcbLang; // загрузка языков
  LoadDataFBase;
  FbtOKClick := EditSTB;
end;

procedure TfrmPlayerNd.InitForNew(InParam: PTParamForm);
begin
  FInParam := InParam;
  chbChangePassword.Enabled := false;
  chbChangePassword.Checked := true;
  chbChangePasswordClick(Self);
  edNum.Text := GetGenValue('GEN_USERDATA_ID');
  ed_DateReg.Text := FormatDateTime('dd.mm.yyyy',now);
  LoadcbLang; // загрузка языков
  FbtOKClick := NewSTB;
end;

procedure TfrmPlayerNd.LoadcbLang;
  var
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from REFLANG order by IDLANG ';
      ExecQuery;
      cbLang.Items.Clear;
      while not eof do begin
        cbLang.Items.Add(FieldByName('NAMELANG').AsString);
        next;
      end;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end; 
end;    

procedure TfrmPlayerNd.LoadDataFBase;
  var
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from USERDATA where IDUSER='+FInParam.rr[1];
{
       IDUSER      INTEGER NOT NULL,
       LOGIN       DTXT250 /* DTXT250 = VARCHAR(250) */,
       CITY        DTXT250 /* DTXT250 = VARCHAR(250) */,
       TELEPHON    DTXT250 /* DTXT250 = VARCHAR(250) */,
       EMAIL       DTXT250 /* DTXT250 = VARCHAR(250) */,
       NOTE        DTXT250 /* DTXT250 = VARCHAR(250) */,
       FIRSTNAME   DTXT250 /* DTXT250 = VARCHAR(250) */,
       LASTNAME    DTXT250 /* DTXT250 = VARCHAR(250) */,
       PLACE4      DPHONE /* DPHONE = VARCHAR(40) */,
        DATEREG     DATE,
        CHANGEDATA  BOOLEAN DEFAULT 0 /* BOOLEAN = CHAR(1) */,
        COUNTRY     DTXT26 /* DTXT26 = VARCHAR(26) */,
        SEX         BOOLEAN /* BOOLEAN = CHAR(1) */,
        BIRTHDAY    DATE,
       OFFUSER     BOOLEAN DEFAULT 0 /* BOOLEAN = CHAR(1) */
       PLACE1     // соль1
       PLACE2     // соль2
       PLACE3     // засоленный пароль мд5 + соль1, соль2    }
      ExecQuery;
      edNum.Text := FieldByName('IDUSER').AsString;
      edNote.Text := FieldByName('NOTE').AsString;
      ed_FirstName.Text := FieldByName('FIRSTNAME').AsString;
      edLogin.Text := FieldByName('LOGIN').AsString;
      ed_DateReg.Text := FieldByName('DATEREG').AsString;
      ed_LastName.Text := FieldByName('LASTNAME').AsString;
      ed_email.Text := FieldByName('EMAIL').AsString;
      place1 := FieldByName('PLACE1').AsString;
      place2 := FieldByName('PLACE2').AsString;
      place3 := FieldByName('PLACE3').AsString;
      edCity.Text := FieldByName('CITY').AsString;
      edPhone.Text := FieldByName('TELEPHON').AsString;
      cbCountry.Text := FieldByName('COUNTRY').AsString;
      cbCountry.ItemIndex := cbCountry.Items.IndexOf(cbCountry.Text);
      cbLang.ItemIndex := FieldByName('IDLANG').AsInteger - 1;
      cbSex.ItemIndex := FieldByName('SEX').AsInteger;      
      dtpBirthDay.Date := FieldByName('BIRTHDAY').AsDate;
      chkEnabledAccount.Checked := (FieldByName('OFFUSER').AsString = '0');
      LoadAccount;
      LoadFUNAccount;
      ed_Password.Text := '';
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmPlayerNd.EditSTB(Sender: TObject);
  var
   IBTable1: TIBTable;
begin
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'USERDATA';
      Open;
      if not Locate('IDUSER',VarArrayOf([FInParam.rr[1]]),[]) then begin
        ShowMessage('Ошибка вставки! IDUSER не найдено!');
        close;
        Exit;
      end;
      Edit;
      FieldByName('NOTE').AsString := edNote.Text;
      FieldByName('FIRSTNAME').AsString := ed_FirstName.Text;
      FieldByName('LOGIN').AsString := edLogin.Text;
      FieldByName('EMAIL').AsString := ed_email.Text;
      FieldByName('LASTNAME').AsString := ed_LastName.Text;
      
      FieldByName('CITY').AsString := edCity.Text;
      FieldByName('TELEPHON').AsString := edPhone.Text;
      FieldByName('COUNTRY').AsString := cbCountry.Text;
      FieldByName('IDLANG').AsInteger := cbLang.ItemIndex + 1;
      FieldByName('SEX').AsInteger := cbSex.ItemIndex;
      FieldByName('BIRTHDAY').AsDateTime := dtpBirthDay.Date;
      if chkEnabledAccount.Checked then FieldByName('OFFUSER').AsString := '0'
        else FieldByName('OFFUSER').AsString := '1';
      
      if chbChangePassword.Checked then begin
         SaltPassMD5ForBase(Place1,Place2,Place3,ed_Password.Text);
         FieldByName('PLACE1').AsString := place1;
         FieldByName('PLACE2').AsString := place2;
         FieldByName('PLACE3').AsString := Place3;
      end;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;

procedure TfrmPlayerNd.NewSTB(Sender: TObject);
  var
   IBTable1: TIBTable;
begin
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'USERDATA';
      Open; Insert;
      FieldByName('IDUSER').AsString := edNum.Text;
      FieldByName('NOTE').AsString := edNote.Text;
      FieldByName('FIRSTNAME').AsString := ed_FirstName.Text;
      FieldByName('LASTNAME').AsString := ed_LastName.Text;
      FieldByName('LOGIN').AsString := edLogin.Text;
      FieldByName('EMAIL').AsString := ed_email.Text;
      FieldByName('DATEREG').AsString := ed_DateReg.Text;

      FieldByName('CITY').AsString := edCity.Text;
      FieldByName('TELEPHON').AsString := edPhone.Text;
      FieldByName('COUNTRY').AsString := cbCountry.Text;
      FieldByName('IDLANG').AsInteger := cbLang.ItemIndex + 1;
      FieldByName('SEX').AsInteger := cbSex.ItemIndex;
      FieldByName('BIRTHDAY').AsDateTime := dtpBirthDay.Date;
      if chkEnabledAccount.Checked then FieldByName('OFFUSER').AsString := '0'
        else FieldByName('OFFUSER').AsString := '1';
      
      
      SaltPassMD5ForBase(Place1,Place2,Place3,ed_Password.Text);
      FieldByName('PLACE1').AsString := place1;
      FieldByName('PLACE2').AsString := place2;
      FieldByName('PLACE3').AsString := Place3;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;


function TfrmPlayerNd.TestOnRight: boolean;
begin
  Result := false;
  if Length(ed_FirstName.Text)< 1 then begin
    ShowMessage('Ошибка ввода имени!');
    exit;
  end;
  if Length(edLogin.Text)< 1 then begin
    ShowMessage('Ошибка ввода Логина!');
    exit;
  end;
  if ((Length(ed_Password.Text)< 1)and(chbChangePassword.Checked)) then begin
    ShowMessage('Ошибка! Пароль не может быть пустым!');
    exit;
  end;
  Result := true;
end;

procedure TfrmPlayerNd.btOKClick(Sender: TObject);
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

procedure TfrmPlayerNd.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPlayerNd.FormDestroy(Sender: TObject);
begin
  ForDestroyForm;
end;

procedure TfrmPlayerNd.ForDestroyForm;
begin
  FInParam.PForm := nil; // для информирования формы хозяина, что мы Destroyed
end;

procedure TfrmPlayerNd.chbChangePasswordClick(Sender: TObject);
begin
  if (chbChangePassword.Checked) then begin
    ed_Password.Enabled := true;
    ed_Password.Color := clWindow;
  end
  else begin
    ed_Password.Enabled := false;
    ed_Password.Color := cl3DLight;
  end;
end;

procedure TfrmPlayerNd.LoadAccount;
  var
    IdUser,sum: integer;
begin
  ed_account.Text :='';
  IdUser := StrToInt(edNum.Text);
  if not GetUserAccount(sum,IdUser, 'USER_AC') then begin
    ed_account.Text := 'ERROR!!!';
  end
  else begin
    ed_account.Text := IntToStr(sum);
  end;
end;

procedure TfrmPlayerNd.LoadFUNAccount;
  var
    IdUser,sum: integer;
begin
  edFun.Text :='';
  IdUser := StrToInt(edNum.Text);
  if not GetUserAccount(sum,IdUser, 'USER_ACFUN') then begin
    edFun.Text := 'ERROR!!!';
  end
  else begin
    edFun.Text := IntToStr(sum);
  end;
end;


procedure TfrmPlayerNd.bt_AddToAccountClick(Sender: TObject);
 Var
    ClickedOK: boolean;
    sval: string;
    IdUser, val: integer;
begin
   sval := '0';
   ClickedOK := InputQuery('Пополнить счет','на сумму:',sval);
   if ClickedOK then begin
     if not TestOnInt(sval) then begin
       ShowMessage('Ошибка! Неверный формат целого числа!');
       Exit;
     end;
     val := StrToInt(sval);
     IdUser := StrToInt(edNum.Text);
     STB_UserBalanceAccount(IdUser,1,val, 'USER_AC');
     LoadAccount;
     SendReloadServer;
   end;
end;



procedure TfrmPlayerNd.btAddToFUNClick(Sender: TObject);
 Var
    ClickedOK: boolean;
    sval: string;
    IdUser, val: integer;
begin
   sval := '0';
   ClickedOK := InputQuery('Пополнить FUN счет','на сумму:',sval);
   if ClickedOK then begin
     if not TestOnInt(sval) then begin
       ShowMessage('Ошибка! Неверный формат целого числа!');
       Exit;
     end;
     val := StrToInt(sval);
     IdUser := StrToInt(edNum.Text);
     STB_UserBalanceAccount(IdUser,1,val, 'USER_ACFUN');
     LoadFUNAccount;
     SendReloadServer;
   end;
end;

procedure TfrmPlayerNd.SendReloadServer;
var
  PortChatServer, sUrl,
  ServerHost, aPost: string;
  HttpsClient1: THttpsClient;
begin
 PortChatServer := GetParamValue('10');
 ServerHost := GetParamValue('17');
 sUrl := 'https://'+ServerHost+':'+PortChatServer;
 aPost := '11&'+KeyChangeData+'&1&'+edNum.Text;
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


end.
