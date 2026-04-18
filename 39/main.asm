;; PROGRAM ;;
;%define HEX_SYSTEM
;%define OCT_SYSTEM
;%define BIN_SYSTEM

global _start

section .bss
buffer      resb    4096
buff_size   equ     $-buffer
fd          resd    1
argvp       resd    1

section .text
print:                      ; num to print
        push ebp
        mov ebp, esp
        mov eax, [ebp+8]    ; number
    %ifdef HEX_SYSTEM
        mov ecx, 10h 
    %elifdef OCT_SYSTEM
        mov ecx, 10o
    %elifdef BIN_SYSTEM
        mov ecx, 10b
    %else                   ; by the default use DEC_SYSTEM
        mov ecx, 10
    %endif
        push dword 10       ; new line for array
        ; 1234
        ; 1234/10 = 123.4
.lp:    xor edx, edx        ; 0 for divided
        div ecx             
    %ifdef BIN_SYSTEM
        add edx, '0'
    %elifdef OCT_SYSTEM
        add edx, '0'
    %elifdef HEX_SYSTEM
        cmp edx, 9
        ja .extended
        add edx, '0'
        jmp .ok
.extended:
        add edx, '7'        ; 'A' in ASCII = 65, 65-10= '7'
.ok:    
    %else                   ; DEC_SYSTEM by default
        add edx, '0'
    %endif
        push edx            ; push remainder
        test eax, eax       ; if 0 -- end
        jz .zero_moment
        jmp short .lp
.zero_moment:
        mov ecx, esp        ; last symbol
        lea edx, [ebp-3]    ; new line
        sub edx, ecx        ; straightaway calculate the length
        mov eax, 4          ; write
        mov ebx, 1          ; stdout
        int 80h
        mov esp, ebp
        pop ebp
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
count_new_line:             ; arg1 = address, arg2 = size
        push ebp
        mov ebp, esp
        xor eax, eax        ; return result
        mov ecx, [ebp+8]    ; address
        mov edx, [ebp+12]   ; size, will be decremented
        dec edx
.lp:    cmp byte [edx+ecx], 10
        je .set_nl
        jmp short .skip
.set_nl:
        inc eax             ; +1 new line
.skip:  dec edx             ; -1 size to search 
        ;jnc .lp             ; if edx = 0xffffffff it`s over
        cmp edx, -1
        jne .lp             ; if edx = 0xffffffff it`s over
        mov esp, ebp
        pop ebp
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_start: pop ecx             ; how much?
        cmp ecx, 2          ; ./prog + file.txt
        je .count_files_ok  ; ^?
        mov eax, 1          ; if no -- error
        mov ebx, 1
        int 80h
.count_files_ok:
        add esp, 4          ; ./prog -
        mov eax, 5          ; open
        pop ebx             ; ebx count the address of the string
        mov ecx, 0          ; mode O_READ
        int 80h
        cmp eax, 0          ; if eax < 0 then error
        jnl .file_open_ok
        mov eax, 1
        mov ebx, 2
        int 80h
.file_open_ok:
        mov [fd], eax       ; save descriptor
        xor esi, esi        ; esi use for count /n
.lp:    mov eax, 3          ; read
        mov ebx, [fd]       ; from file descriptor
        mov ecx, buffer     ; write into buffer
        mov edx, buff_size  ; buffer size
        int 80h
        cmp eax, 0          ; 0 is EOF, also eax < 0 is error
        jle .EOF
        push eax            ; size of write data
        push dword buffer   ; address of the string portion of reading
        call count_new_line ; eax contain count of the new lines 
        add esp, 8
        add esi, eax        ; summary count +
        jmp .lp
.EOF:   
        mov eax, 6
        mov ebx, [fd]
        int 80h 
        push esi
        call print 
        add esp, 4
        mov eax, 1
        mov ebx, 0
        int 80h
