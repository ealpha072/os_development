[org 0x7c00] 			;sets origin of bootloader

mov ah, 0x0e            	;to use teletype services
mov bh, 0x00            	;color background of screen
mov si, hello_msg       	;move eddress of hello_msg to si addess, si is a general purpose address

print_loop:
	lodsb           	;load next byte from SI into AL, and increase SI 
	cmp al, 0       	;compare if value of AL is zero
	je print_done   	;(jump if equal) if its zero, we have reached the end of the string, 
	int 0x10
	jmp print_loop  	;loop again
print_done:
	jmp $			;jump to current line

hello_msg db 'Hello user', 0	;define byte "Hello user"
times 510 - ($ -$$) db 0	;repeat to fill 0 in the first 510 bytes
dw 0xaa55			;boot signature
