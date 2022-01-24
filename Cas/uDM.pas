unit uDM;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBSQL, IBCustomDataSet, IBTable,
  IBQuery, HttpsClient;

type
  TfrmDM = class(TDataModule)
    IBDatabaseG: TIBDatabase;
    IBTransactionG: TIBTransaction;
    IBTableG: TIBTable;
    IBSQLG: TIBSQL;
    IBQueryG: TIBQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDM: TfrmDM;

implementation

{$R *.dfm}

end.
