bits 16
org 0x7c00

;where to load the kernel
KERNEL_OFFSET equ 0x1000

;BIOS sets boot drive in 'dl'
MOV [BOOT_DRIVE], dl

;setup the stack
MOV BP, 0x9000
MOV sp, bp

call load_kernel
call swith_to_32bits

jmp $

%include "disk.asm"
%include "gdt.asm"
%include "switch_to_32bit.asm"

bits 16

load_kernel;
	mov bx, KERNEL_OFFSET
	mov dh, 2
	mov dl, [BOOT_DRIVE]
	call disk_load
	ret

bits 32

switch_32bits
	call KERNEL_OFFSET
	JMP $

; boot drive variable
BOOT_DRIVE DB 0

;padding
TIMES 510 - ($ - $$) DB 0

DW 0xAA55
	
