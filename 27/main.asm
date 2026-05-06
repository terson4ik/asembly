;; MAIN MODULE ;;
; %define SCIENTIFIC 
;%include 'kernel.inc'
%include 'callproc.inc'
global _start
extern quit
extern read
extern print_str
extern num_to_str
extern str_to_num
extern poliz

section .bss
%ifdef SCIENTIFIC
buff_size   equ     9000001
%else
buff_size   equ     4097
%endif
buffer      resb    buff_size

section .text
_start: xor esi, esi
.reading:
        callproc read, 0, buffer, buff_size-1
        mov byte [buffer+eax], 0
        cmp eax, 1
        je .reading
        cmp eax, 0
        jge .read_no_error
        push dword 1
        call quit
.read_no_error:
        test eax, eax
        jz .EOF_fatal
        cmp byte [buffer+eax-1], 10      ; pressed ENTER
        je .read_OK
        jne .EOF_exit
.EOF_fatal:
        push dword 0x0A
        callproc print_str, 1, esp
        jmp .exit
.EOF_exit:
        push dword 0x0A
        callproc print_str, 1, esp
        add esp, 4
        inc esi
.read_OK:
        callproc poliz, buffer
        test ecx, ecx
        jz .number_ok
        push dword 4
        call quit
.number_ok:
        callproc num_to_str, buffer, eax
        callproc print_str, 1, buffer
        test esi, esi
        jnz .exit
        jmp .reading
.exit   push dword 0
        call quit
