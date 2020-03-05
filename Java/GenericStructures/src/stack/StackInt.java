package stack;

public class StackInt {

    public int maxSize;
    public int size = 0;

    public StackInt(int maxSize){
        this.maxSize = maxSize;
    }

    public StackElement tail;

    private class StackElement{
        private int value;
        private StackElement previous;

        private StackElement(int newValue, StackElement previous){
            this.previous = previous;
            this.value = newValue;
        }
    }

    public void pushInt(int newValue){
        if (this.size == maxSize){
            throw new IllegalStateException("Stack overflow");
        }
        this.tail = new StackElement(newValue, tail);
        this.size ++;
    }

    public int pop(){
        if (size == 0){
            throw new IllegalStateException("Empty stack");
        }
        else {
            int value = this.tail.value;
            this.tail = this.tail.previous;
            size--;
            return value;
        }
    }
}
