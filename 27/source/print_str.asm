;; print_str.asm ;;
%include 'kernel.inc'
%include 'callproc.inc'
global print_str
extern count_size

section .text
print_str:
; arg1 == file descriptor
; arg2 == address of start the string
        prologue 
        callproc count_size, [arg2]
        kernel 4, [arg1], [arg2], eax
        epilogue
