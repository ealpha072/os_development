;print hello world to screen

mov ah, 0x0E ;int 10/ ah = 0eh -> scrolling teletype BIOS routine
mov al, 'H'
int 0x10
mov al, 'E'
int 0x10
mov al, 'L'
int 0x10
mov al, 'L'
int 0x10
mov al, 'O'
int 0x10

;padding and magic BIOS number

jump $

times 510 - ($-$$) db 0 ;Pad the boot sector out with zeros
dw 0xaa55               ;Last two bytes form the magic number ,
