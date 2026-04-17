;; 38/convert.asm ;;
%include 'callproc.inc'

global convert

section .text
calculate:prologue
; arg1 base
; arg2 string to calc
        push ebx
        push esi
        xor eax, eax        ; return result
        xor ecx, ecx
        mov esi, [arg1]     ; use for multiply
        mov ecx, [arg2]
        xor ebx, ebx
.lp:    mov bl, [ecx]
        test bl, bl
        jz .over
        cmp bl, 'A'
        jb .defolt
        ; in ASCII table, 'A'=65. 65-10='7', 65-55=10. 'A'-'7'=10
        sub bl, '7'
        jmp short .act
.defolt:sub bl, '0'
        ; ->10011=19 in 2
        ; 0*2+1=1
        ; 1*2+0=2
        ; 2*2+0=4
        ; 4*2+1=9
        ; 9*2+1=19
.act:   mul esi
        add eax, ebx
        inc ecx
        jmp .lp
.over:  pop esi
        pop ebx
        epilogue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
transform:prologue
; arg1 number
; arg2 base
; arg3 result arr for writing
        push ebx            
        mov eax, [arg1]
        xor ebx, ebx
        mov ebx, [arg2]         ; use for multiply
        mov ecx, [arg3]         ; res arr
        ; 1234 in eax; base = 10
        ; 1234/10 = 123.4
        ; 123/10 = 12.3
        ; 12/10 = 1.2
        ; 1/10 = 0.1
        ;       ^
        ;       |
        ; need to stack obviously 
        ; of course, push edx to stack
        push dword 0            ; terminator zero
.lp:    xor edx, edx
        div ebx
        ; right now convert to ASCII
        cmp edx, 9
        ja .extended
        add edx, '0'
        jmp short .after_conv
.extended:  
        ; in ASCII table, 'A'=65. 65-10='7', 65-55=10. 'A'-'7'=10
        add edx, '7'
.after_conv:
        push edx
        test eax, eax
        jz .zero_moment
        jmp .lp
.zero_moment:
        pop eax
        mov [ecx], al
        inc ecx
        test eax, eax
        jz .full_arr_ok
        jmp short .zero_moment
.full_arr_ok:
        mov byte [ecx-1], 10
        mov byte [ecx], 0
        pop ebx
        epilogue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
convert:prologue
; int arg1 base for arg3
; int arg2 destination base
; pointer arg3 conversion number
; pointer arg4 array for result
        push esi
        push edi
        mov esi, [arg2]         ; will be in edx
        xor ecx, ecx
.normalization:
        cmp esi, '9'
        ja .ext
        sub esi, '0'
        jmp short .after_form
.ext:   ; in ASCII table, 'A'=65. 65-10='7', 65-55=10. 'A'-'7'=10
        sub esi, '7'
.after_form:
        test ecx, ecx
        jnz .ok
        inc ecx
        xchg edi, esi
        mov esi, [arg1]
        jmp .normalization
.ok:
        callproc calculate, esi, [arg3]
        ; eax have result in dec, now convert for arg2
        callproc transform, eax, edi, [arg4]
        ; eax contain last char
        epilogue
