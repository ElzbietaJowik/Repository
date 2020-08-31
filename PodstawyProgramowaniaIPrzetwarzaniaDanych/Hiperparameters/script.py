"""
Zadanie wyszukiwania hiperparametrów 'po siatce'
"""

import math
import numpy as np
from sklearn import datasets, svm
import matplotlib.pyplot as plt
import matplotlib.patches as patches

def F(a, b):
    """
    Nie interesuje nas, co funkcja robi:
    traktujemy ja jako "czarna skrzynke".

    Wazne jest jedynie to, ze F(a, b) zwraca wartość z przedzialu [0,1]
    dla a, b > 0


    Przykład  inspirowany http://scikit-learn.org/stable/auto_examples/
                          exercises/plot_iris_exercise.html
    """
    iris = datasets.load_iris()  # zbior iris
    X, y = iris.data, iris.target
    X, y = X[y != 0, :2], y[y != 0] # tylko klasy 1 i 2
    n_sample = len(X)
    np.random.seed(1234)
    order = np.random.permutation(n_sample)
    X = X[order]
    y = y[order].astype(np.float)
    X_train = X[:int(0.8 * n_sample)] # proba uczaca = losowe 80%
    y_train = y[:int(0.8 * n_sample)]
    X_test = X[int(0.8 * n_sample):]  # proba testowa = pozostale 20%
    y_test = y[int(0.8 * n_sample):]
    clf = svm.SVC(gamma=a, C=b) # support vector classifier
    clf.fit(X_train, y_train)
    return np.mean(clf.predict(X_test) == y_test) # accuracy, wartość z [0,1]



# 1.1

f = open("input.txt", "r")

a1 = float(f.readline())
an = float(f.readline())
n = int(f.readline())
b1 = float(f.readline())
bm = float(f.readline())
m = int(f.readline())

f.close()

"""
for line in f:
    x = line # aktualny wiersz pliku
    x = int(x)
    # ....
"""

if a1 > an or b1 > bm or n < 1 or m < 1:
    exit("Wartosci parametrow nie sa poprawne.")
    
print(str.format("a1 = {0}, an = {1}, n = {2}, b1 = {3}, bm = {4}, m = {5}", a1, an, n, b1, bm, m))

# 1.2
# obliczenie wartości funkcji F w każdym punkcie z siatki i zapis wyników w postaci
# estetycznie sformatowanej tabelki
diff_a = (an - a1) / (n - 1)
diff_b = (bm - b1) / (m - 1)

## zmienne pomocnicze do wyznaczenia minimum i maksiumum

fmax = -math.inf
fmin = math.inf
# amax
# bmax
# takie ze F(amax, bmax) = fmax

f = open("output.txt", "w")

## generujemy pierwszy wiersz

print(str.format("{0:6s}|", "a / b"), end="", file = f)
for j in range(m):
    bj = b1 + j * diff_b
    print(str.format("{0:^6.2f}", bj), end="", file = f)
    
print("", end="\n", file = f)
print("-"*6 + "|" + "-" * (m * 6), end="\n", file = f)

### Petla zewnetrzna
for i in range(n): # petla odpowiedzialna za iterowanie po wierszach
    ai = a1 + i * diff_a
    
    print(str.format("{0:<6.1f}|", ai), end="", file = f)
    
    ### Petla wewnetrzna:
    for j in range(m): # petla odpowiedzialna za iterowanie po kolumnach
        bj = b1 + j * diff_b
        
        val = F(ai, bj)
        
        if fmax < val:
            fmax = val
            amax = ai
            bmax = bj
        
        if fmin > val:
            fmin = val
            
        print(str.format("{0:^6.2f}", val), end= "", file = f)
    ### Koniec petli wewnetrznej
    print("", end="\n", file=f)
### Koniec petli zewnetrznej

f.close()

## 1.3
# Znajdowanie wartości maksymalnej i minimalnej

print(str.format("fmin = {0:.2f}, fmax = {1:.2f}, ai = {2:0.2f}, b = {3:0.2f}", fmin, fmax, amax, bmax))

## 1.4
# Rysowanie mapy ciepła

import matplotlib.pyplot as plt
import matplotlib.patches as patches
fig = plt.figure()
ax = fig.add_subplot(111)

# ustal zakresy na osiach:
ax.set_xlim([a1 - diff_a/2, an + diff_a/2])  # zakres wartości na osi OX [xmin, xmax]
ax.set_ylim([b1 - diff_b/2, bm + diff_b/2]) # zakres wartości na osi OY [ymin, ymax]


for i in range(n):
    ai = a1 + i * diff_a
    for j in range(m):
        bj = b1 + j * diff_b
        
        val = F(ai, bj)
        
        val_scal = (val - fmin)/ ( fmax - fmin)
        
        ax.add_patch(patches.Rectangle(
                (ai - diff_a/2, bj - diff_b/2),        # (x,y)
                diff_a,                  # szerokosc
                diff_b,                  # wysokosc
                facecolor=str(val_scal)  # stopien szarosci (od 0 do 1) jako napis
        ))

# zapis do PNG po zakończeniu rysowania
fig.savefig('output.png', dpi=90)
