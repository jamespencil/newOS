; entrypoint for after the MBR has switched to long mode
org 0x7e00
bits 64

jmp start

vgaDriver:
    ; rdi is function to call functions are printscreen 1, clearscreen 2 more may be added
    ; rax will be set to 1 if the functon returns successfully
    ; otherwise it will be zero
    ; other function specific params will be in the function implementation and will use registers rdi rsi and rdx
    cmp rdi, 1
    je .printtext
    cmp rdi, 2
    je .clearscreen
    mov rax, 0
    ret         ; return fail if rax is invalid
.printtext:
    ; rsi is a pointer to the text to print
    ; rdx is the length of the text to print
    push rcx
    push r8
    xor r8, r8                      ; ensure r8 is 0
    mov rcx, rdx
.printChars:
    mov al, [rsi]                   ; set al to the dereferenced rsi
    mov byte [0xb8000 + r8], al
    mov byte [0xb8001 + r8], 0x0F

    add rsi, 1
    add r8, 2
    loop .printChars
    pop r8
    pop rcx
    ret

.clearscreen:
    ; Blank out the screen to a black color.
    mov edi, 0xB8000
    mov rcx, 500
    mov rax, 0x0F200F200F200F20   ; 4 spaces, white on black
    rep stosq
    ret

start:
    mov rdi, 2
    call vgaDriver
    mov rdx, 16
    mov rsi, text
    mov rdi, 1
    call vgaDriver
    jmp $

text:
    db "loaded stage two"