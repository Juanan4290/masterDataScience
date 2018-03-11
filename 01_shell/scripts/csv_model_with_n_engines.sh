#!/usr/bin/bash
file=$1
engines=$2

num_models_with_engines=$(cut -d '^' -f 7 $file | grep $engines | wc -l)

echo "There are $num_models_with_engines models with $engines engines"
