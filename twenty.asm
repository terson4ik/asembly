%include 'stud_io.inc'
global _start

section .text
_start: GETCHAR
        cmp eax, 10
        jne skip
        PRINT 'OK'
        PUTCHAR 10
        jmp _start
skip:   cmp eax, -1
        jne _start
        FINISH
