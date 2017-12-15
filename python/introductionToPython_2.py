# Exercise 1
# Given a string and a non-negative int n, return a 
# larger string that is n copies of the original string:

def q1(string,integer):
    return string*integer

# Exercise 2
# Given a string, return a new string made of every 
# other char starting with the first element (meaning
# index 0). In other words delete every even char 
# position the string, so "Hello" yields "Hlo":


def q2(string):
    result=""
    for letter in range(0,len(string),2):
        result = result+string[letter]
        
    return result

# Exercise 3
# Write a function to calculate the number of words, 
# number of lines, and length of a string the same
# way the wc command does in the command line:

def q3(string):
    chars = len(string)
    words = len(string.split())
    lines = len(string.splitlines())
    
    return (chars,words,lines)

# Exercise 4
# Write a Python program to remove the nth index 
# character from a string. If the input string is empty
# print warning:

def q4(string, n):
    if not string:
        print ('Warning!!!, the string is empty')
        return
    else:
        print(string[:n]+string[(n+1):])
        return

# Exercise 5
# Given 2 strings, a and b, return a string of the form 
# short+long+short, with the shorter string on the
# outside and the longer string on the inside. The 
# strings will not be the same length, but they may be
# empty (length 0).


def q5(stringA, stringB):
    if len(stringA)>len(stringB):
        print(stringB+stringA+stringB)
        return
    else:
        print(stringA+stringB+stringA)
        return
