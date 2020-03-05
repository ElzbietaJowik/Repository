package streams;

public class Kwadrat extends Figura {

    public Kwadrat(int bok) {
        super(bok);
    }

    @Override
    public double polePowierzchni() {
        return wysokosc * wysokosc;
    }

    @Override
    public double obwod() {
        return 4 * wysokosc;
    }

    @Override
    public String toString() {
        return "Kwadrat, " +
                "wysokość = " + wysokosc +
                ", pole = " + polePowierzchni() +
                ", obwód = " + obwod();
    }
}
