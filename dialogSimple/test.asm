extern _MessageBoxA@16

global _m

section .data
etiqueta db 'Mi dialog',0
texto db "Texto del dialog",0

section .text
_m:
push dword 0
push dword etiqueta
push dword texto
push dword 0
call _MessageBoxA@16
ret