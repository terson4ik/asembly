;; 40/put_arr.asm ;;
global put_arr

section .text
put_arr:        ; arg1 array to write, arg2 count of params, arg3 first ptr
        push ebp
        mov ebp, esp
        push esi
        push edi
        mov edx, [ebp+8]        ; buffer
        mov ecx, [ebp+12]       ; argc
        mov esi, [ebp+16]       ; esp in fact
        ; first element write to arr
        ; inc addres and dec argc
.loop:  mov edi, [esi]          ; get address of start the string
.lp:    mov al, [edi]           ; get char to write
        test al, al             ; if 0
        jz .end_lp              ; then end
        mov [edx], al           ; edx is buffer, mov there value
        inc edx                 ; next char in buffer
        inc edi                 ; next char in stack
        jmp short .lp
.end_lp:
        mov byte [edx], ' '     ; write space for good formatting
        inc edx
        add esi, 4              ; mov to the next address
        dec ecx                 ; decrement general count of args
        test ecx, ecx           ; if 0 args
        jz .end_loop            ; then exit
        jmp .loop
.end_loop:
        dec edx
        mov [edx], 10            ; it`s over
        mov [edx+1], 0           ; it`s over
        ; exit
        pop edi
        pop esi
        mov esp, ebp
        pop ebp
        ret
