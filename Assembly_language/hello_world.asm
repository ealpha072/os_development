; Hello World Program - asmtutor.com
; Compile with: nasm -f elf helloworld.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 helloworld.o -o helloworld
; Run with: ./helloworld
 

SECTION .data
	hello db 'Hello world!', 0

SECTION .text
	global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, hello
	mov edx, 13
	int 0x80
	
	;exit with status code
	mov eax, 1
	xor ebx, ebx
	int 0x80

