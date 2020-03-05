import java.util.Scanner;

public class Main {
    public static void main (String[] args) {
        double value;
        String currency_in;
        String currency_out;
        Scanner scanner = new Scanner (System.in);

        System.out.println("Proszę podać wartość do przeliczenia");
        value=scanner.nextDouble();
        System.out.println("Proszę podać walutę wejściową");
        currency_in=scanner.next();
        System.out.println("Proszę podać walutę wyjściową");
        currency_out=scanner.next();
        Waluty waluty = new Waluty();
        value=waluty.to_PLN(value, currency_in);
        value=waluty.from_PLN(value, currency_out);
        System.out.println(value);



    }



}