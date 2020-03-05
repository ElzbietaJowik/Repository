import math
def shellsort(t):
    n = len(t)
    K = math.floor(math.log(n-1, 2))
    a = 0
    j = 0
    for k in range(K, 0, -1):
# i.
        s = 2**k - 1
        for l in range(n-1):
            for i in range(l, n-1, s):
                value = t[i]
                j = i-s
                while j >= 0:
                    if not t[j] <= value:
                        t[j+s] = t[j]
                        t[j] = value
                        j -= s
                    else:
                        break
    return t
#	TEST
t = [1, 4, 2, 5, 8, 7, 9]
print(shellsort(t))
