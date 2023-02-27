section .data
	A   dd    -30; define dword
	B   dd     21
section .bss
	X resd 1
section .text
	global _start
_start:
	mov rax, [A] 	; RAX:= A
	add rax, 5 	; RAX:= RAX + 5
	sub rax,[B]	; RAX:= RAX - B
 	mov [X], rax 	; сохранить результат в яечкий памяти X	
exit:
	mov rax, 60
    xor rdi, rdi 		; return code 0 
    syscall
