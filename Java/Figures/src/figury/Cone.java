package figury;

import static java.lang.StrictMath.sqrt;

public class Cone extends Round implements Dimension3 {  // Stozek

    double height;

    public Cone(double radius, double height){
        this.height = height;
        this.radius = radius;
    }

    @Override
    public double area() {
        return (Math.PI * radius * radius + Math.PI * radius * sqrt(radius * radius + height * height));
    }

    @Override
    public double volume() {
        return (Math.PI * radius * radius * height) / 3;
    }

}
