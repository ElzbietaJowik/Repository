import random
import math
random.seed(12345)

# znajdowanie minimum fukcji - uproszczony algorytm symulowanego wyżarzania.
def f(x):                                             # funkcja zdefiniowana w zadaniu

    t = 0.1
    if x < -4:
        return(x**2 - 10.46)
    elif x <= 4:
        return(t*math.cos(14*x) + (1 - t) * 8*math.sin(x))
    elif x <= 6:
        return(t*math.cos(x) + (1 - t) * 0.5*math.sin(14*x))
    else:
        return(t*math.cos(6) + (1 - t) * 8*math.sin(14*6))

h = open("input_.txt", "r")                          # zczytujemy dane z pliku input.txt
                   
N = int(h.readline())
T0 = float(h.readline())
TN = float(h.readline())
a = float(h.readline())
b = float(h.readline())

h.close()



def simulated_annealing(f, N, T0, TN, a, b):
    if N < 0 or T0 < TN or a > b:
        raise Exception("Parametry nie spelniaja zalozen") #zglaszamy blad wowczas, gdy dane zczytane z pliku nie spelniaja zalozen
    x = random.uniform(a,b)
    T = T0
    for k in range(1, N+1):
        u1 = random.uniform(-1,1)
        y = x + u1
        if f(x) > f(y):
            x = y
        else:
            u2 = random.uniform(0,1)
            if math.exp((f(x)-f(y))/T) > u2:
                x = y
        T = T0 * math.exp(-(k/N)*math.log((T0/TN),2))

    return x


x = random.uniform(a,b)
z = f(x)

g = open("output_.txt", "w")                          # wypisujemy dane w pliku output_.txt
print(str.format("a  = {0:0.2f}", a), file = g)
print(str.format("b  =  {0:0.2f}", b), file = g)
print(str.format("N  =  {0}"+" "*4+"x    = {1:0.3f}", N, x), file = g)
print(str.format("T0 =  {0}"+" "*4+"f(x) = {1:0.3f}", T0, z), file = g)
print("TN = ", TN, file = g)
g.close()

import matplotlib.pyplot as plt                       # rysujemy wykres funkcji w pliku output_.png
import numpy as np
fig = plt.figure()

u = np.linspace(-6, 8)
v = [f(x) for x in u]
plt.plot(u, v)
plt.scatter(x, f(x), color="red")
fig.savefig('output_.png', dpi=90) 

def g(x):                                            # definiujemy dana w zadaniu funkcje g(x)

    return math.sin(x**2) + abs(x)

t = open("simulations.txt", "w")

print(str.format("{0:^8s}|{1:^8s}", "N", " m.error"), file = t)
print("-"*17, file = t)

error_sum = 0

### petla zewnetrzna
for i in range(1000,11000,1000): # petla odpowiedzialna za iterowanie po wierszach i kolumnach
    print(str.format("{0:7d} |", i), end = "", file = t)
### petla wewnetrzna
    for j in range(100):         # petla odpowiedzialna za stukrotne powtarzanie operacji
        zmienna = simulated_annealing(g, i, T0, TN, a, b)
        error_sum += math.fabs(g(zmienna))
    average_error = 0.01 * error_sum
    print(str.format("{0:8.3f}", average_error), file = t)
    print("-"*17, file = t)
    
        
    
