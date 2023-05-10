; A loop to print hello world 10 times
; Compile with: nasm -f elf hello_world_loop.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 hello_world_loop.o -o hellowoldloop
; Run with ./helloworldloop


section .data
    msg db "Display 9 stars", 0xa
    len equ $ - msg
    stars times 9 db '*'

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, stars
    mov edx, 9
    int 0x80

    ;exit
    mov eax, 1
    int 0x80


