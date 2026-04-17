;; 38/validate.asm ;;
%include 'callproc.inc'
global validate

section .text
decimal:prologue
        mov eax, [arg2]
        mov edx, [arg1]
        xor ecx, ecx
.lp:    cmp byte [ecx+edx], 0
        je .end
        cmp byte [ecx+edx], '0'
        jb .abort
        cmp byte [ecx+edx], al
        ja .abort
        inc ecx
        jmp short .lp
.end:   test ecx, ecx
        jz .abort
        xor eax, eax
        jmp short .quit
.abort: mov eax, -1
.quit:  epilogue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AtoZ:   prologue
        mov eax, [arg2]
        mov edx, [arg1]
        xor ecx, ecx
.lp:    cmp byte [ecx+edx], 0
        je .end
        cmp byte [ecx+edx], 'A'
        jb .check_range
        cmp byte [ecx+edx], al
        ja .abort
        inc ecx
        jmp short .lp
.check_range:
        cmp byte [ecx+edx], '0'
        jb .abort
        cmp byte [ecx+edx], '9'
        ja .abort
        inc ecx
        jmp .lp
.end:   test ecx, ecx
        jz .abort
        xor eax, eax
        jmp short .quit
.abort: mov eax, -1
.quit:  epilogue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; arg1 address of the string
; arg2 limiter in range 1-Z
validate:
        prologue
        mov eax, [arg2]
        cmp al, 'A'
        jne .easy
        mov al, '9'
        jmp .skip
.easy:  dec al                         ; target can`t be above then numeric system
        cmp al, '9'
        ; 9 go to 8. 'B' go to "A"
        jb .skip
        callproc AtoZ, [arg1], eax
        jmp short .final
.skip:  callproc decimal, [arg1], eax
.final: ; after AtoZ or  decimal we get
        ; eax = 0 OK
        ; eax !=  FAIL
        epilogue 
