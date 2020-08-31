import copy
def replace_pattern(t, s, r):
    n = len(t)
    m = len(s)
    k = len(r)
    j = 0
    i = 0
    index = 0
    licznik = 0
    index = 0
    z = [0] * (n-m+k)
    kolejka = -1
    assert n != 0
    assert m != 0
    assert k != 0
    for i in range(n):
        while j <= m-1:
            if t[i] == s[j]:
                licznik += 1
                j += 1
                break
            else:
                licznik = 0
                j = 0
                kolejka += 1
                if kolejka > 0:
                    break
                continue
        if licznik == m:
            index = i-m+1
            print(index)
            break
    if index == 0:
        return copy.copy(t)
    
    else:
        for i in range(index):
            z[i] = t[i]
        for j in range(index, index+k):
            z[j] = r[j-index]
        for l in range(index+k, n-m+k):
            z[l] = t[l-k+m]
    return z


t = [1, 2, 3, 1, 2, 3, 4, 2, 2, 1, 2, 3, 4]
s = [1, 2, 3, 4]
r = [6, 6, 7]
print(replace_pattern(t, s, r))


u = [1, 2, 3]
w = [4, 6]
x = [5]
print(replace_pattern(u, w, x))
                