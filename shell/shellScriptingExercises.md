# Shell Scripting: Quick Exercises 1

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
