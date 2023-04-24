.reset:
  mov ah, 0x0 ;set function to reset
  int 0x13    ;call the interupt
  
 .read:
  
