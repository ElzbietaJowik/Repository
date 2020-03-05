import math
import csv
iris = []
f = open("iris.csv", "r") # r=do odczytu
for row in csv.reader(f):
    for i in range(len(row)):
        row[i] = float(row[i]) # konwersja z str na float
    list.append(iris, row) # == A.append(row)
f.close()

def transpozycja(iris):
    _iris = [[0]*150 for i in range(4)]
    for i in range(150):
        for j in range(4):
            _iris[j][i] = iris[i][j]
    return _iris

_iris = transpozycja(iris)

# korelacja Pearsona
import math
def korelacja(_iris, x, y):
    sumax=0
    sumay=0
    sumaxy=0
    sumax2=0
    sumay2=0
    for i in range(150):
        sumax += _iris[x][i]
        sumay += _iris[y][i]
        sumaxy += _iris[x][i]*_iris[y][i]
        sumax2 += _iris[x][i]**2
        sumay2 += _iris[y][i]**2
        sx = math.sqrt(sumax2-sumax**2/150)
        sy = math.sqrt(sumay2-sumay**2/150)
        r = sumaxy - (sumax*sumay)/150
    return r/(sx * sy)

korelacja_Pearsona = [[0]*4 for i in range(4)]
for i in range(4):
    for j in range(4):
        korelacja_Pearsona[i][j] = round(korelacja(_iris, j, i),5)
print(korelacja_Pearsona)

# Wspolczynniki prostej
def prosta(_iris, x, y):
    _sumax=0
    _sumay=0
    _sumaxy=0
    _sumax2=0
    _sumay2=0
    for i in range(150):
        _sumax += _iris[x][i]
        _sumay += _iris[y][i]
        _sumaxy += _iris[x][i]*_iris[y][i]
        _sumax2 += _iris[x][i]**2
        _sumay2 += _iris[y][i]**2
    a = (150*_sumaxy-_sumax*_sumay)/(150*_sumax2-_sumax**2)
    b = (_sumax2*_sumay-_sumax*_sumaxy)/(150*_sumax2-_sumax**2)
    return [a, b]

import matplotlib.pyplot as plt
plt.figure(figsize=[16, 16], dpi=72)
x = (_iris[0])
y = (_iris[0])
plt.xlabel("sepal length")
plt.ylabel("sepal length")


plt.subplot(4, 4, 1)
x = (_iris[0])
y = (_iris[0])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 0, 0)[0] * min(x)+prosta(_iris, 0, 0)[1],prosta(_iris, 0, 0)[0] * max(x)+prosta(_iris, 0, 0)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal length")
plt.ylabel("sepal length") 

plt.subplot(4, 4, 2)
x = (_iris[1])
y = (_iris[0])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 1, 0)[0] * min(x)+prosta(_iris, 1, 0)[1],prosta(_iris, 1, 0)[0] * max(x)+prosta(_iris, 1, 0)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal width")
plt.ylabel("sepal length") 

plt.subplot(4, 4, 3)
x = (_iris[2])
y = (_iris[0])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 2, 0)[0] * min(x)+prosta(_iris, 2, 0)[1],prosta(_iris, 2, 0)[0] * max(x)+prosta(_iris, 2, 0)[1]], color="blue", alpha=0.5)
plt.xlabel("petal length")
plt.ylabel("sepal length")

plt.subplot(4, 4, 4)
x = (_iris[3])
y = (_iris[0])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 3, 0)[0] * min(x)+prosta(_iris, 3, 0)[1],prosta(_iris, 3, 0)[0] * max(x)+prosta(_iris, 3, 0)[1]], color="blue", alpha=0.5)
plt.xlabel("petal width")
plt.ylabel("sepal length") 

plt.subplot(4, 4, 5)
x = (_iris[0])
y = (_iris[1])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 0, 1)[0] * min(x)+prosta(_iris, 0, 1)[1],prosta(_iris, 0, 1)[0] * max(x)+prosta(_iris, 0, 1)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal length")
plt.ylabel("sepal width")

plt.subplot(4, 4, 6)
x = (_iris[1])
y = (_iris[1])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 1, 1)[0] * min(x)+prosta(_iris, 1, 1)[1],prosta(_iris, 1, 1)[0] * max(x)+prosta(_iris, 1, 1)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal width")
plt.ylabel("sepal width")

plt.subplot(4, 4, 7)
x = (_iris[2])
y = (_iris[1])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 2, 1)[0] * min(x)+prosta(_iris, 2, 1)[1],prosta(_iris, 2, 1)[0] * max(x)+prosta(_iris, 2, 1)[1]], color="blue", alpha=0.5)
plt.xlabel("petal length")
plt.ylabel("sepal width")

plt.subplot(4, 4, 8)
x = (_iris[3])
y = (_iris[1])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 3, 1)[0] * min(x)+prosta(_iris, 3, 1)[1],prosta(_iris, 3, 1)[0] * max(x)+prosta(_iris, 3, 1)[1]], color="blue", alpha=0.5)
plt.xlabel("petal width")
plt.ylabel("sepal width")

plt.subplot(4, 4, 9)
x = (_iris[0])
y = (_iris[2])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 0, 2)[0] * min(x)+prosta(_iris, 0, 2)[1],prosta(_iris, 0, 2)[0] * max(x)+prosta(_iris, 0, 2)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal length")
plt.ylabel("petal length")

plt.subplot(4, 4, 10)
x = (_iris[1])
y = (_iris[2])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 1, 2)[0] * min(x)+prosta(_iris, 1, 2)[1],prosta(_iris, 1, 2)[0] * max(x)+prosta(_iris, 1, 2)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal width")
plt.ylabel("petal length")

plt.subplot(4, 4, 11)
x = (_iris[2])
y = (_iris[2])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 2, 2)[0] * min(x)+prosta(_iris, 2, 2)[1],prosta(_iris, 2, 2)[0] * max(x)+prosta(_iris, 2, 2)[1]], color="blue", alpha=0.5)
plt.xlabel("petal length")
plt.ylabel("petal length")

plt.subplot(4, 4, 12)
x = (_iris[3])
y = (_iris[2])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 3, 2)[0] * min(x)+prosta(_iris, 3, 2)[1],prosta(_iris, 3, 2)[0] * max(x)+prosta(_iris, 3, 2)[1]], color="blue", alpha=0.5)
plt.xlabel("petal width")
plt.ylabel("petal length")

plt.subplot(4, 4, 13)
x = (_iris[0])
y = (_iris[3])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 0, 3)[0] * min(x)+prosta(_iris, 0, 3)[1],prosta(_iris, 0, 3)[0] * max(x)+prosta(_iris, 0, 3)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal length")
plt.ylabel("petal width")

plt.subplot(4, 4, 14)
x = (_iris[1])
y = (_iris[3])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 1, 3)[0] * min(x)+prosta(_iris, 1, 3)[1],prosta(_iris, 1, 3)[0] * max(x)+prosta(_iris, 1, 3)[1]], color="blue", alpha=0.5)
plt.xlabel("sepal width")
plt.ylabel("petal width")

plt.subplot(4, 4, 15)
x = (_iris[2])
y = (_iris[3])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 2, 3)[0] * min(x)+prosta(_iris, 2, 3)[1],prosta(_iris, 2, 3)[0] * max(x)+prosta(_iris, 2, 3)[1]], color="blue", alpha=0.5)
plt.xlabel("petal length")
plt.ylabel("petal width")

plt.subplot(4, 4, 16)
x = (_iris[3])
y = (_iris[3])
plt.scatter(x, y, alpha=0.3)
plt.plot([min(x), max(x)], [prosta(_iris, 3, 3)[0] * min(x)+prosta(_iris, 3, 3)[1],prosta(_iris, 3, 3)[0] * max(x)+prosta(_iris, 3, 3)[1]], color="blue", alpha=0.5)
plt.xlabel("petal width")
plt.ylabel("petal width")

plt.savefig("output.png")
#plt.show()


