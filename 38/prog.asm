%include 'callproc.inc'
global _start
extern quit
extern check_numeric
extern validate
extern convert
extern print

section .bss
firadr  resd    1       ; 'remember' about location of arg
secadr  resd    1       ; 'remember' about location of arg
thradr  resd    1       ; 'remember' about location of arg
reslt   resb    34      ; max number have no more then 32 bits. + \n + 0

section .text
_start: pop esi
        add esp, 4      ; erase ./prog arg
        cmp esi, 4      ; 3 + 1
        je .count_ok
        callproc quit, 1
.count_ok:
        pop esi         ; have address of the first arg
        mov [firadr], esi
        pop esi
        mov [secadr], esi   
        pop esi
        mov [thradr], esi
        callproc check_numeric, [firadr]
        test eax, eax
        jz .first_ok
        callproc quit, 2
.first_ok:
        callproc check_numeric, [secadr]
        test eax, eax
        jz .second_ok
        callproc quit, 3
.second_ok:
        xor esi, esi
        mov eax, [firadr]               ; get the address
        xor ecx, ecx
        mov cl, [eax]                  ; get value from the address
        mov esi, ecx
        callproc validate, [thradr], esi
        test eax, eax
        jz .third_ok
        callproc quit, 4
.third_ok:
        xor edi, edi
        mov eax, [secadr]               ; get the address
        xor ecx, ecx
        mov cl, [eax]                  ; get value from the address
        mov edi, ecx
        callproc convert, esi, edi, [thradr], reslt
        test eax, eax
        jz .go_to_print
        callproc quit, 5
.go_to_print:
        callproc print, reslt
        test eax, eax       ; eax after syscall write have count after write
        jnz .happy_end
        callproc quit, 6
.happy_end:
        callproc quit, 0
