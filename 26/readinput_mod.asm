%include 'stud_io.inc'
global readnumbers

section .text
;
; first parameter is pointer of array
; second parameter is size of array
; eax return value for diagnostic (last symbol which not character)
; ecx return size of sequence of symbols
readnumbers:
        push ebp
        mov ebp, esp
        mov edx, [ebp+8]
        xor ecx, ecx
.loop: 
        GETCHAR
        cmp eax, '0'
        jb .quit
        cmp eax, '9'
        ja .quit
        inc ecx
        cmp ecx, [ebp+12]
        ja .error
        mov [edx], al
        inc edx
        jmp .loop
.error:
        xor eax, eax    ; if eax = 0 it`s overflow
.quit:
        mov byte [edx], 0
        pop ebp
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
