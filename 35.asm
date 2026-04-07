global _start
%define arg1 ebp+8
%define arg2 ebp+12
%define arg3 ebp+16


section .text
nl      db 10

error:
        mov ebx, 100
        mov eax, 1
        int 80h

count_length:   ; arg1 address of the string
        xor eax, eax
        mov ecx, [esp+4]
        push ebx
.lp:    mov bl, [ecx]
        test bl, [ecx]
        jz .end
        inc ecx
        inc eax
        jmp short .lp
.end:   pop ebx
        ret

find_param:     ; arg1 is count, args address of the string
        push ebp
        mov ebp, esp
        mov ecx, [arg1]
        xor eax, eax
        inc eax
        push ebx
        push esi
        mov esi, 2
        ; arg1 is max default
.lp:    
        dec ecx
        test ecx, ecx
        jz .end
        mov ebx, [arg1+eax*4]
        mov edx, [arg1+esi*4]
        inc esi
        cmp ebx, edx
        ja .lp
        mov eax, esi
        dec eax     ; in 4 step back esi will be inc
        jmp short .lp
.end:   pop esi
        pop ebx
        pop ebp
        ret

find_max:       ; arg1 is count, args address of the string
        push ebp
        mov ebp, esp
        mov ecx, [arg1] ;argc
        shl ecx, 2      ; *4
.lp:    
        mov eax, [arg1+ecx] 
        push ecx

        push eax
        call count_length
        add esp, 4

        pop ecx
        push eax
        sub ecx, 4
        test ecx, ecx
        jz .next
        jmp short .lp
.next:  
        mov ecx, [arg1]
        push ecx
        call find_param
        add esp, 4
        mov ecx, [arg1+eax*4]
        xchg eax, ecx
        mov ebx, [arg1]
        shl ebx, 2
        add esp, ebx
        pop ebp
        ret

print:   
        mov eax, [esp+4] 
        push eax
        call count_length
        add esp, 4
        xchg edx, eax
        mov eax, 4
        mov ebx, 1
        mov ecx, [esp+4]
        int 80h
        mov eax, 4
        mov ecx, nl
        mov edx, 1
        int 80h
        ret
        
_start: 
        mov ecx, [esp]
        dec ecx     ; -./prog 
        test ecx, ecx   
        jz error

        lea edx, [4+esp+4*ecx]      ; skip argc and ./prog, go to last arg
        ; for experience use true CDECL
        ; prepare stack to find_max
lp:     mov eax, [edx]
        push eax
        sub edx, 4
        dec ecx
        test ecx, ecx
        jnz lp

        sub edx, 4         ; argc
        mov eax, [edx]
        dec eax
        push eax
        call find_max
        pop edx

        mov ecx, edx
        shl ecx, 2
        add esp, ecx 

        ; in eax have address of large arg in stack
        push eax
        call print  ; print word
        add esp, 4

        xor ebx, ebx    ; exit
        mov eax, 1
        int 80h
