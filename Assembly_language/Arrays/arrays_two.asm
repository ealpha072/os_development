;print even numbers in an array

section .data
    myArray: dd 2,13,14,6,8,3,7,11
    arraySize: equ $ - myArray

section .text
    global _start

_start:
    ;loop through each element of the array
    mov ecx, myArray
    mov ebx, 0

    print_loop:
        cmp ebx, arraySize
        jge exit_program

        mov eax, [ecx+ebx*4]
        and eax, 1
        cmp eax, 0
        jne next_element

        ;if even, print it
        mov eax, 4
        mov ebx, 1
        mov ecx, 
    
    ;next element


        ;exit_program
