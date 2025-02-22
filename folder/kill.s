.global _start
.extern atoi
.data
pid: .space 10       
signal: .space 10
.text
_start:
    mov r0, #0         
    ldr r1, =pid      
    mov r2, #10       
    mov r7, #3        
    swi 0             

    ldr r1, =pid      
    mov r2, r0        
    bl find_newline

mov r0,#0
ldr r1,=signal
mov r2,#10
mov r7,#3
swi 0
ldr r1,=signal
mov r2,#0
bl find_newline

ldr r0,=signal
bl atoi
push {r0}
ldr r0,=pid
bl atoi
pop {r1}
mov r7,#0x25
swi 0

exit_program:
mov r0,#0
mov r7,#1
swi 0

find_newline:
    ldrb r3, [r1], #1
    cmp r3, #10       
    beq null_terminate
    subs r2, r2, #1   
    bne find_newline  
    b null_terminate  

null_terminate:
    sub r1, r1, #1    
    mov r3, #0        
    strb r3, [r1]     
    bx lr
