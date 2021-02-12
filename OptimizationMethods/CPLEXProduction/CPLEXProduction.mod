/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 9 gru 2020 at 08:51:33
 
 Produkujemy 3 rodzaje makaronów: "kluski", "capellini",
 "fettucine".
 Do ich produkcji wamagane s¹ produkty (zasoby):
 (1) flour - dostêpna iloœæ: 120,  
 (2) eggs - dostêpna iloœæ: 150.
 
 Zu¿ycie sk³adników:
 |	     |	kluski	|	capellini	|	fettucine	|
 | flour |	 0.5	|	   0.4   	|	   0.3  	|
 | eggs  |	 0.2	|	   0.4   	|	   0.6  	|
 
 Mo¿emy produkowaæ we w³asnym zak³adzie (wtedy musimy siê
 liczyæ z dostêpnoœci¹ zasobów) albo zamówiæ na zewn¹trz.
 
 Koszta produkcji:
 |	                | kluski | capellini | fettucine |
 | produkcja w³asna |   0.6  |    0.8    |    0.3  	 |
 | prod. na zewn.   |	0.8	 |	  0.9    |	  0.4  	 |
 
 Produkujemy (u siebie, na zewn¹trz), aby zaspokoiæ 
 zapotrzebowanie:
| kluski | capellini | fettucine |
|   100  |    200    |    300  	 |

Jak zorganizowaæ produkcjê (u siebie, na zewn¹trz) aby
koszty realizacji zamówienia by³y najmniejsze?
 
 *********************************************/
 
{string} Products = ...;
{string} Resources = ...;
float consumption[Products][Resources] =...;
int Demand[Products] =...;
float costInside[Products] =...;
float costOutside[Products] =...;
int MaxOutside[Products] =...;
float LimitResources[Resources] =...;
// decision variables
dvar float+ insideProduction[Products];
dvar float+ outsideProduction[Products];
//set the objective funstion
minimize 
    sum (p in Products) (insideProduction[p]*costInside[p] + 
                        outsideProduction[p]*costOutside[p]);
//set constraints
subject to{
   forall (p in Products) 
   demandConstraint: (insideProduction[p] + 
                          outsideProduction[p]) >= Demand[p];
   forall (p in Products) 
   outsideSupply: outsideProduction[p] <= MaxOutside[p];
   forall (r in Resources) 
   resourceAvailability: sum (p in Products) insideProduction[p]*consumption[p][r]
                               <= LimitResources[r];
}
   