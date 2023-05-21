SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1 

section .data
    msg1 db "Enter a digit ", 0xA, 0xD
    len1 equ $ - msg1
    msg2 db "Enter second digit ", 0xA, 0xD
    len2 equ $ - msg2
    msg3 db "The sum is: "
    len3 equ $ - msg3

section .text
    global _start

section .bss
    num1 resb 2
    num2 resb 2
    sum resb 1

_start:
    