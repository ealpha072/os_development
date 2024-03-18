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

**INT 0x13/AH=0x0 - DISK : RESET DISK SYSTEM [More here](https://stanislavs.org/helppc/int_13-0.html)** </br> 

Function 0 of Interrupt 13h requires several input parameters to perform disk operations. </br>
`AH`: This register holds the function number (in this case, 0 or 0x0).
`DL`: Drive number to reset. This specifies the drive from which to read. This is typically set to 0x00 (0) for the first floppy disk drive (A:), 0x80 for the first hard disk drive (C:), and so on.


Returns:
`AH`: = Status Code (puts the disk reset operation status) </br>
CF (Carry Flag) is clear if success, it is set if failure

Example
```asm
.Reset
  mov ah, 0x0 ; Set AH to 0x0 to indicate disk reset command
  mov dl, 0x0 ; Set the driver number in register dl
  int 0x13    ; Call BIOS interrupt 0x13
  jc .Reset   ; 
```

Why is this interrupt important to us? Before reading any sectors, we have to ensure we begin from sector 0. We dont know what sector the floppy controller is reading from. This is bad, as it can change from any time you reboot. Reseting the disk to sector 0 will insure you are reading the same sectors each time. 

**`BIOS Interrupt (INT) 0x13 Function 0x02 - Reading Sectors`** - sed to read disk sectors into memory. This interrupt is typically used to load boot code or other data from disk into memory during system startup.
When this interrupt is called with AH=0x2, the other registers are used to specify the disk address and number of sectors to read. The disk address is specified using the CH, CL, and DH registers, while the number of sectors to read is specified using the AL register.

After the read operation is complete, the data is typically stored in memory at the location specified by the ES:BX register pair.

**INT 0x13/AH=0x02 - DISK : READ SECTOR(S) INTO MEMORY [More here](https://stanislavs.org/helppc/int_13-2.html)** </br>
AH = 0x02 (function number doe INT 0x13) </br>
AL = Number of sectors to read (1-128 dec.) </br>
CH = track/cylinder number  (0-1023 dec.) Low eight bits of cylinder number </br>
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

An example of reading and reseting in [here](NASM_Bootloader/boot_three.asm)

**Note: If there is a problem reading the sectors, and you try to jump to it to execute it, The CPU will exeute whatever instructions at that address, weather or not the sector was loaded. This useually means the CPU will run into either an invalid/unkown instruction, or the end of memory, both will result in a Triple Fault.**

## Navigating The FAT12 FileSystem
`OEM Parameter Block` - Detail 
```asm
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "
```

This is a block of data structure definitions commonly known as the BIOS Parameter Block (BPB) for a floppy disk using the FAT12 file system.

Here is the breakdown of the different fields in this BPB:
- bpbBytesPerSector: A 16-bit value specifying the number of bytes per sector on the disk. In this case, it is set to 512 bytes.
- bpbSectorsPerCluster: An 8-bit value specifying the number of sectors in each cluster. In this case, it is set to 1 sector per cluster.
- bpbReservedSectors: A 16-bit value specifying the number of reserved sectors at the beginning of the volume. In this case, it is set to 1 sector.
- bpbNumberOfFATs: An 8-bit value specifying the number of File Allocation Tables (FATs) on the disk. In this case, it is set to 2.
- bpbRootEntries: A 16-bit value specifying the maximum number of files in the root directory of the volume. In this case, it is set to 224 entries.
- bpbTotalSectors: A 16-bit value specifying the total number of sectors on the disk. In this case, it is set to 2880 sectors.
- bpbMedia: An 8-bit value specifying the media descriptor for the disk. In this case, it is set to 0xF0, which indicates a 1.44 MB 3.5" floppy disk.
- bpbSectorsPerFAT: A 16-bit value specifying the number of sectors occupied by each FAT. In this case, it is set to 9 sectors per FAT.
- bpbSectorsPerTrack: A 16-bit value specifying the number of sectors per track on the disk. In this case, it is set to 18 sectors per track.
- bpbHeadsPerCylinder: A 16-bit value specifying the number of heads (or read/write surfaces) on the disk. In this case, it is set to 2 heads.
- bpbHiddenSectors: A 32-bit value specifying the number of hidden sectors preceding the partition that contains the volume. In this case, it is set to 0.
- bpbTotalSectorsBig: A 32-bit value specifying the total number of sectors on the disk for volumes larger than 32 MB. In this case, it is set to 0.
- bsDriveNumber: An 8-bit value specifying the BIOS drive number of the disk. In this case, it is set to 0.
- bsUnused: An 8-bit value reserved for future use. In this case, it is set to 0.
- bsExtBootSignature: An 8-bit value indicating the presence of an extended boot signature in the next three fields. In this case, it is set to 0x29.
- bsSerialNumber: A 32-bit volume serial number. In this case, it is set to 0xa0a1a2a3.
