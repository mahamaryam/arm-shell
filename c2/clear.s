.global _start

.text
_start:
    mov r0, #1          
    ldr r1, =clear_cmd  //load address of the escape sequence
    mov r2, #12       
    mov r7, #4         
    swi 0              

    mov r7, #1          
    mov r0, #0          
    swi 0

.data
clear_cmd: .asciz "\033[2J\033[3J\033[H"  //clear screen,clear scrollback buffer,move cursor to top-left

