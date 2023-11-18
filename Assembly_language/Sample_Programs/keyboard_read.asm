;The following example reads a number from the keyboard and displays it on the screen

section .data
    userMsg DB "Please enter a number: "
    lengthUserMsg EQU $-userMsg
    displayMsg DB "You've entered: "
    lenDispMsg EQU $-displayMsg

section .bss
    num RESB 5 ;upto 5 bytes (5 numbers)

section .text
    global _start

_start:
    ;Prompt user for number
    mov eax, 4
    mov ebx, 1
    mov ecx, userMsg
    mov edx, lengthUserMsg
    int 0x80

    ;Read and store user input
    mov eax, 3
    mov ebx, 2
    mov ecx, num
    mov edx, 5
    int 0x80

    ;output message 'Youve, entered number;
    mov eax, 4
    mov ebx, 1
    mov ecx, displayMsg
    mov edx, lenDispMsg
    int 0x80

    ;show the input to screen
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 5
    int 0x80

    ;print new line
    mov eax, 4
    mov ebx, 1
    mov ecx, 0xa
    mov edx, 1
    int 0x80   

    ;exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80