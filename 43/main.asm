global _start

section .data
msg     db      'OK', 10
msg_len equ     $-msg

section .text
convert:        ; arg1 is start of the string
        push ebp
        mov ebp, esp
        mov ecx, [ebp+8]
        xor eax, eax
        xor edx, edx
.loop:  mov byte dl, [ecx]
        test dl, dl
        jz .good
        cmp dl, '0'
        jb .error
        cmp dl, '9'
        ja .error
        sub dl, '0'
        add eax, edx
        inc ecx
        jmp short .loop
.good:  xor ecx, ecx
        jmp short .end
.error: mov ecx, -1
.end:   mov esp, ebp
        pop ebp
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_start: mov esi, [esp]
        dec esi
        test esi, esi
        jnz .arg_ok
        mov eax, 1
        mov ebx, 1
        int 80h
.arg_ok:push dword [esp+8]
        ; this function return number in eax
;call read_STD
        call convert
        add esp, 4
        test ecx, ecx
        jz .argument_val_ok
        mov eax, 1
        mov ebx, 2
        int 80h
.argument_val_ok:
        xor edx, edx
        mov ecx, 3
        div ecx
        test edx, edx
        jnz quit
        mov eax, 4
        mov ebx, 1
        mov ecx, msg
        mov edx, msg_len
        int 80h
quit:   mov eax, 1
        mov ebx, 0
        int 80h
