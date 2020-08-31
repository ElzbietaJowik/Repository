x = [-0.56047565, -0.23017749, 1.55870831, 0.07050839, 0.12928774, 1.71506499,
0.46091621, -1.26506123, -0.68685285, -0.44566197, 1.22408180, 0.35981383,
0.40077145, 0.11068272, -0.55584113, 1.78691314, 0.49785048, -1.96661716,
0.70135590, -0.47279141, -1.06782371, -0.21797491, -1.02600445, -0.72889123]
y = [-23.678758, -12.45, -3.4, 4.43, 5.5, 5.678, 16.87, 24.7, 56.8]
z = [1.1, 1.2, 1.3, 1.4]
import math
def sort(x):
    n = len(x)
    for i in range(n):
        for j in range(n-i-1):
            if not x[j]<=x[j+1]:
                x[j], x[j+1] = x[j+1], x[j]
    return x


def dziel_zaokr(x):
    n = len(x)
    dzielnik = 0
    _x = [0]*len(x)
    for i in range(len(x)):
        _x[i] = math.fabs(x[i])
    Max = max(_x) # maksymalna liczba co do wartosci bezwzglednej
    if Max < 10:
        dzielnik = 1
        for i in range(n):
            x[i] = round(x[i], 1)
    else:
        for i in range(n):
            x[i] = int(round(x[i], 0))
        i = 1
        while Max//10**i>1:
            dzielnik = 10**i
            i += 1
    return dzielnik


def unique(x):
    n = len(x)
    duplicated = False
    u = []
    for i in range(n):
        for uj in u:
            if x[i] == uj:
                duplicated = True
                break
        if not duplicated:
            list.append(u, x[i])
        duplicated = False
    return u


def stem(x):
    n = len(x)
    sort(x)
    dziel_zaokr(x)
    y = dziel_zaokr(x)
    stem = [0]*n
    leaf = [0]*n
    for i in range(n):
        stem[i] = math.fabs(x[i])//y
        leaf[i] = round(math.fabs(x[i])-y*math.fabs(stem[i]), 1)
        if leaf[i]<1:
            leaf[i] = 10*leaf[i]
        stem[i] = int(stem[i])
        leaf[i] = int(leaf[i])
    u = unique(stem)
    if len(u) == 1:
        print(str.format(" {0}"+" |", u[0]), end = " ")
        for j in range(len(x)):
            print(leaf[j], end = "")
    else:

        for i in range(len(x)):
            if x[i] < 0 and not stem[i]==stem[i-1]:
                print(str.format("-"+"{0}"+" |", stem[i]), end = " ")
                for j in range(len(x)):
                    if x[j] < 0 and stem[j] == stem[i]:
                        print(leaf[j], end = "")
                print("")

            if x[i] >= 0 and x[i-1] <= 0 and stem[i]==stem[i-1]:
                print(str.format(" "+"{0}"+" |", stem[i]), end = " ")
                for j in range(len(x)):
                    if x[j] > 0 and stem[j] == stem[i]:
                        print(leaf[j], end = "")
                print("")
            if x[i] >=0 and not stem[i] == stem[i-1]:
                print(str.format(" "+"{0}"+" |", stem[i]), end = " ")
                for j in range(len(x)):
                    if x[j] > 0 and stem[j] == stem[i]:
                        print(leaf[j], end = "")
                print("")

        

stem(x)
stem(y)
stem(z)