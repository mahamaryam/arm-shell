.global _start
_start:
    ldr r0, =12345        // Load constant 12345 into r0 (dividend)
    mov r1, #10           // Load constant 10 into r1 (divisor)

    // Calculate the remainder using modulus (r0 % r1)
    udiv r2, r0, r1       // r2 = r0 / r1 (quotient, but we won't use it)
    mul r3, r2, r1        // r3 = r2 * r1 (quotient * divisor)
    sub r3, r0, r3        // r3 = r0 - r3 (remainder = dividend - (quotient * divisor))

    add r3, r3, #48       // Convert remainder to ASCII (5 -> '5')

    mov r1, r3            // Move remainder (ASCII) into r1
    mov r0, #1            // File descriptor 1 (stdout)
    mov r2, #1            // Length of output (1 byte)
    mov r7, #4            // Syscall number for write
    swi 0                 // Make the syscall to print remainder ('5')

    // Exit the program (syscall number 0x01)
    mov r0, #0            // Exit status 0
    mov r7, #1            // Syscall number for exit
    swi 0                 // Make the syscall

