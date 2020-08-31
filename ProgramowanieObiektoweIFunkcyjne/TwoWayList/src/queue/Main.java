package queue;

public class Main {
    public static void main(String[] args){

        Queue<String> queue = new Queue<>(3);
        System.out.println(queue.getSize());
        queue.pushHead("ma");
        queue.pushHead("Ala");
        queue.pushTail("kota");
        // queue.pushTail("dodatkowy");


        System.out.println(queue.getHead());
        System.out.println(queue.getTail());
        System.out.println(queue.popHead());
        System.out.println(queue.popHead());
        System.out.println(queue.popHead());
        System.out.println(queue.popHead());






    }
}