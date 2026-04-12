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
    push %1
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
                        pop esi
                        %if %0 > 7
                            %error "no more then 7 params to syscall"
                        %endif
                    %endif
                %endif
            %endif
        %endif
    %endif
%endif
        int 80h
        mov ecx, eax
        and ecx, 0fffff000h
        cmp ecx, 0fffff000h
        jne %%ok
        mov ecx, eax
        mov eax, -1
        jmp short %%quit
%%ok:   xor ecx, ecx
%%quit:
%if %0 > 1
        %if %0 > 4
            pop ebp
            pop edi
            pop esi
        %endif
        pop ebx
%endif
%endmacro

%macro quit 1
    mov eax, 1
    mov ebx, %1
    int 80h
%endmacro
