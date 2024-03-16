;
;A simple boot sector that loops for ever
;This will be the starting point for developing the boot loader


loop:
	jmp loop		;Jumps to the current instruction
	
times 510 - ($-$$) db 0		;when compiled, program should fit it exactly in 512b
				;with the last two bytes having the boot signature
				;This tells compiler to pad first 510 bytes with 0s

dw 0xAA55			;This is the boot signature

;
