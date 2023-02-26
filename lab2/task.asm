%include "lib.asm"

section .data; сегмент инициализированных переменных
    ResMsg db "Result is: d = " ; выводимое сообщение
    lenRes equ $-ResMsg

    StartMsg db "Calculate following expression d = a * x - 3 * (b + 3/k)", 0xa
    lenStart equ $-StartMsg

    ZeroDiv db "Zero division is forbidden (K is zero)", 0xa
    lenZeroDiv equ $-ZeroDiv
    
    AMsg db "Enter a = "
    lenAMsg equ $-AMsg

    BMsg db "Enter b = "
    lenBMsg equ $-BMsg

    KMsg db "Enter k = "
    lenKMsg equ $-KMsg

    XMsg db "Enter x = "
    lenXMsg equ $-XMsg

    ExitMsg db 0xa, `Goodbye, have a nice day`, 0E2h, 098h, 0BAh, 0xa
    lenExit equ $-ExitMsg


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
    D   resb 10

section .text ; сегмент кода
global _start
_start:
    ; write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, StartMsg ; адрес выводимой строки
    mov rdx, lenStart ; длина строки
    syscall; вызов системной функции
    
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
    cmp rax, 0 ; compare Kб which is in rax with zero
    je zero_division
    mov [K], rax
    jmp calculation

zero_division:
    ;write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ZeroDiv ; адрес выводимой строки
    mov rdx, lenZeroDiv ; длина строки
    syscall; вызов системной функции
    jmp exit

 calculation:
    mov  rax, [A]; AX:=A
    mov  rbx, [X]; BX:=X
    imul rbx; AX:=A*X
    mov [D], rax; D:=A*X
    mov rax, 3; AX:= 3
    mov rbx, [K]; BX:= K
    idiv rbx; AX:=3/K
    mov rbx, [B]; BX:=B
    add rax, rbx; AX:=3/K+B
    mov rbx, 3; BX:=3
    imul rbx; AX:=3*(3/K+B)
    mov rbx, [D]; BX:=D
    sub rbx, rax; D:=A*X-3*(3/K+B)
    ;SAVE IN D
    mov [D], rbx
    
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ResMsg ; адрес выводимой строки
    mov rdx, lenRes ; длина строки
    syscall; вызов системной функции    

    mov rsi, OutBuf; Pass address of output buffer to IntToStr64
    mov rax, [D]
    call IntToStr64

    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, lenOut ; длина строки
    syscall; вызов системной функции

exit:
    ;write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ExitMsg ; адрес выводимой строки
    mov rdx, lenExit ; длина строки
    syscall; вызов системной функции    

    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
