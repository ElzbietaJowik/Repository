import math
n = int(input("Liczba wiezowcow: "))
t = [0]*n  # tworze n-elementowa pusta tablice, w ktorej bede zapisywac wysokosci wszystkich wiezowcow
for i in range(n):
    h = int(input("Wysokosc wiezowca: "))
    t[i] = h

def widoczny(t, n):
    licznik = 1  # pierwszy snajper zawsze widzi drugiego, bo miedzy nimi nie ma zadnego innego wiezowca
    for i in range(2, n):
        x = True
        delta = math.fabs(t[i]-t[0])
        for j in range(1, i):
            if t[j] > min(t[0], t[i]) + delta/i:
                x = False
        if x != False:
            licznik += 1
    return licznik

def wysokosc_minimalna(t, n):
    maks = -math.inf     # maksymalna wysokosc jaka wyznaczymy porownujac ze soba dwa kolejne wiezowce bedzie 
    z = [0]*(n-2)
    for k in range(2, n):# niezbedna do tego, aby snajper widział wszystkich innych
        if t[k] < t[k-1]:# wyznaczamy roznnice wysokosci dla kazdych dwoch kolejnych wiezowcow
            diff = t[k-1] - t[k]
            H = t[k] + diff * k
            z[k-2] = H
        elif t[0] == t[k-1]:
            z[k-2] = t[k]
        else: 
            diff = t[k] - t[k-1]
            H = t[k] - diff * k
            z[k-2] = H
           
    return max(z)
#	TEST
print(t)
print(widoczny(t, n))
print(wysokosc_minimalna(t, n))

        
                
                 
            



             

                           



             
        


    