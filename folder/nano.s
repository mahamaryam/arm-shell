.global _start
.data
nano_path: .asciz "/usr/bin/nano"    // Path to nano executable
file: .space 100                      // Buffer to store the file name input
args: .space 8                        // Space for the arguments array (nano + filename + NULL)
env: .asciz "TERM=linux"              // Environment variable

.text
_start:
    // Step 1: Read the file name from stdin
    mov r0, #0          // File descriptor: stdin (0)
    ldr r1, =file       // Address of the buffer (file name)
    mov r2, #100        // Maximum size of the buffer
    mov r7, #3          // sys_read (read from stdin)
    swi 0               // Read the file name into buff

    // Step 2: Null-terminate the input string (handle newline)
    ldr r1, =file       // Load buffer address
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

    // Step 3: Set up arguments for execve ("/usr/bin/nano" and the file name)
    ldr r0, =nano_path  // Path to nano executable
    ldr r1, =args       // Address of arguments array
    ldr r2, =file       // File name from the buffer
    str r0, [r1]        // args[0] = "/usr/bin/nano"
    str r2, [r1, #4]    // args[1] = file name
    mov r3, #0          // Null terminate the arguments array (args[2])
    str r3, [r1, #8]    // args[2] = NULL

    // Step 4: Set up environment variables (optional)
    ldr r2, =env        // Environment variable (TERM=linux)
    
    // Step 5: Execute the program using execve
    mov r7, #0x0b       // sys_execve (execute program)
    swi 0               // Execute nano with arguments

exit_program:
    mov r7, #1          // sys_exit (exit the program)
    mov r0, #0          // Exit code 0
    swi 0               // Exit the program

