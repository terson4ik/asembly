global _start

section .text
nlstr   db 10, 0

strlen:         ; arg1 address of the string
        push ebp
        mov ebp, esp
        xor eax, eax
        mov ecx, [ebp+8]
.lp:    cmp byte [eax+ecx], 0
        jz .quit
        inc eax
        jmp short .lp
.quit:  pop ebp
        ret

print_str:      ; arg1 address of the string
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, [ebp+8]
        push ebx
        call strlen
        add esp, 4
        mov edx, eax    ; length
        mov ecx, ebx    ; address of start
        mov eax, 4      ; write
        mov ebx, 1      ; stdout
        int 80h
        pop ebx
        mov esp, ebp
        pop ebp
        ret

_start: 
        mov ebx, [esp]  ; argc
        mov esi, esp
        add esi, 4
loop:   push dword [esi]
        call print_str
        add esp, 4
        push dword nlstr
        call print_str
        add esp, 4
        add esi, 4
        dec ebx
        jnz loop
        mov ebx, 0
        mov eax, 1
        int 80h
