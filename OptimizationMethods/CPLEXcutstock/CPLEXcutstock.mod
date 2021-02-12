/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 20 sty 2021 at 09:03:23
 *********************************************/
 
int RollWidth = ...;
int NbItems = ...;

range Items = 1..NbItems;
int Size[Items] = ...;
int Amount[Items] = ...;

// used in column generation
float Duals[Items] = ...;


tuple  pattern {
   key int id;
   int cost;
   int fill[Items];
}


{pattern} Patterns = ...;

dvar float Cut[Patterns] in 0..1000000;


minimize
  sum( p in Patterns ) 
    p.cost * Cut[p];
  
subject to {
  forall( i in Items ) 
    ctFill: 
      sum( p in Patterns )
         p.fill[i] * Cut[p] >= Amount[i];
}
    

execute DISPLAY {
  writeln("Cut = ",Cut);
  for(var p in Patterns) 
    writeln("Use of pattern ", p, " is : ",Cut[p]);
}
     
/*tuple CutSolutionT{ 
	pattern Patterns; 	
	float value; 
};
{CutSolutionT} CutSolution = {<i0,Cut[i0]> | i0 in Patterns}; */
 