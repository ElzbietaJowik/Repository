/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 23 gru 2020 at 09:54:18
 *********************************************/
 /*
 Zadanie harmonogramowania produkcji.
 Mamy mozliwosc produkowania u siebie, mozemy produkowac na zewnatrz.
 Jezeli produkujemy u siebie, to musimy liczyc sie z dostepnoscia surowcow.
 Zakladamy, ze w kazdym okresie te surowce maja ta sama wartosc.
 Zakladamy, ze zamowienie dotyczy wiecej niz 1 okresu. 
 Mamy kilka produktow i kilka zasobow. Wiemy ile danego surowca potrzeba
 do produkcji okreslonego produktu. 
 */
 
{string} Products = ...; // zbior produktow
{string} Resources = ...; // zbior zasobow
int NbPeriods = ...; // liczba okresow
range Periods = 1..NbPeriods;

// Consumption okresla ilosc danego zasobu  
// potrzebna do wyprodukowania danego produktu
float Consumption[Resources][Products] = ...; 
// Capacity okresla ilosc zasobow dostepnych 
// na kazdy okres 
float Capacity[Resources] = ...; 
// Demand okresla ile produktow mamy wyprodukowac 
float Demand[Products][Periods] = ...;
// InsideCost okresla koszt produkcji u siebie
float InsideCost[Products] = ...;
// OutsideCost okresla koszt produkcji na zewnatrz
float OutsideCost[Products] = ...;
// Inventory odpowiada mozliwosci skladowania
float Inventory[Products] = ...;
// InvCost okresla koszt magazynowania
float InvCost[Products] = ...;

dvar float+ Inside[Products][Periods];
dvar float+ Outside[Products][Periods];
dvar float+ Inv[Products][0..NbPeriods];

execute{
  writeln("* This OPL model is not compliant with cloud execution");
}
minimize
	sum(p in Products, t in Periods)
		(InsideCost[p] * Inside[p][t] + 
     	OutsideCost[p] * Outside[p][t] + 
     	InvCost[p] * Inv[p][t]);
  	subject to {
    	forall(r in Resources, t in Periods)
      		ctCapacity:
    	  	sum(p in Products)
    	    	Consumption[r][p] * Inside[p][t] <= Capacity[r];
    	forall (p in Products, t in Periods)
      		ctDemand:
    			Inv[p][t-1] + Inside[p][t] + Outside[p][t] == 
    	  		Demand[p][t] + Inv[p][t];
    	forall (p in Products)
      		ctInventory:
      			Inv[p][0] == Inventory[p];
}

tuple plan{
  float inside;
  float outside;
  float inv;
}

plan Plan[p in Products][t in Periods] = 
	<Inside[p, t], Outside[p, t], Inv[p, t]>;
	
// Chcemy aby dodatkowa zmienna zwiazana z procesem 
// optymalizacji byla zmienna zwiazana z dostepnoscia
// jednego z dwoch zasobow. Chcielibysmy okreslic przy
// jakiej ilosci maki, ktory bylby utrzymywany w kazdym 
// z okresow koszty realizacji bylyby najmniejsze.
// Mozna podejsc do tego dwojako:
// 1. Wprowadzic dodatkowa zmienna decyzyjna okreslajaca 
// poziom zasobow maki i wtedy znalezc jej optymalna wartosc
// 2. Korzystajac z istniejacej definicji zadania wewnatrz 
// skryptu zmieniamy jedna ze zmiennych i po zmianie danych
// ponownie rozwiazujemy zadanie optymalizacji. (tak robimy)


main{
  var src = new IloOplModelSource("CPLEXMulprod.mod");
  var def = new IloOplModelDefinition(src);
  var opl2 = new IloOplModel(def, cplex);
  var data = new IloOplDataSource("CPLEXMulprod.dat");
  opl2.addDataSource(data);
  
  // thisOplModel.generate();
  opl2.generate();
  
  // var produce = thisOplModel;
  var produce = opl2;
  var capFlour = produce.Capacity["flour"];
  
//  var basis = new IloOplCplexBasis();
  
  var best;
  var curr = Infinity;
  var ofile = new IloOplOutputFile("mulprod_main.txt");
  while(1){
    best = curr;
    writeln("Solve with capFlour = ", capFlour);
    if(cplex.solve()){
      
//      basis.getBasis(cplex)

      curr = cplex.getObjValue();
      writeln();
      writeln("OBJECTIVE: ", curr);
      ofile.writeln("Objective with capFlour = ",capFlour, " is ", curr);
    }
    else{
      writeln("No solution!");
      break;
    }
    if(best == curr) break;
    
    capFlour++;
//    for (var t in thisOplModel.Periods)
    for (var t in opl2.Periods)
//    thisOplModel.ctCapacity["flour"][t].UB = capFlour;
		opl2.ctCapacity["flour"][t].UB = capFlour;
//	basis.setBasis(cplex)
  }
  if(best != Infinity){
    writeln("plan = ", produce.Plan);
  }
  
  ofile.close();
  // 0;
  
}
