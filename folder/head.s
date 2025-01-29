.global _start
.data
buff: .space 100        // Space to store the file name input
file: .space 4096       // Buffer to read file contents
len: .word 4096         // Max length for reading

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

    // Step 3: Open the file (file name is in buff)
    ldr r0, =buff       // Load the file name (pointer to buff)
    mov r1, #0          // Flags: read-only (0)
    mov r2, #0          // Mode (unused for read-only)
    mov r7, #5          // sys_open (open the file)
    swi 0               // Result (file descriptor) in r0

    // Step 4: Check if file opened successfully (r0 holds the file descriptor)
    cmp r0, #0
    blt exit_program    // If file descriptor is negative, exit program

    // File has been opened, now we will read the file.
    mov r5, r0          // Store file descriptor in r5 (to be used later)
    ldr r1, =file       // Address of file buffer
    ldr r2, =len        // Length to read (4096 bytes)

read_file:
    mov r0, r5          // File descriptor
    ldr r3, =file       // Buffer to store file contents
    ldr r2, =len        // Number of bytes to read
    mov r7, #3          // sys_read (read from file)
    swi 0               // Perform the syscall

    cmp r0, #0          // Check if we read any data (r0 == 0 means EOF)
    beq close_file      // If no data, EOF reached, close the file

    // Step 5: Print the data (byte-by-byte)
    ldr r3, =file       // Reload the address of the buffer
    mov r1, r3          // Set r1 as the pointer to the buffer (for printing)
print_loop:
    ldrb r2, [r1],#1   // Load the next byte from the buffer and increment r1
    cmp r2, #10          // Check for null-terminator (end of buffer)
    beq read_file       // If null-terminated, we've finished printing this chunk, continue reading
    mov r0, #1          // File descriptor: stdout (1)
    mov r2, #1          // Number of bytes to write (1 byte at a time)
    mov r7, #4          // sys_write (write to stdout)
    swi 0               // Perform the syscall to print the character
    b print_loop        // Continue to the next byte

close_file:
    mov r0, r5          // File descriptor
    mov r7, #6          // sys_close (close file)
    swi 0               // Perform the syscall to close the file

exit_program:
    mov r7, #1          // sys_exit (exit the program)
    mov r0, #0          // Exit code 0
    swi 0               // Perform the exit syscall

