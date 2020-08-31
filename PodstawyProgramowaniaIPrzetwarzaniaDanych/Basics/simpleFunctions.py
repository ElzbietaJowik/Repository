def moving_average(x, k):                 # Analiza rzedu ilosci wykonanych operacji
    assert k%2 != 0                       # 1 porównanie
    n = len(x)                            # pierwsze przypisanie
    l = (k-1)/2                           # drugie przypisanie
    for i in range(0, n-1):               # przechodzimy przez liste n razy          
        if i < l:                         # dokonujemy l+1 porownan i l razy wpisujemy do tablicy NaN                 
            t[i] = float("NaN")
        else:
            t[i] = x[i-l]                 # n-l-1 razy wpisujemy do tablicy wartosci z tablicy x
    return t
def cumsum(x):
    lista = [0]*(n)
    suma = 0
    for i in range(0, n):
        suma += x[i]
        lista[i] = suma
    return lista

import random
random.seed(123)
n = 100
s = 1
# liczba obserwacji
# odchylenie standardowe
# x to skumulowana suma z obserwacji z rozkładu normalnego o wartości
# oczekiwanej 0 i odchyleniu standardowym 1
x = cumsum([random.normalvariate(0, s) for i in range(n)])
import matplotlib.pyplot as plt
# narysuj x[i] jako funkcja indeksów i=0,...,n-1
plt.plot(x, color="black")
# tutaj narysuj wygładzoną wersję x, wywołując moving_average i plt.plot...
# użyj różnych kolorów dla różnych wartości parametru k
# zapis do pliku PNG:
plt.savefig("zadanie_3_1.png")
        
