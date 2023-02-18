%include "lib.asm"

section .data; сегмент инициализированных переменных
    ExitMsg db "Result is :",10 ; выводимое сообщение
    lenExit equ $-ExitMsg
    
    AMsg db "Enter A : ", 0xa
    lenAMsg equ $-AMsg

    BMsg db "Enter B : ", 0xa
    lenBMsg equ $-BMsg

    KMsg db "Enter K : ", 0xa
    lenKMsg equ $-KMsg

    XMsg db "Enter X : ", 0xa
    lenXMsg equ $-XMsg

; сегмент неинициализированных переменных
section .bss
    InBuf resb 10 ; буфер для вводимой строки
    OutBuf resb 4 ; буфер для выводимой строки
    lenIn equ $-InBuf
    lenOut equ $-OutBuf

    X   resb 10
    A   resb 10
    B   resb 10
    K   resb 10
    RES resb 10

section .text ; сегмент кода
global _start
_start:
    ; write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, AMsg ; адрес выводимой строки
    mov rdx, lenAMsg ; длина строки
    syscall; вызов системной функции
    ; read
    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, InBuf ; Address of input buffer
    mov rdx, lenIn ; Maximum length to read
    syscall

    mov rdi, InBuf; Pass address of input buffer to StrToInt64
    call StrToInt64
    cmp rbx, 0
    jne 0
    ;content of InBuf goes to rax
    mov [A], rax
    
    ;write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, XMsg ; адрес выводимой строки
    mov rdx, lenXMsg ; длина строки
    syscall; вызов системной функции
    ; read
    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, InBuf ; Address of input buffer
    mov rdx, lenIn ; Maximum length to read
    syscall

    mov rdi, InBuf; Pass address of input buffer to StrToInt64
    call StrToInt64
    cmp rbx, 0
    jne 0
    ;content of InBuf goes to rax
    mov [X], rax

    ;write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, BMsg ; адрес выводимой строки
    mov rdx, lenBMsg ; длина строки
    syscall; вызов системной функции
    ; read
    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, InBuf ; Address of input buffer
    mov rdx, lenIn ; Maximum length to read
    syscall

    mov rdi, InBuf; Pass address of input buffer to StrToInt64
    call StrToInt64
    cmp rbx, 0
    jne 0
    ;content of InBuf goes to rax
    mov [B], rax


    ;write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, KMsg ; адрес выводимой строки
    mov rdx, lenKMsg ; длина строки
    syscall; вызов системной функции
    ; read
    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, InBuf ; Address of input buffer
    mov rdx, lenIn ; Maximum length to read
    syscall

    mov rdi, InBuf; Pass address of input buffer to StrToInt64
    call StrToInt64
    cmp rbx, 0
    jne 0
    ;content of InBuf goes to rax
    mov [K], rax

    ;CALCULATIONS
    mov  rax, [A]; AX:=A
    mov  rbx, [X]; BX:=X
    imul rbx; AX:=A*X
    mov [RES], rax; RES:=A*X
    mov rax, 3; AX:= 3
    mov rbx, [K]; BX:= K
    idiv rbx; AX:=3/K
    mov rbx, [B]; BX:=B
    add rax, rbx; AX:=3/K+B
    mov rbx, 3; BX:=3
    imul rbx; AX:=3*(3/K+B)
    mov rbx, [RES]; BX:=RES
    sub rbx, rax; RES:=A*X-3*(3/K+B)
    ;SAVE IN RES
    mov [RES], rbx
    
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ExitMsg ; адрес выводимой строки
    mov rdx, lenExit ; длина строки
    syscall; вызов системной функции    

    mov rsi, OutBuf; Pass address of output buffer to IntToStr64
    mov rax, [RES]
    call IntToStr64

    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, lenOut ; длина строки
    syscall; вызов системной функции

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
