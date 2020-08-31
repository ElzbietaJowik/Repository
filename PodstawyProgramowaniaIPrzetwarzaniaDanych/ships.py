import random

def czy_mozna(plansza, x, y, dlugosc):
    n = len(plansza)
    for i in range(x-1, x+2):
        for j in range(y-1, y+dlugosc):
            if i >= 0 and i <= n-1 and j >= 0 and j <= n-1:
                if plansza[j][i] != 0:
                    return False
            else:
                return False
                
    return True


def stworz_plansze(n=10, liczba=6, maxiter=25):
    plansza = [[0]*n for i in range(n)]
    
    for i in range(liczba):
        dlugosc = random.randint(1, 4)
        for j in range(maxiter):
            x = random.randint(0, n-1)
            y = random.randint(0, n-1)

            if czy_mozna(plansza, x, y, dlugosc):
                for k in range(y, y+dlugosc):
                    plansza[k][x] = 1
                break
    return plansza


def odkryj_pole(plansza, x, y):

    if plansza[x][y] == 0:
        plansza[x][y] = 2
    elif plansza[x][y] == 1:
        plansza[x][y] = 3

    return plansza

def czy_wszystkie_trafione(plansza):
    n = len(plansza)
    for i in range(n):
        for j in range(n):
            if plansza[i][j] == 1:
                return False
    return True

def wypisz(A):
    n = len(A)
    # wypisanie numerow kolumn planszy
    for k in range(n):
        if k == 0: print(str.format("{0:^4s}", " "), end="")
        print(str.format("{0:^3s}", str(k)), end="")
    print("\n"+"-"*(n*3+4))
    
    
    for i in range(n):
        for j in range(n):
            # wypisanie numerow wierszy planszy
            if j == 0: print(str.format("{0:^3s}|", str(i)), end=" ") 
            
            # wypisanie pol:
            # ' ' gdy pole nie jest odkryte
            if A[i][j] == 1 or A[i][j] == 0:
                print(" ", end =" "*2)
            else:
                # 'o' pole odkryte bez statku
                if A[i][j] == 2:
                    print("o", end = " "*2)
                # 'x' pole odkryte zawierajace fragment statku
                else:
                    print("x", end = " "*2)
            
        print("\n") 


def gra(n=10, maxiter=10):
    liczba = 6 # przykladowa maksymalna ilosc statkow
    plansza = stworz_plansze(n, liczba, maxiter)

    while True:
        if not czy_wszystkie_trafione(plansza):
            x = int(input("Numer wiersza: "))
            y = int(input("Numer kolumny: "))


            odkryj_pole(plansza, x, y)
            wypisz(plansza)
        else:
            print("Koniec gry! Zatopiles wszystkie statki. ")
            break

gra(10, 10)







