nasm -f win32 pascalTriangle.asm
link /subsystem:console /MERGE:.rdata=.text /entry:m pascalTriangle.obj kernel32.lib