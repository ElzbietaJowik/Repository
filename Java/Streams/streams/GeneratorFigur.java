package streams;

import java.util.ArrayList;
import java.util.List;

public class GeneratorFigur {

    public static List<Figura> generuj() {
        List<Figura> figury = new ArrayList<>();

        figury.add(new Kwadrat(3));
        figury.add(new Kwadrat(10));
        figury.add(new Kwadrat(13));
        figury.add(new Kolo(4));
        figury.add(new Kolo(11));
        figury.add(new Kolo(7));
        figury.add(new TrojkatRownoboczny(3, 6));
        figury.add(new TrojkatRownoboczny(8, 9));
        figury.add(new TrojkatRownoboczny(14, 5));
        figury.add(new Szescian(7));
        figury.add(new Szescian(2));
        figury.add(new Szescian(15));
        figury.add(new Stozek(6, 6));
        figury.add(new Stozek(10, 7));
        figury.add(new Stozek(6, 5));

        return figury;
    }
}
