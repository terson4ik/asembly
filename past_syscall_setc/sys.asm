global _start

section .data
msg     db "hello Vladislav4ik :)", 10
length  equ $-msg

section .text
_start: mov eax, 4  ; write interupt
        mov ebx, 1  ; descriptor N1
        mov ecx, msg
        mov edx, length
        int 80h
        mov eax, 1
        mov ebx, 0
        int 80h
