global read_STD

section .bss
buff_size   equ     4096
buffer      resb    buff_size

section .text
read_STD:
; read std, write regular number into eax
; need file descriptor
        push ebp                ; standard prologue 
        mov ebp, esp    
        push esi                ; use for accumulate result
        xor esi, esi        
        ; next reading
.loop:  mov eax, 3              ; read
        mov ebx, [ebp+8]        ; FD
        mov ecx, buffer
        mov edx, buff_size
        int 80h
        cmp eax, 0
        jle .EOF
        xchg ecx, eax
        xor eax, eax
        xor edx, edx
.lp:    mov dl, [eax+buffer]
        cmp dl, 10              ; user enter the Enter
        je .good
        cmp dl, '0'
        jb .error
        cmp dl, '9'
        ja .error
        sub dl, '0'
        add esi, edx
        inc eax
        cmp eax, ecx
        je .loop
        jmp .lp
.good:  xor ecx, ecx
        jmp short .end
.error: mov ecx, -1
        jmp short .end
.EOF:   mov ecx, 1
.end:   xchg eax, esi
        pop esi
        mov esp, ebp
        pop ebp
        ret
