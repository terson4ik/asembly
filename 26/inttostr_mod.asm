%include 'stud_io.inc'
global inttostr

section .text
;
; first parameter is integer
; second parameter is pointer of array with symbols
; eax return length of string. don`t necessary :)
; 
inttostr:
        push ebp
        mov ebp, esp
        push ebx        ; use for divided
        mov ebx, 10
        mov eax, [ebp+8]
        xor ecx, ecx
        push dword 0
        jmp .do
.start:
        test eax, eax
        jz .filing
        ;12 /10 =1.2
        ;1/10=0.1
        ;21=12
.do:    xor edx, edx
        div ebx
        add edx, '0'
        push edx
        jmp .start
.filing:
        mov eax, [ebp+12]
.loop:  pop edx
        mov [eax], dl
        test edx, edx
        jz .quit
        inc eax
        jmp .loop
.quit:
        pop ebx
        pop ebp
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
