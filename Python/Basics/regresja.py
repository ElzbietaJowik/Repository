def regresja(x,y):
    n = len(x)
    sumax = 0
    sumay = 0
    sumaxy = 0
    sumax2 = 0
    sumay2 = 0
    
    if len(x) != len(y):
        raise Exception("Blad! Listy musza byc rownej dlugosci")
    for i in range(n):
        sumax += x[i]
        sumay += y[i]
        sumaxy += x[i]*y[i]
        sumax2 += x[i]**2
    beta = (sumaxy-sumax*sumay/n)/(sumax2-sumax**2/n)
    alpha = sumay/n-beta*sumax/n
    return [alpha,beta]

def E(alpha, beta, x, y):
    sumaE = 0
    if len(x) != len(y):
        raise Exception("Blad! Listy musza byc rownej dlugosci")
    n = len(x)
    for j in range(n):
        sumaE += (alpha + beta * x[j] - y[j])**2
    return sumaE

def r(x, y):
    n = len(x)
    sumar = 0
    sumax = 0
    sumay = 0
    sumaxy = 0
    sumax2 = 0
    sumay2 = 0
    if len(x) != len(y):
        raise Exception("Blad! Listy musza byc rownej dlugosci")
    for k in range(n):
        sumax += x[k]
        sumay += y[k]
        sumaxy += x[k]*y[k]
        sumax2 += x[k]**2
        sumay2 += y[k]**2
        import math
        sx = math.sqrt(sumax2-sumax**2/n)
        sy = math.sqrt(sumay2-sumay**2/n)
        r = sumaxy - (sumax*sumay)/n
    return r/(sx * sy)

import random
random.seed(123)
alpha0 = -3
beta0 = 1.5
n = 100
x = [ random.uniform(-10, 10) for i in range(n) ]
y = [ alpha0 + beta0 * x[i] + random.normalvariate(0, 1) for i in range(n) ]
# czyli y=alpha0+beta0*x+szum z rozkładu normalnego N(0,1)
import matplotlib.pyplot as plt
# wykres rozproszenia:
plt.scatter(x, y)
# rysowanie odcinka [xmin, xmax], [ymin, ymax]:
plt.plot([-10, 10], [alpha0 + beta0 * (-10), alpha0 + beta0 * 10], color="red")
#testujemy funkcję
wspl = regresja(x, y) # wyznaczamy wspolczynniki alpha i beta poprzez wywołanie funkcji regresja()
plt.plot([-10, 10], [wspl[0] + wspl[1] * (-10), wspl[0] + wspl[1] * 10], color = "blue")
# zapis do pliku PNG:
plt.savefig("zadanie_3_0.png")

#testujemy funkcję
print(str.format("{2:15s} y = {0:^4.03f} + {1:0.3f} * x", wspl[0], wspl[1], "Prosta:"))
print(str.format("{1:15s} = {0:^4.03f}", E(wspl[0], wspl[1], x, y), "E(a, b, x, y)"))
print(str.format("{1:15s} = {0:^4.03f}",r(x, y), "Wspl korelacji"))

N = 100
lista = [0] * N
for i in range(N):
    alpha2 = alpha0 + random.uniform(-1, 1)
    beta2 = beta0 + random.uniform(-1,1)
    lista[i] = E(alpha2, beta2, x, y)

print(str.format("{1:15s} E(a, b, x, y) = {0:^4.03f}", E(wspl[0], wspl[1], x, y), "Regresja:"))

print(str.format("{1:15s} E(a, b, x, y) = {0:^4.03f}", min(lista), "Proste losowe:"))