#Exercise 1
def q1(a,b):
    if a!=b:
        return a+b
    else:
        return 2*(a+b)


#Exercise 2
def q2(a,b):
    if a==10 or b==10 or (a+b)==10:
        return True
    else:
        return False


#Exercise 3
def centenario(name,year):
    if type(year)!=int:
        year=int(year)
    
    year100=100+year
    return '{} will reach 100 years in {}'.format(name,year100)
