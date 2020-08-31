package figury;

import static java.lang.StrictMath.sqrt;

public class Triangle extends Figury implements Dimension2 {

    int numberOfAngles = 3;
    int numberOfEdges = 3;
    double base, edge1, edge2; // podstawa, ramie 1., ramie 2

    public Triangle(double base, double edge1, double edge2){
        this.base = base;
        this.edge1 = edge1;
        this.edge2 = edge2;
    }

    @Override
    public double area() { // implementacja wzoru Herona
        double halfCircuit = (base + edge1 + edge2)/2;
        double a = sqrt(halfCircuit * (halfCircuit - base) * (halfCircuit - edge1) * (halfCircuit - edge2));
        return a;
    }

    @Override
    public double circuit() {
        return (base + edge1 + edge2);
    }
}
