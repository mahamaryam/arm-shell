.global _start
_start:
mov r0, #0
ldr r1,=message
ldr r2, =len
mov r7, #3
swi 0

mov r0,#1
ldr r1,=message
ldr r2,=len
mov r7, #4
swi 0

ldr r0,=message
ldr r1,=ls
cmp r0, r1
beq equal
b end
equal:
mov r0,#1
ldr r1,=ok
ldr r2,#2
mov r7, #4
swi 0

end:
mov r7, #1
swi 0

.data
message: .asciz "?????????????????????????????????????????????????/n"
len= .-message
ls: .asciz "ls\n"
ok: .asciz "ok\n"

