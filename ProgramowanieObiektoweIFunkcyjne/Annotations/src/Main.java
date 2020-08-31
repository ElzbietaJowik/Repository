package pl.edu.pw.mini.jrafalko;

import java.util.List;

public class Main {

    public static void main(String[] args) {

        List<Pracownik> pracownicy = FabrykaTajnePrzezPoufne.tworzZalogeFabryki();
        Cenzura cenzura = new Cenzura();
        for(Pracownik p : cenzura.cenzuruj(pracownicy)){
            System.out.println(p);
        }
    }
}
