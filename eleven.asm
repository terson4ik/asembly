%include 'stud_io.inc'
global _start

section .text
_start: xor ecx, ecx
read:   GETCHAR
        cmp eax, 10
        je action
        cmp eax, -1
        je action
        cmp eax, '0'
        jb read
        cmp eax, '9'
        ja read
        sub ax, '0'
        add cx, ax
        jmp read
action: cmp ecx, 0
        je final
running:PUTCHAR '*'
        loop running
final:  PUTCHAR 10
        FINISH
