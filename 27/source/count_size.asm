;; count_size.asm ;;
%include 'callproc.inc'
global count_size

section .text
count_size:
; arg1 == address of start the string
; eax == size of the string
        prologue 
        xor eax, eax        ;return size
        mov ecx, [ebp+8]
.loop:  cmp byte [eax+ecx], 0
        je .over
        inc eax
        jmp .loop
.over:  epilogue
