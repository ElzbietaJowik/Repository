def arcsinh(x):
    a = x
    suma = a
    granica_ilorazu = -x**2 / 4
    granica_wyrazu_zerowego = x
    granica = granica_wyrazu_zerowego # granica sumy, gdy jej jedynym elementem jest zerowy wyraz ciagu

    iloraz = ((-1) * (2*i-1)**2 * 2*i * x**2)/(4 * i**2 * (2*i+1))
    for i in range(1, n+1):
#   a1 = a * iloraz ** 1
#   a2 = a1 * iloraz = a * iloraz ** 2 
# a(i) = a(i-1) * iloraz = a * iloraz**i 
        ai = a * iloraz**i
        suma += ai 
    return suma