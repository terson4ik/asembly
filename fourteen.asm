%include 'stud_io.inc'
global _start

section .text
_start: xor ecx, ecx ;most longer
        xor ebx, ebx ;over
clbuff: xor edx, edx ;buf
read:   GETCHAR
        cmp eax, -1
        je ending
        cmp eax, 10
        je update
        cmp eax, ' '
        je update
        cmp eax, 9
        jb update
        inc edx
        jmp read
update: cmp ecx, edx
        ja next
        mov ecx, edx
next:   cmp edx, 0
        je skip
        mov ebx, edx
skip:   cmp eax, 10
        je running
        jmp clbuff
running:cmp ecx, 0
        je _start
        PRINT 'a)'
varA:   PUTCHAR '*'
        dec ecx
        cmp ecx, 0
        jne varA
        PUTCHAR 10
        PRINT 'b)' ;if cx is exsisted, then bx also
varB:   PUTCHAR '*'
        dec ebx
        cmp ebx, 0
        jne varB
        PUTCHAR 10
        jmp _start
ending: FINISH
