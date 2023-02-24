section .data; сегмент инициализированных переменных
    ExitMsg db "Press Enter to Exit",10 ; выводимое сообщение
    lenExit equ $-ExitMsg
    A       dw  -30
    B       dw  21
    val1    db  255
    chart   dw  256
    lue3    dw  -128
    v5      db  10h
    beta    db  23,23h,0ch
    sdk     db  "Hello",10
    min     dw  -32767
    ar      dd  12345678h
    valar   times 5 db  8
    ;changes 1.2.11
    num1     dw  25
    num2     dd  -35
    stroka   dt  "Иван"
    F1       dw  65535
    F2       dd  65535
    
; сегмент неинициализированных переменных
section .bss
    InBuf resb 2 ; буфер для вводимой строки
    lenIn equ $-InBuf
    X resd 1
    alu resw 10
    ; f1  resb 5

section .text ; сегмент кода
global _start
_start:
    add word  [F1], 1
    add dword [F2], 1
    mov EAX,[A] ; загрузить число A в регистр EAX
    add EAX,5
    sub EAX,[B] ; вычесть число B, результат в EAX
    mov [X],EAX ; сохранить результат в памяти
    ; write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ExitMsg ; адрес выводимой строки
    mov rdx, lenExit ; длина строки
    syscall; вызов системной функции
    ; read
    mov rax, 0; системная функция 0 (read)
    mov rdi, 0; дескриптор файла stdin=0
    mov rsi, InBuf; адрес вводимой строки
    mov rdx, lenIn; длина строки
    syscall; вызов системной функции
    ; exit
exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
