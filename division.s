.global _start
_start:
    ldr r0, =12345       
    mov r1, #10          
    udiv r2, r0, r1      
    mul r3, r2, r1       
    sub r3, r0, r3       
    add r3, r3, #48      
    mov r1, r3           
    mov r0, #1           
    mov r2, #1           
    mov r7, #4           
    swi 0                
    mov r0, #0           0
    mov r7, #1           
    swi 0                

