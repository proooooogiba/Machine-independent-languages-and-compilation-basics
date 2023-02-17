%include "lib.asm"

section .data
matrix: dd 1, 2
        dd 3, 4

section .bss
    OutBuf resb 10 ; буфер для выводимой строки
    lenOut equ $-OutBuf
    res   resb 10
    InBuf resb 10 ; буфер для вводимой строки
    lenIn equ $-InBuf


section .text
global _start

_start:

    mov rax, 0 ; обнуляем сумму
    mov rbx, 0 ; смещение элемента столбца в строке
    mov rcx, 2 ; количество столбцов
cycle1: 
    push rcx ; сохраняем счетчик
    mov rcx, 1 ; счетчик элементов в столбце
    mov rdx, [rbx + matrix] ; заносим первый элемент столбца
    mov rsi, 8 ; смещение второго элемента столбца
cycle2:
    add rax,[rbx + rsi + matrix] ; просуммировали максимальный элемент


    ;print element

    add rsi, 8 ; переходим к следующему элементу
    loop cycle2 ; цикл по элементам столбца
    pop rcx ; восстановили счетчик
    add rbx, 4 ; перешли к следующему столбцу
    loop cycle1 ; цикл по столбцам

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
