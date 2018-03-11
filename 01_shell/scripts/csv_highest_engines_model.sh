#!/usr/bin/bash
file=$1

model=`cut $file -d '^' -f 3,7 | sort -t '^' -nr -k 2 | head -1 | cut -d '^' -f 1`

engines=`cut $file -d '^' -f 3,7 | sort -t '^' -nr -k 2 | head -1 | cut -d '^' -f 2`

echo "The model with most engines is $model and it has $engines engines"
