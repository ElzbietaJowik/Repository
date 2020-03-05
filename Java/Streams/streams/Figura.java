package streams;

public abstract class Figura {

    private static int licznikFigur;
    private final int id;
    protected int wysokosc;

    public abstract double polePowierzchni();
    public abstract double obwod();

    public Figura() {
        this.id = ++licznikFigur;
    }
    public Figura(int wysokosc) {
        this.wysokosc = wysokosc;
        this.id = ++licznikFigur;
    }

    public int getId() {
        return id;
    }

    public int getWysokosc() {
        return wysokosc;
    }
}
