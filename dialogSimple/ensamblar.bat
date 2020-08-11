nasm -f win32 test.asm
REM link /subsystem:console /entry:m test.obj user32.lib
link /subsystem:windows /MERGE:.rdata=.text /entry:m test.obj user32.lib