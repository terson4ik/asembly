%include 'args.inc'
global check_copy_two
global check_count
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
