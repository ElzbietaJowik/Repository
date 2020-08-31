package genericTendency;

public class DoubleMode {

    double[] timeSeries;

    public DoubleMode(double[] timeSeries){
        this.timeSeries = timeSeries;
    }

    public double calculateMode(){
        double maxCount = 0;
        double modeValue = Double.NaN;

        for (double value: timeSeries){
            int count = 0;
            for (double occurence: timeSeries){
                if (occurence == value){
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
