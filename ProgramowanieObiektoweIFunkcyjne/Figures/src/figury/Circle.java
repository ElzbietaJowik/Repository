package figury;

public class Circle extends Round implements Dimension2 {

    public Circle(double radius){
        this.radius = radius;
    }

    @Override
    public double area() {
        return (Math.PI * radius * radius);
    }

    @Override
    public double circuit() {
        return 2 * Math.PI * radius;
    }
}
