`An Interrupt Vector Table (IVT)` - is a data structure used by a computer's operating system to manage interrupt handling. An interrupt is a signal sent by a device or program to the CPU, indicating that it requires the CPU's attention to perform a specific task. When the CPU receives an interrupt signal, it stops its current task, saves its state, and jumps to a specific memory address that is associated with the interrupt.

The IVT is a table of memory addresses that maps each interrupt number to the address of the corresponding interrupt handler routine in memory. Each entry in the table is called an interrupt vector, and it contains the address of the interrupt handler routine for a specific interrupt number.

The interrupt handler routine is a program that performs the specific task associated with the interrupt. When an interrupt occurs, the CPU looks up the corresponding interrupt vector in the IVT, retrieves the address of the interrupt handler routine, and jumps to that address to execute the routine.

The IVT is typically located in a fixed location in memory, and it is initialized by the operating system during system startup. The size of the IVT and the number of interrupts it can handle depend on the architecture of the computer's CPU and the design of the operating system.

** IVT TABLE FOR THE (X86) ARCHITECTURE **

IVT Offset | INT #     | Description
-----------|-----------|------------------------------
0x0000     | 0x00      | Divide by 0
0x0004     | 0x01      | Reserved
0x0008     | 0x02      | NMI Interrupt
0x000C     | 0x03      | Breakpoint (INT3)
0x0010     | 0x04      | Overflow (INTO)
0x0014     | 0x05      | Bounds range exceeded (BOUND)
0x0018     | 0x06      | Invalid opcode (UD2)
0x001C     | 0x07      | Device not available (WAIT/FWAIT)

The IVT Offset column indicates the memory location of each interrupt vector, which is the starting address of the interrupt handler routine. The INT # column indicates the interrupt number associated with each vector, and the Description column provides a brief description of the corresponding interrupt.

In this example, the IVT starts at memory address 0x0000, and the first three entries are for the Divide by 0, Reserved, and Non-Maskable Interrupt (NMI) handlers.

When an interrupt occurs, the CPU will use the interrupt number to look up the corresponding interrupt vector in the IVT and jump to the address specified in the vector to execute the interrupt handler routine.

More IVT Found at [IVT Full Table](https://wiki.osdev.org/Interrupt_Vector_Table#:~:text=On%20the%20x86%20architecture%2C%20the,4%20bytes%20for%20each%20interrupt).

