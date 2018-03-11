#!/usr/bin/bash
file=$1
delimiter=$2

cat $file | head -1 | tr $delimiter '\n' | cat -n

numCol=`cat $file | head -1 | tr $delimiter '\n' | cat -n | wc -l`

echo "There are $numCol columns in $file"
