package tendency;

public abstract class Tendency {                // klasa na podstawie, ktorej bedzimy obliczac
                                                // rozne tendencje czasowe takie jak:
                                                // rozne rodzaje srednich, moda, mediana itp.
    public double[] timeSeries;

    public abstract double calculateTendency(); /* poniewaz tendencja moze
                                                byc liczona na rozne sposoby
                                                metoda calculateTendency pozostaje
                                                abstrakcyjna i oznaczamy ja modyfikatorem
                                                abstract */
    public int getSeriesLength() {
        return timeSeries.length;               /* pole timeSeries oraz metoda getSeriesLength
                                                sa metodami okreslonymi zatem nie abstrakcyjnymi */
    }

    public Tendency(double[] timeSeries){
        this.timeSeries = timeSeries;
    }
    }

    /* KLASA ABSTRAKCYJNA
    Służy do opisu klas potomnych.
    Nie tylko abstrakcyjne metody.
    Klasy mogą dziedziczyć tylko po jednej klasie abstrakcyjnej.
     */
