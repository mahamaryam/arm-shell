.global _start
_start:
.text
    ldr r0, =message1       
    ldr r1, =message2       
    ldr r2, =len1           
    ldr r3, =len2           

    cmp r2, r3              
    bne ending              

    mov r3, #0              
loop:
    ldrb r4, [r0], #1       
    ldrb r5, [r1], #1       
    cmp r4, r5              
    bne ending              
    add r3, r3, #1          
    cmp r3, r2              
    beq equals              
    b loop                  

ending:
    mov r0, #1              
    mov r7, #1              
    swi 0                   

equals:
    mov r0, #0              
    mov r7, #1              
    swi 0                   

.data
message1: .asciz "Strawberry\n"    
message2: .asciz "Strawmelon\n"    
len1 = . - message1                
len2 = . - message2                

