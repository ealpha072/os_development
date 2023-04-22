; Hello World Program - asmtutor.com
; Compile with: nasm -f elf helloworld.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 helloworld.o -o helloworld
; Run with: ./helloworld
 

SECTION .data
	hello db 'Hello world!', 0

SECTION .text
	global _start

_start:
	;write hello world to standard output
	mov eax, 4
	mov ebx, 1
	mov ecx, hello
	mov edx, 13
	int 0x80

	;write new line
	move eax, 4
	mov ebx, 1
	mov ecx, 0x0a
	mov edx, 1
	int 0x80
	
	;exit with status code
	mov eax, 1
	xor ebx, ebx
	int 0x80

