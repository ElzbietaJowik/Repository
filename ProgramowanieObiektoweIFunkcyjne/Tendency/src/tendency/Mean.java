package tendency;

public class Mean extends Tendency {

    public Mean(double[] timeSeries) {
        super(timeSeries);
    }

    double meanValue = 0;

    @Override
    public double calculateTendency() {
        for (double value : timeSeries){
            meanValue += value;
        }
        return meanValue / getSeriesLength();
    }
}
