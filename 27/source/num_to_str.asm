;; num_to_str.asm ;;
%include 'callproc.inc'
global num_to_str
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; use DEC_SYST by default
; uncomment below defines to use another system
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;%define HEX_SYSTEM
;%define OCT_SYSTEM
;%define BIN_SYSTEM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text
num_to_str:
; ATTENTION!!!!!!!!!
; ARRAY SIZE MUST BE 33 FOR PRETTY WORK
; arg1 == address of the string
; arg2 == number need to convert
        prologue
        mov ecx, [arg1]
        mov eax, [arg2]
        push esi
        push dword 10
%ifdef HEX_SYSTEM
        mov esi, 16
%elifdef OCT_SYSTEM
        mov esi, 8
%elifdef BIN_SYSTEM
        mov esi, 2
%else
        mov esi, 10
%endif
.loop:  ; in eax-->123<--
        ; 123/10=12.3
        ; 12/10=1.2
        ; 1/10=0.1
        ;       ^
        ;      123; need stack  
        xor edx, edx
        div esi
%ifdef HEX_SYSTEM
        cmp edx, 9
        ja .bigger
        add edx, '0'
        jmp short .hex_done
.bigger:add edx, '7'         ; 'A'=65, '7'=55, 55-65=10
.hex_done:
%else
        add edx, '0'
%endif
        push dword edx
        test eax, eax
        jz .over
        jmp .loop
.over:  pop eax
        mov [ecx], al       ; ONE BYTE
        test al, al
        jz .end
        inc ecx
        jmp .over
.end:   mov byte [ecx+1], 0
        pop esi
        epilogue
