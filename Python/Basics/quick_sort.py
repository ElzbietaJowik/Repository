import random
 
def quicksort(t):
    _quicksort(t,0,len(t)-1)
 
def _quicksort(t,i0,i2):
    if i0<i2:
        k=random.randint(i0,i2)
        j=partition(t,k,i0,i2)
 
        _quicksort(t,i0,j-1)
        _quicksort(t,j+1,i2)
 
def partition(t,k,i0,i2):
    n = len(t)
    pocz = i0
    konc = i2
    p = t[k]
    while True:
        while t[pocz]<p:
            pocz +=1
        while t[konc]>p:
            konc -=1
        if t[pocz] ==p and t[konc]==p:
            pocz +=1
        if pocz < konc:
            c = t[pocz]
            t[pocz] = t[konc]
            t[konc] = c
        else:
            return konc

#	TEST
 
t=[random.randint(0,50) for i in range(0,20)]
 
print(t)
 
quicksort(t)
 
print(t)
