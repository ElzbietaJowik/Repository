package queue;

import com.sun.org.apache.xerces.internal.util.SynchronizedSymbolTable;

public class IntQueue {
    public int size = 0;
    public int maxSize;

    public IntQueue(int maxSize){this.maxSize = maxSize;}
    public QueueElement head;
    public QueueElement tail;

    private class QueueElement{

        int value;
        QueueElement prev;
        QueueElement next;

        private QueueElement(int newValue, QueueElement prev, QueueElement next){
            this.value = newValue;
            this.prev = prev;
            this.next = next;
        }

    }

    public void pushInt(int newValue) {
        if (size > maxSize) {
            throw new IllegalStateException("Queue overflow.");
        }
        else if (size == 0) {
            this.head = new QueueElement(newValue, null, null);
            this.tail = this.head;
            size++;
        }
        else {
            this.tail.next = new QueueElement(newValue, tail, null);
            this.tail = this.tail.next;
            size++;
        }
    }

    public int popInt() {
        if (size == 0) {
            throw new IllegalStateException("Empty queue");
        }
        else if(size == 1){
            int val = this.head.value;
            this.head = this.head.next;
            size --;
            return val;
        }
        else {
            int val = this.head.value;
            this.head = this.head.next;
            this.head.prev = null;
            size --;
            return val;
        }
    }

    // Dodatkowe funkcje zaimplementowane w celu przetestowania prawidlowosci kolejki

    public int getSize(){
        return size;
    }
    public int getHead(){
        return head.value;
    }
    public int getHeadPrev(){
        return head.prev.value;
    }
    public int getHeadNext(){
        return head.next.value;
    }
    public int getTailPrev(){
        return tail.prev.value;
    }
    public int getTail(){
        return tail.value;
    }


}