package genericTendency;

public class DoubleMean {

    double[] timeSeries;

    public DoubleMean(double[] timeseries){
        this.timeSeries = timeseries;
    }

    public double getLength(){
        return timeSeries.length;
    }

    public double calculateMean(){

        double meanValue = 0;

        for(double value: timeSeries){
            meanValue += value;
        }
        return meanValue/getLength();
    }


}
