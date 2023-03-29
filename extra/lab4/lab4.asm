%include "lib.asm"

section .data; сегмент инициализированных переменных
	Space db " "
	NewLine: db 0xA
	
	StartMsg db "Input matrix looks following: ", 0xA ; выводимое сообщение
	lenStart equ $-StartMsg
	
	ResMsg db "The number of the row: ", 0xA ; выводимое сообщение
	lenRes equ $-ResMsg
	
	InputMsg db "Input matrix: ", 0xA ; выводимое сообщение
	lenInput equ $-InputMsg
	
	InputLineMsg db "Input element of the line one by one: ", 0xA ; выводимое сообщение
	lenLineInput equ $-InputLineMsg

; сегмент неинициализированных переменных
section .bss
	matrix resd 100
	
	OutBuf resb 2 ; буфер для выводимой строки
	lenOut equ $-OutBuf
	
	InBuf resd 2 ; буфер для вводимой строки
	lenIn equ $-InBuf
			
section .text ; сегмент кода
global _start
_start:
	call PrintInputMsg
	call PrintInputLineMsg; вывод начальны сообщений
	
	mov rbx, 0 ; смещение элемента столбца в строке
	mov rcx, 8 ; количество строк
	cycleInput1:; мы проходимся по столбцам
		push rcx ; сохраняем счетчик
		mov rcx, 6 ; счетчик элементов в строке
		mov rsi, 0 ; ставим указатель на 1 элемент строки
		cycleInput2: ; цикл по элементам строки
			push rcx ; сохраняем счетчик
			push rsi ; помещаем в стек данные 
			push rbx
			
			call InputNumber ; ввод элемента 
			mov rdi, InBuf; Pass address of input buffer to StrToInt64
			call StrToInt64
			cmp rbx, 0
			jne 0 ;content of InBuf goes to rax
			pop rbx ; достаем из стека значения
			pop rsi
			mov [rbx + rsi + matrix], rax ; помещаем значение в массив
			
			add rsi, 4; смещение для другого столбца, изменение указателя
			pop rcx
			loop cycleInput2
			
		call PrintInputLineMsg ; сообщение о вводе новой строки
		pop rcx
		add rbx, 24 ; перешли к следующей строке
		dec rcx ; уменьшение счетчикм на 1
		jnz cycleInput1
		
	mov rax, 1
	mov rdi, 1
	mov rsi, StartMsg ; вывод введеной мтрицы
	mov rdx, lenStart
	syscall
	
	mov rbx, 0 ; смещение элемента столбца в строке
	mov rcx, 8 ; количество строк
	cyclePrint1: ; цикл по строкам
		push rcx ; сохраняем счетчик
		mov rcx, 6 ; счетчик элементов в строке
		mov rsi, 0 ; указываем на первый элемент строки
		cyclePrint2: ; цикл по элементам строки
			push rcx ; сохраняем счетчик
			push rsi
			mov rax, [rbx + rsi + matrix]
			mov rsi, OutBuf
			call IntToStr64
			call PrintNumber
			call PrintSpace
			pop rsi
			pop rcx
			add rsi, 4; смещение для другого столбца
			loop cyclePrint2
		call PrintNewLine
		pop rcx
		add rbx, 24 ; перешли к следующей строке
		dec rcx
		jnz cyclePrint1
	mov rax, 1
	mov rdi, 1
	mov rsi, ResMsg ; сообще о выводе номера строки
	mov rdx, lenRes
	syscall
	
	; расчеты
	mov rbx, 0 ; смещение элемента столбца в строке
	mov rcx, 8 ; количество строк
	mov rdx, 0 ; наибольшая сумма
    mov r8, 0 ; index строки с наибольшей суммой 
	cycle1:
		push rcx ; сохраняем счетчик
		mov rcx, 6 ; счетчик элементов в строке
		mov rsi, 0 ; проходимся по элементам строки
		mov rax, 0 ; сумма строки
		cycle2:
			add rax, [rbx + rsi + matrix]
			add rsi, 4 ; проходимся по элементам строки
			loop cycle2 ; цикл по элементам столбца
			
		cmp rax, rdx
		jl big_rdx ; если rdx больше rax то переходим 
		mov rdx, rax ; перенос из rax в rdx
		pop rcx
        mov r8, rcx
        jmp continue

	big_rdx:
		pop rcx ; восстановили счетчик
	continue:
        add rbx, 24 ; перешли к следующей строке
		dec rcx
		jnz cycle1 ; цикл по строкам	
		
	; вывод результата
		mov rsi, OutBuf; Pass address of output buffer to IntToStr64
        mov rdx, 8
        sub rdx, r8
        mov rax, rdx
		call IntToStr64
		
		mov rax, 1; системная функция 1 (write)
		mov rdi, 1; дескриптор файла stdout=1
		mov rsi, OutBuf ; адрес выводимой строки
		mov rdx, lenOut ; длина строки
		syscall; вызов системной функции
	
	exit:
		mov rax, 60; системная функция 60 (exit)
		xor rdi, rdi; return code 0
		syscall; вызов системной функции
		
	PrintInputMsg:
		mov rax, 1
		mov rdi, 1
		mov rsi, InputMsg
		mov rdx, lenInput
		syscall
		ret
		
	PrintInputLineMsg: 
		mov rax, 1
		mov rdi, 1
		mov rsi, InputLineMsg
		mov rdx, lenLineInput
		syscall
		ret
		
	PrintSpace:
		mov rax, 1
		mov rdi, 1
		mov rsi, Space
		mov rdx, 1
		syscall
		ret
		
	PrintNumber:
		mov rax, 1
		mov rdi, 1
		mov rsi, OutBuf
		mov rdx, lenOut
		syscall
		ret
		
	PrintNewLine:
		mov rax, 1
		mov rdi, 1
		mov rsi, NewLine
		mov rdx, 1
		syscall
		ret
		
	InputNumber:
		mov rax, 0 ; System call 0 for read
		mov rdi, 0 ; File descriptor for stdin
		mov rsi, InBuf ; Address of input buffer
        mov rdx, lenIn ; Maximum length to read
        syscall
        ret
