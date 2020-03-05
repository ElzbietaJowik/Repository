"""
Generator liczb pseudolosowych
"""

s = input("Podaj wartosc ziarna generatora")
s = int(s)
n = input("Podaj liczbe wartosci do wegenerowania")
n = int(n)

if n<0:
    raise Exception("n nie moze byc ujemne")

m = 2**31-1
a = 1103515245
c = 12345

f = open("liczby.txt", "w")                      #zamiast f = open("liczby.txt", "w") mozna napisac: withopen("liczby.txt", "w") as f:

for i in range(0, n):
    s = (a*s+c) % m
    print(s/m, file=f)
f.close()



