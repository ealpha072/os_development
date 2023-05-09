## Learn Assembly Language
This project was put together to teach myself NASM x86 assembly language on linux.

An assembly program can be divided into three sections
- The data section,
- The bss section
- The text section

## Linux System Calls

You can make use of Linux system calls in your assembly programs. You need to take the following steps for using Linux system calls in your program −

- Put the system call number in the EAX register
- Store the arguments to the system call in the registers EBX, ECX, etc.
- Call the relevant interrupt (80h).
- The result is usually returned in the EAX register

There are six registers that store the arguments of the system call used. These are the EBX, ECX, EDX, ESI, EDI, and EBP. These registers take the consecutive arguments, starting with the EBX register. If there are more than six arguments, then the memory location of the first argument is stored in the EBX register.

```asm
;call sytem exit
mov	eax,1		; system call number (sys_exit)
int	0x80		; call kernel

;call kernel to print
mov eax, 4
mov ebx, 1
mov ecx, msg
mov edx, 4
int 0x80
```
All the syscalls are listed in /usr/include/asm/unistd.h, together with their numbers (the value to put in EAX before you call int 80h).

## Type specifier.

BYTE	1
WORD	2
DWORD	4
QWORD	8
TBYTE	10