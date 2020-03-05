package figury;

import java.util.Random;

public class Rectangle extends Figury implements Dimension2 {

    int numberOfAngles = 4;
    int numberOfEdges = 4;
    double edge1, edge2;

    public Rectangle(double edge1, double edge2){
        this.edge1 = edge1;
        this.edge2 = edge2;
    }

    @Override
    public double area() {
        return (edge1 * edge2);
    }

    @Override
    public double circuit() {
        return (2 * edge1 + 2 * edge2);
    }
}
