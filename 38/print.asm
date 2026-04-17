;; 38/print.asm ;;
%include 'kernel.inc'
%include 'callproc.inc'
global print

section .text
count:
; get address, return size of string
        prologue
        xor eax, eax
        mov edx, [arg1]
.lp:    cmp byte [eax+edx], 0
        je .end
        inc eax
        jmp short .lp
.end:   epilogue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print:
; arg1 address of the string
        prologue
        mov ecx, [arg1]
        callproc count, ecx
        kernel 4, 1, ecx, eax
        epilogue
