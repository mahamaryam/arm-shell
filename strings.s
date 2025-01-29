.global _start
_start:
mov r0, #1
ldr r1,=message
ldr r2, =len

mov r3,#0

loop:
ldr r4, [r2,#4]!
add r3,#1
cmp r3, r2
beq end
mov r7,#4
swi 0
bal loop

end:
mov r7, #1
swi 0

.data
message:
.asciz "hello world/n"
len = .-message

