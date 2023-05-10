;NASM CONSTANTS

SYS_WRITE equ 4
SYS_EXIT equ 1
STDIN equ 0
STDOUT equ 1

section .data
    msg db "Hello there friend", 0xa
    len equ $ - msg

section .text
    global _start

_start:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80