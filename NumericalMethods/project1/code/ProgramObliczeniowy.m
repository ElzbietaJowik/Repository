clear
clc

finish=12;  
kontrol=1;
while kontrol~=finish

    kontrol=menu('MENU', 'WprowadŸ macierz A', 'Wyznacz rozk³ad UL macierzy A za pomoc¹ zmodyfikowanej metody Crouta', 'Oblicz wyznacznik macierzy A','Wyznacz macierz odwrotn¹ do A', 'Podaj macierz B i rozwi¹¿ uk³ad równañ postaci AX = B','Porównanie wyniku odwracania z rezultatem funkcji "inv"', 'Analiza rezultatu odwracania macierzy', 'Analiza wyniku dla rozwi¹zania uk³adu równañ', 'Test1', 'Test2', 'Test3', 'Zakoñcz');

    switch kontrol
		case 1
            A=input('Podaj macierz A ');
            [a,b] = size(A);
            if a~=b || Minors(A) == 0
                disp('Wprowadzona macierz A nie spe³nia za³o¿eñ rozk³adu')
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
                disp('Wprowadzona macierz B nie spe³nia za³o¿eñ')
                kontrol = finish;
                close all
            end
            [X] = Equation(A,B)		
        case 6
            disp('Porównanie wyniku odwracania z rezultatem funkcji "inv"')
            disp('Rezultat otrzymany w wyniku wywo³ania na macierzy A naszej funkcji:')
            A1 = Inverse(A)
            disp('Rezultat otrzymany w wyniku wywo³ania na macierzy A funkcji "inv":')
            A2 = inv(A)
            disp('Ró¿nica otrzymanych rezultatów')
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
            disp('Zakoñczono')
            close all;

    end
end

