;In this example I implement my own integer-to-string print function, and play with heap and memory allocation using WIN32 API

extern _GetStdHandle@4
extern _WriteFile@20
extern _HeapCreate@12
extern _HeapAlloc@12
extern _HeapFree@12

global _m

section .data
counter db dword 0
stdin db dword 0
stdout db dword 0
heap db dword 0
sc db ' '
sl db 0xD, 0xA

section .text

printint: ;print number in EAX
;push ebp
mov ebp,0; digit counter
mov ecx,10; divisor
;mov eax,[esp+8]
printintloop:
mov edx,0
div ecx
dec esp
add dl,'0'
mov [esp],dl
inc ebp
test eax,eax; eax==0
jnz printintloop

mov eax,esp; pointer to number string
push dword 0
push counter
push ebp; length
push eax
push dword [stdout]
call _WriteFile@20

add esp,ebp
;pop ebp
ret

printsp:
push dword 0
push counter
push 1; length
push sc
push dword [stdout]
call _WriteFile@20
ret

printnl:
push dword 0
push counter
push 2; length
push sl
push dword [stdout]
call _WriteFile@20
ret

printrow: ;print row in ESI of size EBX
push 0; we need a counter
mov eax,0
prloop:
mov eax,[esi+eax*4]
call printint
inc dword [esp]
mov eax,[esp]
cmp eax,ebx
je exitprloop
call printsp
mov eax,[esp]
jmp prloop
exitprloop:
add esp,4
call printnl
ret

calcrow: ;calc new row in EDI of size EBX from ESI
mov ecx,2; we need a counter
mov dword [edi],1
calcrowloop:
cmp ecx,ebx
je endcalcrowloop
mov eax,[esi+ecx*4-8]
add eax,[esi+ecx*4-4]
mov [edi+ecx*4-4],eax
inc ecx
jmp calcrowloop
endcalcrowloop:
mov dword [edi+ebx*4-4],1
ret

_m:
push dword -10; stdin
call _GetStdHandle@4
mov [stdin],eax
push dword -11; stdout
call _GetStdHandle@4
mov [stdout],eax
;create heap for mem alloc
push 1024*8; max heap size
push 1024*4; actual heap size
push 5; options=HEAP_GENERATE_EXCEPTIONS|HEAP_NO_SERIALIZE
call _HeapCreate@12
mov [heap],eax

mov ebx,1; row counter

push 4; size in bytes (first row to allocate)
push 0; no flags
push dword [heap]
call _HeapAlloc@12

mov dword [eax],1
mov esi,eax; row pointers we be esi,edi registers

rowloop:
call printrow
inc ebx

mov eax,ebx
shl eax,2
push eax; size in bytes
push 0; no flags
push dword [heap]
call _HeapAlloc@12
mov edi,eax

call calcrow

push esi ; memory pointer
push 0; no flags
push dword [heap]
call _HeapFree@12

mov esi,edi
cmp ebx,16; 16 rows
jne rowloop
call printrow

push esi ; memory pointer
push 0; no flags
push dword [heap]
call _HeapFree@12
ret
