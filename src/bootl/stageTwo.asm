; entrypoint for after the MBR has switched to long mode
org 0x7e00
bits 64

jmp start
%include "bootDrivers.asm"


start:
    mov rdi, 2
    call vgaDriver          ; clear screen
    mov rdi, 3
    mov rsi, text
    call vgaDriver          ; get length of text
    mov rdi, 1
    call vgaDriver          ; print text
    jmp $

text:
    db "loaded stage two"