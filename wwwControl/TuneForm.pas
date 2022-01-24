unit TuneForm;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes, Dialogs;

type

//  TKindParams = (XidOrgan, XIdEmployee, Xidcity, Xnamer);
//  TArrayParams = array[TKindParams]of string;

  TModeForm =(mfNew, mfEdit, mfView);
  TRecData = record
    AReloadData:Boolean;
    OffTree: Boolean; //только для CategoryR
    EnabledFlag: Boolean;
    IdEmployee: string;
    EmpName: string;
    EmpPass: string;
    IdCategory: string;
    NameCateg: string;
    IdSupplier: string;
    SuppName: string;
    IdArtData: string;
    SellingCoef: string;
    IdOrder: string;
    TransFlag: string;
    IdPageOnFace: string;
    IdMPages: string;
    PageName: string;
    TypePage: string;
    IdProperty: string;
    PropertyName: string;
    PropTypeID: string;
    PropGroup: string;   
    IdContent: string;
    NameContent: string;
    IdTypeOwner: string;
    IdTypeContent: string;
    TypeOwner: string;
    TypeContent: string;
    DateUpdate: string;
    Id2Field: string;
    Name2Field: string;
    TypeFielID: string;
    IdHRefer: string;
    LockFrom: string;
    FromType: string;
    Pos_Ancor: string;
    AncorTxt: string;
    FlagActive: string;
    IdPicture: string;
    TypePict: string;
    GroupCateg: string;

    // обязательные служебные
    AOwner: Pointer;
    AChild: Pointer;
    ANameClass: string;
    AModeForm: TModeForm;
    ACallBackProc: TNotifyEvent;
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
                 

constructor TTuneForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TTuneForm.Destroy;
begin
 if Assigned(CallBackProc)and(Assigned(PRData.AOwner)and(PRData.AReloadData)) then CallBackProc(nil);
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
     PRData.AReloadData := false;////!!!!
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
