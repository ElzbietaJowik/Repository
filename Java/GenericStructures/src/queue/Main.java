package queue;

public class Main {
    public static void main(String[] args){

        IntQueue intQueue = new IntQueue(4);

        intQueue.pushInt(1);
        intQueue.pushInt(2);
        intQueue.pushInt(3);
        intQueue.pushInt(4);
        intQueue.popInt();
        intQueue.popInt();
        System.out.println(intQueue.getSize());
        intQueue.popInt();
        System.out.println(intQueue.getSize());
        intQueue.popInt();
        System.out.println(intQueue.getSize());
        intQueue.popInt();



        Queue<Person> queue = new Queue<>(3);
        queue.push(new Person("Janek"));
        queue.push(new Person("Piotrek"));
        queue.push(new Person("Filip"));
        System.out.println(queue.getHead());
        System.out.println(queue.getHeadNext());
        System.out.println(queue.getTail());
        System.out.println(queue.pop());
        System.out.println(queue.pop());
        System.out.println(queue.pop());
        System.out.println(queue.pop());

    }
}
