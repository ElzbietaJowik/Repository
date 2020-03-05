A = randn(5,5);
A = A*A'
B = eye(5)
[con,e_dc,e_rel,wspolczynnik_stabilnosci,wspolczynnik_poprowanosci] = Equation_errors(A,B)
