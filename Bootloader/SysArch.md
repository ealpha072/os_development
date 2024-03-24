## Memory Mapping
On the x86 Architecture, the processor uses specific memory locations to represent certain things.
For example, The address 0xA000:0 represents the start of VRAM in the video card. By writing bytes to this location, you effectivly change what is currently in video memory, and effectivly, what is displayed on screen.

Other memory addresses can represent something else--lets say, a register perhaps for the Floppy Drive Controller (FDC)?

Understanding what addresses are what is critical, and very important to us.

1. 0x00000000 - 0x000003FF - Real Mode Interrupt Vector Table
2. 0x00000400 - 0x000004FF - BIOS Data Area
3. 0x00000500 - 0x00007BFF - Unused
4. 0x00007C00 - 0x00007DFF - Our Bootloader
5. 0x00007E00 - 0x0009FFFF - Unused
6. 0x000A0000 - 0x000BFFFF - Video RAM (VRAM) Memory
7. 0x000B0000 - 0x000B7777 - Monochrome Video Memory
8. 0x000B8000 - 0x000BFFFF - Color Video Memory
9. 0x000C0000 - 0x000C7FFF - Video ROM BIOS
10. 0x000C8000 - 0x000EFFFF - BIOS Shadow Area
11. 0x000F0000 - 0x000FFFFF - System BIOS

### Registers
he x86 processor has alot of different registers for storing its current state. Most applications only have access to the general, segment, and eflags. Other registers are specific to Ring 0 programs, such as our Kernel.
The x86 family has the following registers: **RAX (EAX(AX/AH/AL)), RBX (EBX(BX/BH/BL)), RCX (ECX(CX/CH/CL)), RDX (EDX(DX/DH/DL)), CS,SS,ES,DS,FS,GS, RSI (ESI (SI)), RDI (EDI (DI)), RBP (EBP (BP)). RSP (ESP (SP)), RIP (EIP (IP)), RFLAGS (EFLAGS (FLAGS)), DR0, DR1, DR2, DR3, DR4, DR5, DR6, DR7, TR1, TR2, TR3, TR4, TR5, TR6, TR7, CR0, CR1, CR2, CR3, CR4, CR8, ST, mm0, mm1, mm2, mm3, mm4, mm5, mm6, mm7, xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm6, xmm7, GDTR, LDTR, IDTR, MSR, and TR.** All of these registers are stored in a special area of memory inside the processor called a Register File. Please see the Processor Architecture section for more information. Other registers include, but may not be in the Resgister File, include: PC, IR, vector registers, and Hardware Registers.

Alot of these registers are only avilable to real mode ring 0 programs. And for very good reasons, too. Most of these registers effect alot of states within the processor. Incorrectly setting them can easily triple fault the CPU. Other cases, might cause the CPU to malfunction. (Most notably, the use of TR4,TR5,TR6,TR7)

Some of the other registers are internal to the CPU, and cannot be accessed through normal means. One would need to reprogram the processor itself in order to access them. Most notably, IR, the vector registers.

We will need to know some of these special registers, so lets take a look closer, shall we?

Note: Think of the CPU as any normal device that we need to comunicate with. The concept of Control Registers (and registers themselves) will be important later on when we talk to other devices.


### General Purpose Registers
These are 32 bit registers that can be used for almost any purpose. Each of these registers have a special purpose as well, however.
1. `EAX` - Accumlator Register. Primary purpose: Math calculations
2. `EBX` - Base Address Register. Primary purpose: Indirectly access memory through a base address.
3. `ECX`- Counter Register. Primary purpose: Use in counting and looping.
4. `EDX` - Data Register. Primary purpose: um... store data. Yep, thats about it :)
   
Each of these 32 bit registers has two parts. The High order word and low order word. The high order word is th upper 16 bits. The low order word is the lower 16 bits.

On 64 bit processors, these registers are 64 bits wide, and or named RAX, RBX, RCX, RDX. The lower 32 bits is the 32 bit EAX register.

The upper 16 bits does not have a special name associatd with them. However, The lower 16 bits do. These names have an oppended 'H' (for higher 8 bits in low word), or an appended 'L' for lower 8 bits.

### Segment Registers
The segment registers modify the current segment addresses in real mode. They are all 16 bit.

1. CS - Segment address of code segment
2. DS - Segment address of data segment
3. ES - Segment address of extra segment
4. SS - Segment address of stack segment
5. FS - Far Segment address
6. GS - General Purpose Register
   
Remember: Real Mode uses the segment:offset memory addressing model. The segment address is stored within a segment register. Another register, such as BP, SP, or BX can store the offset address.
It is useually refrenced like: DS:SI, where DS contains the segment address, and SI contains the offset address.

Segment registers can be used within any program, from Ring 0 to Ring 4. 

### Index Registers
The x86 uses several registers that help when access memory.

1. SI - Source Index
2. DI - Destination Index
3. BP - Base Pointer
4. SP - Stack Pointer
   
Each of these registers store a 16 bit base address (that may be used as an offset address as well.)
On 32 bit processors, these registers are 32 bits and have the names ESI, EDI, EBP, and ESP.

On 64 bit processors, each register is 64 bits in size, and have the names RSI, RDI, RBP, and RSP.

The 16 bit registers are a subset of the 32 bit registers, which is a subset of the 64 bit registers; the same way with RAX.

The Stack Pointer is automatically incremented and decremented a certain amount of bytes whenever certain instructions are encountered. Such instructions include push*, pop* instructions, ret/iret, call, syscall etc.

The C Programming Language, in fact most languages, use the stack regularly. We will need to insure we set the stack up at a good address to insure C works properly. Also, remember: The stack grows *downward*!

### Instruction Pointer / Program Counter
The Instruction Pointer (IP) register stores the current offset address of the currently exectuting instruction. Remember: This is an offset address, *Not* an absolute address!
The Instruction Pointer (IP) is sometimes also called the Program Counter (PC).

On 32 bit machines, IP is 32 bits in size and uses the name EIP.

On 64 bit machines, IP is 64 bits in size, and uses the name RIP.

### Instruction Register
This is an internal processor register that cannot be accessed through normal means. It is stored within the Control Unit (CU) of the processor inside the Instruction Cache. It stores the current instruction that is being translated to Microinstructions for use internally by the processor. Please see Processor Architecture for more information.

### EFlags Register
The EFLAGS register is the x86 Processor Status Register. It is used to determin the um.. current status. We have actually used this alot already so far. A simple example: jc, jnc, jb, jnb Instruction
Most instructions manupulate the EFLAGS register so that you can test for conditions (Like if the value was lower or higher then another).

The IO Privilege Level (IOPL) controls the current ring level required to use certain instructions. For example, the CLI, STI, IN and OUT instructions will only execute if the current Privilege Level is equal, or greater, then the IOPL. If not, a General Protection Fault (GPF) will be generated by the processor.

Most operating systems set the IOPF to 0 or 1. This means that only Kernel level software can use these instructions. This is a very good thing. After all, if an application issues a CLI, it can effectivly stop the Kernel from running.

For most operations, we only need to use the FLAGS register. Notice that the last 32 bits of the RFLAGS register is nill, null, non existant, there for viewing pleasure. So, um... yeah. For speed puposes, of course, but alot of bytes being wasted... ...yeah.

### Test Registers
The x86 family uses some registers for testing purposes. Many of these registers are undocumented. On the x86 series, these registers are TR4,TR5,TR6,TR7.
TR6 is the most commonly used for command testing, and TR7 for a test data register. One can use the MOV instruction to access them. There are only avilable in Ring 0 for both pmode and real mode. Any other attempt will cause a General Protection Fault (GPF) leading to a Triple Fault.

### Debug Registers
These registers are used for program debugging. They are DR0,DR1,DR2,DR3,DR4,DR5,DR6,DR7. Just like the test registers, they can be accessed using the MOV instruction, and only in Ring 0. Any other attempt will cause a General Protection Fault (GPF) leading to a Triple Fault.

#### Beakpoint Registers
The registers DR0, DR1, DR2, DR3 store an Absolute Address of a breakpoint condition. If Paging is enabled, the address will be converted to its Absolute address. These breakpoint conditions are further defined in DR7.

### Model Specific Register
This is a special control register that provides special processor specific features that may not be on others. As these are system level, Only Ring 0 programs can access this register.
Because these registers are specific to each processor, the actual register may change.

The x86 has two special instructions that are used to access this register:

RDMSR - Read from MSR
WRMSR - Write from MSR
The registers are very processor specific. Because of this, it is wise to use the CPUID instruction before using them.

To access a given register, one must pass the instructions an Address which represents the register you want access to.

Through the years, Intel has used some MSRs that are not machine specific. These MSRs are common within the x86 architecture.

### Control Registers
THIS is going to be important to us.
The control registers allow us to change the behavior of the processor. They are: CR0, CR1, CR2, CR3, CR4.

#### CR0 Control Register
CR0 is the primary control register. It is 32 bits, which are defined as follows:

1. Bit 0 (PE) : Puts the system into protected mode
2. Bit 1 (MP) : Monitor Coprocessor Flag This controls the operation of the WAIT instruction.
3. Bit 2 (EM) : Emulate Flag. When set, coprocessor instructions will generate an exception
4. Bit 3 (TS) : Task Switched Flag This will be set when the processor switches to another task.
5. Bit 4 (ET) : ExtensionType Flag. This tells us what type of coprocesor is installed.
  * 0 - 80287 is installed
  * 1 - 80387 is installed.
6. Bit 5 (NE): Numeric Error
  *0 - Enable standard error reporting
  1 - Enable internal x87 FPU error reporting
7. Bits 6-15 : Unused
8. Bit 16 (WP): Write Protect
Bit 17: Unused
Bit 18 (AM): Alignment Mask
0 - Alignment Check Disable
1 - Alignment Check Enabled (Also requires AC flag set in EFLAGS and ring 3)
Bits 19-28: Unused
Bit 29 (NW): Not Write-Through
Bit 30 (CD): Cache Disable
Bit 31 (PG) : Enables Memory Paging.
0 - Disable
1 - Enabled and use CR3 register
Wow... alot of new stuff, huh? Lets look at Bit 0--Puts system in protected mode. This means, By setting Bit 0 in the CR0 register, we effectivly enter protected mode.
For example:
