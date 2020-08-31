library(igraph)
spectral_clustering <- function(X, k, M){
  
  # Funkcja wyznaczająca odległości euklidesowe, jako argument przyjmuje 
  # macierz, której wiersze odpowiadają kolejnym punktow, a kolumny współrzędnym 
  # tych punktów. Innymi słowy są to macierze postaci:
  #     [,1]  [,2]  [,3] ... [, d]
  # [1,] a1    b1    c1  ...   z1
  # [2,] b2    b2    b2  ...   z2
  #  .   .     .      .  ...   .
  #  .   .     .      .  ...   .
  #  .   .     .      .  ...   .
  # [n,] an    bn    cn  ...   zn
  # gdzie n odpowiada liczbie punktów, a d wymiarów.
  
  # EuclideanDist <- function(M){
  #   n <- dim(M)[1]
  #   r <- dim(M)[1]
  #   c <- dim(M)[2]
  #   dis <- matrix(0, nrow = n, ncol = n)
  #   
  #   for (i in 1:(r-1)) {
  #     for (j in (i+1):r) {
  #       s = 0
  #       x <- M[i, ] - M[j, ]
  #       for (l in 1:c) {
  #         s = s + (x[l])^2
  #       }
  #       dis[i, j] <- sqrt(s)
  #       dis[j, i] <- sqrt(s)
  #     }
  #   }
  #   return(dis)
  # }
  
  # My jednak skorzystamy z gotowej implementacji - 
  # funkcji dist() pochodzącej z pakietu stats.
  
  normalize <- function(x){
    return((x - min(x)) / (max(x) - min(x)))
  }
  
  
  Mnn <- function(X, M){
    # UWAGA! Zgodnie z treścią zadania zakładamy, że odległości się nie powtarzają!
    EuclideanDistance <- dist(X, method = "euclidean")
    #  class(EuclideanDistance) # dist! - do dalszych przekształceń musimy 
    # zamienić obiekt klasy dist na obiekt klasy matrix
    EuclideanDistance <- as.matrix(EuclideanDistance)
    #  class(EuclideanDistance) # matrix
    
    EuclideanDistance <- normalize(EuclideanDistance)
    # zera zamienic na NA, bo element nie może być bliski samemu sobie
    diag(EuclideanDistance) = NA
    # robimy sort_per... dla pierwszej kol macierzy i tworzymy macierz,
    # żeby miec obiekt, do którego będziemy mogli "doklejać"
    sort_permutation <- order(EuclideanDistance[1, ], decreasing = FALSE)
    
    S <- matrix(sort_permutation[1:M], nrow = 1)
    
    for (j in 2:dim(EuclideanDistance)[1]) {
      sort_permutation <- order(EuclideanDistance[j, ])
      S <- rbind(S, matrix(sort_permutation[1:M], nrow = 1))
    }
    return(S)
  }
  # Poniżej znajduje się alternatywna implementacja dotychczas zaimplementowanego 
  # fragmentu algorytmu spektralnego, tym razem z wykorzystaniem samodzielnej 
  # implementacji funkcji wyznaczającej odległość Euklidesową. 
  # Jak wykazała analiza wykonana za pomocą dplyr::all_equals()
  # funkcje Mnn() i Mnn_1() działają równoważnie! 
  # Co istotne, z punktu widzenia implementacji, są one do siebie bliźniaczo podobne
  
  # Mnn_1 <- function(X, M){
  #   stopifnot(M < dim(X)[1])
  #   # UWAGA! Zgodnie z treścią zadania zakładamy, że odległości się nie powtarzają!
  #   EuclideanDistance <- EuclideanDist(as.matrix(X)) # wbudowana funkcja distance! Można?
  #   
  #   EuclideanDistance <- normalize(EuclideanDistance)
  
  # for (i in 1:dim(EuclideanDistance)[1]) { # dim(...)[1] == dim(...)[2] bo nrow == ncol
  #       EuclideanDistance[i, i] = NA
  #     }
  #   diag(EuclideanDistance) = NA
  
  #   sort_permutation <- order(EuclideanDistance[1, ], decreasing = FALSE)
  #   
  #   S <- matrix(sort_permutation[1:M], nrow = 1)
  #   
  #   for (j in 2:dim(EuclideanDistance)[1]) {
  #     sort_permutation <- order(EuclideanDistance[j, ])
  #     S <- rbind(S, matrix(sort_permutation[1:M], nrow = 1))
  #   }
  #   return(S)
  # }
  
  # Argumentem funkcji Mnn_graph jest macierz wygenerowana za pomocą funkcji Mnn() 
  S <- Mnn(X, 5)
  
  
  # UWAGA! Zakładamy, że punkt nie jest swoim własnym sąsiadem
  
  Mnn_graph <- function(S){
    n <- dim(S)[1] # punktów jest tyle, ile wierszy macierzy S
    G <- matrix(0, ncol = n, nrow = n) # generujemy macierz n x n wypełnioną zerami,
    # następnie iterujemy po tej macierzy i w odpowiednie miejsca
    # dostawiamy jedynki
    for (i in 1:dim(S)[1]) {
      for (j in 1:dim(S)[2]){
        l <- S[i, j] # druga wspólrzędna najbliższych sąsiadów
        G[i, l] <- 1 # pierwsza to nr wiersza, w którym znajduje się dany punkt
        G[l, i] <- 1 # alternatywa: l-ty punkt jest najbliższym sąsiadem i-tego lub i-ty l-tego -> graf nieskierowany
      }
    }
    
    G_graph <- graph.adjacency(G, mode = "undirected")
    details <- groups(components(G_graph)) # otrzymujemy liste, ktora zawiera listy z elementami z każdej składowej
    # implementacja algorytmu badającego spójność i znajdującego składowe spójne wymagałaby implementacji stosu
    # i byłaby dość złożona, dlatego skorzystamy z biblioteki igraph
    if (length(details) != 1){ # uspójnienie grafu, jeśli jest tylko jedna lista wewnątrz otrzymanej listy to znaczy,
      # że jest tylko jedna składowa -> graf jest spójny.
      for (i in 1:(length(details)-1)) {
        G[details[[i]][1], details[[i+1]][1]] <- 1
        G[details[[i+1]][1], details[[i]][1]] <- 1
      }
    }
    
    return(G)
  }
  
  G <- Mnn_graph(S)
  
  # dodatkowe sprawdzenie poprawności procesu uspójniania grafu:
  # isSymmetric.matrix(G) 
  # components(graph.adjacency(G))
  
  Laplacian_eighen <- function(G, k){
    
    n <- dim(G)[1]
    # 1. wyznaczam macierz diagonalną D
    D <- matrix(0, nrow = n, ncol = n)
    
    for (i in 1:n) {
      D[i, i] <- sum(G[i, ])    
    }
    
    L <- D-G
    eig <- eigen(L)
    values <- eig$values
    vectors <- eig$vectors
    m <- length(values)
    # eigen <- funkcja wyznaczająca wektory i wartości własne macierzy
    # indeksy największych k najwiekszych wart. własnych od 2 do k+1
    # $values <- a vector containing the p eigenvalues of x, sorted in decreasing order
    # $vectors <- a matrix whose columns contain the p eigenvalues of x
    # CRAN: The eigenvalues are always returned in decreasing order, and each column of vectors CORRESPONDS to the elements in values.
    E <- vectors[, (m-1)]
    for (i in (m-2):(m-k-1)) {
      E <- cbind(E, vectors[, i])    
    }
    return(as.matrix(E))
  }
  
  
  E <- Laplacian_eighen(G, k)
  k_means <- kmeans(E, k, nstart = 100)
  return(k_means$cluster)
}

