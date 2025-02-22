
.global _start
_start:
    mov r7, #11             
    ldr r0, =script_path   
    ldr r1, =argv          
    mov r2, #0             
    swi 0                  

    mov r7, #1             
    mov r0, #0             
    swi 0                  

.data
script_path: .asciz "./script.sh"   
argv:       .word script_path, 0          



