def selectSort(t):
    n = len(t)
    for i in range(n-1):
        minindex = i
        for j in range(i+1, n):
            if not t[minindex] <= t[j]:
                minindex = j
        if minindex != i:
            t[i], t[minindex] = t[minindex], t[i]
        else:
            continue
    return t


t = [1, 5, 4, 9, 66, 54, 98, 100]
print(selectSort(t))

                
                
