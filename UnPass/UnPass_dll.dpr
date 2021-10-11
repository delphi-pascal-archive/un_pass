library UnPass;

uses
  Windows, Messages;

var
  SysHook: HHOOK = 0;
  Wnd: HWND = 0;

function SysMsgProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  CallNextHookEx(SysHook, nCode, wParam, lParam);
  if nCode = HC_ACTION then
    begin
      Wnd:=TMsg(Pointer(lParam)^).hwnd;
      if TMsg(Pointer(lParam)^).message = WM_LBUTTONDOWN then
        if (TMsg(Pointer(lParam)^).wParam and MK_CONTROL) = MK_CONTROL then
          begin
            SendMessage(Wnd, EM_SETPASSWORDCHAR, 0, 0);
            InvalidateRect(Wnd, nil, true);
          end;
    end;
end;

procedure RunStopHook(State: boolean); export; stdcall;
begin
  if State then
    SysHook:=SetWindowsHookEx(WH_GETMESSAGE, @SysMsgProc, hInstance, 0)
  else
    begin
      UnhookWindowsHookEx(SysHook);
      SysHook:=0;
    end;
end;

exports
  RunStopHook name 'RunStopHook';

begin
end.
