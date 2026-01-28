%include 'stud_io.inc'
global _start

section .text
_start: GETCHAR
        cmp AL, 'A'
        jne incor
        PRINT 'YES'
        jmp fin
incor:  PRINT 'NO'
fin:    PUTCHAR 10  ;for good formating 
        GETCHAR     ;for shell, because it 'eat' $10 for enter
        FINISH
