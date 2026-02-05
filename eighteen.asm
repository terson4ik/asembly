%include 'stud_io.inc'
global _start

section .text
_start: xor ebx, ebx        ;storage results
        xor esi, esi        ;for buffer
run:    GETCHAR
        test eax, eax
        js print              ;-1=EOF
        ;if no number then go to print
        cmp eax, '0'
        jb print
        cmp eax, '9'
        ja print
        
        sub eax, '0'        ;next interpried from ASCII to numeric
        mov esi, eax
        mov eax, ebx
        mov ebx, 10
        mul ebx             ;by condition of the task, overflow may do not take
        ;then can skeep processing of the EDX which used for overflow EAX
        mov ebx, eax
        add ebx, esi
        jmp run
print:  test ebx, ebx
        jz final
        PUTCHAR '*'
        dec ebx
        jmp print
final:  PUTCHAR 10
        FINISH
