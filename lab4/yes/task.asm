%include "lib.asm"

section .data
A:  dw  1, 3
    dw  2, 1

section .bss
    OutBuf resb 10 ; буфер для выводимой строки
    lenOut equ $-OutBuf
    counter resb 8
    InBuf resb 10 ; буфер для вводимой строки
    lenIn equ $-InBuf
    res resb 10
section .text
global _start

_start:

    mov rbx, 0 ; номер элемента 0
    mov rcx, 3 ; счетчик цикла
    mov rax, [A] ; заносим первое число
cycle: 
    cmp rax, [rbx*2 + 2 + A] ; сравниваем числа
    jge next ; если больше, то перейти к следующему
    mov rax, [rbx*2 + 2 + A] ; если меньше, то запомнить
next:
    inc rbx ; переходим к следующему числу
    loop cycle
    ; максимальное значение заносим в ячейку памяти res
    mov [res], rax

    ; convert the maximum number to a string
    mov rsi, OutBuf
    mov rax, [res]
    call IntToStr64
    
    ; print the maximum number
    mov rax, 1
    mov rdi, 1
    mov rsi, OutBuf
    mov rdx, lenOut
    syscall

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
