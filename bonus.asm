%include 'stud_io.inc'
global _start

section .text
_start: GETCHAR
        mov ecx, eax
        sub cl, '0'
        cmp ecx, 10
        ja final
        cmp ecx, 0
        jz final
        mov dl, al
loops:  PUTCHAR dl
        dec dl
        loop loops
final:
        PUTCHAR 10
        GETCHAR 
        FINISH
