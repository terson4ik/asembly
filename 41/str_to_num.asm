global str_to_num
;%define OCT_SYSTEM
;%define HEX_SYSTEM
;%define BIN_SYSTEM
;%define DEC_SYSTEM     ; use by default
section .text
str_to_num:             ; arg1 the string of the number
        push ebp
        mov ebp, esp
        ; ->1234 
        ; 0*10+1=1
        ; 1*10+2=12......
        push ebx
        xor eax, eax
        mov ecx, [ebp+8]
        cmp byte [ecx], 0
        je .good
    %ifdef HEX_SYSTEM
        mov ebx, 10h
    %elifdef OCT_SYSTEM
        mov ebx, 10o
    %elifdef BIN_SYSTEM
        mov ebx, 10b
    %else
        mov ebx, 10
    %endif
.lp:    mul ebx
        xor edx, edx
        mov dl, [ecx]
        cmp edx, '0'
        jb .error
    %ifdef HEX_SYSTEM
        cmp edx, '9'
        ja .sec_check
        jmp .range_ok
.sec_check:
        cmp edx, 'A'
        jb .error
        cmp edx, 'F'
        ja .error
.range_ok:
    %elifdef OCT_SYSTEM
        cmp edx, '7'
        ja .error
    %elifdef BIN_SYSTEM
        cmp edx, '1'
        ja .error
    %else   ; DEC_SYSTEM
        cmp edx, '9'
        ja .error
    %endif

    %ifndef HEX_SYSTEM
        sub edx, '0'       
    %else
        cmp edx, '9'
        ja .bigger
        sub edx, '0'       
        jmp short .act
.bigger:sub edx, '7'        ; '7'=55, 'A'=65
.act:
    %endif 
        add eax, edx
        inc ecx
        cmp byte [ecx], 0
        je .good
        jmp short .lp
.error: mov ecx, -1
        jmp short .end
.good:  xor ecx, ecx
.end:   pop ebx
        mov esp, ebp
        pop ebp
        ret
