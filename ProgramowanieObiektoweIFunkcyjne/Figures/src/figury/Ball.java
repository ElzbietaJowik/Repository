package figury;

public class Ball extends Round implements Dimension3 {

    public Ball(double radius){
        this.radius = radius;
    }

    @Override
    public double area() {
        return (4 * Math.PI * radius * radius);
    }

    @Override
    public double volume() {
        return (4 * Math.PI * radius * radius * radius / 3);
    }
}
