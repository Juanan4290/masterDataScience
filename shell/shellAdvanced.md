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







