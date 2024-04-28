#!/bin/bash

# z80dasm -l -t -g 0 -a Otrona_Attaché_U252_Rev_D.BIN > otrona_d2.asm

while true; do
    inotifywait -qq -e close_write u20.asm
    echo -n "Checking..."
    # z80asm otrona_d.asm -o otrona_d.bin
    pasmo --alocal u20.asm u20.bin u20.sys
    echo "done"

    if [ -f u20.bin ]; then
        if ! diff -q u20.bin ROMs/U20.BIN; then
            echo "ERROR!"
            hexdump ROMs/U20.BIN > /tmp/a.hex
            hexdump u20.bin > /tmp/b.hex
            # git diff -U0  --no-index --no-prefix --word-diff=plain --word-diff --word-diff-regex=. /tmp/a.hex /tmp/b.hex
            diff /tmp/a.hex /tmp/b.hex | head -10
        else
            cp u20.asm u20-lastgood.asm
        fi
    fi
done
