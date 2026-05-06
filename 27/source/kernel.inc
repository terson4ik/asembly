%macro kernel 1-4       ; i don`t use 4+ parameters
%if %0 > 1
        push ebx
%endif
%rep %0
    %rotate -1
    push dword %1
%endrep
pop eax
%if %0 > 1
    pop ebx
    %if %0 > 2
        pop ecx
        %if %0 > 3
            pop edx
        %endif
    %endif
%endif
        int 80h
%if %0 > 1
    pop ebx
%endif
%endmacro
