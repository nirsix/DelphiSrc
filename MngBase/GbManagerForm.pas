unit GbManagerForm;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes;

const
 CRLF = #13+#10;

type

  TfrmOrganNd = class;

  TClassForm = class of TForm;
  TFormParam = record
    ParentForm: TForm;
    ChildForm: TForm;
    OnBackProc: TNotifyEvent;
  end;

  TManagerForm = class(TComponent)
  public
    { Public declarations }
    frmOrganNd: TfrmOrganNd;
    constructor Create(AOwner: TComponent); overload; override;
    destructor Destroy; override;
    procedure OpenForm(AForm: TForm; ATypeClass: TClassForm);
    procedure OpenfrmOrganNd;
  end;

implementation

uses uOrganNd;

constructor TManagerForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TManagerForm.Destroy;
begin
  inherited Destroy;
end;

procedure TManagerForm.OpenForm(AForm: TForm; ATypeClass: TClassForm);
begin
   if Assigned(AForm) then AForm.Show
   else begin
     AForm := ATypeClass.Create(Self);
   end;
end;

procedure TManagerForm.OpenfrmOrganNd;
begin
   OpenForm(frmOrganNd, TfrmOrganNd);
   frmOrganNd.InitForEdit(nil);
end;





end.
