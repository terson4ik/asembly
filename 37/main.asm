%include 'kernel.inc'
%include 'callproc.inc'
global _start
extern check_oct
extern sum
extern multiply
extern print

size    equ     12      ; 11 in oct + 1 zero terminator

section .bss
buff    resb    size
first   resd    1
second  resd    1

section .data
msg_sum     db      'a + b = '
sum_len     equ     $-msg_sum
msg_mult    db      'a * b = '
mult_len    equ     $-msg_mult

section .text
_start: mov ecx, esp
        cmp dword [ecx], 3
        je .count_ok
        quit 1
.count_ok:
        add ecx, 8
        mov eax, [ecx]
        mov [first], eax
        callproc check_oct, eax
        test eax, eax
        jns .first_par_ok
        quit 2
.first_par_ok:
        add ecx, 4
        mov eax, [ecx]
        mov [second], eax
        callproc check_oct, eax
        test eax, eax
        jns .second_par_ok
        quit 3
.second_par_ok:
        kernel 4, 1, msg_sum, sum_len
        mov eax, [first]
        mov ecx, [second]
        callproc sum, eax, ecx, buff
        callproc print, buff
        kernel 4, 1, msg_mult, mult_len
        mov eax, [first]
        mov ecx, [second]
        callproc multiply, eax, ecx, buff
        callproc print, buff
        quit 0
