unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, IniFiles, ExtCtrls, StdCtrls, uClasses, IBSQL, OleServer,
  Grids, ActnList, ComCtrls, uGLBProcBD, uTablesRef, uParams, uPass,
  uSecur, uRoulStatRef, uPlayersRef, uUsersStatRoul, uTotalUsersRoul,
  uPlayerConnL, uBanIPL, HttpsClient;

const
  ctIFalse ='F';
  ctITrue ='T';
  CRLF = #13+#10;


type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    mnImport: TMenuItem;
    ActionList1: TActionList;
    acSetStg: TAction;
    acUpdateBase: TAction;
    OpenDialog1: TOpenDialog;
    mi_Tables: TMenuItem;
    mn_Parametrs: TMenuItem;
    mi_ParamsMain: TMenuItem;
    miSaap: TMenuItem;
    N1: TMenuItem;
    miRoulStat: TMenuItem;
    miPlayers: TMenuItem;
    miRoulStatUser: TMenuItem;
    miTotalUsersRoul: TMenuItem;
    miBANLISTIP1: TMenuItem;
    miPlayersConn: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure acSetStgExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mi_TablesClick(Sender: TObject);
    procedure mi_ParamsMainClick(Sender: TObject);
    procedure miSaapClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ExitForm(Sender: TObject);
    procedure miRoulStatClick(Sender: TObject);
    procedure miPlayersClick(Sender: TObject);
    procedure miRoulStatUserClick(Sender: TObject);
    procedure miTotalUsersRoulClick(Sender: TObject);
    procedure miPlayersConnClick(Sender: TObject);
    procedure miBANLISTIP1Click(Sender: TObject);

  private
    { Private declarations }
    FEnter: boolean;
    procedure InitBase;

  public
    { Public declarations }
    AppDir: string;
    pTablesRef: TParamForm;
    pParams: TParamForm;
    pSaap: TParamForm;
    pPass: TParamForm;
    pRoulStat: TParamForm;
    pPlayersRef: TParamForm;
    pUsersStatRoul: TParamForm;
    pTotalUsersRoul: TParamForm;
    pPlayerConnL: TParamForm;
    pBanIPL: TParamForm;
  end;

var
  frmMain: TfrmMain;


implementation

{$R *.dfm}
uses uDM, uStgConfig;



//-----------Begin----- Раздел № 1, создание дочерних форм-------------------------
//-----------End----- Раздел № 1, инициализация приложения-------------------------


//-----------Begin----- Раздел № 1, инициализация приложения-----------------------
procedure TfrmMain.FormCreate(Sender: TObject);
begin
 AppDir := ExtractFilePath(ParamStr(0));
 InitBase;
end;

procedure TfrmMain.InitBase;
var
  IniFile: TIniFile;

begin
 FEnter := false;
 try
   IniFile := TIniFile.Create(AppDir+'config.ini');
   frmDM.IBDatabaseG.DatabaseName := IniFile.ReadString('Main','SERVERNAME','');
   frmDM.IBDatabaseG.Connected := False;
   frmDM.IBDatabaseG.Params.Clear;
   IniFile.ReadSectionValues('Database', frmDM.IBDatabaseG.Params);
   frmDM.IBDatabaseG.Connected := True;
   frmDM.IBTransactionG.Active := True;
   IniFile.Free;
 except
   Application.Terminate;
   raise;
 end;
end;
//-----------End----- Раздел № 1, инициализация приложения-------------------------



//-----------Begin----- Раздел № 2, создание дочерних форм-------------------------


//-----------End----- Раздел № 2, создание дочерних форм---------------------------


//-----------Begin----- Раздел № 3, функции и процедуры формы----------------------


//-----------End----- Раздел № 3, функции и процедуры формы------------------------



procedure TfrmMain.acSetStgExecute(Sender: TObject);
begin
 frmStgConfig := TfrmStgConfig.Create(Self);
 frmStgConfig.InitForm;
end;


procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FEnter then  if MessageDlg('Выйти из программы?', mtWarning, [mbYes, mbNo], 0) = mrNo then CanClose := false;
end;


procedure TfrmMain.mi_TablesClick(Sender: TObject);
begin
 with pTablesRef do begin
   if PForm <> nil then begin
     (PForm as TfrmTablesRef).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmTablesRef.Create(Self);
   (PForm as TfrmTablesRef).InitForm(@pTablesRef);
 end;
end;

procedure TfrmMain.mi_ParamsMainClick(Sender: TObject);
begin
 with pParams do begin
   if PForm <> nil then begin
     (PForm as TfrmParams).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmParams.Create(Self);
   (PForm as TfrmParams).InitForm(@pParams);
 end;
end;

procedure TfrmMain.miSaapClick(Sender: TObject);
begin
 with pSaap do begin
   if PForm <> nil then begin
     (PForm as TfrmPass).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmPass.Create(Self);
   (PForm as TfrmPass).InitForm(@pSaap);
 end;
end;

procedure TfrmMain.miRoulStatClick(Sender: TObject);
begin
 with pRoulStat do begin
   if PForm <> nil then begin
     (PForm as TfrmRoulStatRef).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmRoulStatRef.Create(Self);
   (PForm as TfrmRoulStatRef).InitForm(@pRoulStat);
 end;
end;

procedure TfrmMain.miPlayersClick(Sender: TObject);
begin
 with pPlayersRef do begin
   if PForm <> nil then begin
     (PForm as TfrmPlayersRef).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmPlayersRef.Create(Self);
   (PForm as TfrmPlayersRef).InitForm(@pPlayersRef);
 end;

end;

procedure TfrmMain.miRoulStatUserClick(Sender: TObject);
begin
 with pUsersStatRoul do begin
   if PForm <> nil then begin
     (PForm as TfrmUsersStatRoul).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmUsersStatRoul.Create(Self);
   (PForm as TfrmUsersStatRoul).InitForm(@pUsersStatRoul);
 end;
end;

procedure TfrmMain.miTotalUsersRoulClick(Sender: TObject);
begin
 with pTotalUsersRoul do begin
   if PForm <> nil then begin
     (PForm as TfrmTotalUsersRoul).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmTotalUsersRoul.Create(Self);
   (PForm as TfrmTotalUsersRoul).InitForm(@pTotalUsersRoul);
 end;
end;

procedure TfrmMain.miPlayersConnClick(Sender: TObject);
begin
 with pPlayerConnL do begin
   if PForm <> nil then begin
     (PForm as TfrmPlayerConnL).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmPlayerConnL.Create(Self);
   (PForm as TfrmPlayerConnL).InitForm(@pPlayerConnL);
 end;
end;

procedure TfrmMain.miBANLISTIP1Click(Sender: TObject);
begin
 with pBanIPL do begin
   if PForm <> nil then begin
     (PForm as TfrmBanIPL).Show;
     Exit;
   end;
   OnPushParam := nil;
   PForm := TfrmBanIPL.Create(Self);
   (PForm as TfrmBanIPL).InitForm(@pBanIPL);
 end;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
 if not FEnter then begin
   self.Enabled := false;
   with pPass do begin
     OnPushParam := ExitForm;
     PForm := TfrmSecur.Create(Self);
     (PForm as TfrmSecur).InitForm(@pPass);
   end;
 end;
end;

procedure TfrmMain.ExitForm(Sender: TObject);
begin
  if pPass.rr[1] = '1' then  begin
    self.Enabled := true;
    FEnter := true;
    Exit;
  end;
  Close;
end;          

end.
