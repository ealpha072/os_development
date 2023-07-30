;infinite loop

loop:
    jmp loop

times 510 - ($ - $$) db 0
;magic number
dw 0xaa55