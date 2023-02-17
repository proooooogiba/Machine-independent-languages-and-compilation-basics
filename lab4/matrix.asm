%include "lib.asm"

section .data
matrix: dd 4, 2
        dd 1, 5

section .bss
    OutBuf resb 10 ; буфер для выводимой строки
    lenOut equ $-OutBuf
    buf   resb 10
    res   resb 10
    InBuf resb 10 ; буфер для вводимой строки
    counter resb 10
    lenIn equ $-InBuf

section .text
extern printf
global _start

_start:
    mov rbx, 0 ; смещение элемента столбца в строке
    mov rcx, 2 ; количество столбцов
    mov rdx, 0  ;ячейка суммы 
cycle1: 
    push rcx ; сохраняем счетчик
    mov rcx, 1 ; счетчик элементов в столбце
    
    ; add rdx, [rbx + matrix]

    push rcx ; сохраняем счетчик
    push rsi

    mov rax, [rbx + matrix]
    mov rsi, OutBuf
    call IntToStr64

    ; print the number    
    mov rax, 1
    mov rdi, 1
    mov rsi, OutBuf
    mov rdx, lenOut
    syscall

    pop rsi
    pop rcx

    mov rsi, 8 ; смещение второго элемента столбца
cycle2:
    push rcx ; сохраняем счетчик
    push rsi

    mov rax, [rbx + rsi + matrix]
    mov rsi, OutBuf
    call IntToStr64

    ; print the number    
    mov rax, 1
    mov rdi, 1
    mov rsi, OutBuf
    mov rdx, lenOut
    syscall

    pop rsi

    add rsi, 8 ; переходим к следующему элементу
    pop rcx
    loop cycle2 ; цикл по элементам столбца
    pop rcx ; восстановили счетчик
    add rbx, 4 ; перешли к следующему столбцу
    dec rcx
    jnz cycle1 ; цикл по столбцам

    ; mov [res], rdx
    ; convert number to a string
    ; mov rsi, OutBuf
    ; mov rax, [res]
    ; call IntToStr64
    ; ; print the number
    ; mov rax, 1
    ; mov rdi, 1
    ; mov rsi, OutBuf
    ; mov rdx, lenOut
    ; syscall
exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
