%include 'args.inc'
global check_end_two
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
