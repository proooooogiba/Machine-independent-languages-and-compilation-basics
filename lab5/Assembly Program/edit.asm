section .data
input db "hey how are you? I am fine thank you!", 0
len equ $-input
output db 100 dup(0)  ; allocate space for output string
vowels db "AEIOUaeiou"
vowelsNumber equ $-vowels

section .text
global _start

_start:
    call delete_vowels

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции

delete_vowels:
    push rbp
    mov rbp, rsp
    mov rsi, input  ; point to first character of input
    mov rdi, output ; point to start of output buffer
    xor rcx, rcx   ; initialize character count to

loop_start:
    mov al, [rsi]  ; load current character into eax
    cmp al, 0      ; check if we've reached the end of the string
    je done        ; if so, jump to done
    
    push rcx
    push rdi
    
    check_char_occurrence:; на входе: al - текущий символ, ecx - счетчик, edi - указатель на начало строки
        mov rcx, vowelsNumber
        mov rdi, vowels
        cld
        repne scasb
    
    pop rdi
    pop rcx
    je is_vowel
    
not_vowel:
    mov [rdi], al   ; copy current character to output buffer
    inc rsi          ; move to next character
    inc rdi
    loop loop_start ; jump to loop_start

is_vowel:
    inc rsi
    loop loop_start ; jump to loop_start

done:
    mov byte [rdi], 0 ; add null terminator to output string
    mov	rax, 1	        ; файловый дескриптор (stdout)
    mov	rdi, 1	        ; номер системного вызова (sys_write)
    mov	rdx, 100	    ; длина сообщения
    mov	rsi, output	        ; сообщение для вывода на экран
    syscall
final_done:
    pop rbp
    ret
