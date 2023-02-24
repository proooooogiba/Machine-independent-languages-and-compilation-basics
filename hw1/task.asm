section .data
    input db 55 dup(0)
    len equ $-input

section .bss
    Buf resb 2 ; буфер для вводимой строки
    out1 resb 6 
    out2 resb 6

;99abcd 37defg 26ghkl 53emka 10babk 82ebka 02hero 24days
;12yaza 54budu 47vsec 78htom 22ozhn 07ozab 51itne 01pyta

section .text
global _start

_start:
; доделать ввод строки
    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, input ; Address of input buffer
    mov rdx, len ; Maximum length to read
    syscall

    mov rcx, 8
    mov rbx, 0
ExternCycle:
    push rcx

    mov rcx, 7
    mov rdx, 0
InternCycle:
    push rcx

; в rbx содержится смещение от начала строки первой подстроки
; в rdx содержится смещение от начала строки второй подстроки

    mov rsi, input  ; point to first character of the word
    add rsi, rdx
    mov rdi, out1 ; point to start of output buffer
    mov rax, [rsi]  ; load current character into al
    mov [rdi], rax
    
    mov rsi, input  ; point to first character of the word
    add rsi, rdx
    add rsi, 7    ; add offset to the start of the word
    mov rdi, out2 ; point to start of output buffer
    mov rax, [rsi]  ; load current character into al
    mov [rdi], rax

    push rsi
    push rdi

    mov rsi, out1
    mov rdi, out2
    mov rcx, 2
    cld
    repe cmpsb

    pop rdi
    pop rsi
    jl no_swap

swap:
    ; надо подумать как сделать swap
    ; осталось доделать swap и все будет ок

    ; copy out1 на место out2
    mov	rcx, 6
    mov	rsi, out2
    mov	rdi, input
    add rdi, rdx
    cld
    rep	movsb

    ;copy out2 на место out1
    mov	rcx, 6
    mov	rsi, out1
    mov	rdi, input
    add rdi, rdx
    add rdi, 7
    cld
    rep	movsb

no_swap:
    add rdx, 7
    pop rcx
    dec rcx
    jnz InternCycle

    add rbx, 7
    pop rcx
    dec rcx
jnz ExternCycle

done:
    mov	rax, 1	        ; файловый дескриптор (stdout)
    mov	rdi, 1	        ; номер системного вызова (sys_write)
    mov	rdx, len	        ; длина сообщения
    mov	rsi, input	    ; сообщение для вывода на экран
    syscall

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
