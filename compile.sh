#!/usr/bin/env bash

nasm -f elf64 -o acat.o acat.asm
ld acat.o -o acat
rm acat.o
