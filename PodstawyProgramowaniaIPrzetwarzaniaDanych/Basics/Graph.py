import math
import matplotlib.pyplot as plt
class Graph:

    def __init__(self, edges):
        """
        Jako argument przyjmuje 
        liste wierzcholkow grafu
        """
        assert isinstance(edges, list) # poprawnosc struktury argumentu
        n = len(edges)
        for i in range(n):
            assert isinstance(edges[i], list)
        
        def duplicated(lista):
            x = []
            x.append(lista[0])
            flag = False
            for el in lista:
                for i in range(len(x)):
                    if x[i] == el:
                        flag = True
                if not flag:
                    x.append(el)
                flag = False

            return x

        points = []
        for i in range(n):
            edges[i] = duplicated(edges[i]) #pom. dwoma wierzcholkami wyst. jedna krawedz skierowana
            m = len(edges[i])
            _points = []
            for j in range(m):
                if edges[i][j] != i: # wierzcholki nie moga wskazywac same na siebie
                    _points.append(edges[i][j])
            points.append(_points)

        k = len(points)
        wierzcholki = [i for i in range(k)] # lista istniejacych wierzcholkow
        for i in range(k):
            for j in range(len(points[i])):
                assert points[i][j] in wierzcholki

        self.__edges = points

    def __len__(self):
        return len(self.__edges)
    
    def get_edges(self):
        return self.__edges
    
    def add_vertex(self):
        """
        dodaje do grafu wierzcholek
        """
        self.__edges.append([])
    
    def add_edge(self, v1, v2):
        """
        dodaje do grafu krawedz od v1 do v2
        """
        n = len(self.__edges)
        wierzcholki = [i for i in range(n)]
        assert v1>=0 and v1<self.__edges.__len__()
        assert v2>=0 and v2<self.__edges.__len__()

        if v1 == v2:
            raise Exception("Krawedz nie moze laczyc tych samych punktow. ")
        
        if v2 in self.__edges[v1]:
            raise Exception("Podana krawedz juz wystepuje. ")
        
        self.__edges[v1].append(v2)
    
    def plot(self):
        """
        rysuje graf
        """
        liczba=self.__edges.__len__()
        fig = plt.figure()
        ax = fig.add_subplot(111)

        ax.set_xlim([-1, 1]) # zakres wartości na osi OX
        ax.set_ylim([-1, 1]) # zakres wartości na osi OY
        x=[0]*liczba
        y=[0]*liczba
        for i in range(liczba):
            x[i]=math.sin((2*math.pi*i)/liczba)
            y[i]=math.cos((2*math.pi*i)/liczba)
        
        """
        rysowanie punktów
        """
        plt.scatter(x,y)
        
        """
        podpisywanie punktów
        """
       

        for i in range(liczba):
            ax.text(1.2*x[i], 1.2*y[i], str(i), horizontalalignment="center", verticalalignment="center")
        
        x0 = x[0]; y0 = y[0]; dx = x[4]-x[0]; dy = y[4]-y[0]
        
        """
        rysowanie strzałek
        """
        for i in range(self.__edges.__len__()):
            for j in range(len(self.__edges[i])):
                x0=x[i]
                y0=y[i]
                dx=x[self.__edges[i][j]]-x[i]
                dy=y[self.__edges[i][j]]-y[i]
                plt.arrow(x0, y0, dx, dy, head_width=0.07, head_length=0.15, fc="k",
length_includes_head=True)
        ax.axis("off") # nie rysuj osi
        ax.axis("equal") # OX i OY proporcjonalne
        plt.show()
        


G2 = Graph([[2],[3],[4],[5],[6],[0],[1]])
print(G2.get_edges())
G2.plot()






        





