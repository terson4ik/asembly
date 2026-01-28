%include 'stud_io.inc'
global _start

section .text
_start: GETCHAR
        cmp eax, -1
        je  final
        PUTCHAR al
        jmp _start
final:  FINISH
