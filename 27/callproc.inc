%define arg1 ebp+8
%define arg2 ebp+12
%define arg3 ebp+16
%define arg4 ebp+20
%define arg5 ebp+24
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%define var1 ebp-4
%define var2 ebp-8
%define var3 ebp-12
%define var4 ebp-16
%define var5 ebp-20

%macro callproc 1-*
; callproc procedure, 1, 2, 3
%rep %0-1
    %rotate -1
        push dword %1   ;3,2,1 -> 1 is first for functions
%endrep
    %rotate -1
    call %1
    add esp, 4*(%0-1)
%endmacro

%macro prologue 0       ; standard procedure start
    push ebp
    mov ebp, esp
%endmacro

%macro epilogue 0       ; standard procedure end
    mov esp, ebp
    pop ebp
    ret
%endmacro
