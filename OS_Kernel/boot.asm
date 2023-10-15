;boot.asm

bits 32

section .text
global start
extern main

start:
	cli 
	move esp, stack_space
	call main
	hlt

section .bss
resb 16000
stack_space
