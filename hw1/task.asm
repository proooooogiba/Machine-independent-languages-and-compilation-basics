section .data
    input db "99abcd 47defg 26ghkl 53emka 10babk ", 0
    len equ $-input
    NewLine: db 0x0A
    new_line db 10 ; define a new line character

section .bss
    Buf resb 2 ; буфер для вводимой строки
    out1 resb 6
    out2 resb 6
    OutBuf resb 100

section .text
global _start

_start:
    mov rcx, 5
    mov rbx, 0
ExternCycle:
    push rcx

    mov rcx, 4
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
