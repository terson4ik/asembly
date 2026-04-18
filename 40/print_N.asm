;; 40/print_N.asm ;;
global print_N

section .text
count:  push ebp        ; return length of the string in bytes
        mov ebp, esp
        xor eax, eax
        mov edx, [ebp+8]
.lp:    cmp byte [eax+edx], 0
        jz .end
        inc eax
        jmp short .lp
.end:   mov esp, ebp
        pop ebp
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_N:                
; arg1 address of the buffer
; arg2 count of print
; arg3 file descriptor
        push ebp
        mov ebp, esp
        push dword [ebp+8]
        call count
        add esp, 4
        push edi
        push esi
        xchg edi, eax
        mov esi, [ebp+12]
.loop:  test esi, esi
        jz .end
        mov eax, 4
        mov ebx, [ebp+16]
        mov ecx, [ebp+8]
        mov edx, edi
        int 80h
        dec esi
        jmp short .loop
.end:   pop esi
        pop edi
        mov esp, ebp
        pop ebp
        ret
