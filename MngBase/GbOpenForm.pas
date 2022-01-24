unit GbOpenForm;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes;

const
 CRLF = #13+#10;

type
  TKindParams = (XidOrgan, XIdEmployee, Xidcity, Xnamer);
  TArrayParams = array[TKindParams]of string;

  TOrganNd = class
    IdOrgan: string;
    IdEmployee: string;
    ParentForm: TForm;
    SelfForm: TForm;
    OnBackProc: TNotifyEvent;
  end;

  TManagerForm = class
    OrganNd: TOrganNd;
  end;

  TFormParam = record   // запись для передачи параметров между формами
    PParent: TArrayParams;
    PChild: TArrayParams;
    ParentForm: TForm;//Pointer;
    ChildForm: TForm;//Pointer;
    OnBackProc: TNotifyEvent;
  end;
  PTFormParam = ^TFormParam;


implementation




end.