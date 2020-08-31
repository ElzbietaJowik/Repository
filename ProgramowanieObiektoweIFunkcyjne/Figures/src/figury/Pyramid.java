package figury;

import static java.lang.StrictMath.sqrt;

public class Pyramid extends Figury implements Dimension3 { // Ostroslup
    int numberOfEdges = 8;                         // Ograniczamy typ ostroslupa do tych z kwadratem w podstawie
    int numberOfAngles = 4 + 4 * 3;
    double baseEdge;
    double height;

    public Pyramid(double baseEdge, double height){
        this.baseEdge = baseEdge;
        this.height = height;
    }

    @Override
    public double area() {
        double sideWallHeigth = sqrt(height * height + (baseEdge/2) * (baseEdge/2));
        return (baseEdge * baseEdge + 4 * 1/2 * baseEdge * sideWallHeigth);
    }

    @Override
    public double volume() {
        return (baseEdge * baseEdge * height)/3;
    }
}