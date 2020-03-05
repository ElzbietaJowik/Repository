package figury;

public class Main<volume, volume5> {
    public static void main(String[] args) {

        Triangle triangle1 = new Triangle(3, 4, 5);
        double area1 = triangle1.area();
        double circuit1 = triangle1.circuit();
        System.out.println(area1);
        System.out.println(circuit1);

        Triangle triangle2 = new Triangle(3, 3, 3);
        double area2 = triangle2.area();
        double circuit2 = triangle2.circuit();
        System.out.println(area2);
        System.out.println(circuit2);

        Square square1 = new Square(7);
        double area3 = square1.area();
        double circuit3 = square1.circuit();
        System.out.println(area3);
        System.out.println(circuit3);

        Rectangle rectangle = new Rectangle(3, 4);
        double area4 = rectangle.area();
        double circuit4 = rectangle.circuit();
        System.out.println(area4);
        System.out.println(circuit4);

        Diamond diamond1 = new Diamond(4, 3, 7);
        double area5 = diamond1.area();
        double circuit5 = diamond1.circuit();
        System.out.println(area5);
        System.out.println(circuit5);

        Diamond diamond2 = new Diamond(4, 10, 3);
        double area6 = diamond2.area();
        double circuit6 = diamond2.circuit();
        System.out.println(area6);
        System.out.println(circuit6);

        Circle circle = new Circle(1);
        double area7 = circle.area();
        double circuit7 = circle.circuit();
        System.out.println(area7);
        System.out.println(circuit7);

        Ball ball = new Ball(5);
        double area8 = ball.area();
        double volume1 = ball.volume();
        System.out.println(area8);
        System.out.println(volume1);

        Cone cone = new Cone(3, 4);
        double area9 = cone.area();
        double volume2 = cone.volume();
        System.out.println(area9);
        System.out.println(volume2);

        Cuboid cuboid = new Cuboid(2, 3, 4);
        double area10 = cuboid.area();
        double volume3 = cuboid.volume();
        System.out.println(area10);
        System.out.println(volume3);

        Cube cube = new Cube(2);
        double area11 = cube.area();
        double volume4 = cube.volume();
        System.out.println(area11);
        System.out.println(volume4);

        Pyramid pyramid = new Pyramid(6, 4);
        double area12 = pyramid.area();
        double volume5 = pyramid.volume();
        System.out.println(area12);
        System.out.println(volume5);


        // Tworzymy nowy obiekt - figure, ktora chcemy miec w podstawie graniastoslupa
        Square square = new Square(3); // zmiana w klase square (juz nie dzidziczy po figurach tylko po Fig2D
        Graniastoslup graniastoslup = new Graniastoslup(square, 5);
        double volume = graniastoslup.volume();
        System.out.println(volume);
    }











    }