%include 'stud_io.inc'
global _start

section .text
_start: xor ecx, ecx
read:   GETCHAR
        cmp eax, -1
        je final
        cmp eax, 10
        je output
        inc cx
        jmp read
output: cmp cx, 0
        je _start
loops:  PUTCHAR '*'
        loop loops
        PUTCHAR 10
        jmp _start
final:
        FINISH
