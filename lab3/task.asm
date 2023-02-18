%include "lib.asm"

section .data; сегмент инициализированных переменных
    ExitMsg db "Result is :",10 ; выводимое сообщение
    lenExit equ $-ExitMsg
    
    AMsg db "Enter A : ", 0xa
    lenAMsg equ $-AMsg

    BMsg db "Enter B : ", 0xa
    lenBMsg equ $-BMsg

; сегмент неинициализированных переменных
section .bss
    InBuf resb 10 ; буфер для вводимой строки
    OutBuf resb 4 ; буфер для выводимой строки
    lenIn equ $-InBuf
    lenOut equ $-OutBuf

    A   resb 10
    B   resb 10
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

    ;CALCULATIONS
    mov rax, [A]
    mov rbx, [A]
    imul rbx
    cmp rax, 4
    jl else; переходим если значение a^2 оказалось меньше 4
    idiv word [B]; we already have a^2 in rax
    mov [RES], rax
    jmp continue
else:
    mov rax, [A]
    add rax, [B]
    mov [RES], rax
continue:
    ;ouput
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
