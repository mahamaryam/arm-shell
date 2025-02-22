.global _start
.extern sprintf 

.data
    pid_msg: .asciz "PID: %d\n"  
    pid_buf: .space 32         

.text
_start:
    mov r7, #20          
    swi 0               
    mov r3, r0           

    ldr r0, =pid_buf    
    ldr r1, =pid_msg    
    mov r2, r3           
    bl sprintf           

    mov r0, #1           
    ldr r1, =pid_buf    
    mov r2, #32          
    mov r7, #4           
    swi 0               

    mov r0, #0           
    mov r7, #1           
    swi 0

