extern _GetStdHandle@4
extern _WriteFile@20
extern _ReadConsoleA@20

global _m

section .data
counter db dword 0
stdin db dword 0
stdout db dword 0
texto1 db "Introduzca texto: "
texto2 db "Obtenido ["
linea resb 48
texto3 db "].",0xA, 0xD

section .text
_m:
push dword -10; stdin
call _GetStdHandle@4
mov [stdin],eax
push dword -11; stdout
call _GetStdHandle@4
mov [stdout],eax

loop:
push dword 0
push counter
push dword 18; strlen(texto1)
push texto1
push dword [stdout]
call _WriteFile@20

push dword 0
push counter
push dword 48
push linea
push dword [stdin]
call _ReadConsoleA@20
sub dword [counter],2; quitamos eol
jz loop; por si no introducimos nada

mov dword ecx,48; concatenamos input hasta llenar el buffer
sub ecx,[counter]
mov esi, linea
mov edi, esi
add edi,[counter]
rep movsb

push dword 0
push counter
push 62
push texto2
push dword [stdout]
call _WriteFile@20

jmp loop
