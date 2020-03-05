"""
Rozwiazanie zadania 5.05
"""

# wczytanie zbioru danych: 
import csv
tips = []
f = open("tips.csv", "r") # r=do odczytu
for row in csv.reader(f):
    tips.append(row)
f.close()

n = len(tips)
m = len(tips[0])
transpozycja = [[0]*n for i in range(m)]
for i in range(n):
    for j in range(m):
        transpozycja[j][i] = tips[i][j]

total_bill = transpozycja[0]
tip = transpozycja[1]
sex = transpozycja[2]
smoker = transpozycja[3]
day = transpozycja[4]
time = transpozycja[5]
size = transpozycja[6]
for i in range(n):
    total_bill[i] = float(total_bill[i])
    tip[i] = float(tip[i])

def unique(x):
    n = len(x)
    duplicated = False
    u = []
    list.append(u, x[0])
    for i in range(1, n):
        for uj in u:
            if x[i] == uj:
                duplicated = True
                break
        if not duplicated:
            list.append(u, x[i])
        duplicated = False
    return u

sex_dict = unique(sex)
smoker_dict = unique(smoker)
day_dict = unique(day)
time_dict = unique(time)
size_dict = unique(size)

print(sex_dict)
print(smoker_dict)
print(day_dict)
print(time_dict)
print(size_dict)

def encode(x, x_dict):
    n = len(x)
    m = len(x_dict)
    out = [0]*n
    for i in range(n):
        for j in range(m):
            if x[i] == x_dict[j]:
                out[i] = j
                break
    return out

sex = encode(sex, sex_dict)
smoker = encode(smoker, smoker_dict)
day = encode(day, day_dict)
time = encode(time, time_dict)
size = encode(size, size_dict)

def split(x, y):
# len(y_dict) == max(y)+1
    output = [[] for i in range(max(y)+1)]
    for j in range(len(x)):
        list.append(output[y[j]], x[j])
    return output

def median(x, start=0, stop=None):
    n = len(x)
    sorted_x = sorted(x)
    if n == 1:
        return x[0]
    if stop is None:
        stop = n
    else:
        if start == 0 and n%2:
            stop += 1
    m = stop-start
    if m%2 != 0:
        return sorted_x[m//2+start]
    else:
        return (sorted_x[m//2-1+start]+sorted_x[m//2+start])/2

def fivenum(x):
    n = len(x)
    sorted_x = sorted(x)
    Min = sorted_x[0]
    Q1 = median(sorted_x, 0, n//2)
    Med = median(sorted_x)
    Q3 = median(sorted_x, n//2, n)
    Max = sorted_x[n-1]
    return [Min, Q1, Med, Q3, Max]

import matplotlib.pyplot as plt
import matplotlib.patches as patches

def boxplot1(x, y, y_dict, nazwa_pliku):
    # x - wektor liczbowy, czyli tip lub total_bill
    # y - wektor po wykonaniu na nim funkcji encode
    #rysuje wykresy dla len(y_dict) podgrup
    ngroup = len(y_dict)
    group = split(x,y)

    fig = plt.figure()
    ax = fig.add_subplot(111)

    ax.set_xlim([-0.5, ngroup-0.5])

    for i in range(ngroup):
        x_sorted = sorted(group[i])
        array = fivenum(x_sorted)
        n = len(x_sorted)
        if n==1:
            next
        IQR = array[3]-array[1]
        outliers = []
        outSmaller = array[1] - 1.5*IQR
        outGreater = array[3] + 1.5*IQR

        j = 0
        while x_sorted[j] < outSmaller:
            list.append(outliers, x_sorted[j])
            j += 1

        u = x_sorted[j]

        j = n-1
        while x_sorted[j] > outGreater:
            list.append(outliers, x_sorted[j])
            j -= 1

        v = x_sorted[j]

        ax.add_patch(patches.Rectangle(
        (i-0.25, array[1]),
        0.5,
        IQR,
        facecolor="0.75",
        ec = "k"
        ))
        plt.plot([i-0.25, i+0.25], [array[2], array[2]], "r")

        plt.plot([i,i], [array[3], v], "-k")
        plt.plot([i-0.25,i+0.25], [v, v], "-k")

        plt.plot([i,i], [u, array[1]], "-k")
        plt.plot([i-0.25,i+0.25], [u, u], "-k")

        if len(outliers)>0:
            plt.plot([i]*len(outliers), outliers, "kd")
    plt.xticks([i for i in range(ngroup)], y_dict)
    fig.savefig(nazwa_pliku, dpi=90)

boxplot1(total_bill, day, day_dict, "boxplot1.png")

# Rozwiązanie dr Ceny:

def boxplot2(x, y, y_dict, z, z_dict, nazwa_pliku):
    
    ngroups = len(y_dict)
    nsubgroups = len(z_dict)
    
    groups = split(x, y)
    zgroups = split(z, y)

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_xlim([-0.5, ngroups-0.5])
    
    # rysujemy boxploty dla kazdej listy:
    
    for i in range(ngroups):
        
        x = groups[i]
        subgroups = split(x, zgroups[i])
        
        # teraz dziele na grupy wzgledem drugiej zmiennej
        for k in range(nsubgroups):
            
            x_sorted = sorted(subgroups[k])
            n = len(x_sorted)
            if n == 0:    # jesli akurat nie mamy zadnych takich obserwacji
                continue  # pomijamy bo nie mozemy narysowac pustego boxplotu
                
            summary = fivenum(x_sorted)
        
            IQR = summary[3] - summary[1]
            outSmaller = summary[1] - 1.5*IQR
            outGreater = summary[3] + 1.5*IQR
        
            outliers = [] # tutaj bede przechowywac obs. odstajace
            
            # mniejsze:
            j = 0
            while x_sorted[j] < outSmaller:
                list.append(outliers, x_sorted[j])
                j += 1
            
            u = x_sorted[j]
            
            # wieksze:
            j = n-1
            while x_sorted[j] > outGreater:
                list.append(outliers, x_sorted[j])
                j -= 1
            
            v = x_sorted[j]
        
            # pudelko:
            rog = i-0.25 + k*0.25
            srodek = rog + 0.25/2

            l = ax.add_patch(patches.Rectangle((rog, summary[1]),           # (i, Q1) dolny rog pudelka
                                               0.25,                       # szerokosc pudelka 
                                               IQR,                         # wysokosc pudelka
                                               facecolor="0.75", # kolor wypelnienia pudelka
                                               ec = "k"                     # kolor linii pudelka
                                               ))
            
            # gorny was:
            plt.plot([srodek, srodek], [summary[3], v], "-k")
            plt.plot([srodek-0.125, srodek+0.125], [v, v], "-k")
            
            # dolny was:
            plt.plot([srodek, srodek], [u, summary[1]], "-k")
            plt.plot([srodek-0.125, srodek+0.125], [u, u], "-k")
            
            # dorysowujemy obserwacje odstajace jesli istnieja:
            if len(outliers) > 0:
                plt.plot([srodek]*len(outliers), outliers, "kd")
            
            # zaznaczamy mediane na pudelku jako pozioma linie:
            plt.plot([srodek-0.25/2, srodek+0.25/2], [summary[2], summary[2]], "-k")
        
    
    # ustawiam nazwy pudelek czyli etykiety na osi x
    plt.xticks([i for i in range(ngroups)], y_dict) 
    # zapisujemy do pliku
    fig.savefig(nazwa_pliku, dpi=90)

boxplot2(total_bill, day, day_dict, smoker, smoker_dict, "boxplot2.png")
boxplot2(total_bill, day, day_dict, sex, sex_dict, "boxplot3.png")
