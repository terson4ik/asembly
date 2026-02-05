%include 'stud_io.inc'
global _start

section .text
_start: xor ebx, ebx    ;accumulator
        xor esi, esi    ;temporary
run:    GETCHAR
        test eax, eax
        js print
        cmp eax, '0'
        jb print
        cmp eax, '9'
        ja print
        sub eax, '0'
        ;a * 10= a*8 + a*2= a<<3 + a<<1
        mov esi, ebx
        shl esi, 3
        shl ebx, 1
        add ebx, esi
        add ebx, eax
        jmp run
print:  test ebx, ebx
        jz final
        PUTCHAR '*'
        dec ebx
        jmp print
final:  PUTCHAR 10
        FINISH
