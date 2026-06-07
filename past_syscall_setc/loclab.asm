про локальные метки в многострочных макросах
дело следующее

допустим есть макрос принимающий область и длину

%macro zeromem 2   
    mov eax, %1
    mov ecx, %2
lp: mov byte [eax], 0
    inc eax
    loop lp
%endmacro
    если попытаться вызвать 2+ раз то будет ошибка: две метк lp
    поэтому используем ЛОКАЛЬНЫЕ МЕТКИ
    надо два процента: %%


%macro zeromem 2   
    mov eax, %1
    mov ecx, %2
%%lp: mov byte [eax], 0
    inc eax
    loop %%lp
%endmacro

но это не всё
если  мы передадим как аргумент еах или есх в определенном порядке то может быть что то такое
    mov eax, ecx
    mov ecx, eax
поэтому делаем так:

%macro zreomem 2
        pop dword %2
        pop dword %1
        push eax
        push ecx
%%lp:   mov byte [eax], 0
        inc eax
        loop %%lp
%endmacro
