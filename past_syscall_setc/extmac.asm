%ifdef DEBUG_PRINT 
        PRINT 'Entering suspicius code'
%endif
    ;
    ; some code
    ;
%ifdef DEBUG_PRINT
        PRINT 'leaving suspicius code'
%endif


что бы это запустилось есть два варианта
первое
пишем до этого ifdef 
%define DEBUG_PRINT
а можем помимо этого сделать 
nasm -f elf -dDEBUG_PRINT prog.asm 


рассмотрим второй пример
два заказчика, что бы не дублировать код пишем


%ifdef FOR_PETROV
    ;
    ; код предназначенный для Петрова
    ;
%elifdef FOR_SIDOROV
    ;
    ; тут соответсвенно код для Сидорова
    ;
%else
;   если ни тот, ни другой символ не определен,
;   прервем компиляцию и выдадим сообщение об ошибке
%error Please define either FOR_PETROV or FOR_SIDOROV
%endif

ещё есть %ifndef -- if not defined

так же есть директива просто
%if
которая принимает для операций например 
+ - < > >= <= != <> ^^ && || 
также есть %elif 

ifidn ifidni    
проверяют равность двух строк, где ifidni игнорит регистр
почти любая команда где есть if
при приведении к виду ifn будет означать отрицание
