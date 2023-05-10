;A program to get and output user input

section .data
    userMsg db "Please enter a number: "
    lenuserMsg equ $ - userMsg

    dispMsg db "You have entered: "
    lendispMsg equ $ - dispMsg

section .bss
    num resb 5

section .text
    global _start

_start:
    ;prompt user
    mov eax, 4
    mov ebx, 1
    mov ecx, userMsg
    mov edx, lenuserMsg
    int 0x80
    
    ;read and store user numner in register
    mov eax, 3
    mov ebx, 2
    mov ecx, num
    mov edx, 5
    int 0x80

    ;output the message
    mov eax, 4
    mov ebx, 1
    mov ecx, dispMsg
    mov edx, lendispMsg
    int 0x80

    ;output number entered
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 5
    int 0x80

    ;exit
    mov eax, 1
    xor ebx, ebx
    int 0x80