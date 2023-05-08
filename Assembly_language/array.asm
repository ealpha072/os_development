;a nasm program that prints the elements of an array to std output

section .data
    myArray: dd 1,2,3,4,5,6,7,8             ;double boubleword, each 4 bytes, so, myArray is 32bytes
    arraySize: equ $ - myArray              ;subtracts the memory offset of myArray from the current assembly position to calculate the size of the myArray array in bytes.

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, myArray
    mov edx, arraySize
    int 0x80

    ;exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80