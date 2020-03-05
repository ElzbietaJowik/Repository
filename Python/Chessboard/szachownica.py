n = input("Podaj liczbe kolumn i wierszy: ")
n = int(n)

if n<=0:
    exit("Bledne dane!")
f = open("szachownica.txt", "w")

for i in range(0, n):
    for j in range (0, n):
        if (i+j) % 2 == 0:
            print("o", file = f, end="")
        else:
            print("#", file = f, end="")
    print("", file = f)
f.close
