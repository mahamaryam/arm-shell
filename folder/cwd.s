.global _start
.data
buff: .space 100
_start:
ldr r0,=buff
mov r1,#100
mov r7,#0xb7
swi 0

ldr r1,=buff
mov r0,#1
mov r2,#100
mov r7,#4
swi 0

mov r2,#1
mov r1,#10
mov r0,#1
swi 0

mov r7,#1
mov r0,#0
swi 0

