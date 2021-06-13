uppercase: uppercase.o
	ld -o uppercase uppercase.o
uppercase.o: uppercase-2.asm
	nasm -f elf64 -g -F DWARF -o uppercase.o uppercase-2.asm
