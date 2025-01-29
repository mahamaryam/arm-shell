.global _start
.extern sprintf  // Declare sprintf as an external C function

.data
    pid_msg: .asciz "PPID: %d\n"  // Format string for the PID message
    pid_buf: .space 32           // Buffer to store the formatted string

.text
_start:
    // 1. Call getpid (syscall number for getpid = 20)
    mov r7, #0x40          // Syscall number for getpid
    swi 0                // Make the syscall
    mov r3, r0           // Save the PID in r3 (r0 contains the PID)

    // 2. Format the PID using sprintf
    ldr r0, =pid_buf     // Address of the buffer
    ldr r1, =pid_msg     // Address of the format string
    mov r2, r3           // Pass the PID as the argument
    bl sprintf           // Call sprintf

    // 3. Print the formatted string using write (syscall number = 4)
    mov r0, #1           // File descriptor (stdout)
    ldr r1, =pid_buf     // Address of the formatted string
    mov r2, #32          // Number of bytes to write (adjust if needed)
    mov r7, #4           // Syscall number for write
    swi 0                // Make the syscall

    // 4. Exit the program
    mov r0, #0           // Exit status 0
    mov r7, #1           // Syscall number for exit
    swi 0


