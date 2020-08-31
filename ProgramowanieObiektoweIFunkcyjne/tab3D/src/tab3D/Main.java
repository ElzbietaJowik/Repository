package tab3D;

public class Main {
    public static void main(String[] args){

        Tab3D array = new Tab3D(3, 4, 5);

        array.Print();
        System.out.print("\n");
        array.Fill();
        array.Print();
        System.out.print("\n");
        double average = array.Average();
        System.out.println(average);
        int even = array.Even();
        System.out.println(even);
        int odd = array.Odd();
        System.out.println(odd);
        double bound = array.Bound();
        System.out.println(bound);
        array.GreaterThan(4);
        array.Print();
        System.out.print("\n");
        array.Zeroing();
        array.Print();
    }

}
