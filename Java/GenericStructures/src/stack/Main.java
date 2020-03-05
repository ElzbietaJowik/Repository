package stack;

public class Main {
    public static void main(String[] args){

        StackInt stackInt = new StackInt(3);
        stackInt.pushInt(4);
        stackInt.pushInt(6);
        stackInt.pushInt(8);
        int pop = stackInt.pop();
        System.out.println(pop);

        Stack<String> stos2 = new Stack<>(10); //diamond operator
        stos2.push("Ala");
        stos2.push("Ola");
        System.out.println(stos2.getSize());
        System.out.println(stos2.pop());
        System.out.println(stos2.pop());
    }
}
