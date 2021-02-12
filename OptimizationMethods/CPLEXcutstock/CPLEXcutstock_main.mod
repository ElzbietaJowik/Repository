/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 20 sty 2021 at 09:05:58
 *********************************************/

// zarz¹dzanie procesem; plik definiuj¹cy zadanie Z_p + skrypt
// Common width of the rolls to be cut.
int RollWidth = ...;
// Number of item types to be cut
int NbItems = ...;

range Items = 1..NbItems;
// Size of each of the items
int Size[Items] = ...;
// Number of items of each type to be cut
int Amount[Items] = ...;

// Patterns of roll cutting that are generated.
// Some simple default patterns are given initially in cutstock.dat
tuple pattern {
   key int id;
   int cost;
   int fill[Items];
}
{pattern} Patterns = ...;

// dual values used to fill in the sub model.
float Duals[Items] = ...;


// How many of each pattern is to be cut
dvar float Cut[Patterns] in 0..1000000;
     
// Minimize cost : here each pattern has the same constant cost so that
// we minimize the number of rolls used.     
minimize
  sum( p in Patterns ) 
    p.cost * Cut[p];

subject to {
  // Unique constraint in the master model is to cover the item demand.
  forall( i in Items ) 
    ctFill: // wektor etykiet
      sum( p in Patterns ) 
        p.fill[i] * Cut[p] >= Amount[i];
}
tuple r { // krotka do ³adnego przedstawienia wyników
   pattern p;
   float cut;
};

{r} Result = {<p,Cut[p]> | p in Patterns : Cut[p] > 1e-3};

// szereg bloków execute, ale jeden main

// set dual values used to fill in the sub model.
execute FillDuals { // wspó³czynniki lagrange'a uzyskane w rozwi¹zaniu przypisane do zmiennej Duals
  for(var i in Items) {
     Duals[i] = ctFill[i].dual; // odwo³anie do etykiety (zmiennej Lagrange'a otrzymanej przy rozwi¹zaniu zasania)
  }
}

// Output the current result
execute DISPLAY_RESULT {
   writeln(Result);
}

main {
//   var status = 0;
   thisOplModel.generate(); // odwo³anie do modelu z tego pliku (Z_p)
   // This is an epsilon value to check if reduced cost is strictly negative
   var RC_EPS = 1.0e-6;
   
   // zapewnienie komunikacji pomiêdzy zadaniem Z_p i Z_dp
   // data elements - kontener, wszystkie zane naszego zadania
   
   // Retrieving model definition, engine and data elements from this OPL model
   // to reuse them later
   var masterDef = thisOplModel.modelDefinition; // definicja Z_p
   var masterCplex = cplex; // przyporz¹dkowanie domyœlnego solvera do naszefo zadania Z_p
   var masterData = thisOplModel.dataElements;  // kontener danych dla naszego zadania (górnego poziomu)(Z_p) 
   
   // Creating the master-model
   // obiekt wykonywalny powi¹zany z zadaniem Z_p
   var masterOpl = new IloOplModel(masterDef, masterCplex);
   masterOpl.addDataSource(masterData);
   masterOpl.generate(); // obiekt gotowy do rozwi¹zania (to co na pocz¹tku, ale trzeba szczegó³owo)
   
   // Preparing sub-model source, definition and engine
   // zadanie dolnego poziomu
   var subSource = new IloOplModelSource("CPLEXCutstock_sub.mod"); // pobranie modelu/zadania z innego pliku
   var subDef = new IloOplModelDefinition(subSource);
   var subCplex = new IloCplex(); // nowa instancja solvera
   
   var best;
   var curr = Infinity;

   while ( best != curr ) {
      best = curr;
      writeln("Solve master.");
      if ( masterCplex.solve() ) { // rozwi¹zanie zadania Z_p
        masterOpl.postProcess();
        curr = masterCplex.getObjValue(); // podstawiamy wartoœæ optymaln¹ z zadania górnego poziomu
        writeln();
        writeln("MASTER OBJECTIVE: ",curr);
      } else {
         writeln("No solution to master problem!");
         masterOpl.end();
         break;
      }
      // Creating the sub model
      var subOpl = new IloOplModel(subDef,subCplex); // ³¹czenie def Z_dp z instancj¹ solvera
      
      // Using data elements from the master model.
      var subData = new IloOplDataElements(); // kontener na dane zadania Z_dp
      subData.RollWidth = masterOpl.RollWidth; // tworzymy zmienne i przyporz¹dkowujemy wartoœci
      subData.Size = masterOpl.Size;
      subData.Duals = masterOpl.Duals;     
      subOpl.addDataSource(subData); // ³¹czymy def zadania z danymi
      subOpl.generate(); 
      
      // Previous master model is not needed any more.
      masterOpl.end();
      
      writeln("Solve sub.");
      if ( subCplex.solve() && // rozwi¹zanie zadania dolnego poziomu + sprawdzenie wartoœci optymalnej
           subCplex.getObjValue() <= -RC_EPS) {
        writeln();
        writeln("SUB OBJECTIVE: ",subCplex.getObjValue());
      } else {
        writeln("No new good pattern, stop.");
           subData.end();
        subOpl.end();         
        break;
      }
      // prepare next iteration
      // przekazanie nowego wzorca do zadania górnego poziomu
      // dodanie do kontenera Z_p nowego elementu (krotki: identyfikator, koszt, 
      // wektor zawieraj¹cy wartoœci zmiennych decyzyjnych optymalnych zadania dolnego poziomu)
      masterData.Patterns.add(masterData.Patterns.size,1,subOpl.Use.solutionValue);
      masterOpl = new IloOplModel(masterDef,masterCplex); 
      masterOpl.addDataSource(masterData);
      masterOpl.generate(); // generowanie zadania na nowo
      // End sub model
         subData.end();
      subOpl.end();      
   }
    
   // Check solution value
/*   if (Math.abs(curr - 46.25)>=0.0001) {
 //     status = -1;
      writeln("Unexpected objective value");
   }       */  

   subDef.end();
   subCplex.end();
   subSource.end();
   
//   status;
}
 