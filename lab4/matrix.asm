%include "lib.asm"

section .data
    ExitMsg db "Line with zero sum is found", 0xA ; выводимое сообщение
    Space db "  "
    NewLine: db 0xA
    lenExit equ $-ExitMsg

    StartMsg db "Input matrix looks following : ", 0xA ; выводимое сообщение
    lenStart equ $-StartMsg

    ResMsg db "Result matrix looks following : ", 0xA ; выводимое сообщение
    lenRes equ $-ResMsg

    InputMsg db "Input matrix from keyboard(along the lines) : ", 0xA ; выводимое сообщение
    lenInput equ $-InputMsg

    InputLineMsg db "Input element of the line one by one from keyboard : ", 0xA ; выводимое сообщение
    lenLineInput equ $-InputLineMsg


section .bss
    matrix resd 20
    OutBuf resb 2 ; буфер для выводимой строки, он должен быть 2 или 4
                  ;должен быть 4, но пока оставим костыль, можно ввожить только 0 
    lenOut equ $-OutBuf
    InBuf resd 2 ; буфер для вводимой строки
    lenIn equ $-InBuf

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, InputMsg
    mov rdx, lenInput
    syscall

    ; print line element's expectation
    mov rax, 1
    mov rdi, 1
    mov rsi, InputLineMsg
    mov rdx, lenLineInput
    syscall

    mov rbx, 0 ; смещение элемента столбца в строке
    mov rcx, 5 ; количество строк
cycleInput1:; мы проходимся по столбцам
    push rcx ; сохраняем счетчик
    mov rcx, 3 ; счетчик элементов в столбце - 1
    
    push rcx ; сохраняем счетчик
    push rbx
    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, InBuf ; Address of input buffer
    mov rdx, lenIn ; Maximum length to read
    syscall

    mov rdi, InBuf; Pass address of input buffer to StrToInt64
    call StrToInt64
    cmp rbx, 0
    jne 0
    pop rbx
    mov [rbx + matrix], rax;content of InBuf goes to rax
    pop rcx

    mov rsi, 4 ; смещение для другого столбца, но все той-же строки
cycleInput2:
    push rcx ; сохраняем счетчик
    push rsi
    push rbx
    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, InBuf ; Address of input buffer
    mov rdx, lenIn ; Maximum length to read
    syscall

    mov rdi, InBuf; Pass address of input buffer to StrToInt64
    call StrToInt64
    cmp rbx, 0
    jne 0 ;content of InBuf goes to rax
    pop rbx
    pop rsi
    mov [rbx + rsi + matrix], rax

    add rsi, 4; смещение для другого столбца, но все той-же строки
    pop rcx
    loop cycleInput2 ; цикл по элементам столбца

    ; print line element's expectation
    mov rax, 1
    mov rdi, 1
    mov rsi, InputLineMsg
    mov rdx, lenLineInput
    syscall

    pop rcx
    add rbx, 16 ; перешли к следующей строке
    dec rcx
    jnz cycleInput1 ; цикл по столбцам

    mov rax, 1
    mov rdi, 1
    mov rsi, StartMsg
    mov rdx, lenStart
    syscall

    mov rbx, 0 ; смещение элемента столбца в строке
    mov rcx, 5 ; количество строк
; мы проходимся по столбцам
cyclePrint1: 
    push rcx ; сохраняем счетчик
    mov rcx, 3 ; счетчик элементов в столбцов - 1
    
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
cyclePrint2:
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
    loop cyclePrint2 ; цикл по элементам столбца

    ; print the NewLine character
    mov rax, 1
    mov rdi, 1
    mov rsi, NewLine
    mov rdx, 1
    syscall

    pop rcx

    add rbx, 16 ; перешли к следующей строке
    dec rcx
    jnz cyclePrint1 ; цикл по столбцам


    mov rax, 1
    mov rdi, 1
    mov rsi, ResMsg
    mov rdx, lenRes
    syscall

    ;я ёбаный гений блять
    mov rbx, 0 ; смещение элемента столбца в строке
    mov rcx, 5 ; количество строк
cycle1:
    push rcx ; сохраняем счетчик
    mov rcx, 3 ; счетчик элементов в строке - 1
    mov rax, [rbx + matrix]; будем использовать как сумму элементов для строки
    mov rsi, 4 ; проходимся по элементам строки
cycle2:
    add rax, [rbx + rsi + matrix]
    add rsi, 4 ; проходимся по элементам строки
    loop cycle2 ; цикл по элементам столбца

    ;если сумма равна нулю, то мы сразу переходим к новой строке, иначе мы печатаем строку
    cmp eax, 0  ; не знаю почему,но во внутреннем представлении rax когда он должен быть равен нулю,но он ему совсем не равен
                ;пришлось заменять на eax, не приятно конечно,но терпимо
    je if_zero

    mov rcx, 3 ; счетчик элементов в столбце
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

    ; print the NewLine    
    mov rax, 1
    mov rdi, 1
    mov rsi, NewLine
    mov rdx, 1
    syscall

if_zero:
    pop rcx ; восстановили счетчик
    add rbx, 16 ; перешли к следующей строке
    dec rcx
    
    jnz cycle1 ; цикл по строкам

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
