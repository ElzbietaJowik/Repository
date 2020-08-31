package pl.edu.pw.mini.jrafalko.censor;

import pl.edu.pw.mini.jrafalko.Pracownik;

import java.util.List;

public interface Censorable {
    List<Pracownik> cenzuruj(List<Pracownik> list);
}
