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
    Use while reading:
    /The
    /works
    q       #quit
2.  Open ~/Data/opentraveldata/optd_aircraft.csv with less command. Search for “Canada” and then search for “Puma”:
    ```
    > cd
    > cd Data/opentraveldata
    >>> less optd_aircraft.csv
    ```
    Use while reading:
    /Canada #Ctrl+N for next word and Shift+N for previous one
    /Puma   #Ctrl+N for next word and Shift+N for previous one
    q       #quit



