class Matrix:
    def _isnumber(x):
        return isinstance(x, int) or isinstance(x, float)
    def __init__(self, nrow, ncol, data=0):
        if not isinstance(nrow, int) or not isinstance(ncol, int):
            raise Exception("Incorrect type of variable nrow or ncol (must be int).")
        if ncol <= 0 or nrow <= 0:
            raise Exception("nrow <= 0 or ncol <= 0")

        self.__shape = [nrow, ncol]
        self.__data = [0]*(nrow*ncol)

        if Matrix._isnumber(data):
            for i in range(self.__shape[0]*self.__shape[1]):
                self.__data[i] = float(data)
        elif isinstance(data, list):
            for i in range(len(data)):
                if not isinstance(data[i], list):
                    raise Exception("Given data do not consist of lists")
            for i in range(1, len(data)):
                if not len(data[0])==len(data[i]):
                    raise Exception("Matrix rows are of inconsistent lengths.")
            if not self.__shape[1] == len(data[0]) or not self.__shape[0] == len(data):
                raise Exception("nrow != len(data) or ncol != len(data[0])")
            for i in range(len(data)):
                for j in range(len(data[0])):

                    if not Matrix._isnumber(data[i][j]):
                        raise Exception("Data elements must be of type int or float.")

                    self.__data[i*self.__shape[1]+j] = float(data[i][j])
        else:
            raise Exception("Type of data is not correct.")
    def __add__(self, other):
        ret = [[0]*self.__shape[1] for i in range(self.__shape[0])]
        n = self.__shape[0]
        m = self.__shape[1]
        if Matrix._isnumber(other):
            for i in range(n):
                for j in range(m):
                    ret[i][j] = self.__data[i+j*m]+other
        elif isinstance(other, Matrix):
            if other.__shape[0] == self.__shape[0] and other.__shape[1] == self.__shape[1]:
                for i in range(n):
                    for j in range(m):
                        ret[i][j] = self.__data[i+j*m]+other.__data[i+j*m]
            else: raise Exception("self and other shapes are different")
        else:
            raise Exception("other type is neither Matrix nor number") 
            
        return Matrix(n, m, ret)
    







