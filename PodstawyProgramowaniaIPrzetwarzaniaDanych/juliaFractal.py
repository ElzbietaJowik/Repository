import math
import numpy
from PIL import Image

class Complex:
    def __init__(self, re, im=0):
        assert isinstance(re, int) or isinstance(re, float)
        assert isinstance(im, int) or isinstance(im, float)
        
        self.__re = float(re)
        self.__im = float(im)

    def __repr__(self):
        return str.format("{0}"+" + "+"{1}i", self.__re, self.__im)

    def __add__(self, z):
        if isinstance(z, Complex):
            rzeczywista = self.__re + z.__re
            urojona = self.__im + z.__im
            return Complex(rzeczywista, urojona)

        elif isinstance(z, int) or isinstance(z, float):
            return Complex(float(self.__re+z), self.__im)
        else:
            raise Exception("Wrong data type. ")
    
    def __mul__(self, z):
        if isinstance(z, Complex):
            rzeczywista = self.__re*z.__re-self.__im*z.__im
            urojona = self.__re*z.__im+self.__im*z.__re
            return Complex(rzeczywista, urojona)
        elif isinstance(z, int) or isinstance(z, float):
            return Complex(float(self.__re*z), float(self.__im*z))
        else:
            raise Exception("Wrong data type. ")
    
    def abs2(self):
        return self.__re**2 + self.__im**2

def _pixel_julii(p, c, max_iter):
    assert isinstance(p, Complex)
    z0 = p

    for i in range(max_iter):
        z = z0*z0 + c
        z0 = z

        if math.sqrt(z.abs2()) >= 2:
            return (i+1)/max_iter

    return 0


def julia(x=(-1.5, 1.5), y=(-1, 1), c=Complex(-0.70176, -0.3842), max_iter=10, N=1000):

    xseq = [0]*(N)
    yseq = [0]*(N)
    dx = (x[1]-x[0])/(N-1)
    dy = (y[1]-y[0])/(N-1)
    J = [[None]*N for i in range(N)]

    for i in range(N):
        xseq[i] = x[0]+i*dx
        yseq[i] = y[0]+i*dy

    for i in range(N):
        for j in range(N):
            J[i][j] = _pixel_julii(p=Complex(xseq[i], yseq[j]), c=c, max_iter=max_iter)


    return J

result1 = julia(c=Complex(-0.73, 0.19), max_iter=10)
Image.fromarray((numpy.array(result1)*255).astype(numpy.int8), 'L').show()

        
        

