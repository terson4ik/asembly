;; example/getstr.asm ;;
%include 'kernel.inc'
global getstr
section .text
; [ebp+8] = address, [ebp+12] = size of buffer
getstr: push ebp
        mov ebp, esp
        mov edx, [ebp+8]
        xor ecx, ecx
.again: inc ecx
        cmp ecx, [ebp+12]
        jae .quit
        push edx
        push ecx
        kernel 3, 0, edx, 1
        pop ecx
        pop edx
        cmp eax, 1
        jne .quit
        mov al, [edx]
        cmp al, 10
        je .quit
        inc edx
        jmp short .again
.quit:  mov byte [edx], 0
        mov esp, ebp
        pop ebp
        ret
