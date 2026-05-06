%include 'callproc.inc'
;%define SCIENTIFIC
global poliz
extern str_to_num
extern num_to_str

%macro new_oper 0 
        anchor
        push eax
        xor eax, eax
        mov al, [edi]               ; old operator
        dec edi
        push ecx
        callproc calc, poliz_stack, esi, eax
        pop ecx
        sub esi, 4
        pop eax                     ; return value
%endmacro

%macro anchor 0 
        cmp ecx, number
        je %%exit
        mov byte [ecx], 0
        push eax
        callproc str_to_num, number
        test ecx, ecx
        jnz error
        mov [esi], eax
        add esi, 4
        pop eax
        mov ecx, number
%%exit:
%endmacro

%macro after_cal 0
        
%endmacro

section .bss
%ifdef SCIENTIFIC
stack_size  equ     1000000
%else
stack_size  equ     1024
%endif
poliz_stack resb    stack_size
oper_stack  resb    stack_size
number      resb    33

section .text
calc:
; arg1 start of stack
; arg2 top of stack
; arg3 operator
        prologue
        mov edx, [arg2]
        sub edx, 4          ; by arch, need to sub, go to macro anchor
        cmp edx, [arg1]
        jbe near error
        mov eax, [edx-4]
        xchg ecx, [edx]
        mov edx, [arg3]
        cmp edx, '+'
        je .adding
        cmp edx, '-'
        je .substitute
        cmp edx, '*'
        je .multiply
        cmp edx, '/'
        je .divided
        jmp error
.adding:
        add eax, ecx
        jmp short .after
.substitute:
        sub eax, ecx
        jmp short .after
.multiply:
        xor edx, edx
        mul ecx
        jmp short .after
.divided:
        xor edx, edx
        div ecx
.after:
        mov edx, [arg2]
        sub edx, 8
        mov [edx], eax
        epilogue
; arg1 is string of the ASCII data
; return eax -- final number
poliz:  prologue
        push esi
        push edi
        push ebx
        mov esi, poliz_stack    ; top for poliz
        mov edi, oper_stack     ; top for oper
        mov ebx, [arg1]         ; pointer of the arg1 string
        mov byte [edi], '('     ; '(" as anchor
        mov ecx, number         ; save intermediate value
        xor eax, eax            ; clear
        dec ebx
loop:   inc ebx
        mov al, [ebx]           ; get another symbol
        test al, al             ; EOS -- exit
        jz exit
        cmp al, 10
        je exit
        cmp al, ' '             ; spice -- skip
        je loop
        cmp al, ')'
        je pop_close_bracket
        cmp al, '('
        je pop_open_bracket
        cmp al, '+'
        je pop_common
        cmp al, '-'
        je pop_common
        cmp al, '*'
        je pop_uniq
        cmp al, '/'
        je pop_uniq
        ; if it`s NO operator, then it`s number
        mov [ecx], al
        inc ecx
        jmp loop
pop_close_bracket:
        anchor
.lp:    xor eax, eax
        mov al, [edi]           ; get last operator
        dec edi                 ; shift stack top
        cmp al, '('             ; stop
        je .quit
        cmp edi, oper_stack     ; anti overflow stack?
        jb error
        push eax
        push ecx
        callproc calc, poliz_stack, esi, eax
        sub esi, 4
        pop ecx
        pop eax
        jmp .lp
.quit:  jmp loop
pop_open_bracket:
        anchor
        inc edi
        mov byte [edi], '('
        jmp loop
default_add:
        anchor
        inc edi
        mov [edi], al
        jmp loop
pop_common:
        cmp byte [edi], '('         ; ++ +-?
        je default_add
        new_oper
        jmp pop_common
pop_uniq:
        cmp byte [edi], '('         ; (?
        je default_add
        cmp byte [edi], '+'         ; ++ +-?
        je default_add
        cmp byte [edi], '-'         ; ++ +-?
        je default_add
        new_oper
        jmp pop_uniq
exit:   ; go to empty edi
        anchor
.lp:    xor eax, eax
        cmp edi, oper_stack
        je good
        mov al, [edi]
        cmp al, '('
        je error
        push eax
        push ecx
        callproc calc, poliz_stack, esi, eax
        sub esi, 4
        pop ecx
        pop eax
        dec edi
        jmp short .lp
error:  mov ecx, 1
        jmp short quit
good:   xor ecx, ecx
        mov eax, [esi-4]
quit:   pop ebx
        pop edi
        pop esi
        epilogue
