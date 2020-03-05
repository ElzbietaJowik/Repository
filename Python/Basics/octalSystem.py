licznik = 0
wykladnik = -1
wartosc = 0     # wartosc wprowadzonej cyfry po przeliczeniu z systemu heksadecymalnego na dziesietny
suma = 0        # suma wartosci cyfr, ktora ostatecznie da nam wartosc wprowadzonej liczby 


while True:
    x = int(input(">"))
    licznik += 1
    wykladnik += 1
    if (x < 0 or x > 7) and licznik == 1:
        exit("Wprowadzona wartosc nie jest cyfra w systemie osemkowym") 
    elif x < 0 or x > 7 or licznik >= 21:
        break
    elif x == 0: 
        wartosc = 0
        suma += wartosc
    else:
        wartosc = x * 8**wykladnik
        suma += wartosc

print("Wartosc wprowadzonej heksadecymalnie liczby wynosi: ", suma, "w notacji dziesietnej")
    
