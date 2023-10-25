###  Memory, Addresses, and Labels

We can imagine the main memory as long sequence of bytes that can individually be accessed by an address (i.e. an index), so if we want to find out what is in the 54th byte of memory, then 54 is our address, which is often more convenient to express in hexadecimal: 0x36.

So the start of our boot-sector code, the very first machine code byte, is at some address in memory, and it was BIOS that put us there. We might assume,unless we knew otherwise, that BIOS loaded our code at the start of memory, at address 0x0.

It’s not so straightforward, though, because we know that BIOS has already being doing initialisation work on the computer long before it loaded our code, and will actually continue to service hardware interrupts for the clock, disk drives, and so on. So these BIOS routines (e.g. ISRs, services for screen printing, etc.) themselves must be stored somewhere in memory and must be preserved (i.e. not overwritten) whilst they are still of use. The interrupt vector (IVT) is located at the start of memory, and were BIOS to load us there, our code would stomp over the table, and upon the next interrupt occurring, the computer will likely crash and reboot: the mapping between interrupt number and ISR would effectively have been severed.

As it turns out, BIOS likes always to load the boot sector to the address 0x7c00, where it is sure will not be occupied by important routines.