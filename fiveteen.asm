%include 'stud_io.inc'
global _start

section .text
_start: xor ecx, ecx    ;for counter
        xor ebx, ebx
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
addleft:inc ecx
        inc ebx
        jmp read
addrigh:dec ecx
        inc ebx
        cmp ecx, 0
        js calc
        jmp read
calc:   cmp ecx, 0
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
