.global _start
.data
buff: .space 100
buff2: .space 100       // Space to store the file name input
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

    // Step 3: Read the second file name
    mov r0, #0          // File descriptor: stdin (0)
    ldr r1, =buff2      // Address of the second buffer (file name)
    mov r2, #100        // Maximum size of the buffer
    mov r7, #3          // sys_read (read from stdin)
    swi 0               // Read the second file name into buff2

    // Step 4: Null-terminate the second input string (handle newline)
    ldr r1, =buff2      // Load second buffer address
    mov r2, r0          // Number of bytes read (stored in r0 by sys_read)
    bl find_newline

    // Step 5: Open the source file (file name is in buff)
    ldr r0, =buff       // Load the file name (pointer to buff)
    mov r1, #0          // Flags: read-only (0)
    mov r2, #0          // Mode (unused for read-only)
    mov r7, #5          // sys_open (open the file)
    swi 0               // Result (file descriptor) in r0

    // Step 6: Check if file opened successfully (r0 holds the file descriptor)
    cmp r0, #0
    blt exit_program    // If file descriptor is negative, exit program
    mov r4, r0          // Store the source file descriptor in r4

    // Step 7: Open the destination file for writing (file name is in buff2)
    ldr r0, =buff2      // Load second file name (pointer to buff2)
    mov r1, #2          // Flags: O_WRONLY (write-only)
    mov r2, #77        // Mode: rw- for user, group, others (using 0644 permissions)
    mov r7, #5          // sys_open
    swi 0               // Result (file descriptor) in r0

    // Step 8: Check if the destination file opened successfully
    cmp r0, #0
    blt exit_program    // If file descriptor is negative, exit program
    mov r5, r0          // Store the destination file descriptor in r5

    // Step 9: Copy data from source to destination
    mov r0, r4          // Source file descriptor
    mov r1, r5          // Destination file descriptor
    mov r2, #100        // Buffer size
    mov r7, #4          // sys_read
    swi 0               // Read from source

    // Step 10: Write to destination file if data was read
    cmp r0, #0          // Check if data was read
    beq close_files     // No data to copy, exit
    mov r1, r5          // Destination file descriptor
    mov r7, #4          // sys_write
    swi 0               // Write to destination

    cmp r0, #0          // Check if write was successful
    blt exit_program    // If error, exit program
    b step_9            // Repeat the process

close_files:
    // Step 11: Close the source file
    mov r0, r4          // Close source file
    mov r7, #6          // sys_close
    swi 0

    // Close the destination file
    mov r0, r5          // Close destination file
    mov r7, #6          // sys_close
    swi 0

exit_program:
    // Step 12: Exit the program
    mov r7, #1          // sys_exit
    mov r0, #0          // Exit code 0
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

