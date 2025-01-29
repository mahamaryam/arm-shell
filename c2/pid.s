.global _asm_start
.extern sprintf       // Declare the external sprintf function
.extern printf        // Declare the external printf function

.data
    result_fmt: .asciz "PID: %d\n"  // Format string for sprintf
    output: .space 50                          // Buffer for output

.text
_asm_start:
    // Pass arguments to the add function
    mov r7,#0x14
    swi 0
    // Use sprintf to format the result into a string
    ldr r1, =result_fmt  // Format string
    ldr r2, =output      // Buffer to store the result
    mov r3, r0          // Move the result into r3 (argument to sprintf)
    bl sprintf           // Call sprintf

    // Print the result using printf
    ldr r0, =output     // Address of the output buffer
    bl printf           // Call printf to print the formatted string

    // Exit the program
    mov r0, #0          // Exit status 0
    mov r7, #1          // Syscall number for sys_exit
    swi 0               // Make the syscall to exit

