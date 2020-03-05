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
         
col = ["red", "blue", "green"]

# Centroid
centroid = [[0]*4 for i in range(3)]
for j in range(50):
    centroid[0][0] += (_iris[0][j])/50
    centroid[0][1] += (_iris[1][j])/50
    centroid[0][2] += (_iris[2][j])/50
    centroid[0][3] += (_iris[3][j])/50
for j in range(50, 100):
    centroid[1][0] += (_iris[0][j])/50
    centroid[1][1] += (_iris[1][j])/50
    centroid[1][2] += (_iris[2][j])/50
    centroid[1][3] += (_iris[3][j])/50
for j in range(100, 150):
    centroid[2][0] += (_iris[0][j])/50
    centroid[2][1] += (_iris[1][j])/50
    centroid[2][2] += (_iris[2][j])/50
    centroid[2][3] += (_iris[3][j])/50

print(centroid)
import matplotlib.pyplot as plt
plt.figure(figsize=[16, 16], dpi=72)
x = (_iris[0])
y = (_iris[0])
plt.xlabel("sepal length")
plt.ylabel("sepal length")

plt.subplot(4, 4, 1)
for i in range(50):
    x = (_iris[0][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[0][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[0][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][0], centroid[0][0], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][0], centroid[1][0], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][0], centroid[2][0], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal length")
plt.ylabel("sepal length") 

plt.subplot(4, 4, 2)
for i in range(50):
    x = (_iris[1][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[1][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[1][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][1], centroid[0][0], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][1], centroid[1][0], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][1], centroid[2][0], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal width")
plt.ylabel("sepal length") 

plt.subplot(4, 4, 3)
for i in range(50):
    x = (_iris[2][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[2][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[2][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][2], centroid[0][0], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][2], centroid[1][0], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][2], centroid[2][0], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal length")
plt.ylabel("sepal length") 

plt.subplot(4, 4, 4)
for i in range(50):
    x = (_iris[3][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[3][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[3][i])
    y = (_iris[0][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][3], centroid[0][0], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][3], centroid[1][0], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][3], centroid[2][0], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal width")
plt.ylabel("sepal length") 

plt.subplot(4, 4, 5)
for i in range(50):
    x = (_iris[0][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[0][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[0][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][0], centroid[0][1], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][0], centroid[1][1], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][0], centroid[2][1], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal length")
plt.ylabel("sepal width") 

plt.subplot(4, 4, 6)
for i in range(50):
    x = (_iris[1][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[1][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[1][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][1], centroid[0][1], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][1], centroid[1][1], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][1], centroid[2][1], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal width")
plt.ylabel("sepal width") 

plt.subplot(4, 4, 7)
for i in range(50):
    x = (_iris[2][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[2][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[2][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][2], centroid[0][1], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][2], centroid[1][1], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][2], centroid[2][1], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal length")
plt.ylabel("sepal width") 

plt.subplot(4, 4, 8)
for i in range(50):
    x = (_iris[3][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[3][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[3][i])
    y = (_iris[1][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][3], centroid[0][1], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][3], centroid[1][1], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][3], centroid[2][1], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal width")
plt.ylabel("sepal width") 

plt.subplot(4, 4, 9)
for i in range(50):
    x = (_iris[0][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[0][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[0][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][0], centroid[0][2], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][0], centroid[1][2], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][0], centroid[2][2], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal length")
plt.ylabel("petal length")
 
plt.subplot(4, 4, 10)
for i in range(50):
    x = (_iris[1][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[1][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[1][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][1], centroid[0][2], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][1], centroid[1][2], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][1], centroid[2][2], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal width")
plt.ylabel("petal length")

plt.subplot(4, 4, 11)
for i in range(50):
    x = (_iris[2][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[2][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[2][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][2], centroid[0][2], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][2], centroid[1][2], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][2], centroid[2][2], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal length")
plt.ylabel("petal length")

plt.subplot(4, 4, 12)
for i in range(50):
    x = (_iris[3][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[3][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[3][i])
    y = (_iris[2][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][3], centroid[0][2], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][3], centroid[1][2], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][3], centroid[2][2], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal width")
plt.ylabel("petal length")

plt.subplot(4, 4, 13)
for i in range(50):
    x = (_iris[0][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[0][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[0][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][0], centroid[0][3], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][0], centroid[1][3], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][0], centroid[2][3], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal length")
plt.ylabel("petal width")

plt.subplot(4, 4, 14)
for i in range(50):
    x = (_iris[1][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[1][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[1][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][1], centroid[0][3], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][1], centroid[1][3], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][1], centroid[2][3], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("sepal width")
plt.ylabel("petal width")

plt.subplot(4, 4, 15)
for i in range(50):
    x = (_iris[2][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[2][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[2][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][2], centroid[0][3], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][2], centroid[1][3], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][2], centroid[2][3], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal length")
plt.ylabel("petal width")

plt.subplot(4, 4, 16)
for i in range(50):
    x = (_iris[3][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[0], alpha=0.3)
for i in range(50, 101):
    x = (_iris[3][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[1], alpha=0.3)
for i in range(101, 150):
    x = (_iris[3][i])
    y = (_iris[3][i])
    plt.scatter(x, y, color=col[2], alpha=0.3)
plt.plot(centroid[0][3], centroid[0][3], markersize=15, color=col[0], marker="o", linestyle="") 
plt.plot(centroid[1][3], centroid[1][3], markersize=15, color=col[1], marker="o", linestyle="") 
plt.plot(centroid[2][3], centroid[2][3], markersize=15, color=col[2], marker="o", linestyle="") 
plt.xlabel("petal width")
plt.ylabel("petal width")
 
plt.savefig("_output.png")
