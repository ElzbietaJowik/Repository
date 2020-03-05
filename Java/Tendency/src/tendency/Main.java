package tendency;

public class Main {

    public static void main(String[] args) {

        double[] timeSeries = {4.5, 4.0, 5.0, 4.0};

        Tendency tendency1; /* Możemy wykorzystać abstrakcję by określić
                        wstępne założenia,jak konieczność
                        policzenia tendencji dla szeregu czasowego */

        // Następnie, w zależności od potrzeb, zastosować właściwą implementację

        tendency1 = new Mode(timeSeries); /* Mimo, ze zadeklatowalismy typ zmiennej jako Tendency
                                            mozemy ja zainicjalizowac jako mode */

        System.out.println("The most popular wage among " + tendency1.getSeriesLength() + " bets is " + tendency1.calculateTendency());

        Tendency tendency2;

        tendency2 = new Mean(timeSeries);
        System.out.println("The average for " + tendency2.getSeriesLength() + " marks is " + tendency2.calculateTendency());

    }
}
