def BinarySearch(arr, l, r, x):
    if r >= l:
        mid = (l+r)//2
        if arr[mid] == x:
            return mid
        elif arr[mid] > x:
            return BinarySearch(arr, l, mid-1, x)
        else:
            return BinarySearch(arr, mid+1, r, x)
    else:
        return -1
arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
x = int(input("x = "))
result = BinarySearch(arr, 0, len(arr)-1, x)
if result == -1:
    print("The element is not present in the array.")
else:
    print("The element is present in the array.")
