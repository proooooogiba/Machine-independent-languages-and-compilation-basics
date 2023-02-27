section .data
	A dw 25
	B dd -35
	C db "Иван Ivan"
	D dw 25h
	E dw 2500h
	F1 dw 65535
	F2 dd 65535
section .text
	global _start
_start:
	; add [F1], word 1
	; add [F2], dword 1
	mov ax, 5

exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
