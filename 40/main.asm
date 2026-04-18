global _start
extern put_arr
extern print_N

section .bss
buffer      resb    4096
buf_size    equ     $-buffer
argc        resd    1
fd          resd    1
arg1vp      resd    1

section .text
_start: pop ecx             ; get argc
        ; esp ->[./prog]
        cmp ecx, 2          ; ./prog + file + words
        ja .args_ok
        mov eax, 1
        mov ebx, 1
        int 0x80
.args_ok:
        dec ecx             ; - ./prog 
        dec ecx             ; - file
        mov [argc], ecx     ; save argc-1
        ; esp ->[./prog]
        add esp, 4
        ; esp ->[file]
        mov [arg1vp], esp   ; save
        mov eax, 5          ; open
        mov esi, [arg1vp]
        mov ebx, [esi]      ; first dword it's name
        mov ecx, 241h
        mov edx, 0666o
        int 80h
        cmp eax, 0
        jnl .file_open_ok
        mov eax, 1
        mov ebx, 2
        int 80h
.file_open_ok:
        mov [fd], eax
        ; arg1 array to write, arg2 count of params, arg3 first ptr
        add esp, 4
        ; esp ->[word]
        mov [arg1vp], esp
        push dword [arg1vp]
        push dword [argc]
        push buffer
        call put_arr
        add esp, 12
; arg1 address of the buffer
; arg2 count of print
; arg3 file descriptor
        push dword [fd]
        push dword 10
        push buffer
        call print_N
        add esp, 12
        cmp eax, 0
        jnl .write_ok
        mov eax, 1
        mov ebx, 99
        int 80h
.write_ok:
        mov eax, 6              ; close       
        mov ebx, [fd]
        int 80h       
        mov ebx, 0
        mov eax, 1
        int 80h
