unit uTableNd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, IBSQL, IBCustomDataSet, IBTable,
  ComCtrls, uGLBProcBD, uClasses, uMyUtils;

type
  TfrmTableNd = class(TForm)
    btOK: TButton;
    btCancel: TButton;
    Label4: TLabel;
    edNum: TEdit;
    Label2: TLabel;
    edNote: TEdit;
    Label3: TLabel;
    edName: TEdit;
    Label1: TLabel;
    ed_ipaddress: TEdit;
    Label5: TLabel;
    ed_identity: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditSTB(Sender: TObject);
    procedure NewSTB(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure InitForEdit(InParam: PTParamForm);
    procedure InitForNew(InParam: PTParamForm);
    procedure FormDestroy(Sender: TObject);
    procedure LoadDataFBase;
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    FInParam: PTParamForm; //  входящий параметр от формы хозяина
    FbtOKClick: TNotifyEvent;
    function TestOnRight: boolean;
    procedure ForDestroyForm;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses uMain, uDM;

procedure TfrmTableNd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmTableNd.InitForEdit(InParam: PTParamForm);
begin
  FInParam := InParam;
  edNum.Text := InParam.rr[1];
  LoadDataFBase;
  FbtOKClick := EditSTB;
end;

procedure TfrmTableNd.InitForNew(InParam: PTParamForm);
begin
  FInParam := InParam;
  edNum.Text := GetGenValue('GEN_ROULETTES_ID');
  FbtOKClick := NewSTB;
end;

procedure TfrmTableNd.LoadDataFBase;
  var
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from ROULETTES where IDROUL='+FInParam.rr[1];
      ExecQuery;
      edNum.Text := FieldByName('IDROUL').AsString;
      edNote.Text := FieldByName('NOTES').AsString;
      edName.Text := FieldByName('NAMER').AsString;
      ed_ipaddress.Text := FieldByName('IPADDRESS').AsString;
      ed_identity.Text := FieldByName('IDENTITY').AsString;
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmTableNd.EditSTB(Sender: TObject);
  var
   IBTable1: TIBTable;
begin
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'ROULETTES';
      Open;
      if not Locate('IDROUL',VarArrayOf([FInParam.rr[1]]),[]) then begin
        ShowMessage('Ошибка вставки! IDROUL не найдено!');
        close;
        Exit;
      end;
      Edit;
      FieldByName('NOTES').AsString := edNote.Text;
      FieldByName('NAMER').AsString := edName.Text;
      FieldByName('IPADDRESS').AsString := ed_ipaddress.Text;
      FieldByName('IDENTITY').AsString := ed_identity.Text;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;

procedure TfrmTableNd.NewSTB(Sender: TObject);
  var
   IBTable1: TIBTable;
begin
  IBTable1 := TIBTable.Create(nil);
  try
    with IBTable1 do begin
      Database := frmDM.IBDatabaseG;
      TableName := 'ROULETTES';
      Open; Insert;
      FieldByName('IDROUL').AsString := edNum.Text;
      FieldByName('NOTES').AsString := edNote.Text;
      FieldByName('NAMER').AsString := edName.Text;
      FieldByName('IPADDRESS').AsString := ed_ipaddress.Text;
      FieldByName('IDENTITY').AsString := ed_identity.Text;
      Post; frmDM.IBTransactionG.CommitRetaining;
      Close;
    end;
  finally
    IBTable1.Free;
  end;
end;

function TfrmTableNd.TestOnRight: boolean;
begin
  Result := true;
  if Length(edName.Text)< 1 then begin
    ShowMessage('Ошибка ввода имени!');
    Result := false;
    exit;
  end;
  if Length(ed_ipaddress.Text)< 1 then begin
    ShowMessage('Ошибка ввода ipaddress!');
    Result := false;
    exit;
  end;
  if not TestOnInt(ed_identity.Text) then begin
    ShowMessage('Ошибка ввода идентификатора!');
    Result := false;
    exit;
  end;
end;

procedure TfrmTableNd.btOKClick(Sender: TObject);
begin
 if not TestOnRight then Exit;
 if Assigned(FbtOKClick) then begin
    FbtOKClick(Sender);
    Close;
    if Assigned (FInParam.OnPushParam) then FInParam.OnPushParam(nil);
 end
 else ShowMessage('Сбой btOKClick! Не могу сохранить данные!');
end;

procedure TfrmTableNd.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTableNd.FormDestroy(Sender: TObject);
begin
  ForDestroyForm;
end;

procedure TfrmTableNd.ForDestroyForm;
begin
  FInParam.PForm := nil; // для информирования формы хозяина, что мы Destroyed
end;


end.
