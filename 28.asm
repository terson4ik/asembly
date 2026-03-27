%include 'stud_io.inc'
global _start

%macro init 3
; first parameter is init value
; second parameter is step
; third parameter is count
    %assign val %1
    %rep %3
        dd val     ; double word
        %assign val val+%2
    %endrep
%endmacro

section .data
array   init '0', 1, 10

section .text
_start: mov ecx, 10
        mov ebx, array
loop:   mov eax, [ebx]
        add ebx, 4
        dec ecx
        PUTCHAR al
        PUTCHAR 10
        test ecx, ecx
        jnz loop
        FINISH
