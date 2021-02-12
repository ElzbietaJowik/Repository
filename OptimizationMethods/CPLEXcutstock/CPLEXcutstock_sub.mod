/*********************************************
 * OPL 12.10.0.0 Model
 * Author: elzbi
 * Creation Date: 20 sty 2021 at 09:06:39
 *********************************************/

// zadanie dolnego poziomu - Z_dp; niektóre dane na sztywno
int RollWidth = ...;

range Items = 1..5; // ile ró¿nych w_i

int Size[Items] = ...; // w_i
float Duals[Items] = ...; // lambda_i przekazywane z zadania górnego poziomu

dvar int Use[Items] in 0..100000; // y_i - zmienne decyzyjne (liczba szerokoœci (?))


minimize
  1 - sum(i in Items) Duals[i] * Use[i]; // funkcja celu zadania Z_dp
subject to {
  ctFill:
    sum(i in Items) Size[i] * Use[i] <= RollWidth; // ograniczenie
}
 