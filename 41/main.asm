global _start
extern str_to_num
extern copy_bytes

section .data
inv_count_msg   db      'Example of use ./prog <source> <destination> <N_BYTE>', 10, 0
inv_count_len   equ     $-inv_count_msg

broken_file_msg db      'File <source> not exist or broken, impossible to copy', 10, 0
broken_file_len equ     $-broken_file_msg

create_fail_msg db      'File <destination> impossible to creat. Check permissions, fool.', 10, 0
create_fail_len equ     $-create_fail_msg

inv_N_msg       db      'Incorrect <N_BYTE>, please enter number from your system(HEX, OCT, etc)', 10, 0 
inv_N_len       equ     $-inv_N_msg

section .bss
fd_src      resd    1
fd_dest     resd    1
targ_size   resd    1
buffer      resb    4096
buff_size   equ     $-buffer

section .text
_start: mov esi, esp                ; 0xffff1ff
        cmp dword [esi], 4          ; 3 + 1(prog)
        je .count_ok                ; check count of the parameters
        mov eax, 4
        mov ebx, 2
        mov ecx, inv_count_msg
        mov edx, inv_count_len
        int 80h
        mov eax, 1
        mov ebx, 1
        int 80h
.count_ok:
        mov eax, 5                  ; open
        mov ebx, [esi+8]            ; file (first argument, ./prog skip)
        mov ecx, 0                  ; O_RDONLY
        int 80h
        cmp eax, 0                  ; if error we will crash
        jnl .src_open_ok        
        mov eax, 4
        mov ebx, 2
        mov ecx, broken_file_msg
        mov edx, broken_file_len
        int 80h
        mov eax, 1
        mov ebx, 2
        int 80h
.src_open_ok:
        mov [fd_src], eax           ; cp new src file descriptor
        mov eax, 5                  ; open
        mov ebx, [esi+12]           ; file (detination)
        mov ecx, 241h               ; O_WRONLY, O_CREAT, O_TRUNC
        mov edx, 0666q              ; permissions
        int 80h
        cmp eax, 0                  ; if error the exit
        jnl .dest_open_ok
        mov eax, 4
        mov ebx, 2
        mov ecx, create_fail_msg
        mov edx, create_fail_len
        int 80h
        mov eax, 1
        mov ebx, 3
        int 80h
.dest_open_ok:
        mov [fd_dest], eax          ; save second file descriptor
        push dword [esi+16]         ; get argument, the number
        call str_to_num             ; ecx != 0 is error
        add esp, 4
        test ecx, ecx
        jz .size_buffer_ok
        mov eax, 4
        mov ebx, 2
        mov ecx, inv_N_msg
        mov edx, inv_N_len
        int 80h
        mov eax, 1
        mov ebx, 4
        int 80h
.size_buffer_ok:
        mov [targ_size], eax
; fd_src
; fd_dest
; addr of buffer
; size of buffer
; size of need to write
        push dword [targ_size]
        push dword buff_size
        push dword buffer
        push dword [fd_dest]
        push dword [fd_src]
        call copy_bytes
        add esp, 20

        mov eax, 6
        mov ebx, [fd_src]
        int 80h
        mov eax, 6
        mov ebx, [fd_dest]
        int 80h

        mov eax, 1
        mov ebx, 0
        int 80h
