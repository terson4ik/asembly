%include 'stud_io.inc'
global strtoint

section .text
;
; first parameter is pointer to start string
; second parameter is length of string
; eax use to return integer (result)
; cl use to notice of errors
strtoint:
        push ebp
        mov ebp, esp
        push ebx    ; use for multiply
        mov ebx, 10
        xor ecx, ecx
        push esi
        mov esi, [ebp+8]
        push edi
        mov edi, [ebp+12]
        ; because act with memory it`s slow
        ; and it`s destroy original value
.loop:  
        ; in this case ecx use for temp storage for result 
        test edi, edi
        jz .quit
        mov eax, ecx
        mul ebx
        mov ecx, eax
        xor eax, eax
        mov al, [esi]
        cmp al, '0'
        jb .error
        cmp al, '9'
        ja .error
        sub al, '0'
        add ecx, eax
        inc esi
        dec edi
        jmp .loop
.error: 
        xor ecx, ecx
        inc ecx      ; 1 = error
        jmp .shit
.quit:
        mov eax, ecx
        xor ecx, ecx
.shit:  pop edi
        pop esi
        pop ebx
        pop ebp
        ret         ; because it`s convection CDECL
                    ; don`t use ret N
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
