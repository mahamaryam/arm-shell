.global _start
.extern atoi
.data
pid: .space 10        // Space to store the file name input
signal: .space 10
.text
_start:
    // Step 1: Read the file name from stdin
    mov r0, #0          // File descriptor: stdin (0)
    ldr r1, =pid       // Address of the buffer (file name)
    mov r2, #10        // Maximum size of the buffer
    mov r7, #3          // sys_read (read from stdin)
    swi 0               // Read the file name into buff

    // Step 2: Null-terminate the input string (handle newline)
    ldr r1, =pid       // Load buffer address
    mov r2, r0          // Number of bytes read (stored in r0 by sys_read)
    bl find_newline
mov r0,#0
ldr r1,=signal
mov r2,#10
mov r7,#3
swi 0
ldr r1,=signal
mov r2,#0
bl find_newline

ldr r0,=signal
bl atoi
push {r0}
ldr r0,=pid
bl atoi
//r0 has the pid
pop {r1}
//r1 also has the signal now
mov r7,#0x25
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


