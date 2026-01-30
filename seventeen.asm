%include 'stud_io.inc'
global _start

section .text
_start: xor ebx, ebx    ;ebx=0
        GETCHAR
        test eax, eax
        js end
        cmp eax, ' '
        jbe empty
        PUTCHAR '('
        PUTCHAR al
repeat: mov bl, al
        GETCHAR
        test eax, eax
        js final        ;-1=EOF
        cmp eax, ' '
        jbe closing
        PUTCHAR al
        jmp repeat
closing:
        PUTCHAR ')'
empty:  PUTCHAR al
        jmp _start
final:  test bl, bl
        jz end
        cmp bl, ' '
        jbe end
        PUTCHAR ')'
        PUTCHAR 10
end:    FINISH
