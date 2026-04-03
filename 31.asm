%include 'stud_io.inc'
global _start
;%define WORD
;%define DOUBLE
;%define QUADRO

%macro putarrey 1
    %strlen sl %1
    %assign i 1
    %rep sl
        %substr var %1 i
        %ifdef WORD
            dw var
        %elifdef DOUBLE
            dd var
        %elifdef QUADRO
            dq var
        %else
            db var
        %endif
        %assign i i+1
    %endrep
%endmacro

section .data
data    putarrey "Vladislav takoy vot 111)))"

section .text
_start: 
        FINISH
