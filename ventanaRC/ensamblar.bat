nasm -f win32 ventanaRC.asm
link /subsystem:windows /MERGE:.rdata=.text /entry:m ventanaRC.obj ventanaRC.res user32.lib winmm.lib kernel32.lib