%include 'stud_io.inc'
global _start

section .text
_start: GETCHAR
        cmp eax, '0'
        jna final
        cmp eax, '9'
        ja final
        mov cl, al;
        sub cl, '0'
cicle:  PUTCHAR '*'
        dec cl;
        jnz cicle
final:  PUTCHAR 10
        GETCHAR     ;for drop #10 in stdIn
        FINISH 
