%include 'stud_io.inc'
global _start

section .text

;
; eax is pointer of start string
; eax is also use to return value of function
; cl is length of string
; cl is also use to notice of errors
;
strtoint:
            ; build with convention CDECL
            ; eax and cl don`t are included in this convention
            ; in this case we don`t use the recursion
        push ebp
        mov ebp, esp
        sub esp, 8  ; two local variables, first use to store address of string in eax
                    ;    second var. use for result 
        push ebx    ; use in multiply eax
        mov [ebp-4], eax    ; entry address
        xor eax, eax
        mov [ebp-8], eax
        mov ebx, 10
.read:  
        test cl, cl
        jz .quit     ; if cl is equal zero is finish
        mov eax, [ebp-8]    ; load res to eax
        mul ebx             ; res * 10
        mov [ebp-8], eax    ; load temp in eax to res
        xor eax, eax
        mov edx, [ebp-4]     ; read symbol in parameter
        mov al, [edx]
        inc dword [ebp-4]   ; next symbol
        dec cl              ; counter - 1
        cmp al, '0'     
        jb .error
        cmp al, '9'
        ja .error
        sub eax, '0'
        add [ebp-8], eax
        jmp .read
.error: or cl, 1
.quit:
        pop ebx
        mov eax, [ebp-8]
        mov esp, ebp
        pop ebp
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; eax is integer
; ecx is pointer of array of symbols
;
inttostr:
        push ebp
        mov ebp, esp
        push ebx        ; use for divided
        mov ebx, 10
        push dword 0   ; limiter of array
        jmp .do
.formating:
        test eax, eax
        jz .zeroineax
        ;123 / 10 = 12. 3
        ;12 / 10 = 1. 2
        ;1 / 10 = 0. 1
.do:    xor edx, edx
        div ebx
        add edx, '0'
        push edx
        jmp .formating
.zeroineax:
        xor eax, eax
.repeat:
        pop edx
        mov [ecx+eax], dl
        inc eax
        test dl, dl
        jnz .repeat
.quit:  
        pop ebx
        pop ebp
        dec eax     ; eax know about zero byte then delete it
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; this sub module use only COUNTER
; ecx is pointer on start string
; eax is count of symbols
;
printing_arr_with_length:
        push ebp
        mov ebp, esp
        push ecx
        push eax
        mov edx, eax
.outputing:
        test edx, edx
        jz .quit
        mov al, [ecx]
        PUTCHAR al
        inc ecx
        dec edx
        jmp .outputing
.quit:
        PUTCHAR 10
        pop eax
        pop ecx
        pop ebp
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; esi is pointer of array
; edx is size of array
; eax is diagnostic return value 
; ecx is size of sequence of symbols return value 
;
readnumbers:
        xor ecx, ecx
.reading:
        GETCHAR
        cmp ecx, edx
        ja .overflow 
        test eax, eax 
        js .quit        ; EOF = -1
        cmp al, '0'
        jb .quit
        cmp al, '9'
        ja .quit
        mov [esi + ecx], al
        inc ecx
        jmp .reading
.overflow:
        xor eax, eax    ; if eax is equal zero then overflow of size exist
        jmp .skip
.quit:  
        cmp ecx, edx
        je .skip
        mov byte [esi+ecx], 0  ; zero byte. not necessary 
.skip:
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

error:
        PRINT 'ERROR. GANBA!'
        jmp quit
;
; MAIN PROGRAM
;

_start: xor ecx, ecx
loop:
        mov edx, 11
        xor edi, edi
        inc edi
        xor ebp, ebp
        mov esi, firsnum
        call readnumbers
        push ecx
        test eax, eax
        js quit
        jz error
        cmp eax, ' '
        jne error
        mov esi, secnum
        call readnumbers
        cmp eax, 10
        jne error
        test eax, eax
        jz error
        jns continue
        inc ebp
continue:
        mov eax, secnum
        ; ecx ready to execute
        call strtoint
        mov ebx, eax
        pop ecx
        mov eax, firsnum
        call strtoint
        mov ecx, resstr
        ; ebx = b, eax = a
        push eax    ; next actions will broke eax
        PRINT "a + b = "
        add eax, ebx
formating:
        call inttostr
        call printing_arr_with_length
        mov eax, [esp]
        test edi, edi
        jz multip
        js divided
        cmp edi, 10
        je final
        PRINT "a - b = "
        sub eax, ebx
        xor edi, edi
        jmp formating
multip: 
        PRINT "a * b = "
        mul ebx
        not edi
        jmp formating
divided:
        PRINT "a / b = "
        xor edx, edx
        test ebx, ebx
        jz error
        div ebx
        mov edi, 10
        add esp, 4
        jmp formating
final:  test ebp, ebp
        jz loop
quit:   FINISH

section .bss
firsnum resb 11
secnum  resb 11
resstr  resb 11
