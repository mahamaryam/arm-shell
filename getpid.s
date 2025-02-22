.global _start
_start:
    mov r7, #0x11   
    swi 0           
    mov r1, r0      

    mov r0, r1           
    bl int_to_str       

    mov r0, #1           
    ldr r2, =buffer     
    mov r7, #0x04       
    swi 0                

    mov r0, #0           
    mov r7, #0x01        
    swi 0                

int_to_str:
    ldr r3, =buffer     
    add r3, r3, #10     
    mov r4, #0          

convert_loop:
    mov r5, r0           
    udiv r0, r0, #10     
    and r5, r5, #0xF     
    add r5, r5, #'0'    
    strb r5, [r3, #-1]!  

    cmp r0, #0           
    bne convert_loop     

    mov r5, #0
    strb r5, [r3]

    ldr r6, =buffer     
    add r3, r3, #10     

reverse_loop:
    cmp r6, r3           
    bge reverse_done    

    ldrb r7, [r6]
    ldrb r8, [r3]
    strb r8, [r6]
    strb r7, [r3]

    add r6, r6, #1       
    sub r3, r3, #1       
    b reverse_loop

reverse_done:
    bx lr                

buffer:
    .skip 12

