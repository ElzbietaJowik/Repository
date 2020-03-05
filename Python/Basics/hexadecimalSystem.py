licznik = 0
wykladnik = -1
wartosc = 0     # wartosc wprowadzonej cyfry po przeliczeniu z systemu heksadecymalnego na dziesietny
suma = 0        # suma wartosci cyfr, ktora ostatecznie da nam wartosc wprowadzonej liczby 


while True:
    x = int(input(">"))
    licznik += 1
    wykladnik += 1
    if (x < 0 or x > 15) and licznik == 1:
        exit("Wprowadzona wartosc nie jest cyfra w systemie szesnastkowym.") 
    elif x < 0 or x > 15 or licznik >= 21:
        break
    elif x == 0: 
        wartosc = 0
        suma += wartosc
    else:
        wartosc = x * 16**wykladnik
        suma += wartosc

print("Wartosc wprowadzonej szesnastkowo liczby wynosi: ", suma, "w notacji dziesietnej")
