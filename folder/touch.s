.section .data
filename:
    .asciz "example.txt"

.section .text
.global _start

_start:
    ldr r0, =filename
    mov r1, #0x180
    orr r1, r1, #0x30
    mov r7, #8
    swi 0
    mov r7, #1
    mov r0, #0
    swi 0
