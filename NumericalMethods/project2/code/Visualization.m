function[] = Visualization(a, b, c, d, n, m, poly, acc, iter_max)

% Opis dzia�ania funkcji:
% W danym obszarze prostok�tnym [a, b] x [c, d] tworzymy siatk� punkt�w
% (xk, yk),  gdzie xk nale�y do przedzia�u [a, b] a yj do [c, d],
% xk = a + kh1, k = 0, 1, ..., n
% yj = c + jh2, j = 0, 1, ..., m
% h1 = (b-a)/n
% h2 = (d-c)/m

h1 = (b-a)/n;
h2 = (d-c)/m;
X = zeros(1, n+1); % Lista wsp�rz�dnych x punkt�w z siatki
Y = zeros(1, n+1); % Lista wsp�rz�dnych y punkt�w z siatki

for k = 0:1:n
    x = a + k*h1;
    X(k+1) = x;
end

for j = 0:1:m
    y = c + j  * h2;
    Y(j+1) = y;
end


% Tworzymy macierz A o wymiarach (n+1) x (m+1) wype�nion� zerami 
% lub jedynkami

A = ones(n+1, m+1);

% Dla ka�dego z punkt�w siatki (xk, yj), wykonujemy obliczenia metod� 
% Czebyszewa przyjmuj�c punkt xk + i * yj jako przybli�enie pocz�tkowe
% Wykonan� liczb� iteracji zapami�tujemy w odpowiedniej kom�rce macierzy A

for k = 0:1:n
    for j = 0:1:m
       x0 = X(k+1) +  Y(j+1) * i;
       count = IterativeMethod(poly, x0, acc, iter_max);
       A(k+1, j+1) = count;
    end
end

% Wy�wietlamy macierz A
imagesc(A);
colormap("default");
colorbar;
% Przy czym punkty, dla kt�rych zbie�no�� jest wolniejsza np. 30 iteracji
% kolorujemy na czarno.

end

