%include 'stud_io.inc'
global _start
; notice:
; i use ebp how good tone
; in this tasks ebp don`t needed, because not use recurs
; but for experience i use it
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ATTENTION: this procedure use counter (pascal-like style)
; first parameter is pointer on start of string
; second parameter is count of string
; eax
; cl
printing_arr_with_length:
        push ebp
        mov ebp, esp
        mov edx, [ebp+8]
        mov ecx, [ebp+12]
.loop:
        test ecx, ecx
        jz .quit
        mov al, [edx]
        PUTCHAR al
        inc edx
        dec ecx
        jmp .loop
.quit:
        pop ebp
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

FATALerror:
        sub esp, 4
error:  PRINT 'ERROR!!!'
        PUTCHAR 10
        jmp loop
; MAIN PROGRAM
_start: xor ebp, ebp
loop:   
        xor edi, edi
        inc edi
        push dword 11
        push dword firnum
        call readnumbers
        add esp, 8
        test eax, eax
        js quit
        test ecx, ecx
        jz error
        cmp eax, ' '
        jne error
        push ecx    ; for remember about length
        push dword 11
        push secnum
        call readnumbers
        add esp, 8
        test ecx, ecx
        jz FATALerror
        test eax, eax
        jns notOver
        inc ebp
        mov eax, 10
        PUTCHAR 10
notOver:cmp eax, 10
        jne FATALerror
        push ecx 
        push secnum
        call strtoint
        add esp, 8
        test cl, cl
        jnz error
        mov ebx, eax
        pop ecx
        push ecx
        push firnum
        call strtoint
        add esp, 8
        test ecx, ecx
        jnz error
        PRINT 'a + b = '
        push eax
        add eax, ebx
formating:
        push dword resnum
        push eax
        call inttostr

        ; FIRST PARAMETER FOR NEXT STEP IN STACK. IN PAST STEP WE DON`T ERASE IT
        add esp, 4
        ; FIRST PARAMETER FOR NEXT STEP IN STACK. IN PAST STEP WE DON`T ERASE IT
        ; of course, it`s not necessary 

        call printing_arr
        add esp, 4
        PUTCHAR 10
        pop eax
        push eax
        test edi, edi
        jz multi
        js divided
        cmp edi, 555
        je exit
        PRINT 'a - b = '
        sub eax, ebx
        xor edi, edi
        jmp formating
multi:
        PRINT 'a * b = '
        xor edx, edx
        mul ebx
        not edi
        jmp formating
divided:
        PRINT 'a / b = '
        xor edx, edx
        test ebx, ebx
        jz error
        div ebx
        mov edi, 555
        jmp formating
exit:
        test ebp, ebp
        jz loop
quit:   PUTCHAR 10
        FINISH
        
section .bss
firnum resb 11
secnum resb 11
resnum resb 11
