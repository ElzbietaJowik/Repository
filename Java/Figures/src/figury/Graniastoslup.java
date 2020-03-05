package figury;

public class Graniastoslup <T extends Fig2D> extends Figury implements Dimension3 { // w <T> nie mozna uzyc implements

    public T base; // deklarujemy, ze podstawa bedzie typem generycznym
    public double height;

    public Graniastoslup(T base, double height){
        this.base = base;
        this.height = height;
    }


    @Override
    public double area() {
        return 0; // mozna doimplemetowac metody zwracajace dlugosci bokow dla figur 2d
    }

    @Override
    public double volume() {
        double baseArea = base.area();
        double volume = baseArea * height;
        return volume;
    }
}
