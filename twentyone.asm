%include 'stud_io.inc'
global _start

section .bss
buf     resb 10

section .text
error:  PRINT 'Error'
        PUTCHAR 10
        and [buf + 9], byte 0
        jmp _start
chksig: inc ch
        test cl, cl
        jz error
        test ch, 1b
        jz error
        jmp read
setadd: mov [buf], byte 1
        jmp chksig
setmin: mov [buf], byte 2
        jmp chksig
setmul: mov [buf], byte 3
        jmp chksig
setdiv: mov [buf], byte 4
        jmp chksig
chkstr: mov al, [buf + 9]
        test al, al
        jz error
        xor eax, eax
        mov [buf + 1], eax
        mov eax, esi
        mov ecx, 10
        mov bh, [buf]
        cmp bh, 1
        je adding
        cmp bh, 2
        je subtrk
        cmp bh, 3
        je multi
        test edi, edi
        jnz divis
        PRINT 'b=0 :('
        PUTCHAR 10
        jmp error
_start: mov ebp, 10     ;use in mul and div
init:   xor esi, esi    ;use for acumulator 'a'
        xor edi, edi    ;use for acumulator 'b'
        xor ecx, ecx    ;use for boolean type and of course counter
read:   GETCHAR
        test eax, eax
        js endprog
        cmp eax, 10
        je chkstr
        cmp eax, '+'    ;in buf = 1
        je setadd
        cmp eax, '-'    ;in buf = 2
        je setmin
        cmp eax, '*'    ;in buf = 3
        je setmul
        cmp eax, '/'    ;in buf = 4
        je setdiv
        cmp eax, '0'
        jb error
        cmp eax, '9'
        ja error
        sub eax, '0'
        mov [buf + 1], eax
        test ch, 1b
        jnz second
        inc cl
        mov eax, esi
        mul ebp
        add eax, [buf + 1]
        mov esi, eax
        jmp read
second: mov eax, edi
        mul ebp
        add eax, [buf + 1]
        mov edi, eax
        or [buf + 9], byte 1
        jmp read
adding: add eax, edi
        jmp proces
subtrk: sub eax, edi
        jmp proces
multi:  mul edi
        jmp proces
divis:  xor edx, edx
        div edi
proces: xor edx, edx
        div ebp
        mov [buf + ecx - 1], dl
        dec ecx
        test eax, eax
        jz output
        jmp proces
output: inc ecx
        cmp ecx, 10
        ja format
        mov al, [buf + ecx - 1]
        add al, '0'
        PUTCHAR al
        and [buf + ecx - 1], byte 0
        jmp output
format: PUTCHAR 10
        jmp _start
endprog:PUTCHAR 10
        FINISH
