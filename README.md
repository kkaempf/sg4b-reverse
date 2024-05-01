# sg4b-reverse
Texscan MSI SpectraGen 4B ROM reverse engineering

Supports reverse engineering of the Textscan MSI SpectraGen 4B ROM, to understand how to connect with it (does not aim at full reverse).

# Texscan

https://cg-wiki.org/texscan_msi/sg4b

# ROMs:

U20.BIN : Main Boot ROM, 16K, mapped 0x0000 - 0x3fff
U21.BIN : ?
U22.BIN : ?

# How to use

Under linux, install ``pasmo``. Run the ``doit.sh`` script and start hacking the u20.asm file. Any discrepancy in generation will immediately be highligted in the terminal.



# Generation of assembly files

First, generation of a simple assembly file at correct address
Then assembly of this file to generate the correct symbol file
Then concatenation of all symbol file to get a symbol accross all ROMs
Then re-generation of assembly files with all symbols

z80dasm -l -a -t -g 0x8000 ROMs/U21-57.BIN > u21-57.asm
pasmo --alocal u21-57.asm u21-57.bin u21-57.sys

z80dasm -l -a -t -g 0xc000 ROMs/U22-57.BIN > u22-57.asm
pasmo --alocal u22-57.asm u22-57.bin u22-57.sys

cat u20-57.sys u21-57.sys u22-57.sys | sed -e 's/[ \t]*EQU 0\(....\)H/: equ 0x\1/g' > all.sym
z80dasm -l -a -t -g 0x8000 -S all.sym ROMs/U21-57.BIN > u21-57.asm
z80dasm -l -a -t -g 0xc000 -S all.sym ROMs/U22-57.BIN > u22-57.asm

pasmo --alocal u21-57.asm u21-57.bin u21-57.sys

pasmo --alocal rom.asm rom.bin rom.sys
