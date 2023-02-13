SYS_EXIT  equ 1
SYS_READ  equ 0
SYS_WRITE equ 1
STDIN     equ 0
STDOUT    equ 1

; сегмент инициализированных переменных
section .data
    ExitMsg db "Result is:", 0xa ; выводимое сообщение
    lenExit equ $-ExitMsg

    XMsg db "Enter X: ", 0xa
    lenXMsg equ $-XMsg

    BMsg db "Enter B: ", 0xa
    lenBMsg equ $-BMsg

; сегмент неинициализированных переменных
section .bss
    X resb 10 ; буфер для вводимой строки
    lenX equ $-X
    B resb 10
    lenB equ $-B
    res resb 10

section .text    ; сегмент кода
    global _start
_start:

; write INPUT X
    mov RAX, SYS_WRITE; системная функция 1 (write)
    mov RDI, STDOUT; дескриптор файла stdout=1
    mov RSI, XMsg; адрес выводимой строки
    mov RDX, lenXMsg; длина строки
    syscall ; вызов системной функции

; read X
    mov RAX, SYS_READ; системная функция 0 (read)
    mov RDI, STDIN; дескриптор файла stdin=0
    mov RSI, X; адрес вводимой строки
    mov RDX, lenX; длина строки
    syscall  ; вызов системной функции

; write INPUT B
    mov RAX, SYS_WRITE; системная функция 1 (write)
    mov RDI, STDOUT; дескриптор файла stdout=1
    mov RSI, BMsg; адрес выводимой строки
    mov RDX, lenBMsg; длина строки
    syscall ; вызов системной функции

; read B
    mov RAX, SYS_READ; системная функция 0 (read)
    mov RDI, STDIN; дескриптор файла stdin=0
    mov RSI, B; адрес вводимой строки
    mov RDX, lenB; длина строки
    syscall  ; вызов системной функции

; add X to B
    ;выгружаем из памяти в регистры
    mov RAX, [X]
    mov RBX, [B]

    ;конвертируем в десятичные числа(я это на сайте увидел)
    sub RAX, '0'
    sub RBX, '0'
    
    add RAX, RBX
    
    ; конвертируем в символы ASCII
    add RAX, '0'

    ; сохраняем в память
    mov [res], RAX

; write INPUT SUM
    mov RAX, SYS_WRITE; системная функция 1 (write)
    mov RDI, STDOUT; дескриптор файла stdout=1
    mov RSI, ExitMsg; адрес выводимой строки
    mov RDX, lenExit; длина строки
    syscall ; вызов системной функции

; print SUM
    mov RAX, SYS_WRITE; системная функция 1 (write)
    mov RDI, STDOUT; дескриптор файла stdout=1
    mov RSI, res; адрес выводимой строки
    mov RDX, 10; длина строки
    syscall  ; вызов системной функции

; exit
exit:
    mov RAX, 60; системная функция 60 (exit)
    xor RDI, RDI; return code 0
    syscall     ; вызов системной функции

