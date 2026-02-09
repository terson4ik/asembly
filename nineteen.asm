%include 'stud_io.inc'
global _start

section .bss
set10b  resb 10

section .text
_start: xor ebx, ebx
        mov ecx, 10
read:   GETCHAR
        test eax, eax
        js proces
        inc ebx
        jmp read
proces: PUTCHAR 10
        mov eax, ebx
        mov ebx, 10
repeat: cdq
        div ebx
        mov [set10b + ecx-1], dl
        dec ecx
        test eax, eax
        jz final
        jmp repeat
final:  inc ecx
        cmp ecx, 10
        ja end
        mov al, [set10b + ecx-1]
        add al, '0'
        PUTCHAR al
        jmp final 
end:    PUTCHAR 10
        FINISH
