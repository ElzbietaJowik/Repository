/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 23 gru 2020 at 09:31:34
 *********************************************/
{string} Products = ...;
{string} Resources = ...;

// definicje krotek
tuple productData {
  float demand;
  float insideCost;
  float outsideCost;
};

tuple consumptionData{
  string product;
  string resource;
  float c;			// The amount of the resource needed
  					// to produce 1 unit of the product
}
// deklaracje krotek
{consumptionData}consumption = ...;
productData product[Products] = ...;

float availability[Resources] = ...;
float maxOutsideProduction = ...; // The maximum amount that may be outsourced for any product

dvar float+ insideProduction[Products];
dvar float+ outsideProduction[Products] in 0..maxOutsideProduction;

minimize 
	sum(p in Products) (product[p].insideCost * insideProduction[p] + 
						product[p].outsideCost * outsideProduction[p]);
subject to {
  forall(r in Resources)
    resourceAvailability: sum(<p,r,c> in consumption) c * insideProduction[p] <= availability[r];
  forall(p in Products)
    demandFulfillment: insideProduction[p] + outsideProduction[p] >= product[p].demand;
  }    
		
