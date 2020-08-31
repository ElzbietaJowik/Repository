public class Waluty {
    public double to_PLN(double value, String currency_in){
        double result=0;
        switch (currency_in) {
            case "PLN":
                result = value;
                break;
            case "EUR":
                result = value*4.32;
                break;
            case "USD":
                result = value*3.82;
                break;
            case "CHF":
                result = value*3.81;
                break;
            case "GBP":
                result = value*4.94;
                break;
            case "ILS":
                result = value*1.05;
                break;
        }
        return result;
    }
    public double from_PLN(double value, String currency_out){
        double result=0;
        switch (currency_out) {
            case "PLN":
                result = value;
                break;
            case "EUR":
                result = value/4.32;
                break;
            case "USD":
                result = value/3.82;
                break;
            case "CHF":
                result = value/3.81;
                break;
            case "GBP":
                result = value/4.94;
                break;
            case "ILS":
                result = value/1.05;
                break;
        }
        return result;
    }
}