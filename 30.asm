%include 'stud_io.inc'
global _start

%macro putarrey 1
    %strlen sl %1
    %assign i 1
    %rep sl
        %substr var %1 i
        dd var
        %assign i i+1
    %endrep
%endmacro

section .data
data    putarrey "Vladislav takoy vot 111)))"

section .text
_start: 
        FINISH
