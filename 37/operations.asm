;; 37/operations.asm ;;
%include 'stack_frame.inc'
%include 'callproc.inc'
global sum
global multiply
extern read_arr
extern write_arr

%macro prepare 0
        push ebp
        mov  ebp, esp
        mov eax, [arg1]
        callproc read_arr, eax
        xchg ecx, eax
        mov eax, [arg2]
        callproc read_arr, eax
%endmacro

%macro ending 0
        mov ecx, [arg3]
        callproc write_arr, eax, ecx
        mov esp, ebp
        pop ebp
        ret       
%endmacro

section .text
; sum, arg1 first address, arg2 second address, arg3 address of buffer(res)
; arg1..arg3 from inc file
sum:    prepare
        add eax, ecx
        ending

;mult, arg1 first address, arg2 second address, arg3 address of buffer(res)
; arg1..arg3 from inc file
multiply:
        prepare
        mul ecx
        ending
