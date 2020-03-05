package figury;

public class Prism<T extends Fig2D> {

    private final T base;
    private final double height;

    public Prism(T base, double height){
        this.base = base;
        this.height = height;
    }

    public double volume(){
        return (base.area() * height);
    }
    public double area(){
        return (base.circuit() * height + 2 * base.area());
    }
}
