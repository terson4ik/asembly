;; 37/read_arr.asm ;;
global read_arr

section .text
; arg1 address of the string
; return eax = value from array
read_arr:
        push ebp
        mov ebp, esp
        mov edx, [ebp+8]
        xor eax, eax
.again: cmp byte [edx], 0
        je .end
        mov al, [edx]
        sub al, '0'
        push eax
        inc edx
        jmp short .again
.end:   xor eax, eax
        ; in RAM -->1234; in stack 4321<--
        ; 0*10+1=1
        ; 1*10+2=12
        ; 12*10+3=123
        ; 123*10+4=1234
        mov edx, ebp
.lp:    sub edx, 4
        shl eax, 3      ; *8
        add eax, [edx]
        cmp edx, esp
        jne .lp
        mov esp, ebp
        pop ebp
        ret         ; in eax value in dec but value in dec is equal in oct
