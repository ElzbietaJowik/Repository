n = int(input("Liczba stopni: "))
t = [0]*n
for i in range(n):
    t[i] = int(input("Wysokosc schodka: "))
    assert type(t[i]) == int

def ile_schodkow(t, n):
    licznik = 0
    additional_height = 0
    for i in range(n):
        h = t[i] + additional_height
        additional_height = 0.5*h
        if h <= 100:
            licznik += 1
        else:
            break
    return licznik


def wysokosc_pierwszego(t, n):
    for h0 in range(t[0], 101):
        h = h0
#        print(h)
# sprawdzam czy dla t[0] skoczek gdziekolwiek upadnie, jesli tak to zwracam t[0], jesli nie zwiekszam t[0] o 1 
        if h > 100:
            return h0
        else:
            for i in range(1, n):
                h = 0.5 * h + t[i]
#                print(h)
                if h > 100:
                    return h0
print(wysokosc_pierwszego(t, n))
 
# 4 schody
# 40, 60, 10, 60
# nie przewroci sie
# 81 cm
    