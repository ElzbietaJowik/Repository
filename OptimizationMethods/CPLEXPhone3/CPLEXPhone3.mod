/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 25 lis 2020 at 09:54:45
 
 Produkujemy dwa typy telefonów 'Desk' i 'Cell'. 
 Produkcja ta sk³ada siê z dwóch etapów:
 	1) sk³adania z czêœci
 	2) malowania
 |etap\model|	Desk	|	Cell	|
 |   Etap1  |   12 min  |   24 min  |
 |   Etap2  |   30 min  |   24 min  |
 Linie produkcyjne s¹ dzier¿awione i mamy dostêp:
 	400 godzin na linii pierwszej
 	490 godzin na linii drugiej
Powinniœmy wyprodukowaæ co najmniej 200 telefonów
typu 'Desk' i 100 sztuk typu 'Cell'.
  	
Zysk na poszczególnych modelach to:
 	12$/szt. dla modelu 'Desk'
 	20$/szt. dla modelu 'Cell'

Ile telefonów typów 'Desk' i 'Cell' powinniœmy 
wyprodukowaæ, aby sumaryczny zysk by³ najwiêkszy.
 *********************************************/

 {string} Products = ...; 	   // modele telefonów
 dvar float+ production[Products];
 float Atime[Products] = ...;  // czasy sk³adania poszczególnych modeli
 float Ptime[Products] = ...;  // czasy malowania poszczególnych modeli
 float Aavail = ...;		   // czas dostêpu do 1. linii produkcyjnej
 float Pavail = ...;		   // czas dostêpu do 2. linii produkcyjnej
 float profit[Products] = ...; // zysk ze sprzeda¿y poszczególnych modeli
 float minProd[Products] = ...;// minimalne liczby wyprodukowanych telefonów poszczegonych modeli
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