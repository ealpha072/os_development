; A loop to print hello world 10 times
; Compile with: nasm -f elf hello_world_loop.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 hello_world_loop.o -o hellowoldloop
; Run with ./helloworldloop


section .data
    msg db "Display 9 stars", 0xa ;new line character in hex (10), to print a new line every time
    len equ $ - msg
    stars times 9 db '*'

section .text
    global _start

_start:
    mov eax, 4              ;system call number (4) in eax
    mov ebx, 1              ;file descriptor (stdout)
    mov ecx, msg            ; message to write
    mov edx, len            ;length of message
    int 0x80                ;call the kernel

    mov eax, 4
    mov ebx, 1
    mov ecx, stars
    mov edx, 9
    int 0x80

    ;exit
    mov eax, 1
    move ebx, 0
    int 0x80


