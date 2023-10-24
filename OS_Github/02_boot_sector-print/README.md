### Goal: Make our previously silent boot sector print some text

We will improve a bit on our infinite-loop boot sector and print something on the screen. We will raise an interrupt for this.

We are going to write each character of the "Hello" word into the register al (lower part of ax), the bytes 0x0e into ah (the higher part of ax) and raise interrupt 0x10 which is a general interrupt for video services.

0x0e on ah tells the video interrupt that the actual function we want to run is to 'write the contents of al in tty mode'.

To compile: ` *nasm -f bin boot_sector-print.asm -o boot_sector-print.bin* `

To run using QEMU: `qemu boot_sect_simple.bin`