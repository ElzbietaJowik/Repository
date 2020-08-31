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
 
            


