package streams;

public abstract class Figura3D extends Figura {

    protected Figura podstawa;

    public abstract double objetosc();

    public Figura3D() {}
    public Figura3D(Figura podstawa, int wysokosc) {
        super(wysokosc);
        this.podstawa = podstawa;
    }
}