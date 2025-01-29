
.global _start
_start:
    mov r7, #11             @ Syscall: execve
    ldr r0, =script_path    @ Address of the script path (filename)
    ldr r1, =argv           @ Address of arguments array
    mov r2, #0              @ No environment variables (envp = NULL)
    swi 0                   @ Call the kernel

    mov r7, #1              @ Syscall: exit
    mov r0, #0              @ Exit code 0
    swi 0                   @ Exit program

.data
script_path: .asciz "./script.sh"    @ Path to your shell script
argv:       .word script_path, 0           @ Arguments array (NULL-terminated)



