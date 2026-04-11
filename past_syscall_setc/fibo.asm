; заполним область памяти числами Фиббоначи по 4 байта до 100000 

section .text
Fibarr 
    %assign i 1
    %assign j 1
     %rep 100000
    dd i
     %assign k j
     %assign j i+j
     %assign i k
    %if i > 100000
    %exitrep
    %endif
    %endrep
fibcount equ ($-Fibarr)/4
