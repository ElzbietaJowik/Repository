package streams;

import javax.swing.text.html.Option;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ImplementacjaInterfejsu implements pl.edu.pw.mini.jrafalko.streams.MetodyStrumieniowe {

    List<Figura> figury;

    public ImplementacjaInterfejsu(List<Figura> fig) {
        this.figury = fig;
    }

    /**
     * 1
     * @return Największa figura względem pola wysokosc
     * 0,5 pkt
     */
    @Override
    public Figura getNajwiekszaFigure() {
        Optional<Figura> najwFig = figury.stream().collect(Collectors.maxBy(Comparator.comparing(Figura::getWysokosc)));
        return najwFig.orElse(null);
    }

    /**
     * 2
     * @return Figura o najmniejszym polu powierzchni
     * 0,5 pkt
     */
    @Override
    public Figura getFigureONajmniejszymPolu() {
        Optional<Figura> najmFig = figury.stream()
                .collect(Collectors
                .minBy(Comparator.comparing(Figura::polePowierzchni)));
        return najmFig.orElse(null);
    }

    /**
     * 3
     * @return Najwyższa figura 3D
     * 0,5 pkt
     */
    @Override
    public Figura getNajwyzszaFigure3D() {
        Optional<Figura> najw3D =  figury.stream()
                .filter(figura -> figura instanceof Figura3D)
                .collect(Collectors.maxBy(Comparator.comparing(Figura::getWysokosc)));
        return najw3D.orElse(null);
    }

    /**
     * 4
     * @return Najmniejszy stożek względem objętości
     * 1 pkt
     */
    @Override
    public Figura getNajmniejszyStozek() {
        Object[] listaStozkow = figury.stream()
                .filter(figura -> figura instanceof Stozek)
                .toArray();
        if (listaStozkow.length > 0){
            Object[] najmnStoż = Arrays.stream(listaStozkow)
                    .sorted(Comparator.comparing(o -> ((Stozek) o).objetosc()))
                    .limit(1)
                    .toArray();
            return (Figura) najmnStoż[0];
        }
        else{
            return null;
        }

    }

    /**
     * 5
     * @return Lista figur posortowanych względem pola powierzchni
     * 0,5 pkt
     */
    @Override
    public List<Figura> getPosortowaneWzgledemPowiezchni() {
        List<Figura> lista = new ArrayList<>();
          figury.stream()
                .sorted(Comparator.comparing(Figura::polePowierzchni))
                .forEachOrdered(figura -> lista.add(figura));
          return lista;

    }

    /**
     * 6
     * @return Druga figura z posortowanych malejaco względem obwodu
     * 1 pkt
     */
    @Override
    public Figura getDrugaZPosortowanychMalejacoWgObwodu() {
        Object[] fig = figury.stream()
                .sorted(Comparator.comparing(Figura::obwod).reversed())
                .skip(1)
                .limit(1)
                .toArray();
        return (Figura) fig[0];
    }

    /**
     * 7
     * @return Lista pięciu pierwszych figur posortowanych rosnąco względem pola powierzchni,
     * o wysokości nie większej niż 10 i polu powierzchni nie mniejszym niż 10
     * 1 pkt
     */
    @Override
    public List<Figura> getPierwszePiecPosortowaneRosnacoWgPowierzchni() {
        ArrayList<Figura> lista = new ArrayList<>();

        figury.stream()
                .filter(figura -> figura.getWysokosc() <= 10)
                .filter(figura -> figura.polePowierzchni() >= 10)
                .sorted(Comparator.comparing(Figura::polePowierzchni))
                .limit(5)
                .forEachOrdered(figura -> lista.add(figura));
        return lista;
    }

    /**
     * 8
     * @return Lista wszystkich sześcianów o długości boku nie większej niż 10
     * 1 pkt
     */
    @Override
    public List<Figura> getSzesciany() {
        List<Figura> lista = new ArrayList<>();

          figury.stream()
                .filter(figura -> figura.wysokosc <- 10)
                .filter(figura -> figura instanceof Szescian)
                .forEach(figura -> lista.add(figura));
          return lista;
    }

    /**
     * 9
     * @return Koło o najmniejszym polu powierzchni
     * 0,5 pkt
     */
    @Override
    public Figura getNajmniejszeKolo() {
        Object[] najmnKolo =
                figury.stream()
                .filter(figura -> figura instanceof Kolo)
                .sorted(Comparator.comparing(Figura::polePowierzchni))
                .toArray();
        return (Kolo) najmnKolo[0];
    }

    /**
     * 10
     * @return Mapa figur względem ID
     * 1 pkt
     */
    @Override
    public Map<Integer, Figura> mapaWgId() {
        Map<Integer, Figura> mapowanie =
                figury.stream()
                .collect(Collectors.toMap(Figura::getId, Function.identity()));
        return mapowanie;
    }

    /**
     * 11
     * @param pole Max pole powierzchni
     * @return Ilość figur o polu powierzchni nie większym niż pole
     * 0,5 pkt
     */
    @Override
    public int getiloscMalych(double pole) {
        long licznik = figury.stream()
                .filter(figura -> figura.polePowierzchni() <= pole)
                .count();
        int wynik = Math.toIntExact(licznik);
        return wynik;
    }

    /**
     * 12
     * @return Posortowany ciąg figur zaczynając od podanej
     * 0,5 pkt
     */
    @Override
    public List<Figura> posortowaneWgPolaZaczynajacOd(int nr) {
        List<Figura> l = new ArrayList<>();
        figury.stream().
                skip(nr)
                .sorted(Comparator.comparing(Figura::polePowierzchni))
                .forEachOrdered(figura -> l.add(figura));
        return l;
    }
}
