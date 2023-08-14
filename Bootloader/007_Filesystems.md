## Filesystems - Theory

A File System is nothing more then a specification. It helps create the concept of a "file" on a disk. A file is a group of data that has represents something. This data can be anything we want it to be. It all depends on how we interprate the data. A sector is 512 bytes in size. A file is stored across these sectors on disk. If the file exceeds 512 bytes, we have to give it more sectors. Because not all files are evenly 512 bytes in size, we will need to fill in the rest of the bytes (That the file doesnt use). Kind of like what we did for our bootloader.

If a file spans accross several sectors, we call these sectors a Cluster in the FAT file systems. For example, our kernel will most likley span alot of sectors. To load our kernel, we will need to load the cluster (The sectors) from where it is located. If a file spans across different sectors (Not contigous) across different clusters, it is said to be Fragmented. We will need to collect the different parts of the file.

There are alot of different kinds of file systems. Some are widley use (Like FAT12, FAT16, FAT32, NTFS, ext (Linux), HFS (Used in older MACs); other filesystems are only used by specific companies for in house use (Like the GFS - Google File System).

## FAT12 Filesystem - Theory
To understand more about FAT12, and how it works, it is better to look at the structure of a typical formatted disk. 

Boot Sector | Extra Reserved Sectors| File Allocation Table 1 | File Allocation Table 2 | Root Directory (FAT12/FAT16 Only) | Data Region containng files and directories |
------------|------------------------|-------------------------|-------------------------|-----------------------------------|---------------------------------------------|

This is a typical formatted FAT12 disk, from the bootsector to the very last sector on disk. Understanding this structure will be important when loading and searching for our file. Note that there are 2 FATs on a disk. It is located *right after* the reserved sectors (or the bootloader, if there is none).

Also note: The Root Directory is right after all of the FATs. This means...if we add up the number of sectors per FAT, and the reserved sectors, we can get the first sector to the Root Directory. By searching the Root Directory for a simple string (our filename), we can effectivly find the exact sector of the file on disk :) 

**`Boot Sector`** - This section contains the BIOS Parameter Block and the bootloader. Yep--Ours. The BIOS Parameter Block contains information tat help describe our disk.</br>
**`Extra Reserved Sectors`** - Remember the bpbReservedSectors member of our BPB? Any extra reserved sectors are stored here, right after the bootsector. </br>
**`File Allocation Tables (FATs)`** - Remember that a cluster represents a series of contiguous sectors on disk. the size of each cluster is normally 2 KB to 32 KiB. The file peices are linked (from one cluster to another using a common data structure, such as a Linked List. There are two FATs. However, one is just a copy of the first one for data recovery purposes. It useally isnt used.

**The File Allocation Table (FAT) is a list of entrys that map to each of these clusters. They help identify important information to aid in storing data to these clusters.** Each entry is a 12 bit value that represents a cluster. The FAT is a linked list-like structure with these entrys that helps identify what clusters are in use.

To better nderstand this lets look at the possible values: 
1. Value marks free cluster : 0x00
2. Value marks Reserved cluster : 0x01
3. This cluster is in use--the value represents next cluster : 0x002 through 0xFEF
4. Reserved values : 0xFF0 through 0xFF6
5. Value marks bad clusters : 0xFF7
6. Value marks this cluster as the last in the file : 0xFF8 through 0xFFF

A FAT is just an array of these values--thats all. When we find the starting sector form the Root Directory, we can look through the FAT to find which clusters to load. How? We simply check the value. If the value is between 0x02 and 0xfef, this value represents the next cluster to load for the file.

Lets look at this in a deeper way. A cluster, as you know, represents a series of sectors. We define the amount of sectors it represents from the BIOS Paramete Block: 
```asm
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
```
In our case, each cluster is 1 sector. When we get the first sector of Stage 2 (We get this from the root directory), we use this sector as the starting cluster number in the FAT. Once we find the starting cluster, we just refrence the FAT to determin the cluster (The FAT is just an array of 32 bit numbers. We just compare this number with the list above to determin what to do with it.) 

**`The Root Directory Table`** - the root directory table is a fixed-size table that contains information about the files and directories located in the root directory of the file system. The root directory is a special directory that exists at the top level of the file system and contains information about all the files and directories that are directly accessible from the root. The root directory table in FAT12 is located immediately after the boot sector of the file system, and its size is fixed, which means that it can hold a limited number of entries. In particular, the root directory table in a FAT12 file system can hold up to 512 directory entries, with each entry being 32 bytes long.

Each directory entry in the root directory table contains information about a file or directory, such as its name, size, and date/time stamps. The name of each file or directory is stored in a fixed-size field in the directory entry, with up to 8 characters for the file name and up to 3 characters for the file extension. The size of each file is also stored in the directory entry, along with its starting cluster number.

This 32 byte value uses the format: 
1. Byte 0-10: File name (8 bytes) and extension (3 bytes)</br>
    - The first 8 bytes store the file name, which is padded with spaces if it is shorter than 8 characters
    - The next 3 bytes store the file extension, which is also padded with spaces if it is shorter than 3 characters
    - The 11th byte stores the attributes of the file
2. Byte 11: Attributes - The attributes byte stores information about the file, such as whether it is read-only, hidden, or a system file. The value of this byte varies depending on the attributes of the file.
    - Bit 0 : Read Only
    - Bit 1 : Hidden
    - Bit 2 : System
    - Bit 3 : Volume Label
    - Bit 4 : This is a subdirectory
    - Bit 5 : Archive
    - Bit 6 : Device (Internal use)
    - Bit 6 : Unused
3. Byte 12-13: Reserved - These bytes are reserved for future use and are currently unused.
4. Byte 14-15: Creation time
    - Bit 0-4 : Seconds (0-29)
    - Bit 5-10 : Minutes (0-59)
    - Bit 11-15 : Hours (0-23)
5. Byte 16-17: Creation date - 
    - Bit 0-4 : Year (0=1980; 127=2107
    - Bit 5-8 : Month (1=January; 12=December)
    - Bit 9-15 : Hours (0-23)
6. Byte 18-19: Last access date (Uses same format as above)
7. Byte 20-21: Starting cluster number
8. Bytes 22-23 : Last Modified time (See byte 14-15 for format)
9. Bytes 24-25 : Last modified date (See bytes 16-17 for format)
10. Bytes 26-27 : First Cluster - These bytes store the number of the first cluster of the directory that contains the file.
11. Bytes 28-32 : File Size

## Searching and reading FAT12 - Theory
We are going to be refrencing the BIOS Parameter Block (BPB) alot. Here is the BPB that we created from the prevuis tutorials for refrence: 
find the BIO Parameter Block [here](BIOS_PB.md)

### Beginning with a filename
The first thing to do is to create a good filename. Remember: The Filenames must be exactally 11 bytes to insure we don't corrupt the root directory.

I am using "STAGE2.SYS", for my second stage. You can look at an example of its internal filename in the above section. 

### Creating Stage 2
Our Stage2 will be very simular to a DOS COM program. All Stage2 does right now is print a message and halt. We will create the file [Here](here)

### Step 1: Loading the Root Directory Table

We will be refrencing the Root directory table alot here, along with the BIOS parameter block for disk information
#### Step 1: Get size of root directory
To get the size, just multiply the number of entrys in the root directory. In Windows, whenever you add a file or directory to a FAT12 formatted disk, Windows automatically adds the file information to the root directory, so we dont need to worry about it. This makes things much simpler.

Dividing the number of root entrys by bytes per sector will tell us how many sectors the root entry uses

```asm
    mov     ax, 0x0020                  ; 32 byte directory entry
    mul     WORD [bpbRootEntries]       ; number of root entrys
    div     WORD [bpbBytesPerSector]    ; get sectors used by root directory
```
