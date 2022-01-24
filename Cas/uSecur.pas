unit uSecur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, IBSQL, IBCustomDataSet, IBTable,
  ComCtrls, uGLBProcBD, uClasses, uMyUtils, uCripPrk;

type  
  TfrmSecur = class(TForm)
    btOK: TButton;
    Label3: TLabel;
    edName: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure InitForm(InParam: PTParamForm);
    procedure FormDestroy(Sender: TObject);
    procedure LoadDataFBase;
    procedure btOKClick(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FInParam: PTParamForm; //  вход€щий параметр от формы хоз€ина
    FbtOKClick: TNotifyEvent;
    FPass: string;
    procedure ForDestroyForm;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses uMain, uDM;

procedure TfrmSecur.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FInParam.rr[1] <> '1' then FInParam.rr[1] := '2';
  if Assigned (FInParam.OnPushParam) then FInParam.OnPushParam(nil);
  Action := caFree;
end;

procedure TfrmSecur.InitForm(InParam: PTParamForm);
begin
  FInParam := InParam;
  edName.SetFocus;
  LoadDataFBase;
end;

procedure TfrmSecur.LoadDataFBase;
  var
    IBSQLG1: TIBSQL;
begin
  IBSQLG1 := TIBSQL.Create(nil);
  try
    with IBSQLG1 do begin
      Database := frmDM.IBDatabaseG;
      Sql.Text := ' select * from SAAP where ID=1';
      ExecQuery;
      FPass := DeCodeStrS(FieldByName('VALUEP').AsString);
      Close;
    end;
  finally
    IBSQLG1.Free;
  end;
end;

procedure TfrmSecur.btOKClick(Sender: TObject);
begin
 if edName.Text = FPass then begin
   FInParam.rr[1] := '1';
   if Assigned (FInParam.OnPushParam) then FInParam.OnPushParam(nil);
   Close;
 end
 else begin
   ShowMessage('Ќеверный пароль!');
   edName.SetFocus;
 end;  
end;

procedure TfrmSecur.FormDestroy(Sender: TObject);
begin
  ForDestroyForm;
end;

procedure TfrmSecur.ForDestroyForm;
begin
  FInParam.PForm := nil; // дл€ информировани€ формы хоз€ина, что мы Destroyed
end;


procedure TfrmSecur.edNameKeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then btOKClick(nil);
end;

end.
