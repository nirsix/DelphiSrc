unit FormParam;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes;

const
 CRLF = #13+#10;

type

  TModeForm =(mfNew, mfEdit);

  TFormParam = class(TForm)
  public
    { Public declarations }
    ModeForm: TModeForm;
    CallBackProc: TNotifyEvent;
    procedure (var AInData); virtual; abstract;
  end;

implementation


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
