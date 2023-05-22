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
;prompt user for first digit
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

;read first input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 2
    int 0x80

;prompt user for second digit
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

;read second input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num2
    mov edx, 2
    int 0x80

;prompt user for sum
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

;move first number to eax register and 
;second number to ebx
;and substracting ascii '0' to convert it into
;decimal number



