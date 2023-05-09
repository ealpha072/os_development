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

## Assembly - Addressing Modes

The three basic modes of addressing are −
- Register addressing
- Immediate addressing
- Memory addressing

### Register Addressing
In this addressing mode, a register contains the operand. Depending upon the instruction, the register may be the first operand, the second operand or both. As processing data between registers does not involve memory, it provides fastest processing of data.

```asm
MOV DX, TAX_RATE   ; Register in first operand
MOV COUNT, CX	   ; Register in second operand
MOV EAX, EBX	   ; Both the operands are in registers
```
### Immediate Addressing

An immediate operand has a constant value or an expression. When an instruction with two operands uses immediate addressing, the first operand may be a register or memory location, and the second operand is an immediate constant. The first operand defines the length of the data.

```asm
BYTE_VALUE  DB  150    ; A byte value is defined
WORD_VALUE  DW  300    ; A word value is defined
ADD  BYTE_VALUE, 65    ; An immediate operand 65 is added
MOV  AX, 45H           ; Immediate constant 45H is transferred to AX
```

### Direct Memory Addressing
In direct memory addressing, one of the operands refers to a memory location and the other operand references a register.

```asm
ADD	BYTE_VALUE, DL	; Adds the register in the memory location
MOV	BX, WORD_VALUE	; Operand from the memory is added to register
```
### Direct-Offset Addressing
This addressing mode uses the arithmetic operators to modify an address. For example, look at the following definitions that define tables of data −

```asm
BYTE_TABLE DB  14, 15, 22, 45      ; Tables of bytes
WORD_TABLE DW  134, 345, 564, 123  ; Tables of words
```

The following operations access data from the tables in the memory into registers

```asm
MOV CL, BYTE_TABLE[2]	; Gets the 3rd element of the BYTE_TABLE
MOV CL, BYTE_TABLE + 2	; Gets the 3rd element of the BYTE_TABLE
MOV CX, WORD_TABLE[3]	; Gets the 4th element of the WORD_TABLE
MOV CX, WORD_TABLE + 3	; Gets the 4th element of the WORD_TABLE
```

### Indirect Memory Addressing
This addressing mode utilizes the computer's ability of Segment:Offset addressing. Generally, the base registers EBX, EBP (or BX, BP) and the index registers (DI, SI), coded within square brackets for memory references, are used for this purpose.

Indirect addressing is generally used for variables containing several elements like, arrays. Starting address of the array is stored in, say, the EBX register.

```asm
MY_TABLE TIMES 10 DW 0  ; Allocates 10 words (2 bytes) each initialized to 0
MOV EBX, [MY_TABLE]     ; Effective Address of MY_TABLE in EBX
MOV [EBX], 110          ; MY_TABLE[0] = 110
ADD EBX, 2              ; EBX = EBX +2
MOV [EBX], 123          ; MY_TABLE[1] = 123
```
