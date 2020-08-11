alloc(newmem,256)
label(returnherea)
label(newmemw)
label(returnherew)

newmem:
push 00000000
push [esp+08]
push [esp+0C]
push 00000000
call user32.MessageBoxA
//originalcode
mov edi,edi
push ebp
mov ebp,esp
jmp returnherea
newmemw:
push 00000000
push [esp+08]
push [esp+0C]
push 00000000
call user32.MessageBoxW
//originalcode
mov edi,edi
push ebp
mov ebp,esp
jmp returnherew


kernel32.CreateFileA:
jmp newmem
returnherea:

kernel32.CreateFileW:
jmp newmemw
returnherew:
