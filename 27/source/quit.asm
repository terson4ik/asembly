;; quit.asm ;;
global quit

section .text
quit:   mov eax, 1
        mov ebx, [esp+4]
        int 80h
