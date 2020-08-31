package figury;

public class Square extends Fig2D implements Dimension2 {

    int numberOfAngles = 4;
    int numberOfEdges = 4;
    double edge;

    public Square(double edge){
        this.edge = edge;
    }


    @Override
    public double area() {
        return edge*edge;
    }

    @Override
    public double circuit() {
        return 4 * edge;
    }
}
