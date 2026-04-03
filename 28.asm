%include 'stud_io.inc'
global _start

%macro createArr 3 ; init value, step, count
    %assign val %1 
    %rep %3
        dd val
        %assign val val+%2
    %endrep
%endmacro

section .data
count   equ 10
arr     createArr '9', -1, count

section .text
_start: 
        mov ecx, count
        mov ebx, arr
lp:     mov eax, [ebx]
        PUTCHAR al
        add ebx,4
        loop lp
        PUTCHAR 10
        FINISH
