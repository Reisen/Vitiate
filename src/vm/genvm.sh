#!/bin/bash

strip a.out
output="$(objdump -d -j .text a.out | tail -n +8)"
shell="$(echo "$output" | cut -f 2-2)"
instruction="$(echo "$output" | cut -f 3-3 | grep -Eo '^[^ ]+')"
shellc="$(echo "$shell" | awk -F' ' '{print NF}')"
finished="$(paste <(echo "$shellc") <(echo "$shell"))"
finished="$(echo "$finished" | sed 's/ \+$//' | sed 's/\s/, 0x/g' | sed 's/$/,/')"

echo "$finished"

#while read -r line; do
#    echo -e Result: $(echo $line)
#done <<< "$shell"
