extern _MessageBoxA@16
extern _DialogBoxParamA@20
extern _EndDialog@8
extern _PlaySoundA@12
extern _GetDlgItemTextA@16
extern _ExitProcess@4

global _m

section .data
sonido db 'DeviceConnect',0
adios db 'De verdad quieres salir?',0
mensajetexto db 'texto: '
buffertexto resb 50

section .text
_m:
push dword 0; The value to pass to the dialog box in the lParam parameter
push dword logica; DialogBox procedure
push dword 0; Parent window
push dword 101; ID de la ventana (resource.h)
push dword 0; Handle al modulo con la ventana. NULL = current executable
call _DialogBoxParamA@20
push dword 0
call _ExitProcess@4; No vale solo retornar (terminar el hilo), puesto que WinMM crea mas hilos
ret


logica: ;BOOL CALLBACK DlgProc(HWND hwnd, UINT Message, WPARAM wParam, LPARAM lParam)
cmp dword [esp+8],16; Message=WM_CLOSE
jne logicanocerrar
push dword 0x24; MB_ICONQUESTION|MB_YESNO: preguntamos si queremos salir
push dword adios
push dword adios
push dword 0
call _MessageBoxA@16
cmp eax,6; IDYES?
jne finalsalir
push dword 0; nResult
push dword [esp+8]; HWND
call _EndDialog@8
finalsalir:
mov eax,1
ret
logicanocerrar:
cmp dword [esp+8],273; Message=WM_COMMAND
jne logicadefault
cmp dword [esp+12],1002; wParam=IDRUIDO
jne logicanosonido
push dword 1; SND_ASYNC
push dword 0; HMODULE
push dword sonido;
call _PlaySoundA@12
mov eax,1
ret
logicanosonido:
cmp dword [esp+12],1003; wParam=IDIMPRIMIR
jne logicadefault
push dword 50; cchMax
push buffertexto
push dword 1001; IDTEXTO (resource.h)
push dword [esp+16]; HWND
call _GetDlgItemTextA@16
push dword 0x40; MB_ICONINFORMATION
push dword buffertexto
push dword mensajetexto
push dword 0
call _MessageBoxA@16
mov eax,1
ret
logicadefault:
mov eax,0
ret