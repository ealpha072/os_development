[org 0x7c00]

;print string to std output "Hi"
mov ah, 0x0E.  ;Teletype 
mov al, 'H'   ;Move byte
int 0x10
mov al, 'i'
int 0x10

times 510 - ($-$$) db 0
dw 0xAA55

