extern check_end_two
extern check_copy_two
extern check_count
;%define FIRST
;%define SECOND


global _start

section .text

error:
        mov eax, 1
        mov ebx, 127
        int 80h

_start:
        mov ebx, [esp]
        push ebx
        call check_count
        add esp, 4
        test eax, eax
        jnz error
        push dword [esp+12]
        push dword [4+esp+8]      ; +4 because esp shift +4
        %ifdef FIRST
            call check_copy_two
            add esp, 8
            test eax, eax
            jnz error
        %elifdef SECOND
            call check_end_two
            add esp, 8
            test eax, eax
            jnz error
        %else
            call check_copy_two
            add esp, 8
            test eax, eax
            jnz error
            push dword [esp+12]
            push dword [4+esp+8]      ; +4 because esp shift +4
            call check_end_two
            add esp, 8
            test eax, eax
            jnz error
        %endif
        mov eax, 1
        mov ebx, 0
        int 80h
