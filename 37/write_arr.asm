;; 37/write_arr ;;
%include 'stack_frame.inc'
global write_arr

section .text
; except number in dec(arg1) and address of arr(arg2)
; of course, we trust that you reserve 11 byte before call this procedure
write_arr:
        push ebp
        mov ebp, esp
        mov eax, [arg1]
        mov ecx, [arg2]
        push ebx
        mov ebx, 8          ; use for dividing 
        ; 1234
        ; 1234/10=123, _4_
        ; 123/10=12, _3_
        ; 12/10=1, _2_
        ; 1/10=0, _1_
        ; we need to stack
.again: xor edx, edx
        div ebx
        add edx, '0'
        push edx
        test eax, eax
        jz .null
        jmp short .again
.null:  lea edx, [ebp-4]    ; EBX was be reserved
.lp:    pop eax
        mov [ecx], al
        inc ecx
        cmp esp, edx
        je .stop
        jmp short .lp
.stop:  mov byte [ecx], 0
        pop ebx
        pop ebp
        ret
