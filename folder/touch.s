 .section .data
filename:
    .asciz "example.txt"  // Null-terminated string for the file name

    .section .text
    .global _start

_start:
    // Load the address of the filename into r0
    ldr r0, =filename

    // Set file mode in r1 (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP)
    mov r1, #0x180           // User read/write
    orr r1, r1, #0x30        // Group read/write

    // Load the syscall number for creat into r7
    mov r7, #8               // Syscall number for creat

    // Make the syscall
    swi 0

    // Exit the program (syscall 1: exit)
    mov r7, #1               // Syscall number for exit
    mov r0, #0               // Exit code 0
    swi 0

