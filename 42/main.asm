global _start

section .data
f_name   db  'result.dat', 0
f_n_len  equ $-f_name

section .bss
total_str   resd    1
total_len   resd    1
max_len     resd    1
fd          resd    1
buffer      resb    4096
buf_size    equ     $-buffer

section .text
_start: mov eax, 5          ; open
        mov ebx, f_name     ; dest file
        mov ecx, 241h       ; O_WRONLY, O_CREAT, O_TRUNC
        mov edx, 0666o      ; permissions
        int 80h
        cmp eax, 0
        jnl .file_open_ok
        mov eax, 1
        mov ebx, 1
        int 80h
.file_open_ok:
        mov [fd], eax
        mov [total_str], 0
        mov [total_len], 0
        mov [max_len], 0
        xor esi, esi        ; save current value from str
        xor edi, edi        ; save MAX length
.loop:  mov eax, 3          ; read
        mov ebx, 0          ; stdin
        mov ecx, buffer   
        mov edx, buf_size  
        int 80h
        cmp eax, 0
        jle .EOF
        mov ecx, eax
        xor eax, eax
.lp:    mov dl, [eax+buffer]
        cmp dl, 10
        jne .no_nl
        inc dword [total_str]
        add [total_len], esi
        cmp esi, edi
        jb .below 
        xchg edi, esi
.below: xor esi, esi
        jmp short .next_el
.no_nl: inc esi
.next_el:
        inc eax
        cmp eax, ecx
        je .loop
        jmp .lp
.EOF:   mov [max_len], edi
        mov eax, 4
        mov ebx, [fd]
        mov ecx, total_str
        mov edx, 4          ; dword
        int 80h

        mov eax, 4
        mov ebx, [fd]
        mov ecx, total_len
        mov edx, 4          ; dword
        int 80h

        mov eax, 4
        mov ebx, [fd]
        mov ecx, max_len
        mov edx, 4          ; dword
        int 80h
        
        mov eax, 6          ; close
        mov ebx, [fd]       ; file descriptor
        int 80h

        mov eax, 1
        xor ebx, ebx
        int 80h
