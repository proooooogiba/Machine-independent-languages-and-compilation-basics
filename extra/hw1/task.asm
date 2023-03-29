section .data
    input_string db 'abcdef ghklmn oprstu', 0
    string_length equ $ - input_string
	output_string db 20 dup(0)

section .text
    global _start

_start:
    ; Загрузить адрес входной строки в регистр rsi
    mov rsi, input_string

    ; Загрузить адрес выходной строки в регистр rdi
    mov rdi, output_string

    ; Загрузить длину строки в регистр rcx
    mov rcx, string_length

process_word:
 ; Установить rax на количество символов для сдвига
    cmp rdi, output_string
    je .first_word
    cmp rdi, output_string+7
    je .second_word
    jmp .third_word

.first_word:
    mov rax, 1
    jmp .shift_word

.second_word:
    mov rax, 2
    jmp .shift_word

.third_word:
    mov rax, 3

.shift_word:
    ; Сдвигаем символы влево на значение rax
    mov rbx, 0

.shift_loop:
    ; Загрузить символ из исходной строки в регистр dl
    mov dl, [rsi + rbx]

    ; Вычислить новую позицию символа в выходной строке
    add rdx, rbx
    sub rdx, rax

    ; Выполнить кольцевой сдвиг, если индекс выходит за пределы слова
    cmp rdx, 6
    jl .store_char
    sub rdx, 6

.store_char:
    ; Сохранить символ на новой позиции в выходной строке
    mov [rdi + rdx], dl

    ; Перейти к следующему символу
    add rbx, 1
    cmp rbx, 6
    jl .shift_loop

    ; Перейти к следующему слову
    add rsi, 7
    add rdi, 7
    sub rcx, 7
    jnz process_word

print_result:
    ; Вызов системного вызова write (1) для вывода строки
	mov rax, 1           ; syscall номер: write
    mov rdi, 1           ; дескриптор файла: stdout
    mov rdx, string_length  ; длина строки
    mov rsi, output_string ; адрес буфера
    syscall

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
