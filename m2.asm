%define arg1 ebp+8
%define arg2 ebp+12
%define arg3 ebp+16
%define loc1 ebp-4
%define loc2 ebp-8
%define loc3 ebp-12
%define arg(n) ebp+8+(4*(n-1)
%define loc(n) ebp-4*n

%macro pcall0 1
    call %1
%endmacro
