clear
clc

finish=12;  
kontrol=1;
while kontrol~=finish

    kontrol=menu('MENU', 'Podaj przedział [a,b]', 'Podaj przedział [c,d]','Podaj wektor [m,n]','Podaj wspolczynniki wielomianu','Podaj dokładność i ilość iteracji','Wizualizuj','Test 1','Test 2','Test 3','Test 4','Zamknij');
    switch kontrol
		case 1
            a =input('Podaj a ');
            b = input('Podaj b '); 
        case 2	
             c =input('Podaj c ');
            d= input('Podaj d '); 

		case 3
              m =input('Podaj m ');
            n= input('Podaj n '); 
		case 4
             poly = input('Podaj wielomian ');
        case 5
            acc = input('Tolerancja ');
            iter_max = input('Ilosc iteracji ');
        case 6
           Visualization(a, b, c, d, n, m, poly, acc, iter_max);
        case 7
            a=-1;b=1;c=-1;d=1;m=21;n=12;acc=eps;iter_max=100;poly=[0,0,1];
            Visualization(a, b, c, d, n, m, poly, acc, iter_max);
        case 8
            a=-10;b=10;c=-eps;d=eps;m=100;n=100;acc=eps;iter_max=100;poly=[10,21i,-21+10i,-15i];
            Visualization(a, b, c, d, n, m, poly, acc, iter_max);
        case 9 
             a=-100;b=100;c=-100;d=100;m=1000;n=1000;acc=eps;iter_max=1000;poly=[i,-i];
            Visualization(a, b, c, d, n, m, poly, acc, iter_max);
        case 10
             a=-100;b=100;c=-100;d=100;m=1000;n=1000;acc=eps;iter_max=1000;poly=[1,-1];
            Visualization(a, b, c, d, n, m, poly, acc, iter_max);
        case 11
            break

    end
end
