%macro callproc 1-* ; name + params
%rep %0 - 1         ; name don't is parameter 
    %rotate -1      ; CDECL
        push %1
%endrep
%rotate -1
        call %1
        add esp, 4*(%0 - 1)
%endmacro
