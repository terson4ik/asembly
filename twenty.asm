%include 'stud_io.inc'
global _start

section .bss
buffer resb 10

section .text
error:  PRINT 'ERROR. incorrect symbols'
        jmp end
switch: test bl, bl
        jnz error
        test bh, bh
        jz error
        inc bl
        inc cl
        jmp read
check:  test bl, bl
        jz error
        test cl, cl
        jnz error
        jmp arith
_start: xor edi, edi    ;a
        xor esi, esi    ;b
        xor ecx, ecx    ;counter and check
        xor ebx, ebx    ;pseudo boolean
        mov ebp, 10     ;use in div and mul
read:   GETCHAR
        cmp eax, ' '
        jz switch
        cmp eax, 10
        jz check
        cmp eax, '0'
        jb error
        cmp eax, '9'
        ja error
        sub eax, '0'
        test bl, 11b
        jnz second
        mov [buffer], eax
        mov eax, edi
        mul ebp
        mov edi, eax
        add edi, [buffer]
        inc bh
        jmp read
second: mov [buffer], eax
        mov eax, esi
        mul ebp
        mov esi, eax
        add esi, [buffer]
        xor cl, cl
        jmp read
arith:  xor ebx, ebx    ;use for pseudo progress
        mov eax, edi
        add eax, esi
        PRINT 'a + b = '
initcnv:mov ecx, 10
convert:cdq
        div ebp
        mov [buffer + ecx - 1], dl 
        dec ecx
        test eax, eax
        jnz convert
        inc ecx
output: cmp ecx, 10
        ja choice
        mov al, [buffer + ecx - 1]
        add al, '0'
        PUTCHAR al
        inc ecx
        jmp output
choice: test ebx, ebx
        jz subs
        test bh, bh
        jnz end
        inc bh
        PUTCHAR 10
        mov eax, edi
        mul esi
        PRINT 'a * b = '
        jmp initcnv
subs:   inc ebx
        PUTCHAR 10
        mov eax, edi
        sub eax, esi
        PRINT 'a - b = '
        jmp initcnv
end:    PUTCHAR 10
        FINISH
