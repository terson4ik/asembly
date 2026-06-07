%include 'stud_io.inc'
global _start

%macro pcall1 2 ; 2 -- count of parameters of macros
    push %2
    call %1
    add esp, 4
%endmacro

%macro pcall2 3 
    push %3
    push %2
    call %1
    add esp, 8
%endmacro

%macro pcall3 4
    push %4
    push %3
    push %2
    call %1
    add esp, 12
%endmacro

%macro pcall4 5
    push %5
    push %4
    push %3
    push %2
    call %1
    add esp, 16
%endmacro

%macro pcall5 6
    push %6
    push %5
    push %4
    push %3
    push %2
    call %1
    add esp, 20
%endmacro

%macro pcall6 7
    push %7
    push %6
    push %5
    push %4
    push %3
    push %2
    call %1
    add esp, 24
%endmacro

%macro pcall7 8
    push %8
    push %7
    push %6
    push %5
    push %4
    push %3
    push %2
    call %1
    add esp, 28
%endmacro

%macro pcall8 9
    push %9
    push %8
    push %7
    push %6
    push %5
    push %4
    push %3
    push %2
    call %1
    add esp, 32
%endmacro



section .text
_start: pcall1 proc, eax
