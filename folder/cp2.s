.global _start
.data
buff: .space 100
buff2: .space 100
.text
_start:
    mov r0, #0
    ldr r1, =buff
    mov r2, #100
    mov r7, #3
    swi 0

    ldr r1, =buff
    mov r2, r0
    bl find_newline

    mov r0, #0
    ldr r1, =buff2
    mov r2, #100
    mov r7, #3
    swi 0

    ldr r1, =buff2
    mov r2, r0
    bl find_newline

    ldr r0, =buff
    mov r1, #0
    mov r2, #0
    mov r7, #5
    swi 0

    cmp r0, #0
    blt exit_program
    mov r4, r0

    ldr r0, =buff2
    mov r1, #2
    mov r2, #77
    mov r7, #5
    swi 0

    cmp r0, #0
    blt exit_program
    mov r5, r0

step_9:
    mov r0, r4
    mov r1, r5
    mov r2, #100
    mov r7, #4
    swi 0

    cmp r0, #0
    beq close_files
    mov r1, r5
    mov r7, #4
    swi 0

    cmp r0, #0
    blt exit_program
    b step_9

close_files:
    mov r0, r4
    mov r7, #6
    swi 0

    mov r0, r5
    mov r7, #6
    swi 0

exit_program:
    mov r7, #1
    mov r0, #0
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
