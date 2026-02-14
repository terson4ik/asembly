%include 'stud_io.inc'
global _start

section .text
_start: xor ebx, ebx
        xor ecx, ecx
        ;esi have adress of start of the  string
lp:     mov bl, [esi+ecx]
        test bl, bl
        je lpquit
        push ebx
        inc ecx
        jmp lp
lpquit: jecxz done
        mov edi, esi
lp2:    pop ebx
        mov [edi], bl
        inc edi
        loop lp2
done:
