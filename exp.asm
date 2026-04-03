%include 'stud_io.inc'
global _start
%define HUY
;%define ZALUPA
;%define O4KO

%macro jump 1-*
        cmp eax, 0
        jbe %%end
        cmp eax, %0
        ja %%end
        jmp %%skip
%%table:
        %rep %0
            dd  %1  ; eip=4b
            %rotate 1
        %endrep
%%skip: 
        dec eax
        jmp [%%table+4*eax]
%%end:
%endmacro

section .text
f:      PRINT "first"
        jmp over
s:      PRINT "second"
        jmp over
t:      PRINT "third"
        jmp over
_start: 
        %ifdef HUY
            mov eax, 1
        %elifdef ZALUPA
            mov eax, 2
        %elifdef O4KO
            mov eax, 3
        %else 
            mov eax, 0
        %endif
        jump f, s, t
over:
        FINISH
