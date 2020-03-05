function [t,dt, ddt] = Values(n,x)
% Funkcja s³u¿y do obliczania wartoœci wielomianu T_n oraz jego pochodnych
% w punkcie x, z wykorzystaniem zwi¹zku rekurencyjnego spe³nianego przez 
% wielomiany Czebyszewa.

% Funkcja zwraca:
% t = Tn(x)
% dt = Tn'(x)
% ddt = Tn''(x)

% Wiadomo, ¿e:
% T0(x) = 1, 
% T1(x) = x,
% Tk(x) = 2x * T_k-1(x) + T_k-2(x)

% Wyznaczenie wektorów t, dt i ddt t.¿e: 
% t(i) = Ti(x)
% dt(i) = Ti'(x)
% ddt(i) = Ti''(x)

t = zeros(n);
dt = zeros(n); 
ddt = zeros(n);

t(1) = x;
t(2) = 2 * x^2 - 1;
dt(1) = 1;
dt(2) = 4 * x;
ddt(1) = 1;
ddt(2) = 4;

for i = 3:1:n
    t(i) = 2*x * t(i-1) - t(i-2);
    dt(i) = 2 * dt(i-1) + 2 * x * dt(i-1) - t(i-2);
    ddt(i) = 4 * dt(i-1) + 2 * x * ddt(i-1) - ddt(i-2);
end

t = t(n);
dt = dt(n);
ddt = ddt(n);

end

