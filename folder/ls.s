.global _start

.section .data
buffer: .space 1024          // 1 KB buffer for directory entries
dir_name: .asciz "/"      // Replace with your target directory

.section .text
_start:
    // Step 1: Open the directory
    ldr r0, =dir_name        // Pointer to directory name
    mov r1, #0               // O_RDONLY
    mov r7, #5               // Syscall: open
    svc #0                   // Perform syscall
    cmp r0, #0               // Check for errors
    blt exit_program         // Exit if open fails
    mov r4, r0               // Save directory FD in r4

    // Step 2: Call getdents
read_dir:
    mov r0, r4               // Directory file descriptor
    ldr r1, =buffer          // Pointer to buffer
    mov r2, #1024            // Buffer size (1 KB)
    mov r7, #0x8d            // Syscall: getdents
    svc #0                   // Perform syscall
    cmp r0, #0               // Check if any entries were read
    ble close_dir            // Exit if no entries or error
    mov r5, r0               // Save bytes read in r5

    // Step 3: Parse and print directory entries
    ldr r3, =buffer          // Pointer to start of buffer

parse_entries:
    cmp r5, #0               // Check if there are remaining bytes to process
    ble read_dir             // If no more entries, read again

    ldr r0, [r3]             // Read d_ino (inode, optional)
    add r3, r3, #8           // Move to d_reclen (8 bytes from d_ino)
    ldrh r2, [r3]            // Read d_reclen (entry size)
    add r3, r3, #2           // Move to d_name (start of filename)
    mov r1, r3               // Pointer to filename (d_name)
push {r1,r2,r3}
    bl print_string          // Print the filename
pop {r3,r2,r1}
    sub r3,r3,#10           // Move to the next entry (skip d_reclen)
  add r3,r3,r2
    subs r5, r5, r2          // Subtract d_reclen from bytes left
    bgt parse_entries        // If more entries remain, continue

    b read_dir               // Read more entries if any

// Step 4: Close directory
close_dir:
    mov r0, r4               // Directory file descriptor
    mov r7, #6               // Syscall: close
    svc #0                   // Perform syscall

// Exit program
exit_program:
    mov r7, #1               // Syscall: exit
    mov r0, #0               // Exit code
    svc #0                   // Perform syscall

// Print a null-terminated string using write syscall
print_string:
    mov r2, #0               // String length counter
count_loop:
    ldrb r3, [r1, r2]        // Load byte from string
    cmp r3, #0               // Check for null terminator
    beq write_string         // If null, go to write
    add r2, r2, #1           // Increment counter
    b count_loop             // Repeat

write_string:
    mov r7, #4               // Syscall: write
    mov r0, #1               // STDOUT
    svc #0                   // Perform syscall
    mov r0,#1
ldr r1,=newline
mov r2,#1
mov r7,#4
svc #0
    bx lr                    // Return to caller
.data
newline: .asciz "\n"

