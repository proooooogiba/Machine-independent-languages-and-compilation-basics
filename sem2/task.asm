section .data
    a dw 20
    b dw 3
    c dw 25

section .bss
    y resw 1    

section .text
global _start

_start:
    mov ax, [c]
    cwd
    mov bx, 3
    idiv bx
    mov bx, [b]
    sub bx, ax
    mov ax, [a]
    add ax, 4
    imul bx
    mov [y], ax

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
