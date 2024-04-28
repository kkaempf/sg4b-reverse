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

