format PE console
entry start

section '.data' data readable writeable
    hello db 'Hello, World!', 0

section '.text' code readable executable
start:
    ; Write 'Hello, World!' to console
    mov eax, 4       ; 'write' system call
    mov ebx, 1       ; file descriptor 1 = stdout
    mov ecx, hello   ; message to write
    mov edx, 13      ; message length
    int 0x80         ; call kernel
    
    ; Exit program
    mov eax, 1       ; 'exit' system call
    xor ebx, ebx     ; return code 0
    int 0x80         ; call kernel
