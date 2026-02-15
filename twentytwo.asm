%include 'stud_io.inc'
global _start

section .text
_start: xor ecx, ecx
        xor eax, eax
read:   GETCHAR
        test eax, eax
        js output
        cmp eax, 10
        je output
        push eax
        inc ecx
        jmp read
output: jecxz done
lp:     pop eax
        PUTCHAR al
        loop lp
done:   PUTCHAR 10
        FINISH
