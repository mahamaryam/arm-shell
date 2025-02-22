.global _start
.data
buff: .space 100
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
ldr r0,=buff
mov r7,#0x0a
swi 0 
exit_program:
mov r0,#0
mov r7,#1
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
.data
error: .asciz "error in openeing file\n"
len = .-error
