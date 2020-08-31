import math


liczba_elementow = 0
suma_elementow = 0
suma_kwadratow = 0

elementNajwiekszy = -math.inf # element nawiekszy ustawiamy poczatkowo na -nieskonczonosc. W ten sposob pierwszy wczytany element na pewno bedzie wiekszy                              
elementNajmniejszy = math.inf # analogicznie dla minimum ale w druga strone

with open("liczby01.txt", "r") as f:
    
    for liczba in f:
        element = float(liczba)
        liczba_elementow += 1
        suma_elementow += element
        suma_kwadratow += element**2
        if element > elementNajwiekszy:
            elementNajwiekszy = element    # szukamy maksimum
        if element < elementNajmniejszy:
            elementNajmniejszy = element   #szukamy minimum

f.close()

Srednia_arytmetyczna = suma_elementow/liczba_elementow
Wariancja = (suma_kwadratow - (suma_elementow**2)/liczba_elementow)/(liczba_elementow-1)
odchylenie_standardowe = math.sqrt(Wariancja)

with open("tabelka01.txt", "w") as fout:
    print(str.format("{0:^11s} | {1:^11s} | {2:^11s} | {3:^11s} | {4:^11s} | {5:^11s}", "srednia", "wariancja", "odchylenie", "n", "minimum", "maksimum"), file = fout)
    print("-" * (6 * 11 + 5 + 10), file = fout)
    print(str.format("{0:^11.04f} | {0:^11.04f} | {2:^11.04f} | {3:^11.04f} | {4:^11.04f} | {5:^11.04f}", Srednia_arytmetyczna, Wariancja, odchylenie_standardowe, liczba_elementow, elementNajmniejszy, elementNajwiekszy), file = fout)

fout.close()

with open("tabelka02.txt", "w") as fin:
    print(str.format("| {0:^11s} | {1:^11.04f} |", "srednia", Srednia_arytmetyczna), file = fin)
    print("-"*(2*11+4+3), file = fin)
    print(str.format("| {0:^11s} | {1:^11.04f} |", "wariancja", Wariancja), file = fin)
    print("-"*(2*11+4+3), file = fin)
    print(str.format("| {0:^11s} | {1:^11.04f} |", "odchylenie", odchylenie_standardowe), file = fin) 
    print("-"*(2*11+4+3), file = fin)
    print(str.format("| {0:^11s} | {1:^11.04f} |", "n", liczba_elementow), file = fin)
    print("-"*(2*11+4+3), file = fin)
    print(str.format("| {0:^11s} | {1:^11.04f} |", "minimum", elementNajmniejszy), file = fin)
    print("-"*(2*11+4+3), file = fin)
    print(str.format("| {0:^11s} | {1:^11.04f} |", "maksimum", elementNajwiekszy), file = fin)
    print("-"*(2*11+4+3), file = fin)

fin.close()
