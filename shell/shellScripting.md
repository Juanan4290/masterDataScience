# Shell Script

1.  Create a script that will return column names together with their column number from the csv files. The first argument should be file name and the second delimiter.

```
#!/usr/bin/bash
file=$1
delimiter=$2

cat $file | head -1 | tr $delimiter '\n' | cat -n

numCol=`cat $file | head -1 | tr $delimiter '\n' | cat -n | wc -l`

echo "There are $numCol columns in $file"
```
2.  Create a script that accepts a CSV filename as input ($1 inside your script) and returns the model of the
aircraft with the highest number of engines. (use it on ~/Data/opentraveldata/optd_aircraft.csv)

```
#!/usr/bin/bash
file=$1

model=`cut $file -d '^' -f 3,7 | sort -t '^' -nr -k 2 | head -1 | cut -d '^' -f 1`

engines=`cut $file -d '^' -f 3,7 | sort -t '^' -nr -k 2 | head -1 | cut -d '^' -f 2`

echo "The model with most engines is $model and it has $engines engines"
```
3.  Repeat script 2, but add a second argument to accept number of a column with the number of engines. If several planes have the highest number of engines, then the script will only show one of them (use it
on ~/Data/opentraveldata/optd_aircraft.csv):
```
#!/usr/bin/bash
file=$1
column=$2

model=$(cut $file -d '^' -f 3,$column | sort -t '^' -nr -k 2 | head -1 | cut -d '^' -f 1)

engines=$(cut $file -d '^' -f 3,$column | sort -t '^' -nr -k 2 | head -1 | cut -d '^' -f 2)

echo "The model with most engines is $model and it has $engines engines"
```

4.  Create a script that accepts as input arguments the name of the CSV file, and a number (number of
engines) and returns number of aircrafts that have that number of engines (use it on ~/Data/opentraveldata/optd_aircraft.csv):
```
#!/usr/bin/bash
file=$1
engines=$2

num_models_with_engines=$(cut -d '^' -f 7 $file | grep $engines | wc -l)

echo "There are $num_models_with_engines models with $engines engines"
```


