# Shell Scripting

## Sorting and Counting

1.  Find top 10 files by size in your home directory including the subdirectories. Sort them by size and print the result including the size and the name of the file (hint: use find with –size and -exec ls –s parameters)
    ```
    >> find -type f -size +10M -exec ls -s {} \; | sort -nr | head -10
    ```
2.  Create a dummy file with this command: seq 15 > 20lines.txt; seq 9 1 20 >> 20lines.txt; echo "20\n20" >> 20lines.txt; (check the content of file first):<br />
    a)  Sort the lines of file based on alphanumeric characters:
    ```
    >> sort -d 20lines.txt
    ```
    b)  Sort the lines of file based on numeric values and eliminate the duplicates:
    ```
    >> sort -nu 20lines.txt
    ```
    c)  Print just duplicated lines of the file:
    ```
    >> sort -n 20lines.txt | uniq -d
    ```
    d)  Print the line which has most repetitions:
    ```
    >> sort -n 20lines.txt | uniq -c | sort -nr | head -1
    ```
    e)  Print unique lines with the number of repetitions sorted by the number of repetitions from lowest to highest:
    ```
    >> sort -n 20lines.txt | uniq -c | sort -nk 1 -nk 2
    ```
3.  Create another file with this command : seq 0 2 40 > 20lines2.txt:<br />
    a)  Create 3rd file combining the first two files (20lines.txt and 20lines2.txt) but without duplicates:
    ```
    >> cat 20lines.txt 20lines2.txt > 20lines3.txt
    >> sort -nu 20lines3.txt
    ```
    b) Merge the first two files. Print unique lines together with the number of occurrences inside the merged file and sorted based on line content:
    ```
    >> cat 20lines.txt 20lines2.txt | sort -n | uniq -c | sort -nk 1 -nk 2
    ```
4.  Go to ~/Data/opentraveldata and get the line with the highest number of engines from optd_aircraft.csv by using sort:
    ```
    >> cat -n optd_aircraft.csv | sort -nr -t "^" -k 7 | head -1
    ```

## Processing and filtering 1

Go to ~/Data/opentraveldata:<br />
1.  Change the delimiter of optd_aircraft.csv to “,”:
    ```
    >> cat optd_aircraft.csv | tr "^" ","
    ```
2. Check if optd_por_public.csv has repeated white spaces (hint: use tr with wc):
    ```
    >> cat optd_por_public.csv | wc -m #number of characters
    >> cat optd_por_public.csv | tr -s " " | wc -m #number of chracters without repeated white spaces
    ```
3. How many columns has optd_por_public.csv? (hint: use head and tr)
    ```
    >> head -1 optd_por_public.csv | tr "^" "\n" | cat -n | wc -l
    ```
4. Print column names of optd_por_public.csv together with their column number. (hint: use paste)
    ```
    >> head -1 optd_por_public.csv | tr "^" "\n" | cat -n
    ```
5. Use optd_airlines.csv to obtain the airline with the most flights?
    ```
    >> cut -d "^" -f 8,14 optd_airlines.csv | sort -t "^" -nr -k 2 | head -1
    ```
6. Use optd_airlines.csv to obtain number of airlines in each alliance?
    ```
    >> cut -d "^" -f 10 optd_airlines.csv | sort -d | uniq -c
    ```

## Processing and filtering 2

Go to ~/Data/opentraveldata
1.  Use grep to extract all 7x7 or 3xx (where x can be any number) airplane models from optd_aircraft.csv.
(hint: logical or = "|" )
    ```
    >> grep -E "7[0-9]7|3[0-9]{2}" optd_aircraft.csv
    ```
2.  Use grep to obtain the number of airlines with prefix “aero” (case unsensitive) in their name from
optd_airlines.csv
    ```
    >> cut -d "^" -f 8 optd_airlines.csv | grep -Ei "^aero" |wc -l
    ```
3.  How many optd_por_public.csv columns have “name” as part of their name? What are their numerical positions? (hint: use seq and paste)
    ```
    >> paste <(seq 50) <(head -n 1 optd_por_public.csv|tr "^" "\n"|grep -E "?name?") #with paste and seq
    >> head -n 1 optd_por_public.csv|tr "^" "\n"|grep -E "?name?" | cat -n #with cat instead of paste
    ```
4.  Find all files with txt extension that have word “Science” (case unsensitive) inside the content. Print file path and the line containing the (S/s)cience word.
    ```
    >> find -type f -iname "*.txt" -exec grep -iH "Science" {} \;
    ```

## Processing and filtering 3
Use the following **Text_example.txt** file:

```
THIS LINE IS THE 1ST UPPER CASE LINE IN THIS FILE.
this line is the 1st lower case line in this file.
This Line Has All Its First Character Of The Word With Upper Case.

Two lines above this line is empty.
And this is the last line.
```

1.  Replace every “line” with new line character (“\n”):
    ```
    >> 
    ```
2.  Delete lines that contain the “line” word:
    ```
    >> 
    ```
3.  Print ONLY the lines that DON’T contain the “line” word:
    ```
    >> 
    ```
