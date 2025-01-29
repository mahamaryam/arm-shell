.global _start
_start:
    mov r7, #12           @ Syscall: chdir
    ldr r0, =new_dir      @ Path to the directory
    swi 0                 @ Perform chdir

    cmp r0, #0            @ Check if chdir succeeded
    bne failure

    ldr r1, =cmd_prefix   @ Load "cd " prefix
    mov r2, #3            @ Length of "cd "
    mov r0, #1            @ File descriptor (stdout)
    mov r7, #4            @ Syscall: write
    swi 0

    ldr r1, =new_dir      @ Load directory path
    mov r2, #9            @ Length of directory path (adjust as needed)
    mov r0, #1            @ File descriptor (stdout)
    mov r7, #4            @ Syscall: write
    swi 0

    ldr r1, =newline      @ Append a newline
    mov r2, #1            @ Length of newline
    mov r0, #1            @ File descriptor (stdout)
    mov r7, #4            @ Syscall: write
    swi 0

    mov r0, #0            @ Exit code 0
    mov r7, #1            @ Syscall: exit
    swi 0

failure:
    mov r0, #1            @ Exit code 1 (failure)
    mov r7, #1            @ Syscall: exit
    swi 0

.data
cmd_prefix: .asciz "cd "
new_dir:    .asciz "./Desktop"
newline:    .asciz "\n"

