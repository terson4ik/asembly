%include 'stud_io.inc'
global _start

section .text
_start: xor ecx, ecx    ;counter
read:   GETCHAR
        test eax, eax
        js  final       ;-1 = EOF
        cmp eax, 10
        jz output
        cmp eax, ' '
        je read
        inc ecx
cleanW: GETCHAR         ;goal is skiping current word
        test eax, eax
        js final
        cmp eax, ' '
        je read
        cmp  eax, 10
        je output
        jmp cleanW
output: test ecx, ecx
        jz  read
        PRINT '*'
        loop output
        PUTCHAR 10      ;for excellent formatting
        jmp read
final:  FINISH
