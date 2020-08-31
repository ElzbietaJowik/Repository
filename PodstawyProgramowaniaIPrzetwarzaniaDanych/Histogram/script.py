"""
Rozwiazanie zadania 5_01 histogram
"""

import math
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import random

def histogram(x, k = None, nazwa_pliku = "histogram.png"):
    n = len(x)
    if n <= 0:
        raise Exception("n<=0")
    
    if k is None: # domyslna liczba ,,kubelkow''
        k = math.ceil(math.log2(len(x)) + 1)
    
    a0 = min(x)
    ak = max(x) 
    ak += (10**(-9)) * ((ak-a0)/k)
    w = (ak-a0)/k
        
    a = [0] * (k+1)
    for i in range(k+1):
        a[i] = a0 + i*w
    
    c = [0] * k
 
    for i in range(n):
        for j in range(k):
            if x[i] >= a[j] and x[i] < a[j+1]:
                c[j] += 1
                break

    fig = plt.figure()             # inicjowanie rysunku:
    ax = fig.add_subplot(111)
    ax.set_xlim([a0, ak])  # zakres wartości na osi OX
    ax.set_ylim([0.0, max(c)/n])           # zakres wartości na osi OY
    
    for i in range(k):
        ax.add_patch(patches.Rectangle((a[i], 0.0),
                                       w,
                                       c[i]/n,
                                       facecolor="0.75"  # kolor (stopień szarości)
                                       ))
    plt.plot(x, [0]*len(x), "r.") # dodaj czerwone punkty (y=0) reprezentujące
                                  # wszystkie obserwacje z x
    fig.savefig(nazwa_pliku, dpi=90)

## Przyklady wywolan:

N = 500             
#x = [ random.uniform(0, 1) for i in range(N) ]
## rozklad normalny:
x = [ random.gauss(0, 1) for i in range(N) ]
### lub mozemy go uzyskac jako:
#x = [ random.normalvariate(10, 5) for i in range(N) ]
#x = [ random.expovariate(1) for i in range(N) ]
#x = [ random.expovariate(10) for i in range(N) ]
#x = [ random.paretovariate(1) for i in range(N) ]
#x = [ random.betavariate(0.5, 3) for i in range(N) ]
#x = [ random.expovariate(1) for i in range(N)]

histogram(x)

