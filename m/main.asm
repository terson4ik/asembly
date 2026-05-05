global _start

section .data

section .text
;
; [ebp+8] pointer to string
; [ebp+12] pointer to string
; returns eax==0 for false, eax== 1 for true
match:
        push ebp
        mov ebp, esp
        sub esp, 4              ; variable I(index)
        push esi
        push edi
        mov esi, [ebp+8]        ; source
        mov edi, [ebp+12]       ; pattern
        cmp byte [edi], 0       ; pattern end?
        jne .continue           ; if no then continue
        cmp byte [esi], 0       ; if over, check over of source
        je .true                ; successfully 
        jmp .false              ; fail
.continue:
        cmp byte [edi], '*'     ; it`s *?
        jne .not_star 
        mov dword [ebp-4], 0    ; I = 0
        inc edi                 ; *->next
.star_loop:
        mov eax, esi            ; get source
        add eax, [ebp-4]
        push edi                ; pattern
        push eax                ; prepared source
        call match
        add esp, 8
        test eax, eax           ; fail?
        jnz .quit               ; if no, then true
        mov eax, esi            ; now we need to check
        add eax, [ebp-4]        ; example is over?
        mov cl, [eax]
        test cl, cl
        jz .false
        inc [ebp-4]             ; I+1
        jmp .star_loop
.not_star:
        cmp byte [edi], '?'     ; if ? then skip one character
        jne .default            ; if no go to check
        mov cl, [esi]
        test cl, cl
        jz .false
        jmp short .next
.default:
        mov al, [esi]           ; get char
        cmp byte [edi], al      ; check
        jne .false
.next:  inc edi                 ; next char in pattern
        inc esi
        push edi
        push esi
        call match              ; after this, eax contain final value
        add esp, 8
        jmp .quit
.false: xor eax, eax
        jmp short .quit
.true:  mov eax, 1
.quit:  pop edi
        pop esi
        mov esp, ebp
        pop ebp
        ret

_start: pop esi
        cmp esi, 3      ; prog string pattern
        je .param_count_good
        mov eax, 1
        mov ebx, 1
        int 80h
.param_count_good:
        pop esi         ; remove prog
        pop esi         ; string
        pop edi         ; pattern
        push edi
        push esi
        call match
        add esp, 8
        test eax, eax
        jnz true
        mov eax, 1
        mov ebx, 228
        int 80h
true:   
        mov eax, 1
        xor ebx, ebx
        int 80h
