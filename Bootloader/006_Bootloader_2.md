## Introduction
We will cover:
  - BIOS Paramater Block and the MBR
  - Processor Modes
  - Interrups - Printing text and more
  - Segment:Offset Addressing Mode
 
## Processor Modes
### Real Mode
Real mode...
  - Uses the native segment:offset memory model.
  - Is limited to 1 MB (+64k, 2^16) of memory.
  - No Virtual Memory or Memory Protection.

`Segment:Offset Memory Mode` - is a memory addressing mode used in the real mode of x86-compatible processors, such as the Intel 8086 and 80286. In this mode, a memory address is composed of two parts: a segment value and an offset value.  A segment is a section of memory.
The x86 Family of processors uses 4 primary registes that store the beginning location of a segment. Its like a base address--It provides the start of a segment. Normally, a segment may be 64 KB in size, and are freely movable. if the segment base address is 0, then this represents the segment between byte 0 and 64 KB. More on sement offset [here](segment_offsets.md)

The registers the x86 use for segment refrencing are as follows:
  - CS (Code Segment) - Stores base segment address for code
  - DS (Data Segment) - Stores base segment address for data
  - ES (Extra Segment) - Stores base segment address for anything
  - SS (Stack Segment) - Stores base segment address for the stack

### Protected Mode
PMode allows Memory Protection through the use of a Descriptor Tables that describe your memory layout. PMode is a 32 bit processor modes, so it also allows you to use 32 bit registers, and access up to 4 GB of RAM. A huge improvment over Real Mode. 

## Switching Processor modes
The only two built in actual modes and **Real Mode** and **Potected Mode**
There is some important things to remember about PMode however:
  - Absolutley no interrupts will be avilable. You will need to write them yourself. The use of any interrupt--hardware or software will cause a Triple Fault
  - Once you switch into pmode, the *slightest* mistake will cause a Triple Fault. Be carefull.
  - PMode requires the use of Descriptor Tables, such as the GDT, LDT, and IDTs.
  - PMode gives you access to 4 GB of Memory, With Memory Protection
  - Segment:Offset Addressing is used along with Linear Addressing
  - Access and use of 32 bit registers
 
## Expanding the Bootloader
### Printing Text - Interrupt 0x10 Function 0x0E
You an use INT 0x10 for video interrupts. INT 0x10 - VIDEO TELETYPE OUTPUT;
- AH = 0x0E - Move 0x0E to address AH
- AL = Character to write ,The ASCII code of the character to be displayed is placed in the AL register.
- BH - Page Number (Should be 0)
- BL = Foreground color (Graphics Modes Only)

The BIOS interrupt 0x10 is called with the AH register set to 0x0e, which indicates the teletype output function.
To print 'A' to the screen
```asm
xor bx, bx
mov ah, 0x0e
mov al, 'A'
int 0x10
```
More on int 0x10 [here](https://en.wikipedia.org/wiki/INT_10H)

### Printing Strings - Interrupt 0x10 Function 0x0E
Using the same interrupt, we can easily print out a 0 terminated string. To print a string "Hello world" in a bootloader, you can use a loop to iterate through each character in the string, and then use the teletype output function (0x0e) of the BIOS interrupt 0x10 to print each character on the screen.

We will now have a bootloader that looks like this [here](NASM_Bootloader/bootloader_two.asm)

The **lodsb** instruction is an x86 instruction that loads a byte from the memory location pointed to by the source index (SI) register into the AL register, and then increments the SI register to point to the next byte.

Here's a breakdown of how the "lodsb" instruction works:
- The "lodsb" instruction first reads the value in the SI register, which is assumed to hold a memory address.
- The "lodsb" instruction reads a single byte of data from the memory location pointed to by the SI register and loads it into the AL register.
- The "lodsb" instruction then increments the SI register by 1 (or 2, or 4, depending on the operand size).
- The "lodsb" instruction is now complete, and the byte of data that was loaded into the AL register can be used in subsequent instructions.

