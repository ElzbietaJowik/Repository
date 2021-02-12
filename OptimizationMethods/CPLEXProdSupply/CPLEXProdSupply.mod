/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 20 sty 2021 at 10:43:21
 *********************************************/
{string} Products =...;
{string} Resources = ...;
{string} Stores =...;
tuple productData {
//   float demand;
   float insideCost;
   float outsideCost;   //Consumption has been removed
}

tuple storeData {
   float demand[Products];
   float inTransport;
   float outTransport;
}

tuple consumptionData
{
  string product;
  string resource;
  float c;           //The amount of the resource needed to produce 
                     //1 unit of the product
}

{consumptionData} consumption=...; //declares a set of values which are 
                                   //instances of the tuple "consumptionData"
productData product[Products] = ...;
storeData supply[Stores] = ...;
float availability[Resources] = ...;

float maxProd = ...; // The maximum amount that may be outsourced for any product.

dvar float+ insideProduction[Products];
dvar float+ outsideProduction[Products] in 0..maxProd;
dvar float+ insideSupply[Products][Stores];
dvar float+ outsideSupply[Products][Stores];

minimize
   sum(p in Products) (product[p].insideCost*insideProduction[p] + 
                       product[p].outsideCost*outsideProduction[p] +
   sum (s in Stores ) (supply[s].inTransport*insideSupply[p][s] + 
                       supply[s].outTransport*outsideSupply[p][s]));
subject to {
   forall(r in Resources)
      rAvail: sum(<p,r,c> in consumption) c * insideProduction[p] <= availability[r];
   forall (s in Stores, p in Products ) Demand: insideSupply[p][s] + outsideSupply[p][s] >= supply[s].demand[p];
   forall (p in Products) { insideProd: sum (s in Stores ) insideSupply[p][s] <= insideProduction[p];
                            outsideProd: sum(s in Stores ) outsideSupply[p][s] <= outsideProduction[p];
                         }                            
}

main {
  thisOplModel.generate();

  var produce = thisOplModel;
  var MinDemand = produce.supply["Opole"].demand["kluski"];

  var best;
  var curr = Infinity;
  while ( MinDemand >= 5 ) {
    best = curr;

    writeln("Solve with MaxOut = ",MinDemand);
    if ( cplex.solve() ) {
      curr = cplex.getObjValue();
      writeln();
      writeln("OBJECTIVE: ",curr);
//      ofile.writeln("Objective with MinDemand = ", MinDemand, " is ", curr);        
    } 
    else {
      writeln("No solution!");
      break;
    }
    if ( best==curr ) break;

    MinDemand--;

      thisOplModel.Demand["Opole"]["kluski"].LB = MinDemand;
  }
//  if (best != Infinity) {
//    writeln("plan = ",produce.Plan);
//  }

//  ofile.close();

  0;
} 
 
 