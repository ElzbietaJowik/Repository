package practice;

import javax.imageio.ImageIO;
import javax.imageio.plugins.jpeg.JPEGImageReadParam;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.awt.image.BufferedImageOp;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;

import static javax.swing.JFrame.EXIT_ON_CLOSE;
import static javax.swing.JOptionPane.*;

public class ModifiedFoodOrder extends Component implements ActionListener{
    JFrame frame, frame2;
    JLabel l;
    JCheckBox cb1,cb2,cb3, cb4, cb5, cb6, cb7;
    JButton b, help;
    JOptionPane pane;

    JTextField a1 = new JTextField("1");
    JTextField a2 = new JTextField("1");
    JTextField a3 = new JTextField("1");
    JTextField a4 = new JTextField("1");
    JTextField a5 = new JTextField("1");
    JTextField a6 = new JTextField("1");
    JTextField a7 = new JTextField("1");

    JLabel label1 = new JLabel("");
    JLabel label2 = new JLabel("");
    JLabel label3 = new JLabel("");
    JLabel label4 = new JLabel("");
    JLabel label5 = new JLabel("");
    JLabel label6 = new JLabel("");
    JLabel label7 = new JLabel("");


    Toolkit tk = Toolkit.getDefaultToolkit();
    Image img1, img2, img3, img4, img5, img6, img7;


    ModifiedFoodOrder() throws IOException {
        frame = new JFrame("Food Order");
        l=new JLabel("Food Ordering System");
        l.setBounds(50,50,300,20);

        cb1=new JCheckBox("Pizza @ 100");
        cb1.setBounds(180,120,140,20);
        a1.setBounds(340, 120, 50, 20);

        img1 = tk.createImage("/home/elzbieta/Pobrane/pizza.jpg");
        label1.setIcon(new ImageIcon(img1));
        label1.setBounds(10, 100, 150, 100);

        cb2=new JCheckBox("Burger @ 30");
        cb2.setBounds(180,190,150,20);
        a2.setBounds(340, 190, 50, 20);
        img2 = tk.createImage("/home/elzbieta/Pobrane/burger.jpg");
        label2.setIcon(new ImageIcon(img2));
        label2.setBounds(10, 210, 150, 100);

        cb3 = new JCheckBox("Salad @ 15");
        cb3.setBounds(180,250,150,20);
        a3.setBounds(340, 250, 50, 20);
        img3 = tk.createImage("/home/elzbieta/Pobrane/salad.jpg");
        label3.setIcon(new ImageIcon(img3));
        label3.setBounds(10, 320, 150, 100);

        cb4 = new JCheckBox("Water @ 3");
        cb4.setBounds(180, 310, 150, 20);
        a4.setBounds(340, 310, 50, 20);

        cb5 = new JCheckBox("Juice @ 5");
        cb5.setBounds(180, 380, 150, 20);
        a5.setBounds(340, 380, 50, 20);
        img5 = tk.createImage("/home/elzbieta/Pobrane/juice.jpg");
        label5.setIcon(new ImageIcon(img5));
        label5.setBounds(10, 430, 150, 100);

        cb6=new JCheckBox("Tea @ 6");
        cb6.setBounds(180,450,150,20);
        a6.setBounds(340, 450, 50, 20);


        cb7 = new JCheckBox("Coffee @ 8");
        cb7.setBounds(180, 520, 150, 20);
        a7.setBounds(340, 520, 50, 20);


        b=new JButton("Order");
        b.setBounds(100,600,80,30);
        b.addActionListener(this);

        help = new JButton("?");
        help.setBounds(250, 600, 80, 30);
        help.addActionListener(this);

        frame.add(l);frame.add(cb1);frame.add(cb2);frame.add(cb3);frame.add(cb4);frame.add(cb5);frame.add(cb6);frame.add(cb7);frame.add(b);
        frame.add(a1);frame.add(a2);frame.add(a3);frame.add(a4);frame.add(a5);frame.add(a6);frame.add(a7);frame.add(help);
        frame.add(label1); frame.add(label2); frame.add(label3); frame.add(label4); frame.add(label5); frame.add(label6); frame.add(label7);
        frame.setSize(500,700);
        frame.setLayout(null);
        frame.setVisible(true);
        frame.setDefaultCloseOperation(EXIT_ON_CLOSE);
    }
    public void actionPerformed(ActionEvent e) {

        Object source = e.getSource();

        String in1 = a1.getText();
        double c1 = Double.parseDouble(in1);
        String in2 = a2.getText();
        double c2 = Double.parseDouble(in2);
        String in3 = a3.getText();
        double c3 = Double.parseDouble(in3);
        String in4 = a4.getText();
        double c4 = Double.parseDouble(in4);
        String in5 = a5.getText();
        double c5 = Double.parseDouble(in5);
        String in6 = a6.getText();
        double c6 = Double.parseDouble(in6);
        String in7 = a7.getText();
        double c7 = Double.parseDouble(in7);


        float amount = 0;
        String msg = "";
        String msg2;

        if (cb1.isSelected()) {
            amount += c1 * 100;
            msg += in1 + " x Pizza: " + c1 * 100 + "\n";
        }
        if (cb2.isSelected()) {
            amount += c2 * 30;
            msg += in2 +  " x Burger: " + c2 * 30 + "\n";
        }
        if (cb3.isSelected()) {
            amount += c3 * 15;
            msg += in3 + " x Salad: " + c3 * 15 + "\n";
        }
        if (cb4.isSelected()){
            amount += c4 * 3;
            msg += in4 + " x Water: " + c4 * 3 + "\n";
        }
        if (cb5.isSelected()){
            amount += c5 * 5;
            msg += in5 + " x Juice: " + c5 * 5 + "\n";
        }
        if (cb6.isSelected()) {
            amount += c6 * 6;
            msg += in6 + " x Tea: " + c6 * 6 + "\n";
        }
        if (cb7.isSelected()){
            amount += c7 * 8;
            msg += in7 + " x Coffee: " + c7 * 8 + "\n";

        }
        if (source == help) {
            msg2 = "Zaznacz produkt -> Wpisz ilość -> Zamów";
            JOptionPane helpPane = new JOptionPane();

            helpPane.showMessageDialog(frame2, msg2);
        }
        else if (source == b){
            //okno z wynikiem

            msg += "-----------------\n";
            pane = new JOptionPane();
            pane.showMessageDialog(frame, msg + "Total: " + amount);

        }

    }

    public static void main(String[] args) throws IOException {
        new ModifiedFoodOrder();
    }
}

// 5. Funkcjonalne okienko z możliwością zapłacenia po kliknięciu "order"
