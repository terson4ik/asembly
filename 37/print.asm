;; 37/print ;;
%include 'kernel.inc'
%include 'callproc.inc'
global print

section .data
nl      db      10
section .text
; arg1 is address of array
count:  xor eax, eax
        mov edx, [esp+4]
.lp:    cmp byte [eax+edx], 0
        jz .finish
        inc eax
        jmp short .lp
.finish:
        ret

print:  push ebx
        mov ebx, [esp+8]
        callproc count, ebx
        kernel 4, 1, ebx, eax
        kernel 4, 1, nl, 1
        pop ebx
        ret
