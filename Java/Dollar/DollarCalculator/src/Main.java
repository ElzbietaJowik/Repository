import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Arrays;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) throws Exception{
        String currency_in;
        Double value_in;
        Double value_out = 0.0;
        String st;

        File file = new File("/home/elzbieta/IdeaProjects/dolar.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));

        Scanner scanner = new Scanner(System.in);
        br.readLine();

        System.out.println("Proszę podać walutę wejściową");
        currency_in=scanner.next();

        System.out.println("Proszę podać wartość do przeliczenia");
        value_in=scanner.nextDouble();

        while ((st = br.readLine()) != null){

            String[] current = st.split("\t");
            if (current[1].equals(currency_in)){
                value_out = value_in * Double.parseDouble(current[3]);
                break;
            }
        }
        System.out.println(value_out);



    }
}