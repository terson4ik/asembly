также можно сделать так
%define thenumber 20
%define mkvar dd thenumber

section .data
var1    mkvar
даст dd 20
но можно менять типа


%define thenumber 20
%define mkvar dd thenumber
%define thenumber 45

section .data
var1    mkvar
даст dd 45

это называется ЛЕНИВАЯ макроподстановка
что бы избежать можно написать 

%define thenumber 20
%xdefine mkvar dd thenumber
%define thenumber 45
var1 mkvar
и оно даст dd 20 потому что xdefine сразу разворачивает макросы в макровыражениях
это называется ЭНЕРГИЧНОЙ стратегией макроподстановки.
