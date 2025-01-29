.global _start
.data
buff: .space 100        // Space to store the file name input
buff2: .space 100
.text
_start:
    // Step 1: Read the file name from stdin
    mov r0, #0          // File descriptor: stdin (0)
    ldr r1, =buff       // Address of the buffer (file name)
    mov r2, #100        // Maximum size of the buffer
    mov r7, #3          // sys_read (read from stdin)
    swi 0               // Read the file name into buff

    // Step 2: Null-terminate the input string (handle newline)
    ldr r1, =buff       // Load buffer address
    mov r2, r0          // Number of bytes read (stored in r0 by sys_read)
    bl find_newline
mov r0,#0
ldr r1,=buff2
mov r2,#100
mov r7,#3
swi 0
ldr r1,=buff2
mov r2,#0
bl find_newline

ldr r0,=buff
ldr r1,=buff2
mov r7,#0x09
swi 0 
exit_program:
mov r0,#0
mov r7,#1
swi 0

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
    bx lr

.data
error: .asciz "error in openeing file\n"
len = .-error

