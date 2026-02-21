; fill memory (edi=addres, ecx=length, el=value)
fill_memory:
        jecxz fm_q
jm_lp:  mov [edi], al
        loop fm_lp
fm_q:   ret

; for example -- call
        mov edi, my_array
        mov ecx. 256
        mov al, '@'
        call fill_memory
