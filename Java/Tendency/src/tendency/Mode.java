package tendency; // bedziemy liczyc tendencje czasowa jaka jest moda

public class Mode extends Tendency {

    public Mode(double[] timeSeries) { // po zainicjalizowaniu dziedziczenia [alt + Enter]
        super(timeSeries);             // wowczas nadpisza sie metody i stworzy konstruktor
    }                                  // slowo kluczowe super uruchamia konstruktor klasy bazowej

    @Override
    public double calculateTendency() {
        double modeValue, maxCount;
        maxCount = 0;
        modeValue = Double.NaN;

        for (double value: timeSeries){
            int count = 0;
            for(double occurence: timeSeries){
                if(occurence == value){
                    count ++;
                }
            }
            if (count > maxCount){
                maxCount = count;
                modeValue = value;
            }
        }
        return modeValue;

    }
}
