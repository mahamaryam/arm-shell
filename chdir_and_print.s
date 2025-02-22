.global _start
_start:
    mov r7, #12           
    ldr r0, =new_dir      
    swi 0                 

    cmp r0, #0            
    bne failure

    ldr r1, =cmd_prefix   
    mov r2, #3            
    mov r0, #1            
    mov r7, #4            
    swi 0

    ldr r1, =new_dir      
    mov r2, #9            
    mov r0, #1            
    mov r7, #4            
    swi 0

    ldr r1, =newline      
    mov r2, #1            
    mov r0, #1            
    mov r7, #4            
    swi 0

    mov r0, #0            
    mov r7, #1            
    swi 0

failure:
    mov r0, #1            
    mov r7, #1            
    swi 0

.data
cmd_prefix: .asciz "cd "
new_dir:    .asciz "./Desktop"
newline:    .asciz "\n"

