O_RDONLY   equ 0
SYS_READ   equ 0
SYS_WRITE  equ 1
SYS_OPEN   equ 2
SYS_CLOSE  equ 3
SYS_EXIT   equ 60

%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

section .data
    no_file_error db "acat: error: No file specified", 10
    file_not_found db "acat: error: No such file or directory", 10

section .bss
    chunk resb 2048

section .text
    global _start

_start:

    pop rax ; get number of arguments

    cmp rax, 1
    jg openfile

    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, no_file_error
    mov rdx, 31
    syscall
    exit 1

openfile:

    pop rdi ; skip 1 argument cuz it's program's name
    pop rdi

    mov rax, SYS_OPEN
    mov rsi, O_RDONLY
    syscall

    cmp rax, -2
    jne readfile

    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, file_not_found
    mov rdx, 39
    syscall
    exit 2

readfile:

    push rax
    mov rbx, rax
    
loop_through_the_file:

    mov rdi, rbx
    mov rax, SYS_READ
    mov rsi, chunk
    mov rdx, 2047
    syscall

    cmp rax, 0
    je end

    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, chunk
    mov rdx, 2047
    syscall

reset_chunk:

    cmp byte [rsi], 0
    je loop_through_the_file
    mov byte [rsi], 0
    inc rsi
    jmp reset_chunk

end:
    pop rdi
    mov rax, SYS_CLOSE
    syscall

    exit 0
