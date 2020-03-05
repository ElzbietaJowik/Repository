package figury;

public class Diamond extends Figury implements Dimension2 {

    int numberOfAngles = 4;
    int numberOfEdges = 4;
    double edge;
    double diagonal1, diagonal2; // przekatna 1., przekatna 2

    public Diamond(double edge, double diagonal1, double diagonal2){
        this.edge = edge;
        this.diagonal1 = diagonal1;
        this.diagonal2 = diagonal2;

        if (2 * edge < diagonal1 || 2 * edge < diagonal2 ){
            System.err.println("Improper measurements.");
        }
    }


    @Override
    public double area() {
        if (2 * edge > diagonal1 & 2 * edge > diagonal2 ) {
            return (diagonal1 * diagonal2) / 2;
        }
        else{
            return -1.0;
        }}

    @Override
    public double circuit() {
            if (2 * edge > diagonal1 & 2 * edge > diagonal2 ){
                return 4 * edge;
            }
            else{
                return -1.0;
            }
        }

    }
