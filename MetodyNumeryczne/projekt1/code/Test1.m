x1 = hess(hilb(5))
x1_inv = Inverse(x1)
x1_inv_ori = inv(x1);
wynik = x1_inv - x1_inv_ori;
heatmap(wynik,'CellLabelColor','none');
colormap jet;
title('Macierz różnicy wyniów odwracania macierzy');
