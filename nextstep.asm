%define OS_LINUX

%macro kernel 1-*
%ifdef OS_FREEBSD
    %rep %0
        %rotate %0
            push dword %1
    %endrep
        mov eax, [esp]
        int 80h
        jnc %%ok
        xchg ecx, eax
        mov eax, 1
        jmp short %%q
  %%ok:   xor ecx, ecx
  %%q:    add esp, %0*4
%elifdef OS_LINUX
    %if %0 > 1
        push ebx
        %if %0 > 4  ;a,b,c,d
            push esi
            push edi
            push ebp
        %endif
    %endif
    %rep %0
        %rotate -1
            push dword %1
    %endrep
    pop eax
  %if %0 > 1
                            pop ebx
    %if %0 > 2
                            pop ecx
        %if %0 > 3
                            pop edx
            %if %0 > 4
                            pop esi
                %if %0 > 5
                            pop edi
                    %if %0 > 6
                            pop ebp
                        %if %0 > 7
                            %error "Can't do linux syscall with 7+ params"
                        %endif
                    %endif
                %endif
            %endif
        %endif
    %endif
  %endif
        int 80h
        mov ecx, eax
        and ecx, 0fffff000h
        cmp ecx, 0fffff000h
        jne %%ok
        mov ecx, eax
        neg ecx
        mov eax, -1
        jmp short %%q
  %%ok: xor ecx, ecx
  %%q:   
  %if %0 > 1
     pop ebx
    %if %0 > 4
        pop esi
        pop edi
        pop ebp
    %endif
  %endif
%else
    %error Please define either OS_LINUX or OS_FREEBSD
%endif
%endmacro

section .data
%ifdef OS_FREEBSD
openwr_flags equ 601h
%else   ; asume it's Linux
openwr_flags equ 241h
%endif

helpmsg db 'Usage: copy <src> <dest>', 10
helplen equ $-helpmsg
err1msg db "Couldn't open source file for reading", 10
err1len equ $-err1msg
err2msg db "Couldn't open destination file for writting", 10
err2len equ $-err2msg


section .bss
buffer   resb 4096
buffsise equ $-buffer
fdsrc    resd 1
fddest   resd 1
argc     resd 1
argvp    resd 1
section .text
global _start
_start: pop dword [argc]
        mov [argvp], esp
        cmp dword [argc], 3
        je .args_count_ok
        kernel 4, 2, helpmsg, helplen
        kernel 1, 1
.args_count_ok:
        mov esi, [argvp]
        mov edi, [esi+4]
        kernel 5, edi, 0    ; 0_RDONLU
        cmp eax, -1
        jne .source_open_ok
        kernel 4, 2, err1msg, err1len
        kernel 1, 1
.source_open_ok:
        mov [fdsrc], eax
        mov edi, [esi+8]
        kernel 5, edi, openwr_flags, 0666o
        cmp eax, -1
        jne .dest_open_ok
        kernel 4, 2, err2msg, err2len
        kernel 1, 2
.dest_open_ok:
        mov [fddest], eax
.again: kernel 3, [fdsrc], buffer, buffsise
        cmp eax, 0
        jle .end_of_file
        kernel 4, [fddest], buffer, eax
        jmp short .again
.end_of_file:
        kernel 6, [fdsrc]
        kernel 6, [fddest]
        kernel 1, 0
