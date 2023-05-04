; A loop to print hello world 10 times
; Compile with: nasm -f elf hello_world_loop.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 hello_world_loop.o -o hellowoldloop
; Run with ./helloworldloop

SECTION .data
    hello db "Hello world!", 0
    count db 10

SECTION .text
    global _start

_start:
    mov eax, 4              ;system call for write
    mov ebx, 1              ;file descriptor
    mov ecx, count          ;move count to ecx
    mov edx, 12             ;number of bytes to read
    mov esi, hello          ;Address of msg to esi

loop_start:
    cmp ecx, 0              ;compare ecx to 0
    je loop_end             ;(jump if equal) jump to end of loop
    int 0x80                ;call the kernel
    dec ecx                 ;decrease ecx
    jmp loop_start          ;jump to loop_start

loop_end:
    mov eax, 1              ;set exit code to eax
    xor ebx, ebx            ;
    int 0x80


