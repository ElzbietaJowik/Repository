package figury;

public class Cuboid extends Figury implements Dimension3 { // Prostopadloscian

    int numberOfAngles = 6 * 4;
    int numberOfEdges = 12;
    double edge1, edge2, edge3;

    public Cuboid(double edge1, double edge2, double edge3){
        this.edge1 = edge1;
        this.edge2 = edge2;
        this.edge3 = edge3;
    }

    @Override
    public double area() {
        return (2 * edge1 * edge2 + 2 * edge2 * edge3 + 2 * edge1 * edge3);
    }

    @Override
    public double volume() {
        return (edge1 * edge2 * edge3);
    }
}
