program UnPass;

uses
  Windows, Messages;

var
  WinClass: TWndClass;
  Inst: LongWord;
  Handle, laText: HWND;
  Msg: TMsg;
  hFont: LongWord;

procedure RunStopHook(State: boolean) stdcall; external 'UnPass_dll.dll' name 'RunStopHook';

{$R UPRsrc.res}

function WindowProc(hWnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
 Result:=0;
  case uMsg of
    WM_DESTROY:
      begin
        RunStopHook(false);
        if hFont<>0
        then DeleteObject(hFont);
        PostQuitMessage(0);
      end;
    else Result:=DefWindowProc(hWnd, uMsg, wParam, lParam);
  end;
end;

begin
  Inst:=hInstance;
  with WinClass do
    begin
      style:=CS_CLASSDC or CS_PARENTDC;
      lpfnWndProc:=@WindowProc;
      hInstance:=Inst;
      hbrBackground:=COLOR_BTNFACE+1;
      lpszClassname:='TfmMain';
      hCursor:=LoadCursor(0, IDC_ARROW);
      hIcon:=LoadIcon(hInstance, 'MAINICON');
    end;
  RunStopHook(true);
  RegisterClass(WinClass);
  Handle:=CreateWindowEx(WS_EX_WINDOWEDGE, 'TfmMain', 'UnPass v1.4 - by Loonies Software', WS_VISIBLE or WS_MINIMIZEBOX or WS_CAPTION or WS_SYSMENU,
                             492, 407, 335, 85, 0, 0, Inst, nil);
  laText:=CreateWindow('Static', 'При запущенной программе, удерживая "Ctrl", кликнуть левой кнопкой мыши в поле с паролем в звездочках.', WS_VISIBLE or WS_CHILD or SS_LEFT,
               8, 4, 315, 49, Handle, 0, Inst, nil);
  hFont:=CreateFont(-11, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
                      OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                      DEFAULT_PITCH or FF_DONTCARE, 'MS Sans Serif');
  if hFont<>0 then
    SendMessage(laText, WM_SETFONT, hFont, 0);
  UpdateWindow(Handle);
  while GetMessage(Msg, 0, 0, 0) do
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
end.
