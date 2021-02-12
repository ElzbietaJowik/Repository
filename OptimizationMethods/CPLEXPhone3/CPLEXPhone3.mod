/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 25 lis 2020 at 09:54:45
 
 Produkujemy dwa typy telefon�w 'Desk' i 'Cell'. 
 Produkcja ta sk�ada si� z dw�ch etap�w:
 	1) sk�adania z cz�ci
 	2) malowania
 |etap\model|	Desk	|	Cell	|
 |   Etap1  |   12 min  |   24 min  |
 |   Etap2  |   30 min  |   24 min  |
 Linie produkcyjne s� dzier�awione i mamy dost�p:
 	400 godzin na linii pierwszej
 	490 godzin na linii drugiej
Powinni�my wyprodukowa� co najmniej 200 telefon�w
typu 'Desk' i 100 sztuk typu 'Cell'.
  	
Zysk na poszczeg�lnych modelach to:
 	12$/szt. dla modelu 'Desk'
 	20$/szt. dla modelu 'Cell'

Ile telefon�w typ�w 'Desk' i 'Cell' powinni�my 
wyprodukowa�, aby sumaryczny zysk by� najwi�kszy.
 *********************************************/

 {string} Products = ...; 	   // modele telefon�w
 dvar float+ production[Products];
 float Atime[Products] = ...;  // czasy sk�adania poszczeg�lnych modeli
 float Ptime[Products] = ...;  // czasy malowania poszczeg�lnych modeli
 float Aavail = ...;		   // czas dost�pu do 1. linii produkcyjnej
 float Pavail = ...;		   // czas dost�pu do 2. linii produkcyjnej
 float profit[Products] = ...; // zysk ze sprzeda�y poszczeg�lnych modeli
 float minProd[Products] = ...;// minimalne liczby wyprodukowanych telefon�w poszczegonych modeli
 // funkcja celu (the objective function)
 maximize sum (p in Products) profit[p]*production[p];
 // ograniczenia (constraints)
 constraints {
   // I do label constraints to be able to identify the reasons for an infeasibility more quickly.
   Label1: forall (p in Products)
     production[p] >= minProd[p];
     Label2: sum (p in Products)
       production[p]*Atime[p] <= Aavail;
     Label3: sum (p in Products)
       production[p]*Ptime[p] <= Pavail;       
 }
 // Update profit data