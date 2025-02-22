.global _start

.section .data
buffer: .space 1024
dir_name: .asciz "/"

.section .text
_start:
    ldr r0, =dir_name
    mov r1, #0
    mov r7, #5
    svc #0
    cmp r0, #0
    blt exit_program
    mov r4, r0

read_dir:
    mov r0, r4
    ldr r1, =buffer
    mov r2, #1024
    mov r7, #0x8d
    svc #0
    cmp r0, #0
    ble close_dir
    mov r5, r0

    ldr r3, =buffer

parse_entries:
    cmp r5, #0
    ble read_dir

    ldr r0, [r3]
    add r3, r3, #8
    ldrh r2, [r3]
    add r3, r3, #2
    mov r1, r3
push {r1,r2,r3}
    bl print_string
pop {r3,r2,r1}
    sub r3,r3,#10
    add r3,r3,r2
    subs r5, r5, r2
    bgt parse_entries

    b read_dir

close_dir:
    mov r0, r4
    mov r7, #6
    svc #0

exit_program:
    mov r7, #1
    mov r0, #0
    svc #0

print_string:
    mov r2, #0
count_loop:
    ldrb r3, [r1, r2]
    cmp r3, #0
    beq write_string
    add r2, r2, #1
    b count_loop

write_string:
    mov r7, #4
    mov r0, #1
    svc #0
    mov r0,#1
ldr r1,=newline
mov r2,#1
mov r7,#4
svc #0
    bx lr

.data
newline: .asciz "\n"
