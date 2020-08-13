nasm -f win32 concatenador.asm
link /subsystem:console /MERGE:.rdata=.text /entry:m concatenador.obj kernel32.lib