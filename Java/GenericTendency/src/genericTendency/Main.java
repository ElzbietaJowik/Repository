package genericTendency;

import java.util.ArrayList;

import static javafx.scene.input.KeyCode.T;

public class Main {
    public static void main(String[] args){
        double[] timeSeries = {4.0, 5.0, 3.5, 4.0, 4.0};
        DoubleMode tendency1 = new DoubleMode(timeSeries);
        System.out.println("The most popular wage is: " + tendency1.calculateMode());
        DoubleMean tendency2 = new DoubleMean(timeSeries);
        System.out.println("The average is: " + tendency2.calculateMean());

        ArrayList<String> timeseries2 = new ArrayList<String>();
        timeseries2.add("Pies");
        timeseries2.add("Kot");
        timeseries2.add("Kot");
        timeseries2.add("Kot");
        timeseries2.add("Pies");
        GenericMode<String> tendency3 = new GenericMode<>(timeseries2);
        System.out.println("The most popular word is: " + tendency3.calculateMode());
    }
}