%macro kernel 1-7
%if %0 > 1
    push ebx
    %if %0 > 4
        push esi
        push edi
        push ebp
    %endif
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
            %if %0 > 4
                pop esi
                %if %0 > 5
                    pop edi
                    %if %0 > 6
                        pop ebp
                    %endif
                %endif
            %endif
        %endif
    %endif
%endif
        int 80h
        mov ecx, eax
        and ecx, 0xfffff000
        cmp ecx, 0xfffff000
        jne %%ok
        mov ecx, eax
        jmp short %%quit
%%ok:   xor ecx, ecx
%%quit: 
%if %0 > 1
        pop ebx
        %if %0 > 4
            pop ebp
            pop edi
            pop esi
        %endif
%endif
%endmacro
