%include "lib.asm"

section .data
matrix: dd -1,  2,  3, -4
        dd -1,  2, -3,  4
        dd -1, -2, -3, -4
        dd  1, -2, -3,  4
        dd  1, -2, -3, -4

section .bss
    OutBuf resb 10 ; буфер для выводимой строки
    lenOut equ $-OutBuf
    matrix resb 20
    AMsg db "Enter number : ", 0xa
    lenAMsg equ $-AMsg
    counter resb 8
    InBuf resb 10 ; буфер для вводимой строки
    lenIn equ $-InBuf

section .text
global _start

_start:
    mov rcx, 0
loop_row:
    cmp rcx, 2
    je done
    mov rbx, 0
loop_col:

    mov [counter], rbx
    ; write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, AMsg ; адрес выводимой строки
    mov rdx, lenAMsg ; длина строки
    syscall; вызов системной функции

    mov rax, 0 ; System call 0 for read
    mov rdi, 0 ; File descriptor for stdin
    mov rsi, InBuf ; Address of input buffer
    mov rdx, lenIn ; Maximum length to read
    syscall

    mov rdi, InBuf; Pass address of input buffer to StrToInt64
    call StrToInt64
    cmp rbx, 0
    jne 0
    ;content of InBuf goes to rax
    mov rbx, [counter]
    mov [matrix + rbx], rax

    ;convert Str to Int
    ; mov rsi, OutBuf
    ; mov rax, [matrix + 4 * rbx]
    ; call StrToInt64

    cmp rbx, 2
    je loop_col_done
    inc rbx
    jmp loop_col
loop_col_done:
    inc rcx
    jmp loop_row
done:

exit:    ; exit program
    mov rax, 1 ; system call for exit
    xor rbx, rbx ; exit status
    syscall; вызов системной функции
    