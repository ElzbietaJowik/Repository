def insertion_sort(t):
    for i in range(1, len(t)):
        value = t[i]
        j = i - 1
        while j >= 0:
            if value < t[j]:
                t[j+1] = t[j]
                t[j] = value
                j = j-1
            else:
                break
    return t
#	TEST
t = [1, 4, 2, 7, 5, 9, 0, 7, 8]
print(insertion_sort(t))
