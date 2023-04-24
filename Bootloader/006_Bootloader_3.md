## Introduction
This program will be our Second Stage Bootloader. Our Second Stage Bootloader will then set the 32 bit envirement, and prepare to load our C Kernel.

## The Rings of Assembly Language
In Assembly Language, you might here the term "Ring 0 program", or "This program is running in Ring 3". Understanding the different rings (and what they are) can be usefull in OS Development. A "Ring", in Assembly Language, represents the level of protection and control the program has over the system. There are 4 rings: Ring 0, Ring 1, Ring 2, and Ring 3.  Ring 0 programs have absolute control over everything within a system, while ring 3 has less control. The smaller the ring number, the more control (and less level of protection), the software has.

A **Ring** is more then a concept--it is built into the processor arhcitecture. When the computer boots up, even when your Bootloader executes, the processor is in Ring 0. Most applications, such as DOS applications, run in Ring 3. This means Operating Systems, as running in Ring 0, have far more control over everything then normal Ring 3 applications. 
Here is a brief overview of each ring:
- Ring 0 (also known as the kernel mode or supervisor mode) is the most privileged ring and is typically reserved for the operating system kernel. Code running in ring 0 has access to all system resources and can execute privileged instructions.
- Ring 1 and Ring 2 (also known as the device driver or subsystem modes) are less privileged than ring 0 and are typically used by device drivers or other system components that require a higher level of privilege than normal user applications. Code running in these rings has access to a subset of system resources and can execute a subset of privileged instructions.
- Ring 3 (also known as the user mode) is the least privileged ring and is used by normal user applications. Code running in ring 3 has limited access to system resources and can only execute a subset of instructions that are not privileged.

## Multi Stage Bootloaders
### Single Stage Bootloaders
Remember that bootloaders, and bootsectors, are only 512 bytes in size. If the bootloader, within that same 512 bytes, executed the kernel directly, it is called a Single Stage Bootloader. The problem with this, however, is that of its size. There is so little room to do alot within those 512 bytes. It will be very difficault to set up, load and execute a 32 bit kernel within a 16 bit bootloader. This does not include error handling code. This includes code for: GDT, IDT, A20, PMode, Loading and finding 32 bit kernel, executing kernel, and error handling. Fitting all of this code within 512 bytes is impossible. Because of this, Single stage bootloaders have to load and execute a 16 bit kernel. 

Because of this problem, most bootloaders are Multi Stage Loaders. 

### Multi Stage Bootloaders
A Multi Stage Bootloader consists of a single 512 byte bootloader (The Single Stage Loader), however it just loads and executes another loader - A Second Stage Bootloader. the Second Stage Bootloader is normally 16 bit, however it will include all of the code (listed in the previous section), and more. It will be able to load and execute a 32 bit Kernel.  The reason this works is because the only 512 byte limitation is the bootloader. As long as the bootloader loads all of the sectors for the Second Stage loader in good manner, the Second Stage Loader has no limitation in size. This makes things much easier to set up for the Kernel.

We will be using a 2 Stage Bootloader. 

## Loading Sectors Off Disk
Remember that Bootloaders are limited to 512 bytes. Because of this, there is not a whole lot we can do. As stated in the previous section, we are going to be using a 2 Stage Bootloader. This means, we will need our Bootloader to load and execute our Stage 2 program -- The Kernel Loader. 

**`BIOS Interrupt (INT) 0x13 Function 0 - Reset Floppy Disk`** - The BIOS Interrupt 0x13 is used for disk access. You can use INT 0x13, Function 0 to reset the floppy drive. What this means is, wherever the Floppy Controller is reading from, it will immediately go to the first Sector on disk. BIOS interrupt 0x13 is a low-level disk I/O interrupt that allows a bootloader or operating system to read and write sectors from a storage device (such as a hard disk or floppy disk) using BIOS routines.

The interrupt is typically called with the AH register set to a command code that specifies the type of operation to perform, and the other registers set to parameters such as the number of sectors to read or write, the starting sector number, and the buffer address. The BIOS interrupt `0x13 with AH=0x0` is used to reset the disk system. This interrupt resets all disk drives in the system to a known state.

**INT 0x13/AH=0x0 - DISK : RESET DISK SYSTEM** </br>
AH = 0x0 </br>
DL = Drive to Reset

Returns:
AH = Status Code </br>
CF (Carry Flag) is clear if success, it is set if failure

Example
```asm
mov ah, 0x0 ; Set AH to 0x0 to indicate disk reset command
int 0x13    ; Call BIOS interrupt 0x13
```

Why is this interrupt important to us? Before reading any sectors, we have to insure we begin from sector 0. We dont know what sector the floppy controller is reading from. This is bad, as it can change from any time you reboot. Reseting the disk to sector 0 will insure you are reading the same sectors each time. 

**`BIOS Interrupt (INT) 0x13 Function 0x02 - Reading Sectors`** - sed to read disk sectors into memory. This interrupt is typically used to load boot code or other data from disk into memory during system startup.
When this interrupt is called with AH=0x2, the other registers are used to specify the disk address and number of sectors to read. The disk address is specified using the CH, CL, and DH registers, while the number of sectors to read is specified using the AL register.

After the read operation is complete, the data is typically stored in memory at the location specified by the ES:BX register pair.

**INT 0x13/AH=0x02 - DISK : READ SECTOR(S) INTO MEMORY** </br>
AH = 0x02 </br>
AL = Number of sectors to read </br>
CH = Low eight bits of cylinder number </br>
CL = Sector Number (Bits 0-5). Bits 6-7 are for hard disks only </br>
DH = Head Number </br>
DL = Drive Number (Bit 7 set for hard disks) </br>
ES:BX = Buffer to read sectors to

Returns:
AH = Status Code </br>
AL = Number of sectors read </br>
CF = set if failure, cleared is successfull

```asm
mov ah, 0x2      ; Set AH to 0x2 to indicate read sector command
mov al, 0x1      ; Set AL to 0x1 to read a single sector
mov ch, 0x0      ; Set CH to the cylinder number
mov cl, 0x2      ; Set CL to the sector number
mov dh, 0x0      ; Set DH to the head number
mov dl, 0x80     ; Set DL to the drive number
mov bx, 0x7c00   ; Set BX to the address in memory to store the data
mov es, bx       ; Set ES to the same value as BX for convenience
xor bx, bx       ; Clear BX to offset

int 0x13         ; Call BIOS interrupt 0x13 to read the sector
```
**CH = Low eight bits of cylinder number** - What is a Cylinder? A cylinder is a group of tracks (with the same radius) on the disk. To better understand this, lets look at a picture: 

![image](https://user-images.githubusercontent.com/65494407/234108177-536a6c01-6f45-48c2-82a8-be33f0bea76f.png)

Remember:
- Each Track is useually divided into 512 byte sectors. On floppies, there are 18 sectors per track.
- A Cylinder is a group of tracks with the same radius (The Red tracks in the picture above are one cylinder)
- Floppy Disks have two heads (Displayed in the picture)
- There is 2880 Sectors total.

**In summary, there are 512 bytes per sector, 18 sectors per track, and 80 tracks per side.**

**CL = Sector Number (Bits 0-5). Bits 6-7 are for hard disks only** - This is the first sector to begin reading from. Remember: There is only 18 sectors per track. This means that this value can only be between 0 and 17. You have to increase the current track number, and insure the sector number is correctly set to read the correct sector.

If this value is greater then 18, The Floppy Controller will generate an exception, because the sector does not exist. Because there is no handler for it, The CPU will generate a second fault exception, which will ultimately lead to a Triple Fault. 

**DH = Head Number** - Remember that some floppys have two heads, or sides, to them. Head 0 is on the front side, where sector 0 is. Because of this, We are going to be reading from Head 0. If this value is greater than 2, The Floppy Controller will generate an exception, because the head does not exist. Because there is no handler for it, The CPU will generate a second fault exception, which will ultimately lead to a Triple Fault.

**DL = Drive Number (Bit 7 set for hard disks)
ES:BX = Buffer to read sectors to**

A Drive Number represents a drive. Drive Number 0 useually represents a floppy drive.Because we are on a floppy, we want to read from the floppy disk. So, the drive number to read from is 0.

ES:BX stores the segment:offset base address to read the sectors into. Remember that the Base Address represents the starting address. 
With this all in mind, lets try to read a sector;


