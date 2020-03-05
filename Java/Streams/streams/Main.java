package streams;

import streams.ImplementacjaInterfejsu;

public class Main {

    public static void main(String[] args) {

        ImplementacjaInterfejsu imp = new ImplementacjaInterfejsu(GeneratorFigur.generuj());

        System.out.println("1. Największa figura względem pola wysokosc: " + imp.getNajwiekszaFigure());

        System.out.println("2. Figura o najmniejszym polu powierzchni: " + imp.getFigureONajmniejszymPolu());

        System.out.println("3. Najwyższa figura 3D:" + imp.getNajwyzszaFigure3D());

        System.out.println("4. Najmniejszy stożek względem objętości: " + imp.getNajmniejszyStozek());

        System.out.println("5. Lista figur posortowanych względem pola powierzchni: " + imp.getPosortowaneWzgledemPowiezchni());

        System.out.println("6. Druga figura z posortowanych malejaco względem obwodu: " + imp.getDrugaZPosortowanychMalejacoWgObwodu());

        System.out.println("7. Lista pięciu pierwszych figur posortowanych rosnąco względem pola powierzchni: " + imp.getPierwszePiecPosortowaneRosnacoWgPowierzchni());

        System.out.println("8. Lista wszystkich sześcianów o długości boku nie większej niż 10: " + imp.getSzesciany());

        System.out.println("9. Koło o najmniejszym polu powierzchni: " + imp.getNajmniejszeKolo());

        System.out.println("10. Mapa figur względem ID: " + imp.mapaWgId());

        System.out.println("11. Ilość figur o polu powierzchni nie większym niż 200: " + imp.getiloscMalych(200));

        System.out.println("12. osortowany ciąg figur zaczynając od 5: " + imp.posortowaneWgPolaZaczynajacOd(5));

    }
}
