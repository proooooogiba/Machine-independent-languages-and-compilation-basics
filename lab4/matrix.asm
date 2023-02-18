%include "lib.asm"

section .data
matrix: dd -2, 3
        dd -3, 3

ExitMsg db "Line with zero sum is found", 0xA ; выводимое сообщение
Space db " ", 0xA
NewLine: db 0xA
lenExit equ $-ExitMsg

ResMsg db "Result matrix looks following : ", 0xA ; выводимое сообщение
lenRes equ $-ResMsg

section .bss
    OutBuf resb 2 ; буфер для выводимой строки, он должен быть 2 или 4
    lenOut equ $-OutBuf

    Buf   resb 8
    lineBuf equ $-Buf
    res   resb 10
    InBuf resb 10 ; буфер для вводимой строки
    lenIn equ $-InBuf

section .text
    global _start

_start:

    ; mov rbx, 0 ; смещение элемента столбца в строке
    ; mov rcx, 2 ; количество столбцов
    
;мы проходимся по столбцам
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

;     ; print the number    
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, Space
;     mov rdx, 1
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

;     ; print the space    
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, Space
;     mov rdx, 1
;     syscall

;     pop rsi

;     add rsi, 4; смещение для другого столбца, но все той-же строки
;     pop rcx
;     loop cyclePrint2 ; цикл по элементам столбца

;     ; print the NewLinw character
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, NewLine
;     mov rdx, 1
;     syscall

;     pop rcx

;     add rbx, 8 ; перешли к следующей строке
;     dec rcx
;     jnz cyclePrint1 ; цикл по столбцам






    ;я ёбаный гений блять
    mov rbx, 0 ; смещение элемента столбца в строке
    mov rcx, 2 ; количество строк
cycle1:
    push rcx ; сохраняем счетчик
    mov rcx, 1 ; счетчик элементов в строке - 1
    mov rax, [rbx + matrix]; будем использовать как сумму элементов для строки
    mov rsi, 4 ; проходимся по элементам строки
cycle2:
    add rax, [rbx + rsi + matrix]
    add rsi, 4 ; проходимся по элементам строки
    loop cycle2 ; цикл по элементам столбца

    ;если сумма равна нулю, то мы сразу переходим к новой строке, иначе мы печатаем строку
    cmp eax, 0  ; не знаю почему,но во внутреннем представлении rax когда он должен быть равен нулю,но он ему совсем не равен
                ;пришлось заменять на eax, не приятно конечно,но терпимо
    je zero

    mov rcx, 1 ; счетчик элементов в столбце
    ;здесь нужно сделать printf всей строки
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

    ; print the number    
    mov rax, 1
    mov rdi, 1
    mov rsi, Space
    mov rdx, 1
    syscall

    pop rsi
    pop rcx

    mov rsi, 4 ; смещение для другого столбца, но все той-же строки
cyclePrintOut:
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

    ; print the space    
    mov rax, 1
    mov rdi, 1
    mov rsi, Space
    mov rdx, 1
    syscall

    pop rsi

    add rsi, 4; смещение для другого столбца, но все той-же строки
    pop rcx
   loop cyclePrintOut

zero:
    pop rcx ; восстановили счетчик

    add rbx, 8 ; перешли к следующей строке
    dec rcx
    jnz cycle1 ; цикл по строкам

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
