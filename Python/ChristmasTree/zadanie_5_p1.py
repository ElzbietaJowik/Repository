import random
import math
import matplotlib.patches as patches
import matplotlib.pyplot as plt

def generate_fractal(n=int(1e5)):
    """
    Funkcja, która losuje przeksztalcenia z okreslonymi prawdopodobienstwami oraz
    dokonuje tych przeksztalcen, a także przeskalowuje otrzymane wartosci tak, aby 
    rysunek miescil sie w kwadracie [0, 1]**2
    """
    x = 0
    y = 0
    Z = [[] for i in range(2)]
    list.append(Z[0], x)
    list.append(Z[1], y)
    # losuje liczbe calkowita z przedzialu od 0-1
    # jesli wylosuje liczbe z przedzialu [0-0.32] to wylosowano 1. przeksztalcenie
    # jesli wylosuje liczbe z przedzialu (0.32-0.64] to wylosowano 2. przeksztalcenie
    # jesli wylosuje liczbe z przedzialu (0.64-0.96] to wylosowano 3. przeksztalcenie
    # jesli wylosuje liczbe z przedzialu (0.96-1], to wylosowano 4. przeksztalcenie
    for i in range(1, n):
        rand = random.uniform(0, 1)
        if rand <= 0.32:
            x = -0.67*Z[0][i-1]-0.02*Z[1][i-1]
            y = -0.18*Z[0][i-1]+0.81*Z[1][i-1]+10
        elif rand > 0.32 and rand <= 0.64:
            x = 0.4*Z[0][i-1]+0.4*Z[1][i-1]
            y = -0.1*Z[0][i-1]+0.4*Z[1][i-1]
        elif rand > 0.64 and rand <= 0.96:
            x = -0.4*Z[0][i-1]-0.4*Z[1][i-1]
            y = -0.1*Z[0][i-1]+0.4*Z[1][i-1]
        else:
            x = 0.1*Z[0][i-1]
            y = 0.44*Z[0][i-1]+0.44*Z[1][i-1]-2
        list.append(Z[0], x)
        list.append(Z[1], y)
    xmin = min(Z[0])
    xmax = max(Z[0])
    ymin = min(Z[1])
    ymax = max(Z[1])
    for i in range(n):
        Z[0][i] = (Z[0][i]+math.fabs(xmin))/(math.fabs(xmin)+xmax)
        Z[1][i] = (Z[1][i]+math.fabs(ymin))/(math.fabs(ymin)+ymax)
    return Z

n = int(1e5)
Z = generate_fractal(n)
x = Z[0] # lista [x_0, x_1, ...] wspolrzednych x-owych punktow (x_i, y_i)
y = Z[1] # lista [y_0, y_1, ...] wspolrzednych y-owych punktow (x_i, y_i)
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
ax.scatter(x, y, marker=".", s = 1, color = "forestgreen")
fig.savefig("zadanie_5_p1_points.png")

random.seed(123)
n = int(1e5)
Z = generate_fractal(n)
x = Z[0]
y = Z[1]

def find_box_id(x,y,eps):
    # ile kwadratow o wym. eps x eps zmiesci sie w planszy
    # szerokosc prawego skrajnego kwadratu: 1-m*eps (lub ew wysokosc gornego skrajnego)
    boxes = []
    m = math.floor(1/eps)
    for i in range(0, m):
        for j in range(n):
            if x[j] >= i*eps and x[j] <= (i+1)*eps:
                for k in range(0, m):
                    if y[j] >= k*eps and y[j] <= (k+1)*eps:
                        list.append(boxes, [i*eps, k*eps])
                        break
    # jesli 1/eps nie jest liczba calkowita...
    if m*eps < 1:
        for j in range(n):
            if x[j] >= 1-(1-m*eps):
                if y[j] >= 1-(1-m*eps):
                    list.append(boxes, [m+1, m+1])
                else:
                    for k in range(0, m):
                        if y[j] >= k*eps and y[j] <= (k+1)*eps:
                            list.append(boxes, [m+1,k*eps])
            elif y[j] >= 1-(1-m*eps):
                    if x[j] >= 1-(1-m*eps):
                        list.append(boxes, [m+1, m+1])
                    else:
                        for k in range(0, m):
                            if x[j] >= k*eps and x[j] <= (k+1)*eps:
                                list.append(boxes, [k*eps,m+1])
                    
    return boxes

eps = 0.13
boxes = find_box_id(x, y, eps)
def unique_boxes(boxes):
    duplicated = False
    u = []
    list.append(u, boxes[0])
    for i in range(len(boxes)):
        for uj in u:
            if boxes[i] == uj:
                duplicated = True
                break
        if not duplicated:
            list.append(u, boxes[i])
        duplicated = False
    return len(u)


def fractal_dimension(x, y, eps):
    l = find_box_id(x,y,eps)
    licz = unique_boxes(l)
    licznik = math.log(licz, 10)
    mianownik = math.log(1/eps, 10)
    return licznik/mianownik

epss = []
dims = []
for i in range(5, 101, 5):
    i = i/1000
    list.append(epss, i)

for j in range(len(epss)):
    print(1)
    dim = fractal_dimension(x,y,epss[j])
    list.append(dims, dim)
    print(dims)


fig = plt.figure(2)
ax = fig.add_subplot(111)
ax.set_xlim([-0.01, 0.11]) # zakres wartości na osi OX
ax.scatter(epss, dims)
fig.savefig("zadanie_5_p1_dimension.png")
"""
fraktal = generate_fractal(int(1e6))
X = fraktal[0]
Y = fraktal[1]
colors = ["firebrick", "coral", "magenta", "indianred", "orange"]*6

fig = plt.figure(3)
ax = fig.add_subplot(1, 1, 1, facecolor='midnightblue')
ax.set_xlim([-0.1, 1.1])
ax.set_ylim([-0.1, 1.1])

# choinka
ax.scatter(X, Y, marker=".", s = 1, color = "forestgreen")
# Czubek choinki == punkt o najwiekszej wspolrzednej y
czubek = -math.inf
for i in range(len(Y)):
    if Y[i] >= czubek:
        czubek = Y[i]
        i_star = i
ax.scatter(X[i_star], Y[i_star], marker="*", s = 500, color = "gold")
ax.scatter(random.sample(X, 20), random.sample(Y, 20), marker="o", s=200, color=random.sample(colors, 20))
for i in range(500):
    ax.scatter(random.uniform(-0.1, 1.1), random.uniform(-0.1, 1.1), marker="o", s = 10, color = "ivory", alpha=0.6)

fig.savefig("zadanie_5_p1_choinka.jpg", dpi=90)
"""