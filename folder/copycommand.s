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


mov r0,#0
ldr r1,=buff2
mov r2,#100
mov r7,#3
swi 0
ldr r1,=buff2
mov r2,#0
find_newline2:
ldrb r3,[r1],#1
cmp r3,#10
beq null_terminate2
subs r2,r2,#1
bne find_newline2
b null_terminate2
null_terminate2:
sub r1,r1,#1
mov r3,#0
strb r3,[r1]
//now second file has also been read.

    // Step 3: Open the file (file name is in buff)
    ldr r0, =buff       // Load the file name (pointer to buff)
    mov r1, #0          // Flags: read-only (0)
    mov r2, #0          // Mode (unused for read-only)
    mov r7, #5          // sys_open (open the file)
    swi 0               // Result (file descriptor) in r0
    push {r0} //descriptor has been pushed

    // Step 4: Check if file opened successfully (r0 holds the file descriptor)
    cmp r0, #0
    blt exit_error_program    // If file descriptor is negative, exit program
//now open the second file
ldr r0,=buff2
mov r1,#2
mov r2,#540
mov r7,#5
swi 0
cmp r0,#0
blt exit_error_program
//this is the out_fd.... descriptor in in r0 now
    // Store the file descriptor for future use
    pop {r1}
    // Step 5: Prepare for sendfile call
    mov r2, #0          // Offset: 0 (start from beginning of the file)
    mov r3, #100        // Number of bytes to transfer (100 bytes)
    mov r7, #0xbb       // sys_sendfile (send file data)
    swi 0               // Transfer data from file to stdout

    // Step 6: Check if sendfile was successful
    cmp r0, #0          // Check return value of sendfile (r0)
    blt exit_error_program    // If error, exit program

    // Step 7: Close the file (file descriptor in r4)
    mov r0, r1          // File descriptor
    mov r7, #6          // sys_close (close file)
    swi 0
exit_program:
mov r0,#0
mov r7,#1
swi 0
exit_error_program:
    // Step 8: Exit program
    mov r0,#1
    ldr r1,=error
    ldr r2,=len
    mov r7,#4
    swi 0
    mov r7, #1          // sys_exit (exit the program)
    mov r0, #0          // Exit code 0
    swi 0

.data
error: .asciz "error in openeing file\n"
len = .-error

