function[count] = IterativeMethod(a, x0, acc, iter_max)
% Funkcja odpowiada za wyznaczenie zer wielomianu:
% w(x) = a(0) + a(1) * x + a(2) * x^2 + ... + a(n-1) * x^(n-1) + Tn(x)
% metod� Czebyszewa. 
 
% Konwencja nazewnicza stworzona na potrzeby programu: 
% w_x = w(x)
% a - wsp�czynniki ai wielomianu wn
% iter_max - maksymalna zadana liczba iteracji
% x0 - dane przybli�enie pocz�tkowe
% acc - dok�adno�� z jak� funkcja wyznacza pierwiastki wielomianu w (ang. accuracy)
n = max(size(a));
dx = acc + 1;
count = 0; % liczba wykonanych iteracji 

a = fliplr(a);
da = polyder(a); % 1. pochodna wielomianu o wsp�czynnikach z a
dda = polyder(da);  % 2. pochodna wielomianu o wsp�czynnikach z a

while abs(dx) > acc && count <= iter_max 
    % do p�tli wchodzimy tak d�ugo, jak d�ugo dok�adno�� wyniku jest 
    % niesatysfakcjonuj�ca i nie wykonali�my maksymalnej liczby iteracji
    % (zat�wno po�adana dok�adno�� jak i maksymalna l. iteracji zadane s�
    % na wej�ciu)

    % Obliczenie warto�ci wielomianu, jego 1. i 2. pochodnej w punkcie x0
    w1 = Horner(a, x0);
    dw1 = Horner(da, x0);
    ddw1 = Horner(dda, x0);
    
    [w2, dw2, ddw2] = Values(n, x0);
    w = w1 + w2;
    % Wykorzystujemy fakt, �e pochodna sumy jest r�wna sumie pochodnych
    dw = dw1 + dw2;
    ddw = ddw1 + ddw2;

    if (abs(w) <= acc)
        x = x0;
        return
    end
    
    if (dw == 0)
        disp('Dzielenie przez 0!');
        return;
    end
    
    y = x0 - w/dw;
    dx = w/dw + (ddw * (y - x0)^2)/(2*dw);
    x = x0 - dx;
    x0 = x;
    count = count + 1;
end
end

