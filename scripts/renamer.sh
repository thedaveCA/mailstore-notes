#!/bin/bash

for file in ./*.md; do
    date=$(grep -m 1 -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2}" $file)
    mv "$file" "$date"_$(basename "$file")
done
