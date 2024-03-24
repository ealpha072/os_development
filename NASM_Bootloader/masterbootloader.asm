bits 16
org 0x7c00

MOV SI, HelloMsg
CALL PrintString
JMP $

PrintString:
	MOV AH, 0x0E

.loop:
	LODSB
	CMP AL, 0
	JE .done
	INT 0x10
	JMP .loop
.done:
	RET

HelloMsg:
	DB "Hello world", 0

TIMES 510 - ($ - $$) DB 0
DW 0xAA55
