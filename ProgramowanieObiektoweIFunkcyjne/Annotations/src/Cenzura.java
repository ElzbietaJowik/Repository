package pl.edu.pw.mini.jrafalko;

import pl.edu.pw.mini.jrafalko.censor.Censorable;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.function.BiConsumer;

public class Cenzura implements Censorable {

    /* Poniższych dwóch funkcjonalności używamy więcej niż 1 raz, dlatego też
    tworzymy metody, zamiast powtarzać w skrypcie wielokrotnie ten sam tekst
     */
    private BiConsumer<Field, Pracownik> wyczyscString = (Field f, Pracownik p) -> {
        if (f.getType().equals(String.class)){
            f.setAccessible(true);
            try {
                f.set(p, "");
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
            f.setAccessible(false);
        }
    };

    private BiConsumer<Field, Pracownik> zerujInt = (Field f, Pracownik p) -> {
        f.setAccessible(true);
        try {
            f.set(p, 0);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        f.setAccessible(false);
    };



    @Override
    public List<Pracownik> cenzuruj(List<Pracownik> list) {
        List<Pracownik> doUsuniecia = new ArrayList<>();
        for(Pracownik p : list) {

            // Zadanie 1.
            if(p.getClass().isAnnotationPresent(WyczyscString.class)) {
                // Polom dziedziczonym z nadklasy
                for(Field f : Pracownik.class.getDeclaredFields()) {
                    wyczyscString.accept(f, p);
                }
                // polom zadeklarowanym
                for(Field f : p.getClass().getDeclaredFields()) {
                    wyczyscString.accept(f, p);
                }
            }

            // Zadanie 2.
            for(Field f : p.getClass().getDeclaredFields()) {
                if (f.isAnnotationPresent(SkrocString.class)) {
                    f.setAccessible(true);
                    if (f.getType().equals(String.class)){
                        try {
                            String pocz = (String) f.get(p);
                            pocz = pocz.substring(0, 3);
                            f.set(p, pocz + "__");

                        } catch (IllegalAccessException e) {
                            e.printStackTrace();
                        }
                        f.setAccessible(false);
                    }
                }

                // Zadanie 3.
                if (f.isAnnotationPresent(PodmienString.class)) {
                    f.setAccessible(true);
                    try {
                        f.set(p, f.getAnnotation(PodmienString.class).tekstDoPodmiany());
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    }
                    f.setAccessible(false);
                }

                // Zadanie 4.
                if(f.isAnnotationPresent(WyzerujInt.class) && f.getType().equals(int.class)) {
                    zerujInt.accept(f, p);
                }
            }


            for(Field f : Pracownik.class.getDeclaredFields()) {
                if(f.isAnnotationPresent(WyzerujInt.class) && f.getType().equals(int.class)) {
                    zerujInt.accept(f, p);
                }
            }

            // Zadanie 5.
            for(Method m : p.getClass().getDeclaredMethods()) {
                if(m.isAnnotationPresent(WykonajNRazy.class)) {
                    for(int i = 0; i < m.getAnnotation(WykonajNRazy.class).value(); i++) {
                        try {
                            m.setAccessible(true);
                            m.invoke(p);
                            m.setAccessible(false);
                        } catch (IllegalAccessException | InvocationTargetException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }

            // Zadanie 6.
            if(p.getClass().isAnnotationPresent(ProduktLubLiczba.class)) {
                try {
                    if(p.getClass().getAnnotation(ProduktLubLiczba.class).
                            value().equals(ProduktLubLiczba.zbiorWartosci.LICZBA)) {
                        for(Field f : p.getClass().getDeclaredFields()) {
                            if(f.getType().equals(int.class)) {
                                f.setAccessible(true);
                                f.set(p, -1);
                                f.setAccessible(false);
                            }
                        }
                        for(Field f : Pracownik.class.getDeclaredFields()) {
                            if(f.getType().equals(int.class)) {
                                f.setAccessible(true);
                                f.set(p, -1);
                                f.setAccessible(false);
                            }
                        }
                    } else {
                        Field f = p.getClass().getDeclaredField("produkowanyElement");
                        f.setAccessible(true);
                        f.set(p, Produkty.BOMBKI);
                        f.setAccessible(false);
                    }
                } catch (IllegalAccessException | NoSuchFieldException e) {
                    e.printStackTrace();
                }
            }

            // Zadanie 7.
            if(p.getClass().isAnnotationPresent(UsunMlodych.class)) {
                try {
                    Field wiek = Pracownik.class.getDeclaredField("wiek");
                    wiek.setAccessible(true);
                    if((int) wiek.get(p) < 30) {
                        doUsuniecia.add(p);
                    }
                } catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        }
        for(Pracownik p : doUsuniecia) list.remove(p);
        return list;
    }
}
