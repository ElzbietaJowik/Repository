package genericTendency;

/* Tworzymy kod generyczny wyliczający średnią przynastępujących założeniach.
* Średnia będzie wartością typu double
* Średnią da się wyliczyć tylko dla danych numerycznych - musimy zastosowac OGRANICZENIE ZMIENNYCH TYPOWYCH */


import java.util.ArrayList;

public class GenericMean<T extends Number> { // <--- OGRANICZENIE ZMIENNYCH TYPOWYCH
                                            // chcemy ograniczyc dzialanie do zmiennych typu Number !!!
    ArrayList<T> valueSeries;

    public GenericMean(ArrayList<T> valueSeries){
        this.valueSeries = valueSeries;
    }
    public int getLength(){
        return valueSeries.size();
    }

    public double calculateMean(){

        double meanValue = 0;

        for(T value: valueSeries){
            meanValue += value.doubleValue();
        }
        return meanValue/getLength();
    }


}
