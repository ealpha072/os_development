## Filesystems - Theory

A File System is nothing more then a specification. It helps create the concept of a "file" on a disk. A file is a group of data that has represents something. This data can be anything we want it to be. It all depends on how we interprate the data. A sector is 512 bytes in size. A file is stored across these sectors on disk. If the file exceeds 512 bytes, we have to give it more sectors. Because not all files are evenly 512 bytes in size, we will need to fill in the rest of the bytes (That the file doesnt use). Kind of like what we did for our bootloader.

If a file spans accross several sectors, we call these sectors a Cluster in the FAT file systems. For example, our kernel will most likley span alot of sectors. To load our kernel, we will need to load the cluster (The sectors) from where it is located. If a file spans across different sectors (Not contigous) across different clusters, it is said to be Fragmented. We will need to collect the different parts of the file.

There are alot of different kinds of file systems. Some are widley use (Like FAT12, FAT16, FAT32, NTFS, ext (Linux), HFS (Used in older MACs); other filesystems are only used by specific companies for in house use (Like the GFS - Google File System).

## FAT12 Filesystem - Theory
To understand more about FAT12, and how it works, it is better to look at the structure of a typical formatted disk. 

**Boot Sector | Extra Reserved Sectors| File Allocation Table 1 | File Allocation Table 2 | Root Directory (FAT12/FAT16 Only) | Data Region containng files and directories **|
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

