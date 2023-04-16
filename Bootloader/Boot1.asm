;*********************************************
;	Boot1.asm
;       - A Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************
 
org 0x7c00			
bits 16

Start:
  cli
  hlt

times 510 - ($-$$) db 0
dw 0xAA55

; org 0x7c00 - Sets the origin of the program to memory address 0x7c00. This is where the BIOS loads the boot sector into memory.
; bits 16 - Sets the processor into 16-bit mode, We are still in 16 bit Real Mode
; Start - Defines a label named "Start" for the beginning of the program.
; Clear all Interrupts. This instruction disables interrupts from being processed by the CPU.
; halt - the system. This instruction stops the CPU until the next interrupt is received.

;times 510 - ($-$$) db 0: Fills the rest of the 512-byte boot sector with zeros to ensure that it is exactly 512 bytes in size. 
;The $ symbol represents the current position in the code, and $$ represents the beginning of the code. 
;So $-$$ gives the current position relative to the beginning of the code. 
;The times directive repeats the db 0 (which means "define byte 0") instruction until a total of 510 bytes have been written.

;The boot signature is a 16-bit value (0xAA55) that indicates to the BIOS that this is a valid boot sector. 
;The BIOS checks for this signature to determine whether to boot from the disk.
;Assemble with, nasm -f bin Boot1.asm -o Boot1.bin
