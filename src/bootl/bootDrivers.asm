bits 64
extern vgaDriver
vgaDriver:
    ; rdi is function to call functions are printscreen 1, clearscreen 2 more may be added
    ; rax will be set to 1 if the functon returns successfully
    ; otherwise it will be zero
    ; other function specific params will be in the function implementation and will use registers rdi rsi and rdx
    cmp rdi, 1
    je .printtext
    cmp rdi, 2
    je .clearscreen
    cmp rdi, 3
    je .getNullTSLength
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
.getNullTSLength:
    ; get the length of a null terminated string
    ; rsi is the address of the string
    ; length will be returned to rdx for easy .printCharsCalling
    xor rdx, rdx
    push rsi
.loopPoint:
    cmp byte [rsi], 0
    je .foundLength
    inc rdx
    inc rsi
    jmp .loopPoint
.foundLength:
    pop rsi
    ret

.clearscreen:
    ; Blank out the screen to a black color.
    mov edi, 0xB8000
    mov rcx, 500
    mov rax, 0x0F200F200F200F20   ; 4 spaces, white on black
    rep stosq
    ret
