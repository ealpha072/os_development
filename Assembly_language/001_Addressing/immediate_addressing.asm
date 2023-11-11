; an example that uses immediate addressing with registers:

section .data
    result db 0
    result_len equ $-result
    newline db 0xa

section .text
    global _start

_start:
    mov eax, 10             ;Load the value 10 into the eax register
    add eax, 5              ;Add the immediate value 5 to the contents of eax

    ;Convert the result to ASCII and store it in the 'result' variable
    add eax, '0'
    mov [result], al

    ;print the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, result_len
    int 0x80

    ;print new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ;exit
    mov eax, 1
    xor ebx, ebx
    int 0x80