clear
clc

finish=12;  
kontrol=1;
while kontrol~=finish

    kontrol=menu('MENU', 'Wprowad� macierz A', 'Wyznacz rozk�ad UL macierzy A za pomoc� zmodyfikowanej metody Crouta', 'Oblicz wyznacznik macierzy A','Wyznacz macierz odwrotn� do A', 'Podaj macierz B i rozwi�� uk�ad r�wna� postaci AX = B','Por�wnanie wyniku odwracania z rezultatem funkcji "inv"', 'Analiza rezultatu odwracania macierzy', 'Analiza wyniku dla rozwi�zania uk�adu r�wna�', 'Test1', 'Test2', 'Test3', 'Zako�cz');

    switch kontrol
		case 1
            A=input('Podaj macierz A ');
            [a,b] = size(A);
            if a~=b || Minors(A) == 0
                disp('Wprowadzona macierz A nie spe�nia za�o�e� rozk�adu')
                kontrol = finish;
                close all
            end
         
			 
        case 2	
            [U, L] = CroutModif(A)

		case 3
             detA = Det(A)
		case 4
             invA = Inverse(A)
        case 5
              B=input('Podaj macierz B ');
            [c,d] = size(B);
            if c~=d
                disp('Wprowadzona macierz B nie spe�nia za�o�e�')
                kontrol = finish;
                close all
            end
            [X] = Equation(A,B)		
        case 6
            disp('Por�wnanie wyniku odwracania z rezultatem funkcji "inv"')
            disp('Rezultat otrzymany w wyniku wywo�ania na macierzy A naszej funkcji:')
            A1 = Inverse(A)
            disp('Rezultat otrzymany w wyniku wywo�ania na macierzy A funkcji "inv":')
            A2 = inv(A)
            disp('R�nica otrzymanych rezultat�w')
            Difference = A2 - A1

        case 7
			[wynik] = Error1(A)

        case 8	
            [wynik] = Error2(A,B)

		case 9
             Test1
		case 10
             Test2
        case 11
             Test3
		case 12
            disp('Zako�czono')
            close all;

    end
end

