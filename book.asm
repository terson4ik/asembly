%include 'stud_io.inc'
global _start

section .bss
set512  resd    16

section .text
_start: xor eax, eax
        mov ecx, 16
repeat: mov [set512 + ecx * 4 - 4], eax
        loop repeat

        ;adding
        mov ebx. 51
        mov cl, bl
        and cl, 11111b
        mov edx, ebx
        shr edx, 5
        mov eax, 1
        shl eax, cl
        or [set512+edx*4], eax 

        ;removing
        mov ebx, 51
        mov cl, bl
        and cl, 11111b
        mov eax, 1
        shl eax, cl
        not eax
        mov edx, ebx
        shr edx, 5
        and [set512+edx*4], eax

        ;is exist?
        mov ebx, 51
        mov cl, bl
        and cl, 11111b
        mov eax, 1
        shl eax, cl
        mov edx, ebx
        shr edx, 5
        test [set512+edx*4], eax
        jz not exist
        
        ;count
        xor ebx, ebx    ;counter
        mov ecx, 15
l:      mov eax, [set512+ecx*4]
l1:     test eax, 1
        jz notone
        inc ebx
notone: shr eax, 1
        test eax, eax
        jnz l1
        jecxz quit
        dec ecx
        jmp l
quit:   ...
