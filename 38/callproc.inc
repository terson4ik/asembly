%define arg1 ebp+8
%define arg2 ebp+12
%define arg3 ebp+16
%define arg4 ebp+20

%define var1 ebp+4
%define var2 ebp+8
%define var3 ebp+12

%macro callproc 1-*
%rep %0-1
        %rotate -1
        push dword %1
%endrep
        %rotate -1
        call %1
        add esp, (%0-1)*4
%endmacro

%macro prologue 0
        push ebp
        mov ebp, esp
%endmacro

%macro epilogue 0
        mov esp, ebp
        pop ebp
        ret
%endmacro
