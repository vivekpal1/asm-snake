format ELF64

section '.data' writable
    hello db 'Hello, world!',0

section '.text' executable
global _start

_start:
    ; write "Hello, world!" to stdout
    mov rax, 1
    mov rdi, 1
    mov rsi, hello
    mov rdx, 13
    syscall

    ; exit program with status code 0
    mov rax, 60
    xor rdi, rdi
    syscall
