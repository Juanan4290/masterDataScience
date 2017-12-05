# Shell Scripting 

## Quick Exercises 1

1. Create a directory “first_dir” in you home folder:
    ```
    > mkdir first_dir
    ```
2. Create an empty file “text_file.txt” inside “first_dir” directory:
    ```
    > touch ./first_dir/text_file.txt
    ```
3. Add execute permissions to group users, and write permissions to other users to “text_file.txt”:
    ```
    > cd first_dir
    >> chmod g+x,o+w text_file.txt
    ```
4. Create 3 subdirectories inside “first_dir”: “sub1”, “sub2”, “text_file”:
    ```
    >> mkdir sub1 sub2 text_file
    ```
5. Copy the “text_file.txt” file into “sub1” directory:
    ```
    >> cp text_file.txt ./sub1/
    ```
6. Move the “text_file.txt” into sub2 under name “text_file.txt.2”:
    ```
    >> mv text_file.txt ./sub2/text_file.txt.2
    ```
7.  Copy the whole directory “sub1” to “sub3” directory:
    ```
    >> cp -r sub1 sub3
    ```
8.  Change file name of “sub3/text_file.txt” to “sub3/        text_file.txt.backup”:
    ```
    >> cd sub3
    >>> mv text_file.txt text_file.txt.backup
    ```
9.  Move “first_dir /sub3/text_file.txt.backup” to “first_dir” directory as hidden file:
    ```
    >>> cd ..
    >> mv ./sub3/text_file.txt.backup .text_file.txt.backup
    ```
10. Delete the “sub3” subdirectory:
    ```
    >> rm -rf sub3
    ```

## Quick Exercises 2

1.  Go to data/shell/ directory and use less to open Finn.txt:
    a) Locate the lines starting with “The”
    b) Locate the lines ending with “works”
    ```
    > cd Data/shell
    >>> less Finn.txt
    ```
    Use while reading:<br />
    /The <br />
    /works <br />
    
2.  Open ~/Data/opentraveldata/optd_aircraft.csv with less command. Search for “Canada” and then search for “Puma”:
    ```
    > cd Data/opentraveldata
    >>> less optd_aircraft.csv
    ```
    Use while reading:<br />
    /Canada #Ctrl+N for next word and Shift+N for previous one<br />
    /Puma<br />
3.  Use help to find out how to get the list of subdirectories limited to 2 sublevels by using “tree” command:
    ```
    > man tree
    ```
    Use while reading:<br />
    /level<br />

## Quick Exercises 3

1.  Go to ~/Data/Shell/ and use Text_example.txt to generate a new file with the same content but with line number at the beginning of each line:
    ```
    > cd /Data/shell
    >>> cat -n Text_example.txt > Text_example_ln.txt
    ```
2.  Generate a new file with twice the content of “Text_example.txt” inside (one full text content after another):
    ```
    >>> cat Text_example.txt Text_example.txt > Text_example_twice.txt
    ```
3.  Open new shell inside a new terminal tab and using block search execute again the command where we printed the linux details (hint: it had “release” in the name):
    ```
    Ctrl+Shift+t
    Ctrl+r+'release'
    ```

## Quick Exercises 4

1.  Find all files located ONLY inside subdirectories of your home directory which have been modified in last 60min:
    ```
    > find -mindepth 2 -type f -mmin -60
    ```
2.  Find all empty files inside subdirectories of your home directory which do NOT have read-write-execute permissions given to all users:
    ```
    > find -mindepth 2 -type f -empty -not -perm 777
    ```
3.  Expand previous command to grant these permissions using “ok cmd” option:
    ```
    > find -mindepth 2 -type f -empty -not -perm 777 -ok chmod 777 {} \;
    ```

## Quick Exercises 5

1.  Print first 3 lines of ~/Text_example.txt:
    ```
    > cd Data/shell
    >> head -3 Text_example.txt
    ```
2.  Print content of ~/Text_example.txt except first 2 and last 3 lines:
    ```
    >> head -n -3 Text_example.txt | tail -n -1
    ```
3.  How many lines does ~/Data/opentraveldata/optd_aircraft.csv file have?
    ```
    > cd Data/opentraveldata
    >> cat optd_aircraft.csv | wc -l
    ```

## Pipe- Quick exercises

1.  How many words do first 5 lines of the Finn.txt have:
    ```
    > cat Finn.txt | wc -w
    ```
2.  Save the information of 3 largest file inside your home directory into a file. (hint: use ls with sort option and pipe the result):
    ```
    ls -lS | head -4 > top3largest.txt
    ```
3.  Save last 20 commands used at command line to a file:
    ```
    history -20 > history20.txt
    ```










