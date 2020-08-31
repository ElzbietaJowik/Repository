package streams;

public class Stozek extends Figura3D {

    public Stozek(int promienPodstawy, int wysokosc) {
        this.wysokosc = wysokosc;
        this.podstawa = new Kolo(promienPodstawy);
    }

    @Override
    public double objetosc() {
        return Math.PI * podstawa.polePowierzchni() * wysokosc / 3;
    }

    @Override
    public double polePowierzchni() {
        double l = Math.sqrt(wysokosc * wysokosc + podstawa.wysokosc * podstawa.wysokosc);
        return Math.PI * podstawa.wysokosc * (podstawa.wysokosc + l);
    }

    @Override
    public double obwod() {
        return 0;
    }

    @Override
    public String toString() {
        return "Stożek, " +
                "wysokość = " + wysokosc +
                ", pole = " + polePowierzchni() +
                ", objętość = " + objetosc();
    }
}
