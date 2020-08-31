package stack;

public class Stack <T> {

    public StackNode<T> tail;
    public int size = 0;
    public int maxSize;

    public Stack(int x){
        this.maxSize = x;
    }

    private class StackNode<T>{
        private T value;
        private StackNode<T> previous;

        private StackNode(T newElement, StackNode previous){
            this.previous = previous;
            this.value = newElement;
        }
    }
    public void push(T newValue){
        if (size > maxSize){
            throw new StackOverflowError("Stack overflow");
        }
        else{
            this.tail = new StackNode<>(newValue, tail);
            size ++;
        }
    }
    public T pop(){
        if (tail == null){
            throw new IllegalStateException("Empty Stack");
        }
        T value = this.tail.value;
        this.tail = this.tail.previous;
        size --;
        return value;
    }
    public int getSize(){
        return size;
    }
}