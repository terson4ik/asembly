%include 'stud_io.inc'
global _start

section .bss
buf     resb 1024

section .text
_start: xor al, al
        mov edi, buf
        mov ecx, 1024
        cld
rep:    stosb
        loop rep
        ---------------------------
        xor al, al
        mov edi, buf
        mov ecx, 1024
        rep stosb
        =====

section .bss
array   resd 256

        -------
        ;sum of the array
        xor ebx, ebx
        mov esi, array
        cld
rep:    lodsd
        add ebx, eax
        loop rep
        --
        mov esi, array
        mov edi, array
        cld
lp:     lodsd
        inc eax
        stosd
        loop lp
        ===
section .bss
buf1    resb 1024
buf2    resb 1024

section .text
        mov esi, buf1
        mov edi, buf1
        mov ecx, 1024
        cld
        rep movsb

        =
;for example buf1='this is a string', buf2='long '
;length buf1=16, buf2=5
        mov edi, buf1+15+5
        mov esi, buf1+15
        std
        mov ecx, 6
        rep movsb
        mov esi, buf2+4
        mov ecx, 5
        rep movsv
----
        mov edi, mystr
        mov ecx, mystr_length
        cld
        mov al, 'a'
        repne scasb
        jz is exists

