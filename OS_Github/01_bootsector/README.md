### Goal: To create a simple boot sector (file) that the BIOS will inteprate as a bootable disk

To make sure that the "disk is bootable", the BIOS checks that bytes 511 and 512 of the alleged boot sector are bytes 0xAA55
This is the simplest boot sector ever:

```
e9 fd ff 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 29 more lines with sixteen zero-bytes each ]
00 00 00 00 00 00 00 00 00 00 00 00 00 00 55 aa
```

#### Simple bootsector - 
You can either write the above 512 bytes with a binary editor, or just write a very simple assembler code:

```asm
loop 
    jmp loop

times 510 - ($ - $$) db
dw 0xaa55
```

To compile: ` *nasm -f bin boot_sect_simple.asm -o boot_sect_simple.bin* `

To run using QEMU: `qemu boot_sect_simple.bin`