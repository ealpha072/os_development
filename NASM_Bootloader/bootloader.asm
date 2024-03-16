;**************************************
;bootloader.asm
;A simple bootloader
;**************************************

org 0x7c00
bits 16
start: jmp boot

;; Constants and variable definitions

msg db "Welcome to Alpha OS!", 0ah, 0dh, 0h

boot:
	cli
	cld
	hlt

times 510 - ($-$$) db 0
dw 0xAA55
