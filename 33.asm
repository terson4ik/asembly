%define arg1 ebp+8
%define arg2 ebp+12
%define arg3 ebp+16
;%define FIRST
;%define SECOND


global _start

section .text

error:
        mov eax, 1
        mov ebx, 127
        int 80h

check_count:    ; arg1 count of parameters in [esp]
target  equ 2

        xor eax, eax
        mov ebp, esp
        cmp dword [esp+4], target + 1   ; also ./prog
        je .quit
        inc eax
.quit:  ret

check_copy_two:       ; arg1 and arg2 address of the strings
        push ebp
        mov ebp, esp
        mov ecx, [arg1]
        mov edx, [arg2]
        push ebx    ; buffer
.lp:    mov al, [edx]
        mov bl, al
        mov ah, [ecx]
        ; test al, ah   fuck. i find it`s fatal error
        or bl, ah
        jz .good
        test al, al
        jz .disball
        test ah, ah
        jz .disball
        inc ecx
        inc edx
        jmp short .lp
.disball:
        xor eax, eax
        inc eax
        jmp short .end
.good:  xor eax, eax
.end:   pop ebx
        pop ebp
        ret

find_end:               ; return last symbol
        xor eax, eax
        xor ecx, ecx
        mov edx, [esp+4]
.lp:    mov al, [edx+ecx]
        test al, al
        jz .exit
        inc ecx
        jmp short .lp
.exit:  test ecx, ecx
        jz .dontneed
        dec ecx
.dontneed:
        mov al, [edx+ecx]
        ret

check_end_two:          ; arg1 and arg2 address of the strings
        push ebp
        mov ebp, esp
        mov edx, [arg1]
        push edx
        call find_end
        add esp, 4
        mov cl, al
        push ecx
        mov edx, [arg2]
        push edx
        call find_end
        add esp, 4
        pop ecx
        cmp cl, al
        jz .good
        inc eax
        jmp short .end
.good:  xor eax, eax
.end:   pop ebp
        ret

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
