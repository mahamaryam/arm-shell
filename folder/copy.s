.global _start
.data
buff: .space 100 
buff2: .space 100 
.text
_start:
    // Step 1: Read the first file name from stdin
    mov r0, #0          // File descriptor: stdin (0)
    ldr r1, =buff       // Address of the buffer (file name)
    mov r2, #100        // Maximum size of the buffer
    mov r7, #3          // sys_read (read from stdin)
    swi 0               // Read the file name into buff

    // Step 2: Null-terminate the input string (handle newline)
    ldr r1, =buff       // Load buffer address
    mov r2, r0          // Number of bytes read (stored in r0 by sys_read)
    bl find_newline

    // Read the second file name (destination)
    mov r0, #0
    ldr r1, =buff2
    mov r2, #100
    mov r7, #3
    swi 0
    ldr r1, =buff2
    mov r2, r0
    bl find_newline

    // Step 3: Open the first file (source file)
    ldr r0, =buff       // Load the file name (pointer to buff)
    mov r1, #0          // Flags: read-only (0)
    mov r2, #0          // Mode (unused for read-only)
    mov r7, #5          // sys_open (open the file)
    swi 0               // Result (file descriptor) in r0

    cmp r0, #0          // Check if file opened successfully
    blt exit_program    // If file descriptor is negative, exit program
    mov r4, r0          // Store the file descriptor for future use

    // Step 4: Open the second file (destination file)
    ldr r0, =buff2
    mov r1, #64         // O_CREAT
    orr r1, r1, #2      // O_RDWR
    orr r1, r1, #512    // O_TRUNC
    mov r2, #0777       // Mode: rwx for user, group, others
    mov r7, #5
    swi 0

    cmp r0, #0          // Check if file opened successfully
    blt exit_program    // If file descriptor is negative, exit program
    mov r5, r0          // Store the destination file descriptor

    // Step 5: Copy using sendfile
    mov r0, r4          // Source file descriptor
    mov r1, r5          // Destination file descriptor
    mov r3, #0          // Offset: Start from beginning of the file
    mov r4, #100        // Number of bytes to transfer
    mov r7, #0xbb       // sys_sendfile
    swi 0               // Execute the sendfile system call

    cmp r0, #0          // Check the result of sendfile
    blt exit_program    // If error, exit program

    // Step 6: Close the files
    mov r0, r4          // Close the source file
    mov r7, #6
    swi 0
    mov r0, r5          // Close the destination file
    mov r7, #6
    swi 0

exit_program:
    // Step 7: Exit program
    mov r7, #1          // sys_exit (exit the program)
    mov r0, #0          // Exit code 0
    swi 0

find_newline:
    ldrb r3, [r1], #1
    cmp r3, #10
    beq null_terminate
    subs r2, r2, #1
    bne find_newline
    b null_terminate

null_terminate:
    sub r1, r1, #1
    mov r3, #0
    strb r3, [r1]
    bx lr

