package tab3D;
import java.util.Arrays;
import java.util.Random;
import static java.lang.Double.NEGATIVE_INFINITY;

public class Tab3D {

    private int [][][] array;

    public Tab3D(int l, int m, int n){ // Konstruktor, ktorego nazwa jest identyczna jak nazwa klasy
        array = new int[l][m][n];
    }

    public void Print(){
        System.out.print(Arrays.deepToString(array));

    }

    public void Fill(){

        Random random = new Random();

        for (int i = 0; i < array.length; i++){
            for (int j = 0; j < array[i].length; j++){
                for (int k = 0; k < array[i][j].length; k++){
                    array[i][j][k] = random.nextInt(9)+1;
                }

            }

        }

    }
    public double Average(){
        double sum = 0;
        double all = array.length*array[0].length*array[0][0].length;

        for (int i = 0; i < array.length; i++){
            for (int j = 0; j < array[i].length; j++){
                for (int k = 0; k < array[i][j].length; k++){
                    sum += array[i][j][k];
                }
            }
        }
        return sum/all;
    }

    public int Even(){
        int licznik = 0;

        for (int i = 0; i < array.length; i++){
            for (int j = 0; j < array[i].length; j++){
                for (int k = 0; k < array[i][j].length; k++){
                    if (array[i][j][k] % 2 == 0){
                        licznik ++;
                    }

                }
            }
        }
        return licznik;
    }

    public int Odd(){
        int licznik = 0;

        for (int i = 0; i < array.length; i++){
            for (int j = 0; j < array[i].length; j++){
                for (int k = 0; k < array[i][j].length; k++){
                    if (array[i][j][k] % 2 == 1){
                        licznik ++;
                    }
                }

            }
        }
        return licznik;
    }

    public double Bound(){
        double bound = NEGATIVE_INFINITY;

        for (int i = 0; i < array.length; i++){
            for (int j = 0; j < array[i].length; j++){
                for (int k = 0; k < array[i][j].length; k++){
                    if (array[i][j][k] > bound){
                        bound = array[i][j][k];
                    }
                }
            }
        }
        return bound;
    }

    public void GreaterThan(int number){
        for (int i = 0; i < array.length; i++){
            for (int j = 0; j < array[i].length; j++){
                for (int k = 0; k < array[i][j].length; k++){
                    if (array[i][j][k] < number){
                        array[i][j][k] = 0;
                    }
                }
            }
        }

    }

    public void Zeroing(){
        for (int i = 0; i < array.length; i++){
            for (int j = 0; j < array[i].length; j++){
                for (int k = 0; k < array[i][j].length; k++){
                    array[i][j][k] = 0;
                }
            }
        }
    }
}