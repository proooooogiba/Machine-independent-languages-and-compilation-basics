global delete_vowels
extern print_result
section .text
delete_vowels:
; в rdi - исходная первый параметр (строка)
; в rsi - строка содержащая все гласные буквы
; в rdx - длина строки содержащей все гласные буквы
    push rbp ;сохраняем значения регистров
    mov rbp, rsp
    mov rbx, rdi
    mov r10, rsi
    mov rsi, rdi
    xor rcx, rcx; initialize character count to

loop_start:
    mov al, [rsi]  ; load current character into al
    cmp al, 0      ; check if we've reached the end of the string
    je done        ; if so, jump to done

    push rcx
    push rdi
    check_char_occurrence:; на входе: al - текущий символ, rcx - счетчик, rdi - указатель на начало строки
        mov rcx, rdx
        mov rdi, r10
        cld
        repne scasb
    pop rdi
    pop rcx
    je is_vowel

not_vowel:
    mov [rdi], al   ; copy current character to output buffer
    inc rsi          ; move to next character
    inc rdi
    inc rcx
    jmp loop_start ; jump to loop_start

is_vowel:
    inc rsi
    jmp loop_start ; jump to loop_start

done:
    mov rdi, rbx
    mov rsi, rcx
    call print_result
final_done:
    mov rbp, rsp
    pop rbp ;возвращаем регистр
    ret
