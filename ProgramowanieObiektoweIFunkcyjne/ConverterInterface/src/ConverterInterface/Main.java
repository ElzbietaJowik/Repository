package ConverterInterface;
import javafx.beans.binding.DoubleExpression;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.Scanner;
import static javax.swing.JFrame.EXIT_ON_CLOSE;


public class Main extends Component {

    public static void main(String[] args) throws Exception {
        // Wczytanie pliku
        String st;
        String[] names = new String[148];
        Double[] value = new Double[148];
        int counter = 0;

        File file = new File("/home/elzbieta/IdeaProjects/dolar.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));

        br.readLine();


        while ((st = br.readLine()) != null) {

            String[] current = st.split("\t");
            names[counter] = current[1];
            String tmp = current[2];
            String replace = tmp.replace(",", "");

            value[counter] = Double.parseDouble(replace);
            counter++;


        }
        new Main(names, value);
    }


    JFrame frame;
    JComboBox cb;
    JTextField in;
    JButton b;
    JLabel label1, label2;
    JOptionPane pane, errorPane;


    Main(String[] names, Double[] value) throws IOException {

        frame = new JFrame("Converter");
        frame.setSize(300, 200);
        frame.setVisible(true);
        frame.setLayout(null);

        label1 = new JLabel();
        label1.setHorizontalAlignment(JLabel.CENTER);
        label1.setSize(400, 100);
        frame.add(label1);

        cb = new JComboBox(names);
        cb.setBounds(30, 100, 90, 30);
        frame.add(cb);

        in = new JTextField("0");
        in.setBounds(30, 50, 90, 30);
        frame.add(in);
        label2 = new JLabel("$");
        label2.setBounds(120, 40, 50, 50);
        frame.add(label2);

        b = new JButton("Policz!");
        b.setBounds(160, 75, 90, 40);
        frame.add(b);

        frame.setDefaultCloseOperation(EXIT_ON_CLOSE);

        b.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {

                String input = in.getText();
                double inp = 0;
                boolean numeric = true;

                try {
                    inp = Double.parseDouble(input);
                } catch (NumberFormatException ev){
                    numeric = false;
                }
                if (!numeric){
                    errorPane = new JOptionPane();
                    errorPane.showMessageDialog(frame,"SORRY, Invalid Data Type :(");
                    return;
                }


                double val = value[cb.getSelectedIndex()];

                double result = val * inp;

                pane = new JOptionPane();
                pane.showMessageDialog(frame, "The amount of money after conversion is: " + String.format("%.2f",result));
            }
        });
    }
}
