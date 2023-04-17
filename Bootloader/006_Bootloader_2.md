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
  - Is limited to 1 MB (+64k) of memory.
  - No Virtual Memory or Memory Protection.

`Segment:Offset Memory Mode` - is a memory addressing mode used in the real mode of x86-compatible processors, such as the Intel 8086 and 80286. In this mode, a memory address is composed of two parts: a segment value and an offset value.  A segment is a section of memory.
The x86 Family of processors uses 4 primary registes that store the beginning location of a segment. Its like a base address--It provides the start of a segment. Normally, a segment may be 64 KB in size, and are freely movable. if the segment base address is 0, then this represents the segment between byte 0 and 64 KB. More on sement offset [here]()
