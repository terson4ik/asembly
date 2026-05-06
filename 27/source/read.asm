;; read.asm ;;
%include 'kernel.inc'
%include 'callproc.inc'
global read

section .text
; arg1 == file descriptor
; arg2 == string, that is buffer
; arg3 == size of string, that is buffer
read:   prologue
        kernel 3, [arg1], [arg2], [arg3]
        epilogue
