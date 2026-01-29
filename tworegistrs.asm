%include 'stud_io.inc'
global _start

section .text
_start: xor ebx, ebx    ;for (
        xor ecx, ecx    ;for )
read:   GETCHAR
        cmp eax, -1
        je final
        cmp eax, 10
        je calc
        cmp eax, ')'
        je addrigh
        cmp eax, '('
        je addleft
        jmp read
addleft:inc ebx
        jmp read
addrigh:inc ecx
        cmp ecx, ebx
        ja calc
        jmp read
calc:   cmp ecx, ebx
        je equal
        PRINT 'NO'
        PUTCHAR 10
clbuff: cmp eax, 10
        je _start
        GETCHAR
        jmp clbuff
equal:  cmp ebx, 0
        jne allgood
        PRINT 'BRACKETS DOES NOT EXISTS!!!'
        PUTCHAR 10
        jmp _start
allgood:PRINT 'YES'
        PUTCHAR 10
        jmp _start
final:  FINISH
