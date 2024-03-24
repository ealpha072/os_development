# Bootloader Theory

Bootloaders...
  - ...Are stored with the Master Boot Record (MBR).
  - ...Are in the first sector of the disk.
  - ...Are the size of a single sector (512) bytes.
  - ...Are loaded by the BIOS INT 0x19 at address 0x7C00.
    
Here’s a list of things that a modern boot loader should do in order to load and start your operating system’s kernel.
1. Reset the floppy disk system
2. Write a “loading” message to the screen
3. Find the kernel in the root directory of the disk (at any position)
4. Read the kernel from disk into memory
5. Enable the A20-line
6. Setup the IDT and GDT tables
7. Switch to protected mode
8. Clear the processor prefetch queue
9. Run the kernel
    
We cannot do a whole lot in 512 bytes. What do we do? So, the code could look just fine, but only a part of it will be in memory. For example, coinsider this:
```asm
mov	ax, 4ch
inc	bx         ; 512 byte
mov     [var], bx  ; 514 byte

;If the above code was executed, and only the first sector was loaded in memory, 
;It will only copy up to the 512 byte (The inc bx instruction). 
;So, while the last mov instruction is still on disk, It isnt in memory!.
```

`Hardware Exceptions` - Hardware Exceptions are just like Software Exceptions, however the processor will execute them rather then software.
`CLI and STI Instructions` - You can use the STI and CLI instructions to enable and disable all interrupts. Most systems do not allow these instructions for applications as it can cause big problems (Although systems can emulate them).
```asm
cli		; clear interrupts
 
; do something...
 
sti		; enable interrupts--we're in the clear!
```

## Developing a simple Bootloader
A simple bootloader [here](Boot1.asm)
