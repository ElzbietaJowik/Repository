/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 27 sty 2021 at 08:42:25
 *********************************************/

{string} Products =...;
{string} Resources = ...;
{string} warehouses =...;
 
tuple productData {
   float insideCost;
   float outsideCost;
   float demand;
}
 
tuple consumptionData
{
  string product;
  string resource;
  float c;
}
 
{consumptionData} consumption=...;
productData product[Products] = ...;
float availability[Resources] = ...;
float warehouseCost[warehouses][Resources] = ...;
 
float maxProd = ...;
 
dvar float+ insideProduction[Products];
dvar float+ outsideProduction[Products] in 0..maxProd;
dvar float+ resourceDemand[Resources][warehouses];
 
minimize
   sum(p in Products) (product[p].insideCost*insideProduction[p] + 
                       product[p].outsideCost*outsideProduction[p]) +
   sum(w in warehouses) (sum(r in Resources) resourceDemand[r][w]*warehouseCost[w][r]);
 
subject to {
  forall(r in Resources, w in warehouses)
    resAvailability: resourceDemand[r][w] <= availability[r];
  forall(r in Resources)
    sum(<p,r,c> in consumption) insideProduction[p]*c <= sum(w in warehouses) resourceDemand[r][w];
  forall (p in Products) Demand: insideProduction[p] + outsideProduction[p] >= product[p].demand;                          
}
 
main {
  thisOplModel.generate();
  var model = thisOplModel;
  var MinDemand = model.product["kluski"].demand;
  var curr;
  while (1) {
    writeln("Solve with kluskiDemand =", MinDemand);
    if (cplex.solve()) {
      curr = cplex.getObjValue();
      writeln("Solved with: ", curr);
      writeln();
    }
    else {
      writeln("No solution");
      writeln();
      break;
    }
    MinDemand++;
    writeln();
    model.Demand["kluski"].LB = MinDemand;
  }
}



 