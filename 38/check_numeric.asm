;; 38/check_numeric.asm ;;
%include 'callproc.inc'
global check_numeric

section .text
; [ebp + 8] is address of the string
; eax = 0 is good. else = error
check_numeric:
        prologue
        ; ok it is when size = 1 and '1-0' and 'A-Z'
        mov eax, [arg1]
        xor ecx, ecx
.lp:    cmp byte [ecx+eax], 0
        je .check
        cmp byte [ecx+eax], '2'
        jb .error
        cmp byte [ecx+eax], '9'
        ja .sec_step
        inc ecx
        jmp short .lp
.sec_step:
        cmp byte [ecx+eax], 'A'
        jb .error
        cmp byte [ecx+eax], 'Z'
        ja .error
        inc ecx
        jmp .lp
.check: cmp ecx, 1
        je .ok
.error: mov eax, -1
        jmp short .quit
.ok:    xor eax, eax
.quit:  epilogue
