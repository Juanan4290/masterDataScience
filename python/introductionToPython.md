1.  Given two int values, return their sum if the two values are not the same. If the two values are not
the same then return the double of their sum:
```{python}
def q1(a,b):
    if a!=b:
        return a+b
    else:
        return 2*(a+b)
```

2.  Given 2 ints, a and b, return True if one if them is 10 or if their sum is 10:
```
def q2(a,b):
    if a==10 or b==10 or (a+b)==10:
        return True
    else:
        return False
```

3.  Write a function “centenario” that will take Name, and year of birth as inputs, check if year of birth
is int and cast it to int if not, and print name together with the text explaining when the person is to
have 100 years:
```

