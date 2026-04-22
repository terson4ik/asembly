global _start
extern read_STD
section .data
msg     db      'OK', 10
msg_len equ     $-msg

section .text
_start: 
.loop:  push dword 0            ; stdin
        ; this function return number in eax
        call read_STD
        add esp, 4
        test ecx, ecx
        jz .argument_val_ok
        cmp ecx, -1
        jne .EOF_arrived
        mov eax, 1
        mov ebx, 2
        int 80h
.EOF_arrived:
        jmp quit
.argument_val_ok:
        xor edx, edx
        mov ecx, 3
        div ecx
        test edx, edx
        jnz .loop
        mov eax, 4
        mov ebx, 1
        mov ecx, msg
        mov edx, msg_len
        int 80h
        jmp .loop
quit:   mov eax, 1
        mov ebx, 0
        int 80h
