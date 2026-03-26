%include 'stud_io.inc'
global _start
extern strtoint
extern inttostr
extern readnumbers
extern printing_arr

section .text

FATALerror:
        sub esp, 4
error:  PRINT 'ERROR!!!'
        PUTCHAR 10
        jmp loop

; MAIN PROGRAM
_start: xor ebp, ebp
loop:   
        xor edi, edi
        inc edi
        push dword 11
        push dword firnum
        call readnumbers
        add esp, 8
        test eax, eax
        js quit
        test ecx, ecx
        jz error
        cmp eax, ' '
        jne error
        push ecx    ; for remember about length
        push dword 11
        push secnum
        call readnumbers
        add esp, 8
        test ecx, ecx
        jz FATALerror
        test eax, eax
        jns notOver
        inc ebp
        mov eax, 10
        PUTCHAR 10
notOver:cmp eax, 10
        jne FATALerror
        push ecx 
        push secnum
        call strtoint
        add esp, 8
        test cl, cl
        jnz error
        mov ebx, eax
        pop ecx
        push ecx
        push firnum
        call strtoint
        add esp, 8
        test ecx, ecx
        jnz error
        PRINT 'a + b = '
        push eax
        add eax, ebx
formating:
        push dword resnum
        push eax
        call inttostr

        ; FIRST PARAMETER FOR NEXT STEP IN STACK. IN PAST STEP WE DON`T ERASE IT
        add esp, 4
        ; FIRST PARAMETER FOR NEXT STEP IN STACK. IN PAST STEP WE DON`T ERASE IT
        ; of course, it`s not necessary 

        call printing_arr
        add esp, 4
        PUTCHAR 10
        pop eax
        push eax
        test edi, edi
        jz multi
        js divided
        cmp edi, 555
        je exit
        PRINT 'a - b = '
        sub eax, ebx
        xor edi, edi
        jmp formating
multi:
        PRINT 'a * b = '
        xor edx, edx
        mul ebx
        not edi
        jmp formating
divided:
        PRINT 'a / b = '
        xor edx, edx
        test ebx, ebx
        jz error
        div ebx
        mov edi, 555
        jmp formating
exit:
        test ebp, ebp
        jz loop
quit:   PUTCHAR 10
        FINISH
        
section .bss
firnum resb 11
secnum resb 11
resnum resb 11
