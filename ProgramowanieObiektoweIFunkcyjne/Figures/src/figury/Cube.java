package figury;
import figury.Dimension3;
import figury.Figury;

public class Cube extends Figury implements Dimension3 {

    int numberOfAngles = 6 * 4;
    int numberOfEdges = 12;
    double edge;

    public Cube(double edge){
        this.edge = edge;
    }

    @Override
    public double area() {
        return (6 * edge * edge);
    }

    @Override
    public double volume() {
        return (edge * edge * edge);
    }
}
