.global _start
_start:
mov r0, #1  @r0 carries the first arg, and also the return
ldr r1,=message @r1 carries the second arg, that is the text to be printed
ldr r2, =len @r2 carries the length of the text
mov r7, #4 @r7 carries the system call number
swi 0 @software interrupt

mov r7, #1  @system call number for exit
swi 0 @another software interrupt

.data
message:
.asciz "hello world/n"
len = .-message

