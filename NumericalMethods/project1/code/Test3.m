C = magic(4);
A = pascal(4)
B = C-A
x = A\B
X = Equation(A,B);
[con,e_dc,e_rel,wspolczynnik_stabilnosci,wspolczynnik_poprowanosci] = Equation_errors(A,B)
error = X-x;
heatmap(error,'CellLabelColor','none')
colormap jet;
title('Macierz różnicy wyników rozwiązania układu');
