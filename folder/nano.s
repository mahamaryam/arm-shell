.global _start
.data
nano_path: .asciz "/usr/bin/nano"
file: .space 100
args: .space 8
env: .asciz "TERM=linux"

.text
_start:
    mov r0, #0
    ldr r1, =file
    mov r2, #100
    mov r7, #3
    swi 0

    ldr r1, =file
    mov r2, r0
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

    ldr r0, =nano_path
    ldr r1, =args
    ldr r2, =file
    str r0, [r1]
    str r2, [r1, #4]
    mov r3, #0
    str r3, [r1, #8]

    ldr r2, =env

    mov r7, #0x0b
    swi 0

exit_program:
    mov r7, #1
    mov r0, #0
    swi 0
