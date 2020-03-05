package temperatures;

import javax.swing.plaf.metal.MetalInternalFrameTitlePane;
import java.io.*;
import java.lang.reflect.Array;
import java.time.Year;
import java.util.Arrays;
import java.util.Scanner;

import static jdk.nashorn.internal.objects.NativeMath.max;
import static jdk.nashorn.internal.objects.NativeMath.round;

public class Main {
    public static void main(String[] args) throws Exception {

        /* Wszystkie operacje wykonywane są w czasie bieżacego zczytywania danych z pliku,
        Dzięki temu nie musimy zapisywać danych w tablicy i oszczędzamy pamięć */

        File file = new File("/home/elzbieta/IdeaProjects/temperatures.txt");
        Scanner scanner = new Scanner(file); // Służy zapisowi wniosków dla średniej temperatury w 2019 roku w odpowiednim momencie
        BufferedReader br = new BufferedReader(new FileReader(file));

        File report = new File("/home/elzbieta/IdeaProjects/report.txt");
        BufferedWriter writer = new BufferedWriter(new FileWriter(report));
        String st;


        double minTemp = Double.POSITIVE_INFINITY;
        double maxTemp = Double.NEGATIVE_INFINITY;
        String minDate = null;
        String maxDate = null;

        int year;
        int prevYear = 1995; // Ustawiam datę na najwcześniejszą odnotowaną w pliku, przyjmuję że mamy ją daną.
        int month;
        double sum = 0;
        double count = 0;
        double average1995 = 0;
        double average2018 = 0;

        double quarter2018 = 0;
        double quarter2019 = 0;
        String min = null;
        String max = null;


        while ((st = br.readLine()) != null) {
            scanner.nextLine(); // Służy dojściu do końca pliku, aby w odpowiednim momencie
                                // zapisać wnioski z obliczeń dla 2019 roku

            String replaceString1 = st.replaceAll(" {2,}", "\t");
            String[] data = replaceString1.split("\t");

            /* Czyli: każdą sekwencję spacji o długości 2 lub większej zamień na tabulatory.
            replaceAll, bo tak twierdzi Stack.
            Długości 2 lub większej, bo na początku (prawie!) każdego wiersza jest spacja.
            Taby, bo bardziej elegancko i jesteśmy do nich przyzwyczajeni (równie dobrze może być 9 spacji).
            Dzięki temu również wystarczy, że trimujemy tylko data[0].*/

            data[0] = data[0].trim();

            // [miesiąc, dzień, rok, temperatura]

            double fahrenheit = Double.parseDouble(data[3]); // Temperatura w Fahrenheitach
            double celsjus = (fahrenheit - 32) / 1.8;

            // 1. WYZNACZENIE WARTOŚCI MINIMALNEJ I MAKSYMALNEJ TEMPERATURY
            // ORAZ DATY ICH ODNOTOWANIA

            if (celsjus > maxTemp){
                maxTemp = celsjus; // Maksymalna temperatura w Cejcjuszach
                maxDate = data[1] + "." + data[0] + "." + data[2];
            }
            else if (celsjus < minTemp){
                minTemp = celsjus; // Minimalna temperatura w Celcjuszach
                minDate = data[1] + "." + data[0] + "." + data[2];

            }
            min = String.format("%.2f",minTemp);
            max = String.format("%.2f",maxTemp);

            // 2. WYZNACZENIE ŚREDNICH ROCZNYCH TEMPERATUR
            year = Integer.parseInt(data[2]);
            prevYear = Integer.parseInt(String.valueOf(prevYear));
            month = Integer.parseInt(String.valueOf(data[0]));


            if (year == prevYear){
                sum += celsjus;
                count ++;

                if (!scanner.hasNextLine()){ /* Dzięki scannerowi, który zczytawszy wszystkie linie nie ma natępnika,
                                              zapisujemy średnią temp dla 2019 roku,
                                                dla którego mamy niepełne dane */
                    double rounded = Math.round(sum * 100 / count);
                    double average = rounded / 100;
                    String text = "Średnia roczna temperatura w " + year + " roku wynosi w zaokrągleniu: " + average  + " °C." + "\n";
                    writer.write(text);
                }
                if (year == 2018 & !(month > 3)){ // Warunek !(month > 3) stanowi zabezpieczenie przed niepełnym kwartałem
                    quarter2018 = sum/count;
                }
                else if (year == 2019 & !(month > 3)){
                    quarter2019 = sum/count;
                }


            }

            else{
                double rounded = Math.round(sum * 100 / count);
                double average = rounded / 100;
                String text = "Średnia roczna temperatura w " + prevYear + " roku wynosi w zaokrągleniu: " + average  + " °C." + "\n";
                writer.write(text);
                if (prevYear == 1995) {
                    average1995 = average;
                }
                if (prevYear == 2018){
                    average2018 = average;
                }

                sum = celsjus; /* Odnotowujemy wartość temperatury dla pierwszego
                                wystąpienia w danym roku */
                count = 1;     // Odnotowujemy pierwsze wystąpienie dla danego roku
                prevYear = year; /* Zerując wartości sum i licznika (count) pominęlibyśmy jedną w temperatur
                                  (pierwszą) w każdym roku, bo kazdy z wczytywanych wierszy rozpatrujemy tylko 1 raz */
            }

        }
        double difference = Math.abs(average2018 - average1995);
        String final4;

        if (quarter2018 > quarter2019){
            final4 = "Pierwszy kwartał 2018 roku był cieplejszy niż pierwszy kwartał 2019. ";
        }
        else if (quarter2018 == quarter2019){
            final4 = "Srednie temperatury w pierwszych kwartałach w latach 2018-2019 były równe.";
        }
        else{
            final4 = "Pierwszy kwartał 2019 roku był cieplejszy niż pierwszy kwartał 2018. ";
        }

        String final1 =  "Różnica między średnią roczną temperaturą w 1995 i 2018 roku wynosi: " + String.format("%.2f",difference) + " °C." + "\n";
        String final2 = "Minimalną temperaturę odnotowano: " + minDate + ". Wynosiła ona w zaokrągleniu: " + min + " °C." + "\n";
        String final3 = "Minimalną temperaturę odnotowano: " + maxDate + ". Wynosiła ona w zaokrągleniu: " + max + " °C." + "\n";
        writer.write(final1);
        writer.write(final2);
        writer.write(final3);
        writer.write(final4);
        writer.close();


    }
}
