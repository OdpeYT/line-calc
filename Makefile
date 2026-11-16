all: line-calc

line-calc: line-calc.o
	gcc -no-pie line-calc.o -o line-calc

line-calc.o: line-calc.asm
	nasm -f elf64 line-calc.asm -o line-calc.o

clean:
	rm -f line-calc.o line-calc
