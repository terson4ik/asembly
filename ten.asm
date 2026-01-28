%include 'stud_io.inc'
global _start

section .text
_start: xor bl, bl  ;bl for '+'s
        xor cl, cl  ;cl for '-'s
getting:GETCHAR
        cmp al, 10
        je prepare
        cmp eax, -1
        je prepare
        cmp al, '+'
        jne skiptop
        inc bl
skiptop:cmp al, '-'
        jne getting
        inc cl
        jmp getting
prepare:mov al, bl
        mul cl
        xor ecx, ecx
        mov cx, ax
        cmp cx, 0
        je final
output: PUTCHAR '*'
        loop output
final:  PUTCHAR 10
        FINISH
