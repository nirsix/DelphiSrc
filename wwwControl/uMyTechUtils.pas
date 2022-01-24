unit uMyTechUtils;

interface

uses Windows, Forms, SysUtils, ComCtrls, Classes, TLHelp32, ShellAPI, ShlObj;

const
  NIF_INFO = $00000010;

  NIIF_NONE = $00000000;
  NIIF_INFO = $00000001;
  NIIF_WARNING = $00000002;
  NIIF_ERROR = $00000003;

type
  TBalloonTimeout = 10..30 {seconds};
  TBalloonIconType = (bitNone, // нет иконки
    bitInfo,    // информационная иконка (синяя)
    bitWarning, // иконка восклицания (ж?лтая)
    bitError);  // иконка ошибки (краснаа)
    
  NotifyIconData_50 = record // определенная в shellapi.h
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..MAXCHAR] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..MAXBYTE] of AnsiChar;
    uTimeout: UINT; // union with uVersion: UINT;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
  end {record};



function TimeToMin(val: TDateTime):integer;
function TruncDateToTime(val: TDateTime): TDateTime;
function TruncDateTimeToDate(val: TDateTime): TDateTime;
function NullDateTime: TDateTime;
function EncodePass(pass: string):string;
function FindProcess(Name: String): THandle;
function WinExec32(FileName:String; PathDir: string; Visibility : integer):boolean;
function ShutdownComp(param: byte): boolean;
function DZBalloonTrayIcon(const Window: HWND; const IconID: Byte;
  const Timeout: TBalloonTimeout; const BalloonText, BalloonTitle:
  string; const BalloonIconType: TBalloonIconType): Boolean;
function GetDirSHBrowseForFolder(aTitleName: string; AHandle: HWND): string;

implementation

function TruncDateToTime(val: TDateTime): TDateTime;
begin
 Result := StrToTime(FormatDateTime('hh:nn:ss',val));
end;

function TruncDateTimeToDate(val: TDateTime): TDateTime;
begin
 Result := StrToDate(FormatDateTime('dd.mm.yyyy',val));
end;

function NullDateTime: TDateTime;
begin
 Result:=StrToTime(FormatDateTime('hh:nn:ss',StrToTime('00:00:00')));
end; 

function TimeToMin(val: TDateTime):integer;
var
  i,j: integer;
  sh,sm,ss: string;
begin
  // преобразовываем "время" в минуты
  ss:=FormatDateTime('hh:nn:ss',val);
  i:=1;
  while (ss[i]<>':') do inc(i);
  sh:=Copy(ss,1,2);
  j:=i+1;
  while (ss[j]<>':') do inc(j);
  sm:=Copy(ss,i+1,2);
  i:=j+1;
  while (ss[i]<>':')and(i<=Length(ss)) do inc(i);
  ss:=Copy(ss,j+1,2);
  Result:=StrToInt(sh)*3600+StrToInt(sm)*60+StrToInt(ss);
end;

function FindProcess(Name: String): THandle;
  var
     Handler: THandle;
     Data:    TProcessEntry32;
     ProcessID : DWORD;
     ProcessHandle : THandle;
     Srn, Sn: string;
function ReturnName: String;
var
  I    : byte;
  Names: string;
begin
  names:='';
  i:=0;
  while data.szExeFile[i] <> '' do
  begin
    names:=names+data.szExeFile[i];
    inc(i);
  end;
  ReturnName:=names;
end;
begin
  Handler:= CreateToolHelp32SnapShot(TH32CS_SNAPALL,0);
  data.dwSize:=Sizeof(data);
  if process32first(handler,data) then
    Srn:=AnsiUpperCase(ReturnName);
    Sn:=AnsiUpperCase(Name);
    if Pos(Sn,Srn) > 0 then
      Result := OpenProcess(PROCESS_ALL_ACCESS, true, data.th32ProcessID)
    else
    while process32next(handler,data) do begin
      Srn:=AnsiUpperCase(ReturnName);
      Sn:=AnsiUpperCase(Name);
      if Pos(Sn,Srn) > 0 then begin
        Result := OpenProcess(PROCESS_ALL_ACCESS, true, data.th32ProcessID);
        break;
      end
      else Result := 0;
    end;
  CloseHandle(handler);
end;

function WinExec32(FileName:String; PathDir: string; Visibility : integer):boolean;
 var
   zAppName:array[0..1000] of char;
   zAppDir:array[0..1000] of char;
   StartupInfo:TStartupInfo;
   ProcessInfo:TProcessInformation;
begin
  StrPCopy(zAppName,FileName);
  StrPCopy(zAppDir,PathDir);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_RUNFULLSCREEN;
  StartupInfo.wShowWindow := Visibility;
  Result:=CreateProcess(nil,
    zAppName,                      { указатель командной строки }
    nil,                           { указатель на процесс атрибутов безопасности }
    nil,                           { указатель на поток атрибутов безопасности }
    false,                         { флаг родительского обработчика }
    CREATE_NEW_CONSOLE,
    nil,                           { указатель на новую среду процесса }
    zAppDir,                       { указатель на имя текущей директории }
    StartupInfo,                   { указатель на STARTUPINFO }
    ProcessInfo);                  { указатель на PROCESS_INF }
end;

function EncodePass(pass: string):string;
  var
   codes, ps: string;
   i: integer;
begin
  ps:=pass;
  for i:=1 to Length(ps) do begin
    codes:=codes+chr(ord(ps[i])-i);
  end;
  Result:=codes;
end;

function ShutdownComp(param: byte): boolean;
var
  ph:THandle;
  tp,prevst:TTokenPrivileges;
  rl:DWORD;
begin

  OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,ph);
  LookupPrivilegeValue(Nil,'SeShutdownPrivilege',tp.Privileges[0].Luid);
  tp.PrivilegeCount:=1;
  tp.Privileges[0].Attributes:=2;
  AdjustTokenPrivileges(ph,FALSE,tp,SizeOf(prevst),prevst,rl);
  if param = 1 then  Result :=  ExitWindowsEx(EWX_SHUTDOWN or EWX_POWEROFF,0);
  if param = 2 then  Result :=  ExitWindowsEx(EWX_REBOOT,0);
end;


function DZBalloonTrayIcon(const Window: HWND; const IconID: Byte;
  const Timeout: TBalloonTimeout; const BalloonText, BalloonTitle:
  string; const BalloonIconType: TBalloonIconType): Boolean;
const
  aBalloonIconTypes: array[TBalloonIconType] of
    Byte = (NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR);
var
  NID_50: NotifyIconData_50;
begin
  FillChar(NID_50, SizeOf(NotifyIconData_50), 0);
  with NID_50 do begin
    cbSize := SizeOf(NotifyIconData_50);
    Wnd := Window;
    uID := IconID;
    uFlags := NIF_INFO;
    StrPCopy(szInfo, BalloonText);
    uTimeout := Timeout * 1000;
    StrPCopy(szInfoTitle, BalloonTitle);
    dwInfoFlags := aBalloonIconTypes[BalloonIconType];
  end; {with}
  Result := Shell_NotifyIcon(NIM_MODIFY, @NID_50);
end;


function GetDirSHBrowseForFolder(aTitleName: string; AHandle: HWND): string;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  Result := '';
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := AHandle;
  BrowseInfo.pszDisplayName := @DisplayName;
  BrowseInfo.lpszTitle := PChar(aTitleName);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result := TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;



end.
