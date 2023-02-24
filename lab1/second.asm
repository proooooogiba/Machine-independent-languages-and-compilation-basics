section .data ; сегмент инициализированных переменных
    F1 dw 65535
    F2 dd 65535

section .bss ; сегмент неинициализированных переменных

section .text ; сегмент кода
global _start
_start:
    add word [F1], 1
    add dword [F2], 1
exit:
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; return code 0
    syscall ; вызов системной функции


; The problem with the updated code is that the add instruction requires 
; an operand size to be specified, and it cannot infer the operand size 
; from the register or memory address alone.

; To fix the "operation size not specified" error, you need to specify 
; the operand size explicitly using one of the size prefixes: byte ptr,
; word ptr, dword ptr, or qword ptr. Here's the corrected code:
