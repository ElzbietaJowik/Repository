def mergesort(t):
# sortowanie przez scalanie (w miejscu)

    def _merge(t, i0, i1, i2): # funkcja odpowiadajaca za scalanie posortowanych tablic
        l = i0
        r = i1
        i = 0
        while l < i1 and r < i2:
            if t[l] <= t[r]:
                aux[i] = t[l]
                l += 1
            else:
                aux[i] = t[r]
                r += 1
            i += 1
        while l < i1:
            aux[i] = t[l]
            l += 1
            i += 1
        while r < i2:
            aux[i] = t[r]
            r += 1
            i += 1

        for i in range(i0, i2):
            t[i] = aux[i-i0]



    def _mergesort(t, i0, i2):            # funkcja odpowiadajaca za dzielenie tablicy na mniejsze

        if i2 - i0 <= 1:                  # przestaje dzielic tablice wowczas, gdy ...
            return
        else:
            i1 = (i0 + i2) // 2		   # wywolanie rekurencyjne
            _mergesort(t, i0, i1)      # sortujemy kolejno coraz mniejsze fragmenty lewej czesci tablicy wejsciowej
            _mergesort(t, i1, i2)	   # sortujemy kolejno coraz mniejsze fragmenty prawej czesci tablicy wejsciowej
            _merge(t, i0, i1, i2)	   # scalamy kolejne posortowane juz fragmenty
    aux = [0] * len(t)        # tablica pomocnicza (dodatkowa pamiec- O(n))
    _mergesort(t, 0, len(t)) 		   # wywolanie funkcji _mergesort(t) wewnatrz funkcji mergesort(t)
    return t

t = [1, 4, 9, 0, 5]
print(mergesort(t))
        
