.global _start
_start:
    // Step 1: Get the process ID using the getpid syscall (syscall number 0x11)
    mov r7, #0x11        // syscall number for getpid
    swi 0                // make the syscall
    mov r1, r0          // store pid in r1 (r0 contains the pid)

    // Step 2: Convert the PID to a string
    mov r0, r1           // move the pid to r0 (for conversion)
    bl int_to_str        // call the conversion function

    // Step 3: Print the string to stdout (syscall number 0x04)
    mov r0, #1           // file descriptor 1 (stdout)
    ldr r2, =buffer      // load the address of the buffer (string)
    mov r7, #0x04        // syscall number for write
    swi 0                // make the syscall

    // Exit the program (syscall number 0x01)
    mov r0, #0           // exit status 0
    mov r7, #0x01        // syscall number for exit
    swi 0                // make the syscall

// Function to convert integer to string
// Converts the integer in r0 to a string and stores it in the buffer
int_to_str:
    ldr r3, =buffer      // buffer to store the string
    add r3, r3, #10      // move to the end of the buffer (reserve 10 digits max)
    mov r4, #0           // clear r4 (digit counter)

convert_loop:
    // Get the last digit (divide by 10, and convert it to ASCII)
    mov r5, r0           // move pid to r5
    udiv r0, r0, #10     // divide pid by 10 (r0 now contains the quotient)
    and r5, r5, #0xF     // extract the last digit (this gets the last 4 bits)
    add r5, r5, #'0'     // convert digit to ASCII
    strb r5, [r3, #-1]!  // store the digit in buffer and decrement pointer

    cmp r0, #0           // check if done (quotient is 0)
    bne convert_loop     // if not, continue

    // Null-terminate the string (store '\0' at the current position)
    mov r5, #0
    strb r5, [r3]

    // Reverse the string since we've been filling it in reverse order
    ldr r6, =buffer      // load buffer address
    add r3, r3, #10      // move to the start of the string

reverse_loop:
    cmp r6, r3           // check if we reached the middle
    bge reverse_done     // if so, we're done

    // Swap characters at r6 and r3
    ldrb r7, [r6]
    ldrb r8, [r3]
    strb r8, [r6]
    strb r7, [r3]

    add r6, r6, #1       // increment r6
    sub r3, r3, #1       // decrement r3
    b reverse_loop

reverse_done:
    bx lr                // return from function

// Reserve buffer space (max 10 digits for pid + null-terminator)
buffer:
    .skip 12

