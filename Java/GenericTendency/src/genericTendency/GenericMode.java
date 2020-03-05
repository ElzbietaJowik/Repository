package genericTendency;

import java.util.ArrayList;

public class GenericMode<T> {
    ArrayList<T> valueSeries;

    public GenericMode(ArrayList<T> valueSeries){
        this.valueSeries = valueSeries;
    }

    public T calculateMode(){
        int maxCount;
        T modeValue;
        maxCount = 0;
        modeValue = null;

        for (T value: valueSeries){
            int count = 0;
            for (T occurence: valueSeries){
                if (value.equals(occurence)){
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
