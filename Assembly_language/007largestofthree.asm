section .data
    msg db "Largest of the three is: ", 0xA, 0xD
    len equ $ - msg
    numone dd '47'
    numtwo dd '22'
    numthree dd '31'

section .text
    global _start

_start:
    

section .bss
    largest resb 2