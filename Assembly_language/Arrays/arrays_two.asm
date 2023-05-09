;print even numbers in an array

section .data
    myArray dd 2,13,14,6,8,3,7,11                   ;define double word
    arraySize equ ($ - myArray) / 4                 ;array size, number of elements

section .text
    global _start

_start:
    mov ebx, 0

print_even:
    mov eax, [myArray + ebx*4]                      ;indexing, 
    and eax, 1                                      ;bitwise and on eax
    jz print_number                                 ;jump if eax is zero, 
    ;else continue to next element
    add ebx, 1                                      ;increament ebx to move to next index
    cmp ebx, arraySize                              ;compare ebx and arraySize
    jl print_even                                   ;jump if less
    ;else we are done

print_number:
    mov ecx, eax
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 0x80

    ;After printing number, continue to next element
    add ebx, 1
    cmp ebx, arraySize
    jl print_even
    ;we are done

    mov eax, 1
    xor ebx, ebx
    int 0x80

;je: Jump if equal
;jne: Jump if not equal
;jg: Jump if greater
;jge: Jump if greater or equal
;jl: Jump if less
;jle: Jump if less or equal
;jo: Jump if overflow
;jno: Jump if not overflow
;js: Jump if sign
;jns: Jump if not sign
;jp: Jump if parity (even number of 1 bits)
;jnp: Jump if not parity (odd number of 1 bits)
;jc: Jump if carry (unsigned overflow)
;jnc: Jump if not carry (no unsigned overflow)