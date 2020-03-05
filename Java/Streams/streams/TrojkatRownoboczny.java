package streams;

import static java.lang.Math.*;

public class TrojkatRownoboczny extends Figura {

    private int podstawa;

    public TrojkatRownoboczny(int podstawa, int wysokosc) {
        super(wysokosc);
        this.podstawa = podstawa;
    }

    @Override
    public double polePowierzchni() {
        return 0.5 * podstawa * wysokosc;
    }

    @Override
    public double obwod() {
        return 2 * sqrt(wysokosc * wysokosc + pow(0.5 * podstawa, 2)) + podstawa;
    }

    @Override
    public String toString() {
        return "Trójkąt, " +
                "wysokość = " + wysokosc +
                ", pole = " + polePowierzchni() +
                ", obwód = " + obwod();
    }
}
