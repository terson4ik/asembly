global copy_bytes

section .text
copy_bytes:
; fd_src                    ebp+8
; fd_dest                   ebp+12
; addr of buffer            ebp+16
; size of buffer            ebp+20
; size of need to write     ebp+24
        push ebp
        mov ebp, esp
        push esi
        mov esi, [ebp+24]   ; will be decremented
        push ebx
.loop:  mov eax, 3          ; read
        mov ebx, [ebp+8]    ; fd_src
        mov ecx, [ebp+16]   ; addr_buff
        mov edx, [ebp+20]   ; size of buff
        int 80h
        cmp eax, 0          ; if EOF then end
        jle .end
        cmp esi, eax 
        ja .bigger
        xchg edx, esi
        xor esi, esi
        jmp .run
.bigger:sub esi, eax
        xchg edx, eax
.run:   mov eax, 4
        mov ebx, [ebp+12]   ;fd_dest
        mov ecx, [ebp+16]   ; addr_buff
        ; edx will configured
        int 80h
        test esi, esi
        jz .end
        jmp .loop
.end:   pop ebx
        pop esi
        mov esp, ebp
        pop ebp
        ret
