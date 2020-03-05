package streams;

public class Szescian extends Figura3D{

    public Szescian(int bok) {
        this.wysokosc = bok;
        podstawa = new Kwadrat(bok);
    }

    @Override
    public double polePowierzchni() {
        return 6 * this.podstawa.polePowierzchni();
    }

    @Override
    public double obwod() {
        return 0;
    }

    @Override
    public double objetosc() {
        return wysokosc * wysokosc * wysokosc;
    }

    @Override
    public String toString() {
        return "Sześcian, " +
                "wysokość = " + wysokosc +
                ", pole = " + polePowierzchni() +
                ", objętość = " + objetosc();
    }
}