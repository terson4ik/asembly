global _start

%define TESTIK

%macro CHECKSTR 4   ; %1 is call proc, %2 is arg to push, %3 is print proc
                    ; %4 is label to jump
        push %2
        call %1
        add esp, 4
        test eax, eax
        jz %%skip
        push %2
        call %3
        add esp, 4
        jmp %4
%%skip:
%endmacro

%macro skelet 3-4     ; address, buffer, uniqpar, optional:counter
        %if %0 == 4
            %ifnidni %4, ecx
                %error incorrect registr
            %endif
            xor ecx, ecx
        %endif
        mov %1, [esp+4]
        %ifidni %3, MONO
            mov cl, [%1]
        %endif
.lp:    mov %2, [%1]
        test %2, %2
        %ifidni %3, DOG
            jz .check
        %else
            jz .end
        %endif
        inc %1
        %ifidni %3, ONE_LETER
            cmp %2, 'A'
            jb .lp
            cmp %2, 'Z'
            ja .lp
            jmp .end
        %elifidni %3, DOG
            ; in this case need to xor ecx before call
            %define FAILING
            cmp %2, '@'
            je .dog
            cmp %2, '.'
            je .dot
            jmp .lp

.dog:       test cl, cl
            jnz .fail
            inc cl
            jmp short .lp
.dot:       inc ch
            jmp short .lp
.check:    
            test cl, cl
            jz .fail
            test ch, ch
            jz .fail
            inc eax
            jmp short .end
            
        %elifidni %3, Az
            ; in this case need to xor ecx before call
    %define FAILING
            test ecx, ecx
            jnz .next
            cmp %2, 'A'
            jb .fail
            cmp %2, 'Z'
            ja .fail
            inc ch
.next:      mov cl, [%1]   ; before this, %1 upped
            test cl, cl
            jnz .lp
            cmp %2, 'a'
            jb .fail
            cmp %2, 'z'
            ja .fail
            jmp short .end
        %elifidni %3, MONO
    %define FAILING
            cmp %2, cl
            jnz .fail
            mov ch, [%1]
            test ch, ch
            jz .end
            jmp short .lp
        %else
            %error parametr %3 unknown
        %endif

        %ifdef FAILING
.fail:      xor eax, eax
        %endif

.end:   ret
    %undef FAILING
%endmacro

section .text
nl      db  10

count_chrs:             ; arg1 is address of string
        xor eax, eax
        mov ecx, [esp+4]
.lp:    mov dl, [ecx]
        test dl, dl
        jz .end
        inc eax
        inc ecx
        jmp short .lp
.end:   ret

print:                  ; arg1 is address of string

        mov eax, [esp+4]
        push eax
        call count_chrs
        add esp, 4
        xchg edx, eax
        mov eax, 4
        mov ecx, [esp+4]
        push ebx
        mov ebx, 1
        int 80h
        mov eax, 4
        mov ecx, nl
        mov edx, 1
        int 80h
        pop ebx
        ret

big_let:                ; arg1 is address of string
        skelet edx, al, ONE_LETER

one_dog_more_dots:      ; arg1 is address of string
        skelet edx, al, DOG, ecx

big_let_small_let:      ; arg1 is address of string
        skelet edx, al, Az, ecx

mono:                   ; arg1 is address of string
        skelet edx, al, MONO, ecx

_start:
        mov esi, [esp]
        dec esi
        jz end
        lea edi, [esp+4]    ; ./prog

lp:     add edi, 4
        mov ebx, [edi]

        CHECKSTR one_dog_more_dots, ebx, print, skip
        CHECKSTR big_let_small_let, ebx, print, skip
        CHECKSTR mono, ebx, print, skip
        %ifdef TESTIK  ; bigletsmalllet duple this
        CHECKSTR big_let, ebx, print, skip
        %endif

skip:   dec esi
        jz end
        jmp lp

end:    xor ebx, ebx
        mov eax, 1
        int 80h
