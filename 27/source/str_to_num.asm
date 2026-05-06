;; str_to_num.asm ;;
%include 'callproc.inc'
global str_to_num
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; use DEC_SYST by default
; uncomment below defines to use another system
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;%define HEX_SYSTEM
;%define OCT_SYSTEM
;%define BIN_SYSTEM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text
str_to_num:
; ATTENTION!!!
; ARRAY SIZE MUST BE 34 FOR PRETTY WORK IN BIN_SYSTEM 

; arg1 == address of the string
; result write in EAX

; IF ERROR THEN ECX != 0 ;
        prologue
        mov ecx, [arg1]
        xor eax, eax
        push esi
        push ebx
        xor ebx, ebx
%ifdef HEX_SYSTEM
        mov esi, 16
%elifdef OCT_SYSTEM
        mov esi, 8
%elifdef BIN_SYSTEM
        mov esi, 2
%else
        mov esi, 10
%endif
.loop:  ; in array-->123\NULL;
        ; 0*10+1=1
        ; 1*10+2=12
        ; 12*10+3=123
        mov bl, [ecx]           ; ONE BYTE
        test bl, bl
        jz .good
        cmp bl, 10
        jz .good
        cmp bl, '0'
        jb .error
%ifdef HEX_SYSTEM
        cmp bl, '9'
        ja .next_check
        jmp short .ok
.next_check:
        cmp bl, 'A'
        jb .error
        cmp bl, 'F'
        ja .error
.ok:
%elifdef OCT_SYSTEM
        cmp bl, '7'
        ja .error
%elifdef BIN_SYSTEM
        cmp bl, '1'
        ja .error
%else
        cmp bl, '9'
        ja .error
%endif
%ifdef HEX_SYSTEM
        cmp bl, '9'
        ja .bigger
        sub bl, '0'
        jmp short .hex_done
.bigger:
        sub bl, '7'         ; 'A'=65, '7'=55, 55-65=10
.hex_done: 
%else
        sub bl, '0'
%endif
        mul esi
        add eax, ebx
        inc ecx
        jmp .loop
.error: mov ecx, 1
        jmp short .end
.good:  xor ecx, ecx
.end:   pop ebx
        pop esi
        epilogue
