%include 'stud_io.inc'
global _start

section .text
_start: xor ecx, ecx
        mov esi, 10
        push esi
        lea esi, [esp]
        mov edi, esi
reading:GETCHAR
        test eax, eax
        js output       ;-1=eof
        push eax
        jmp reading
output: cmp esi, esp
        jbe end
finding:sub esi, 4
        mov edi, esi
        cmp esi, esp
        jbe newline
        cmp [esi], dword 10
        je newline
        inc ecx
        jmp finding
newline:cmp [edi], dword 10
        jne lp
        add edi, 4
lp:     mov eax, [edi]
        PUTCHAR al
        add edi, 4
        jecxz output
        dec ecx
        jmp lp
end:    FINISH
