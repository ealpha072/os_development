; Hello World Program - asmtutor.com
; Compile with: nasm -f elf helloworld.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 helloworld.o -o helloworld
; Run with: ./helloworld
; this is to be run on a linux 

SECTION .data
	hello db 'Hello world!', 10 ;sets new line charcyer after msg, ensures next msg is printed in new line

SECTION .text
	global _start

_start:
	;write hello world to standard output
	mov eax, 4 		;system call for write
	mov ebx, 1 		;file descriptor for std output
	mov ecx, hello  ;load message to register
	mov edx, 13     ;length to read and write to std output in bytes
	int 0x80        ;call kernel

	;write new line
	mov eax, 4      ;same as above
	mov ebx, 1
	mov ecx, 0x0a
	mov edx, 1
	int 0x80
	
	;exit with status code
	mov eax, 1
	xor ebx, ebx
	int 0x80

