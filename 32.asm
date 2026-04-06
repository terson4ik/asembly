global _start

section .text
target  equ 3
_start: 
        mov eax, 1
        mov ecx, [esp]
        cmp ecx, target + 1 ; 3+1 because ./prog it is also arg
        jnz bad
        xor ebx, ebx
        int 80h
bad:    mov ebx, 128
        int 80h
