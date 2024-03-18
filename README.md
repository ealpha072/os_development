# os_development
Materials on OS development.

### Bootstrapping
1. ** Understanding Bootstrapping ** - Bootstrapping is the first stage in the execution of an operating system. It involves a sequence of events starting from the moment the computer is powered on until the operating system is fully loaded and running. The process varies depending on the architecture of the computer system, but the general principles remain the same.

2. * Bootloader Development * - The bootloader is a small program that resides in the boot sector of a storage device, typically the first sector (sector 0) of a disk or the Master Boot Record (MBR) on a partitioned disk. The primary task of the bootloader is to locate the operating system kernel, load it into memory, and transfer control to the kernel to start the operating system. Bootloaders are usually written in assembly language due to their low-level nature and the need for direct hardware interaction. Bootloader code must be concise, efficient, and capable of loading the kernel from various storage devices such as hard drives, solid-state drives, or network interfaces.

Startup Code - Once the bootloader has loaded the operating system kernel into memory, control is transferred to the startup code. The startup code initializes the system environment required for executing the kernel. This includes setting up processor registers, enabling memory protection mechanisms, configuring interrupt handlers, and initializing hardware devices. The startup code may also perform basic hardware diagnostics and initialization routines to ensure the system is in a stable state before handing control over to the kernel.

