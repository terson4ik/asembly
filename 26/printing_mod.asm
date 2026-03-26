%include 'stud_io.inc'
global printing_arr
section .text
;
; ATTENTION: this procedure don`t use counter
; only zero byte (C-like style)
; first parameter is pointer on start of string
; don`t return value.
printing_arr:
        push ebp
        mov ebp, esp
        mov edx, [ebp+8]
.loop:
        mov al, [edx]
        test al, al
        jz .quit
        PUTCHAR al
        inc edx
        jmp .loop
.quit:
        pop ebp
        ret
