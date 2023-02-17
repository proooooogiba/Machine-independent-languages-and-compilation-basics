%include "lib.asm"

section .data
matrix: dd -2, 2
        dd -3, 3

ExitMsg db "Line with zero sum is found", 10 ; выводимое сообщение
lenExit equ $-ExitMsg

section .bss
    OutBuf resb 10 ; буфер для выводимой строки
    lenOut equ $-OutBuf
    buf   resb 10
    res   resb 10
    InBuf resb 10 ; буфер для вводимой строки
    counter resb 10
    lenIn equ $-InBuf
    

section .text
    global _start

_start:

;     mov rbx, 0 ; смещение элемента столбца в строке
;     mov rcx, 2 ; количество столбцов
; ;мы проходимся по столбцам
; cyclePrint1: 
;     push rcx ; сохраняем счетчик
;     mov rcx, 1 ; счетчик элементов в столбце
    
;     push rcx ; сохраняем счетчик
;     push rsi

;     mov rax, [rbx + matrix]
;     mov rsi, OutBuf
;     call IntToStr64

;     ; print the number    
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, OutBuf
;     mov rdx, lenOut
;     syscall

;     pop rsi
;     pop rcx

;     mov rsi, 4 ; смещение для другого столбца, но все той-же строки
; cyclePrint2:
;     push rcx ; сохраняем счетчик
;     push rsi

;     mov rax, [rbx + rsi + matrix]
;     mov rsi, OutBuf
;     call IntToStr64

;     ; print the number    
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, OutBuf
;     mov rdx, lenOut
;     syscall

;     pop rsi

;     add rsi, 4; смещение для другого столбца, но все той-же строки
;     pop rcx
;     loop cyclePrint2 ; цикл по элементам столбца
;     pop rcx ; восстановили счетчик
;     add rbx, 8 ; перешли к следующей строке
;     dec rcx
;     jnz cyclePrint1 ; цикл по столбцам










    mov rbx, 0 ; смещение элемента столбца в строке
    mov rcx, 2 ; количество столбцов
cycle1:
    push rcx ; сохраняем счетчик
    mov rcx, 1 ; счетчик элементов в столбце - 1
    mov rax, [rbx + matrix]; будем использовать как сумму элементов для строки
    mov rsi, 4 ; проходимся по элементам строки
cycle2:
    add rax, [rbx + rsi + matrix]

    add rsi, 4 ; проходимся по элементам строки
    loop cycle2 ; цикл по элементам столбца

    ;если сумма равна нулю, то выводим 'блин, блинский'
    cmp eax, 0  ; не знаю почему,но во внутреннем представлении rax когда он должен быть равен нулю, ему совсем не равен
                ;пришлось заменять на eax, не приятно конечно,но терпимо
    jne next

    push rsi
    push rcx
    
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ExitMsg ; адрес выводимой строки
    mov rdx, lenExit ; длина строки
    syscall; вызов системной функции
    
    pop rcx
    pop rsi
next:
    pop rcx ; восстановили счетчик
    add rbx, 8 ; перешли к следующей строке
    dec rcx
    jnz cycle1 ; цикл по столбцам

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
