;The following program illustrates some of the concepts discussed above. 
;It stores a name 'Zara Ali' in the datasection of the memory. 
;Then changes its value to another name 'Nuha Ali' programmatically and displays both the names.

section .data
    name db "Zara Ali", 0xa

section .text
    global _start

_start:

;write name to stdoutput
    mov eax, 4
	mov ebx, 1
	mov ecx, name
	mov edx, 9
	int 0x80

    mov [name], dword 'Nuha'

;write name Nuha Ali to stdoutput
    mov eax, 4
	mov ebx, 1
	mov ecx, name
	mov edx, 9
	int 0x80

;exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80
