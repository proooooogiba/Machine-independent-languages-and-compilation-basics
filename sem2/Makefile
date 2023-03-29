TARGET = task

help:
	@echo Available goals:
	@echo ' run   - create and run without debugging '
	@echo ' debug - create and debug  '
	@echo ' help  - show this message '
	@echo ' add -m elf_i386 to nasm command if you are using 32-bit system on 64-bit OS '
$(TARGET): $(TARGET).asm
	nasm -f elf64 -l $(TARGET).lst $(TARGET).asm
	ld -o $(TARGET) $(TARGET).o
run: $(TARGET)
	./$(TARGET)
debug: $(TARGET)
	edb --run $(TARGET)
