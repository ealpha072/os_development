### Booting process
1. `Pressing the power button` - When this button is pressed, the wires connected to the button send an electronic signal to the motherboard. The motherboard simply reroutes this signal to the power supply (PSU). The PSU then sends a signal, called the "power_good" signal into the motherboard to the Basic Input Output System (BIOS).

2. `BIOS POST` - When the BIOS recieves this "power_good" signal, the BIOS begins initializing a process called POST (Power On Self Test). The POST then tests to insure there is good amount of power being supplied, the devices installed (such as keyboard, mouse, USB, serial ports, etc.), and insures the memory is good. 
  - The POST then gives control to the BIOS. 
  - The POST loads the BIOS at the end of memory (Might be 0xFFFFF0) and puts a jump instruction at the first byte in memory.
  - The processors Instruction Pointer (CS:IP) is set to 0, and the processor takes control.
  - The processor starts executing instructions at address 0x0 (the jump instruction placed by the POST)
  - This jump instruction jumps to 0xFFFFF0 (or wherever the BIOS was loaded), and the processor starts executing the BIOS.
The BIOS takes control...

3. `The BIOS` - The Basic Input Output System (BIOS) does several things:
  - It creates an **Interrupt Vector Table (IVT)** , and provides some basic interrupt services. An Interrupt Vector Table (IVT) is a data structure used by a computer's operating system to manage interrupt handling. An interrupt is a signal sent by a device or program to the CPU, indicating that it requires the CPU's attention to perform a specific task. When the CPU receives an interrupt signal, it stops its current task, saves its state, and jumps to a specific memory address that is associated with the interrupt. 
