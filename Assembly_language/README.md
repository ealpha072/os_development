# Learn Assembly Language
This project was put together to teach myself NASM x86 assembly language on linux.

An assembly program can be divided into three sections
- The data section,
- The bss section
- The text section

# Linux System Calls

You can make use of Linux system calls in your assembly programs. You need to take the following steps for using Linux system calls in your program −

- Put the system call number in the EAX register
- Store the arguments to the system call in the registers EBX, ECX, EDX, ESI, EDI, EPB.
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

# Allocating Storage Space for Initialized Data

BYTE	1
WORD	2
DWORD	4
QWORD	8
TBYTE	10

Directive	Purpose	        Storage Space
DB	Define Byte	            allocates 1 byte
DW	Define Word	            allocates 2 bytes
DD	Define Doubleword	    allocates 4 bytes
DQ	Define Quadword	        allocates 8 bytes
DT	Define Ten Bytes	    allocates 10 bytes

Following are some examples of using define directives −
choice		    DB	    'y'
number		    DW	    12345
neg_number	    DW	    -12345
big_number	    DQ	    123456789
real_number1	DD	    1.234
real_number2	DQ	    123.456

Please note that −
- Each byte of character is stored as its ASCII value in hexadecimal.
- Each decimal value is automatically converted to its 16-bit binary equivalent and stored as a hexadecimal number.
- Processor uses the little-endian byte ordering.
- Negative numbers are converted to its 2's complement representation.
- Short and long floating-point numbers are represented using 32 or 64 bits, respectively.

# Allocating Storage Space for Uninitialized Data

The reserve directives are used for reserving space for uninitialized data. The reserve directives take a single operand that specifies the number of units of space to be reserved. Each define directive has a related reserve directive.

There are five basic forms of the reserve directive −
Directive	Purpose
RESB	    Reserve a Byte
RESW	    Reserve a Word
RESD	    Reserve a Doubleword
RESQ	    Reserve a Quadword
REST	    Reserve a Ten Bytes


# Assembly - Addressing Modes

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

# Assembly - Constants

There are several directives provided by NASM that define constants. We will particularly discuss three directives −
- EQU
- %assign - The %assign directive can be used to define numeric constants like the EQU directive. This directive allows redefinition
- %define - The %define directive allows defining both numeric and string constants. This directive is similar to the #define in C. This directive also allows redefinition and it is case-sensitive.

```asm
TOTAL_STUDENTS equ 50
%assign TOTAL 10
;Later in the code, you can redefine it as
%assign  TOTAL  20
%define PTR [EBP+4]
```

# Arithmetic Instructions
1. **The INC Instruction** - used for incrementing an operand by one. It works on a single operand that can be either in a register or in memory

2. **The DEC Instruction** - used for decrementing an operand by one. It works on a single operand that can be eitherin a register or in memory.

3. **The ADD and SUB Instructions** - The ADD and SUB instructions are used for performing simple addition/subtraction of binary data in byte, word and doubleword size. Takes place between:
- Register to register
- Memory to register
- Register to memory
- Register to constant data
- Memory to constant data

4. **The MUL/IMUL Instruction** - The MUL (Multiply) instruction handles unsigned data and the IMUL (Integer Multiply) handles signed data. Both instructions affect the Carry and Overflow flag.
5. **The DIV/IDIV Instructions** - The division operation generates two elements - a quotient and a remainder. In case of multiplication, overflow does not occur because double-length registers are used to keep the product. However, in case of division, overflow may occur. The processor generates an interrupt if overflow occurs. The DIV (Divide) instruction is used or unsigned data and the IDIV (Integer Divide) is used for signed data.

# Logical Instructions

The processor instruction set provides the instructions AND, OR, XOR, TEST and NOT Boolean logic, which tests, sets and clears the bits according to the need of the program. 

Instruction | Format
------------|------------------------
AND         | AND operand1, operand2
OR          | OR operand1, operand2
XOR         | XOR operand1, operand2
TEST        | TEST operand1, operand2
NOT         | NOT operand1

The first operand in all the cases could be either in register or in memory. The second operand could be either in register/memory or an immediate (constant) value. However, memory to memory operations are not possible. These instructions compare or match bits of the operands and set the CF, OF, PF, SF and ZF flags.

1. **The AND Instruction** - The AND instruction is used for supporting logical expressions by performing bitwise AND operation. The bitwise AND operation returns 1, if the matching bits from both the operands are 1, otherwise it returns 0. 

The AND operation can be used for clearing one or more bits. For example, say, the BL register contains 0011 1010. If you need to clear the high order bits to zero, you AND it with 0FH.

```asm
AND BL, 0FH ;Sets BL to 0000 1010
```
2. **The OR Instruction** - The OR instruction is used for supporting logical expression by performing bitwise OR operation. The bitwise OR operator returns 1, if the matching bits from either or both operands are one. It returns 0, if both the bits are zero. In the above we can say

```asm
OR BL, 0FH ;Sets BL to 0000 1010
```

3. **The XOR Instruction** - The XOR instruction implements the bitwise XOR operation. The XOR operation sets the resultant bit to 1, if and only if the bits from the operands are different. If the bits from the operands are same (both 0 or both 1), the resultant bit is cleared to 0. 

4. **The TEST Instruction** - The TEST instruction works same as the AND operation, but unlike AND instruction, it does not change the first operand. So, if we need to check whether a number in a register is even or odd, we can also do this using the TEST instruction without changing the original number.

5. **The NOT Instruction** - The NOT instruction implements the bitwise NOT operation. NOT operation reverses the bits in an operand. The operand could be either in a register or in the memory.

# Assembly Conditions

1. `Unconditional jump` - This is performed by the JMP instruction. Conditional execution often involves a transfer of control to the address of an instruction that does not follow the currently executing instruction. Transfer of control may be forward to execute a new set of instructions, or backward to re-execute the same steps.

2. `Conditional jump` - This is performed by a set of jump instructions j<condition> depending upon the condition. The conditional instructions transfer the control by breaking the sequential flow and they do it by changing the offset value in IP.

`The CMP Instruction` - compares two operands. It is generally used in conditional execution. This instruction basically subtracts one operand from the other for comparing whether the operands are equal or not. It does not disturb the destination or source operands. It is used along with the conditional jump instruction for decision making.

```asm
;CMP destination, src

CMP DX, 00          ;compare  DX to 0
JE L7               ;if yes, jump to label L7

L7:
```
Following are the conditional jump instructions used on signed data used for arithmetic operations:

Instruction |Description                                      | Flags tested
------------|-------------------------------------------------|-----------------
JE/JZ       | Jump Equal or Jump Zero                         | ZF
JNE/JNZ     | Jump not Equal or Jump Not Zero                 | ZF
JG/JNLE     | Jump Greater or Jump Not Less/Equal             | OF, SF, ZF
JGE/JNL     | Jump Greater or Jump Not Less                   | OF, SF
JL/JNGE     | Jump Less or Jump Not Greater/Equal             | OF, SF
JLE/JNG     | Jump Less/Equal or Jump Not Greater             | OF, SF, ZF

Following are the conditional jump instructions used on unsigned data used for logical operations:

Instruction | Description                             | Flags tested
------------|-----------------------------------------|-----------------
JE/JZ       | Jump Equal or Jump Zero                 | ZF
JNE/JNZ     | Jump not Equal or Jump Not Zero         | ZF
JA/JNBE     | Jump Above or Jump Not Below/Equal      | CF, ZF
JAE/JNB     | Jump Above/Equal or Jump Not Below      | CF
JB/JNAE     | Jump Below or Jump Not Above/Equal      | CF
JBE/JNA     | Jump Below/Equal or Jump Not Above      | AF, CF


