.global _start
_start:
.text
    ldr r0, =message1       @ Load address of message1
    ldr r1, =message2       @ Load address of message2
    ldr r2, =len1           @ Load length of message1
    ldr r3, =len2           @ Load length of message2

    cmp r2, r3              @ Compare lengths
    bne ending              @ If not equal, branch to ending

    mov r3, #0              @ Initialize counter
loop:
    ldrb r4, [r0], #1       @ Load byte from message1 and increment r0
    ldrb r5, [r1], #1       @ Load byte from message2 and increment r1
    cmp r4, r5              @ Compare bytes
    bne ending              @ If not equal, branch to ending
    add r3, r3, #1          @ Increment counter
    cmp r3, r2              @ Compare counter to message length
    beq equals              @ If all bytes matched, branch to equals
    b loop                  @ Otherwise, repeat the loop

ending:
    mov r0, #1              @ Exit syscall number
    mov r7, #1              @ Syscall: exit
    swi 0                   @ Call kernel

equals:
    mov r0, #0              @ Success syscall number
    mov r7, #1              @ Syscall: exit
    swi 0                   @ Call kernel

.data
message1: .asciz "Strawberry\n"    @ First string
message2: .asciz "Strawmelon\n"    @ Second string
len1 = . - message1                @ Length of message1
len2 = . - message2                @ Length of message2

