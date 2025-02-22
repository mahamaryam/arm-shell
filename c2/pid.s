.global _asm_start
.extern sprintf       
.extern printf        

.data
    result_fmt: .asciz "PID: %d\n"  
    output: .space 50               

.text
_asm_start:
    mov r7,#0x14
    swi 0
    ldr r1, =result_fmt 
    ldr r2, =output     
    mov r3, r0          
    bl sprintf          

    ldr r0, =output    
    bl printf           

    mov r0, #0         
    mov r7, #1          
    swi 0               

