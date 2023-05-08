;reset disk before reading sectors

.reset:
  mov ah, 0x0 		;set function to reset
  mov dl, 0x0 		;set drive number
  int 0x13    		;call the interupt
  jc .reset.  		;Jump if carry

 .read:
  mov ah, 0x2   	;set AH to 0x02 to indicate read sector cmd
  mov al, 0x1   	;sector number
  mov ch, 0x1   	;cylinder number
  mov cl, 0x1   	;sector number
  mov dh, 0x0   	;head number
  mov dl, 0x0   	;drive number
  int 0x13      	;call the interrupt
  jc .read      	;if carry flag is set, try again

  jmp 0x1000:0x0   	;jump to execute the sector
