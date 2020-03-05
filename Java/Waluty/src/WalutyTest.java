import org.junit.jupiter.api.Assertions;
// Tworzenie testu [Ctrl+Shift+T] --> JUnit5

import static org.junit.jupiter.api.Assertions.*;

class WalutyTest {
    @org.junit.jupiter.api.Test
    void to_PLN() {
        Waluty waluty = new Waluty();
        double result;
        result = waluty.to_PLN(100, "PLN");
        Assertions.assertEquals(100, result);
        result = waluty.to_PLN(100, "EUR");
        Assertions.assertEquals(432, result);
        result = waluty.to_PLN(100, "USD");
        Assertions.assertEquals(382, result);
        result = waluty.to_PLN(100, "CHF");
        Assertions.assertEquals(381, result);
        result = waluty.to_PLN(100, "GBP");
        Assertions.assertEquals(494, result);
        result = waluty.to_PLN(100, "ILS");
        Assertions.assertEquals(105, result);
    }

    @org.junit.jupiter.api.Test
    void from_PLN() {
        Waluty waluty = new Waluty();
        double result = waluty.from_PLN(100, "PLN");
        Assertions.assertEquals(100, result);
        result = waluty.from_PLN(432, "EUR");
        Assertions.assertEquals(100, result);
        result = waluty.from_PLN(382, "USD");
        Assertions.assertEquals(100, result);
        result = waluty.from_PLN(381, "CHF");
        Assertions.assertEquals(100, result);
        result = waluty.from_PLN(494, "GBP");
        Assertions.assertEquals(100, result);
        result = waluty.from_PLN(105, "ILS");
        Assertions.assertEquals(100, result);

    }


}