function[] = Visualization(a, b, c, d, n, m, poly, acc, iter_max)

% Opis dzia³ania funkcji:
% W danym obszarze prostok¹tnym [a, b] x [c, d] tworzymy siatkê punktów
% (xk, yk),  gdzie xk nale¿y do przedzia³u [a, b] a yj do [c, d],
% xk = a + kh1, k = 0, 1, ..., n
% yj = c + jh2, j = 0, 1, ..., m
% h1 = (b-a)/n
% h2 = (d-c)/m

h1 = (b-a)/n;
h2 = (d-c)/m;
X = zeros(1, n+1); % Lista wspó³rzêdnych x punktów z siatki
Y = zeros(1, n+1); % Lista wspó³rzêdnych y punktów z siatki

for k = 0:1:n
    x = a + k*h1;
    X(k+1) = x;
end

for j = 0:1:m
    y = c + j  * h2;
    Y(j+1) = y;
end


% Tworzymy macierz A o wymiarach (n+1) x (m+1) wype³nion¹ zerami 
% lub jedynkami

A = ones(n+1, m+1);

% Dla ka¿dego z punktów siatki (xk, yj), wykonujemy obliczenia metod¹ 
% Czebyszewa przyjmuj¹c punkt xk + i * yj jako przybli¿enie pocz¹tkowe
% Wykonan¹ liczbê iteracji zapamiêtujemy w odpowiedniej komórce macierzy A

for k = 0:1:n
    for j = 0:1:m
       x0 = X(k+1) +  Y(j+1) * i;
       count = IterativeMethod(poly, x0, acc, iter_max);
       A(k+1, j+1) = count;
    end
end

% Wyœwietlamy macierz A
imagesc(A);
colormap("default");
colorbar;
% Przy czym punkty, dla których zbie¿noœæ jest wolniejsza np. 30 iteracji
% kolorujemy na czarno.

end

