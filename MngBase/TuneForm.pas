unit TuneForm;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes, Dialogs;

type

//  TKindParams = (XidOrgan, XIdEmployee, Xidcity, Xnamer);
//  TArrayParams = array[TKindParams]of string;

  TModeForm =(mfNew, mfEdit, mfView);
  TRecData = record
    AReloadData:Boolean;
    IdOrgan: string;
    IdEmployee: string;
    IdLocality: string;
    EmpName: string;
    EmpPass: string;
    EmpPhone: string;
    SaveOrgan: string;
    NameCityLocality: string;
    PostIndecs: string;
    IdGroupOrg: string;
    GroupName: string;
    idTask: string;
    TaskName: string;
    DateEndTask: string;
    idAction: string;
    ActionName: string;
    IdDegree: string;
    DegreeName: string;    
    // обязательные служебные
    AOwner: Pointer;
    AChild: Pointer;
    ANameClass: string;
    AModeForm: TModeForm;
    ACallBackProc: TNotifyEvent;
    Proc1: TNotifyEvent;
  end;
  PTRecData = ^TRecData;

  TTuneForm = class(TForm)
  public
    { Public declarations }
    PRData: PTRecData;
    ModeForm: TModeForm;
    CallBackProc: TNotifyEvent;
    procedure InitForm; virtual; abstract;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;
  TClassTuneForm = class of TTuneForm;

  procedure OpenTuneForm(Args: PTRecData);

implementation

//---------Uses----------------
uses uOrganNd, OrganR, uEmploeeRef, uEmploeeNd, OrganBy1Indecs;

//===============endUses----------------


constructor TTuneForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TTuneForm.Destroy;
begin
 if Assigned(CallBackProc)and(Assigned(PRData.AOwner)) then CallBackProc(nil);
 inherited Destroy;
 PRData.AChild := nil;
end;

procedure OpenTuneForm(Args: PTRecData);
 var
  VTypeClass: TClassTuneForm;
  VNameClass: string;
begin
  try
   VTypeClass := TClassTuneForm(FindClass(Args.ANameClass));
   if Args.AChild <> nil then TTuneForm(Args.AChild).Show
   else begin
      Args.AChild := VTypeClass.Create(Args.AOwner);
     with TTuneForm(Args.AChild) do begin
     PRData := Args;
     CallBackProc := Args.ACallBackProc;
     ModeForm := Args.AModeForm;
     InitForm;
    end;
   end;
  except
    on E: Exception do ShowMessage(E.Message + ' - '+ IntToStr(E.HelpContext));
  end;
end;


end.
