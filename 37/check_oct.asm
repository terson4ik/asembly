;; 37/check_oct.asm ;;
global check_oct
section .text
; [ebp+8] is address of start the string
; if number out of ranger "7" -> eax = -1
check_oct:
        push ebp
        mov ebp, esp
        mov edx, [ebp+8]
        xor eax, eax
.again: cmp byte [edx], 0
        je .end
        cmp byte [edx], '7'
        ja .abort
        cmp byte [edx], '0'
        jb .abort
        inc edx
        jmp short .again
.end:   cmp edx, [ebp+8]
        jne .good
.abort: mov eax, -1
.good:  mov esp, ebp
        pop ebp
        ret
