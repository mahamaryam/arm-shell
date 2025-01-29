.global _start
_start:

ldr r0,=buff
mov r7,#0x7a
swi 0
ldr r1,=buff
mov r0,#1
mov r2,#20
mov r7,#4
swi 0
ldr r1,=newline
mov r0,#1
mov r2,#1
mov r7,#4
svc #0
mov r0,#0
mov r7,#1
swi 0
.data
buff: .space 20
newline: .asciz "\n"

