#!/bin/bash
nasm -f elf $1.asm && ld -m elf_i386 $1.o -o $1;
rm  *.o *~ .*~ > /dev/null
echo "RUN IT:"
./$1

