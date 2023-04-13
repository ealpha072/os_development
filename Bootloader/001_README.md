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
      - It creates an **Interrupt Vector Table (IVT)** , and provides some basic interrupt services. An Interrupt Vector Table (IVT) is a data structure used by a computer's operating system to manage interrupt handling. An interrupt is a signal sent by a device or program to the CPU, indicating that it requires the CPU's attention to perform a specific task. When the CPU receives an interrupt signal, it stops its current task, saves its state, and jumps to a specific memory address that is associated with the interrupt. More on [IVT](IVT.md)
      - The BIOS also supplies a Setup utility.
      - The BIOS then needs to find an OS. 
      - Based on the boot order that you set in the BIOS Setup, the BIOS will execute Interrupt (INT) 0x19 to attempt to find a bootable device. `Interrupt 0x19` is used by the BIOS to retry the boot process if the previous boot attempt failed. When the interrupt is invoked, the BIOS will reset the system and try to boot from the next available boot device.
      - If no bootable device is found (INT 0x19 returns), the BIOS goes on to the next device listed in the boot order. If there is no more devices, it will print an error similar to "No Operating System found" and halt the system.
      - `INT 0x19 - SYSTEM: BOOTSTRAP LOADER` - Reboots the system through a Warm Reboot without clearing memory or restoring the Interrupt Vector Table (IVT). This interrupt is executed by the BIOS. It reads the first sector (Sector 1, Head 0, Track 0) of the first hard disk. A `Sector` simply represents a goupe of 512 bytes. So, Sector 1 represents the first 512 bytes of a disk.

       
      ![platter 1](https://user-images.githubusercontent.com/65494407/231854822-b0f153e4-20f8-493a-837c-16153ef12784.gif)
       
       
      - A Track is a collection of sectors.
    ***Note**: Remember that 1 sector is 512 bytes, and there are 18 sectors per track on floppy disks. This wil be important when loading files.
      - If the disk is bootable, Then the bootsector will be loaded at 0x7C00, and INT 0x19 will jump to it, therby giving control to the bootloader.
4. Next file [Bootloader Theory]()
