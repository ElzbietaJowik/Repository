import random
def stworz_plansze(n, liczba, maxiter):
    plansza = [[0]*n for i in range(n)] # stworzenie planszy

    for i in range(liczba):
        for j in range(maxiter):
            x = random.randint(0, n-1) # wylosowanie wspolrzednych min
            y = random.randint(0, n-1)
            if plansza[y][x] != 9: # umieszczenie min
                plansza[y][x] = 9
                break
    return plansza

def liczba_min(plansza):
    n = len(plansza)
    for i in range(n):
        for j in range(n):
            if plansza[i][j] != 9:
                for k in range(i-1, i+2):
                    for l in range(j-1, j+2):
                        if k >= 0 and k < n and l >= 0 and l < n:
                            if plansza[k][l] == 9:
                                plansza[i][j] += 1
    return plansza

def ile_min(plansza):
    licznik = 0
    for i in range(n):
        for j in range(n):
            if plansza[i][j] == 9:
                licznik += 1
    return licznik


def odkryj_pole(x, y, plansza, pola_odkryte):
    n = len(plansza)
    pola_odkryte[x][y] = True
    if plansza[x][y] == 9 and x >= 0 and x < n and y >= 0 and y < n:
        return True
    else:
        return False

def wypisz(plansza, pola_odkryte):
    n = len(plansza)
    
    # wypisanie numerow kolumn planszy
    for k in range(n):
        if k == 0: print(str.format("{0:^3s}|", " "), end="")
        print(str.format("{0:^3s}", str(k)), end="")
    print("\n"+"-"*(n*3+4))
    
    # wypisanie stanu planszy:
    for i in range(n):     # petla po wierszach
        for j in range(n): # petla po kolumnach
            # wypisywanie numerow wierszy
            if j == 0: print(str.format("{0:^3s}|", str(i)), end=" ") 
            # jesli pole nie jest odkryte wypisz ' '
            if pola_odkryte[i][j] == False:
                print(" ", end = " "*2)
            else:
                # jesli pole jest odkryte i nie zawiera miny wypisz jego wartosc
                if plansza[i][j] != 9:
                    print(str.format("{0}", plansza[i][j]), end = " "*2)
                # jesli pole jest odkryte i zawiera mine wypisz 'x'
                else:
                    print("x", end = " "*2)        
        print("\n")

def gra(n=10, liczba=10, maxiter=25):
    plansza = stworz_plansze(n, liczba, maxiter)
    liczba_min(plansza)
    pola_odkryte = [[False]*n for i in range(n)]
    wszystkie_odkryte = True
    while True:
        for i in range(n):
            if wszystkie_odkryte is True:
                for j in range(n):
                    if pola_odkryte[i][j] != True and plansza[i][j] != 9:
                        wszystkie_odkryte = False

        if not wszystkie_odkryte:
            wszystkie_odkryte = True
            x = int(input("Numer kolumny: "))
            y = int(input("Numer wiersza: "))
            odkryj_pole(x, y, plansza, pola_odkryte)
            wypisz(plansza, pola_odkryte)
            if plansza[x][y] == 9:
                print("Koniec gry! Na odkrytym polu znajduje sie mina. ")
                return
        else:
            print("Koniec gry! Wszystkie pola zostaly odkryte. ")
            return
            

gra(10, 10, 25)