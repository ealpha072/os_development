# Introduction

We also looked at the BIOS Interrupt (INT) 0x19, which searches for a boot signiture (0xAA55), and, if found, loads and executes our bootloader at 0x7C00.

# Processor Modes

The x86 family of processors boots up in a 16-bit environment because of historical reasons. When the first x86 processors were introduced in the late 1970s and early 1980s, they were designed to be compatible with the 16-bit Intel 8086 processor, which was already in widespread use at the time. The 8086 was designed to work in a 16-bit real mode, and this mode was retained for compatibility reasons in later generations of x86 processors.

`Real Mode` - Real mode is a 16-bit operating mode that is used by x86 processors, such as the Intel 8086, during system boot-up and for running old DOS applications. In real mode, the processor operates with only 20 bits of addressable memory (1 MB of physical memory), and all memory addresses are calculated relative to a base address of zero. 
