## Filesystems - Theory

A File System is nothing more then a specification. It helps create the concept of a "file" on a disk. A file is a group of data that has represents something. This data can be anything we want it to be. It all depends on how we interprate the data. A sector is 512 bytes in size. A file is stored across these sectors on disk. If the file exceeds 512 bytes, we have to give it more sectors. Because not all files are evenly 512 bytes in size, we will need to fill in the rest of the bytes (That the file doesnt use). Kind of like what we did for our bootloader.

If a file spans accross several sectors, we call these sectors a Cluster in the FAT file systems. For example, our kernel will most likley span alot of sectors. To load our kernel, we will need to load the cluster (The sectors) from where it is located. If a file spans across different sectors (Not contigous) across different clusters, it is said to be Fragmented. We will need to collect the different parts of the file.

There are alot of different kinds of file systems. Some are widley use (Like FAT12, FAT16, FAT32, NTFS, ext (Linux), HFS (Used in older MACs); other filesystems are only used by specific companies for in house use (Like the GFS - Google File System).

## FAT12 Filesystem - Theory
To understand more about FAT12, and how it works, it is better to look at the structure of a typical formatted disk. 
