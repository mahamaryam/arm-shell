.global _start
.data
buff: .space 32  // Space to store the folder name input
.text
_start:
    // Read folder name from stdin
    mov r0, #0          // File descriptor: stdin
    ldr r1, =buff       // Address of the buffer
    mov r2, #32         // Maximum size of the buffer
    mov r7, #3          // sys_read
    swi 0

    // Null-terminate the input string (handle newline)
    ldr r1, =buff       // Load buffer address
    mov r2, r0         // Max size of the buffer
find_newline:
    ldrb r3, [r1], #1   // Load byte and increment pointer
    cmp r3, #10         // Check for newline (ASCII 10)
    beq null_terminate  // If newline found, null-terminate
    subs r2, r2, #1     // Decrement size counter
    bne find_newline    // Continue until end of buffer
    b null_terminate    // Ensure null-termination

null_terminate:
    sub r1, r1, #1      // Step back to overwrite the newline
    mov r3, #0          // Null character
    strb r3, [r1]       // Null-terminate the string

    // Call rmdir
    mov r7, #40         // sys_rmdir (40 in decimal)
    ldr r0, =buff       // Pointer to the folder name
    swi 0

    // Exit program
    mov r7, #1          // sys_exit
    mov r0, #0          // Exit code 0
    swi 0


