.global _start

.text
_start:
    // Step 1: Clear the screen, clear scrollback buffer, and move cursor to top-left
    mov r0, #1          // File descriptor: stdout (1)
    ldr r1, =clear_cmd  // Load address of the escape sequence
    mov r2, #12         // Length of the combined escape sequence (10 bytes)
    mov r7, #4          // sys_write (write to stdout)
    swi 0               // Execute sys_write

    // Step 2: Exit the program
    mov r7, #1          // sys_exit
    mov r0, #0          // Exit code
    swi 0

.data
clear_cmd: .asciz "\033[2J\033[3J\033[H"  // Clear screen, clear scrollback buffer, move cursor to top-left

