package foodControl;

import javax.swing.*;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.table.DefaultTableModel;
import javax.swing.text.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.io.*;
import java.lang.reflect.Array;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static java.lang.Math.round;

public class FoodController extends Component implements ActionListener {

    JFrame initialFrame, helpFrame, menuFrame, summarizeFrame; // Pierwsze okno po uruchomieniu aplikacji
    JLabel l1, l2, l3, l4; // Etykiety "Food Controller System", "Select Meal Time"
    JComboBox cb; // Rozwijana lista z możliwościami wyboru posiłku (Śniadanie/Obiad/Kolacja)
    JButton hb, b1, b2, b3, b4, b5, b6, b7; // helpButton - przyciski "?", "Go to MENU"
    String[] choices = {"Breakfast", "Dinner", "Supper"}; // pory posiłków do wyboru
    JTextField a1; // pola tekstowe do wprowadzania ilości poszczególnych produktów w posiłku
    double in1;
    Double[] total;
    JTextField field_search;
    DefaultTableModel tableModel_Sum;
    String fav_text;
    JMenuBar menuBar;
    JMenu menu;
    JMenuItem menuItem,menuItem1;
    JLabel label_search;

    File historyFile = new File("./History.txt"); // Historia zapisywanych posiłków
    File favorites = new File("./Favorites.txt"); // Posiłki ulubione
    String hist;
    String fav;
    JFrame favFrame;
    JTextField fav_Field;
    JButton favButton;
    JLabel favLabel;
    JTable sumTab;


    FoodController() throws IOException, ClassNotFoundException, UnsupportedLookAndFeelException, InstantiationException, IllegalAccessException {
        // Pierwsze okno po uruchomieniu aplikacji
        UIManager.setLookAndFeel(
                "com.sun.java.swing.plaf.gtk.GTKLookAndFeel");
        initialFrame = new JFrame("Food Controller");
        initialFrame.setSize(400, 400);
        initialFrame.setLayout(null);
        initialFrame.setVisible(true);
        initialFrame.setResizable(false);
        initialFrame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

        // Etykieta okna
        l1 = new JLabel("Food Controller System");
        l1.setBounds(50, 30, 300, 20);
        initialFrame.add(l1);

        // Etykieta listy rozwijanej
        l2 = new JLabel("Select Meal Time");
        l2.setBounds(90, 80, 300, 20);
        initialFrame.add(l2);

        // Lista rozwijana z porami posiłków do wyboru - domyślny wybór to śniadanie
        cb = new JComboBox(choices);
        cb.setBounds(125, 110, 150, 40);
        initialFrame.add(cb);

        // Przycisk odpowiadający za przejście od okna początkowego do MENU.
        b1 = new JButton("Go to MENU");
        b1.setBounds(135, 170, 130, 40);
        b1.addActionListener(this);
        initialFrame.add(b1);

        // Przycisk wyświetlający instrukcję obsługi aplikacji
        hb = new JButton("?");
        hb.setBounds(300, 300, 50, 30);
        hb.addActionListener(this);
        initialFrame.add(hb);

        // Przycisk odpowiadający za wyświetlenie historii posiłków
        b3 = new JButton("Display history");
        b3.setBounds(20, 300, 200, 30);
        b3.addActionListener(this);
        initialFrame.add(b3);

        //Przycisk odpowiadający za wyświetlenie ulubionych
        b7 = new JButton("Display favourites");
        b7.setBounds(20, 250, 200, 30);
        b7.addActionListener(this);
        initialFrame.add(b7);

        //Create the menu bar.
        menuBar = new JMenuBar();

//Build the first menu.
        menu = new JMenu("Options");
        menuBar.add(menu);

//a group of JMenuItems
        menuItem = new JMenuItem("Clear history");
        menu.add(menuItem);

        menuItem1 = new JMenuItem("Clear favorites");
        menu.add(menuItem1);

        initialFrame.setJMenuBar(menuBar);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        JButton add = new JButton();
        String[] col = {"Igredient", "Quantity", "Calories", "Fat", "Sugar", "Protein"};
        DefaultTableModel tableModel = new DefaultTableModel(null, col);
        JTable table = new JTable(tableModel) {
            private static final long serialVersionUID = 1L;

            public boolean isCellEditable(int row, int column) {
                return false;
            }

            ;
        };
        //logika tabelki i listy do dodawania danych
        JScrollPane pane = new JScrollPane(table);
        DefaultListModel<String> model = new DefaultListModel<>();
        JList<String> list = new JList<>(model);
        JScrollPane pan = new JScrollPane(list);

        HashMap<String, List<Double>> kcal
                = new HashMap<>();

        List<List<String>> records = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader("./nutrients1.csv"))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");
                records.add(Arrays.asList(values));

            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        for (List<String> l : records) {
            double fat = Double.parseDouble(l.get(1));
            double sugar = Double.parseDouble(l.get(2));
            double calories = Double.parseDouble(l.get(3));
            double protein = Double.parseDouble(l.get(4));
            ArrayList<Double> lista = new ArrayList<>();
            lista.add(calories);
            lista.add(fat);
            lista.add(sugar);
            lista.add(protein);
            kcal.put(l.get(0), lista);
        }

        //nasluchiwanie na akcje
        Object source = e.getSource();

        // Obsługa przycisku "?"
        String helpMsg;

        if (source == hb) {
            helpMsg = "Select meal -> Go to MENU -> Select products -> Type in their quantities -> Conclude";
            JOptionPane helpPane = new JOptionPane();

            helpPane.showMessageDialog(helpFrame, helpMsg);
        }


        menuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev) {
                try {
                    new PrintWriter("./History.txt").close();
                } catch (FileNotFoundException ex) {
                    ex.printStackTrace();
                }
            }
        });
        menuItem1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev) {
                try {
                    new PrintWriter("./Favorites.txt").close();
                } catch (FileNotFoundException ex) {
                    ex.printStackTrace();
                }
            }

        });

        // Wyświetlenie historii
        if (source == b3) {
            try {
                hist = "History: \n";
                Scanner sc = new Scanner(historyFile);
                while (sc.hasNextLine()) {
                    hist += sc.nextLine() + "\n";
                }
            } catch (FileNotFoundException ex) {
                ex.printStackTrace();
            }
           //ustawianie historii
            JTextArea textArea = new JTextArea(10, 25);
            textArea.setText(hist);
            textArea.setEditable(false);

            JScrollPane scrollPane = new JScrollPane(textArea);

            JOptionPane.showMessageDialog(summarizeFrame, scrollPane);
        }
        //ustawianie tekstu ulubionych
        if (source == b7) {
            try {
                fav = "Favourites: \n";
                Scanner sc = new Scanner(favorites);
                while (sc.hasNextLine()) {
                    fav += sc.nextLine() + "\n";
                }
            } catch (FileNotFoundException ex) {
                ex.printStackTrace();
            }
            JTextArea textArea1 = new JTextArea(10, 25);
            textArea1.setText(fav);
            textArea1.setEditable(false);

            JScrollPane scrollPane = new JScrollPane(textArea1);

            JOptionPane.showMessageDialog(summarizeFrame, scrollPane);
        }

        // Przechodzenie do list produktów dostosowanych do wybranego posiłku
        if (source == b1) {
            for (String key : kcal.keySet()) {
                model.addElement(key);
            }

            menuFrame = new JFrame("MENU");
            menuFrame.setSize(700, 700);
            menuFrame.setLayout(null);
            menuFrame.setVisible(true);
            menuFrame.setResizable(false);

            //obsluga ilosci dodawanych gramow posliku
            a1 = new JTextField("100");
            ((AbstractDocument) a1.getDocument()).setDocumentFilter(new DocumentFilter() {
                Pattern regEx = Pattern.compile("\\d*");

                @Override
                public void replace(DocumentFilter.FilterBypass fb, int offset, int length, String text, AttributeSet attrs) throws BadLocationException {
                    Matcher matcher = regEx.matcher(text);
                    if (!matcher.matches()) {
                        return;
                    }
                    super.replace(fb, offset, length, text, attrs);
                }
            });
            ;
            //obsluga danych
            l1 = new JLabel("g");
            l1.setBounds(300, 600, 30, 30);
            menuFrame.add(l1);
            a1.setBounds(190, 600, 100, 30);
            menuFrame.add(a1);
            add.setText("Add");
            add.setBounds(20, 600, 150, 30);
            menuFrame.add(add);
            pan.setBounds(20, 50, 200, 500);
            menuFrame.add(pan);
            pane.setBounds(250, 50, 430, 410);
            menuFrame.add(pane);
            col[0] = "Sum";
            tableModel_Sum = new DefaultTableModel(null, col);
            JTable sumTab = new JTable(tableModel_Sum) {
                private static final long serialVersionUID = 1L;

                public boolean isCellEditable(int row, int column) {
                    return false;
                }

                ;
            };

            JScrollPane pane_sum = new JScrollPane(sumTab);
            pane_sum.setBounds(250, 460, 430, 75);
            menuFrame.add(pane_sum);


            //niezbedne przyciski
            b4 = new JButton("Add to favorites");
            b4.setBounds(20, 560, 150, 30);
            b4.addActionListener(this);
            menuFrame.add(b4);

            field_search = new JTextField(1);
            field_search.setBounds(190, 560, 100, 30);
            field_search.addActionListener(this);
            menuFrame.add(field_search);

            label_search = new JLabel("Search");
            label_search.setBounds(300, 560, 50, 30);
            menuFrame.add(label_search);


            b6 = new JButton("Close MENU");
            b6.setBounds(350, 600, 160, 30);
            b6.addActionListener(this);
            menuFrame.add(b6);

        }

        if (source == b6) {
            tableModel.setRowCount(0);
            model.clear();
            menuFrame.dispose();
        }

        //obsluga pola do szukania w potrawach
        field_search.getDocument().addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                filter();
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                filter();
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
            }

            private void filter() {
                String filter = field_search.getText();
                filterModel((DefaultListModel<String>) list.getModel(), filter);
            }

            public void filterModel(DefaultListModel<String> model, String filter) {
                for (String s : kcal.keySet()) {
                    if (!s.startsWith(filter)) {
                        if (model.contains(s)) {
                            model.removeElement(s);
                        }
                    } else {
                        if (!model.contains(s)) {

                            model.addElement(s);
                        }
                    }
                }
            }
        });

        total = new Double[6];
        total[0] = null;
        total[1] = (double) 0;
        total[2] = (double) 0;
        total[3] = (double) 0;
        total[4] = (double) 0;
        total[5] = (double) 0;
        add.addActionListener(e1 -> {

            //obsluga przycisku dodawania jedzenia
            String selectedPlanet = list.getSelectedValue();
            String a = a1.getText();
            in1 = Double.parseDouble(a);
            double kc = Math.round((kcal.get(selectedPlanet).get(0) * in1) / 100.0);
            double fat = Math.round((kcal.get(selectedPlanet).get(1) * in1) / 100.0);
            double sugar = Math.round((kcal.get(selectedPlanet).get(2) * in1) / 100.0);
            double protein = Math.round((kcal.get(selectedPlanet).get(3) * in1) / 100.0);
            tableModel.addRow(new Object[]{selectedPlanet, in1, kc, fat, sugar, protein});
            total[1] += in1;
            total[2] += kc;
            total[4] += sugar;
            total[3] += fat;
            total[5] += protein;
            tableModel_Sum.setRowCount(0);
            tableModel_Sum.insertRow(0, new Object[]{total[0], total[1], total[2], total[3], total[4], total[5]});


            try {
                //zapis do pliku historii
                BufferedWriter bfw = new BufferedWriter(new FileWriter("./History.txt", true));

                for (int i = 0; i < tableModel.getRowCount(); i++) {
                    bfw.newLine();
                    bfw.write(choices[cb.getSelectedIndex()] + " ");
                    Date date = new Date(); // this object contains the current date value
                    SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
                    bfw.write(formatter.format(date) + "\n");
                    bfw.write(tableModel.getValueAt(i, 0) + "\n");
                    for (int j = 0; j < tableModel.getColumnCount(); j++) {
                        if (j == 1) {
                            bfw.write(tableModel.getValueAt(i, j) + " g" + "\n");
                            bfw.write("\t");
                        }
                        if (j == 2) {
                            bfw.write(tableModel.getValueAt(i, j) + " kcal" + "\n");
                            bfw.write("\t");
                        }
                        if (j == 3) {
                            bfw.write(tableModel.getValueAt(i, j) + " fat (g)" + "\n");
                            bfw.write("\t");
                        }
                        if (j == 4) {
                            bfw.write(tableModel.getValueAt(i, j) + " sugar (g)" + "\n");
                            bfw.write("\t");
                        }
                        if (j == 5) {
                            bfw.write(tableModel.getValueAt(i, j) + " protein (g)" + "\n");
                            bfw.write("\t");
                        }
                        ;
                    }
                }
                bfw.close();

            } catch (IOException ex) {
                ex.printStackTrace();
            }

        });
        //dodawanie wlasnego posilku
        b4.addActionListener(e1 -> {
            favFrame = new JFrame("Own meal");
            favFrame.setSize(300, 150);
            favFrame.setLayout(null);
            favFrame.setVisible(true);
            favFrame.setResizable(false);

            favLabel = new JLabel("Add to favourites");
            favLabel.setBounds(30, 10, 150, 30);
            favFrame.add(favLabel);


            fav_Field = new JTextField("");
            fav_Field.setBounds(30, 40, 200, 30);
            fav_Field.addActionListener(this);
            favFrame.add(fav_Field);
            //ograniczenie mozliwosci wpisywania do ulubiionych potraw
            class CharFilter extends DocumentFilter {

                public void insertString(DocumentFilter.FilterBypass fb, int offset,
                                         String string, AttributeSet attr)
                        throws BadLocationException {

                    StringBuffer buffer = new StringBuffer(string);
                    for (int i = buffer.length() - 1; i >= 0; i--) {
                        char ch = buffer.charAt(i);
                        if (!Character.isLetter(ch)) {
                            buffer.deleteCharAt(i);
                        }
                    }
                    super.insertString(fb, offset, buffer.toString(), attr);
                }

                public void replace(DocumentFilter.FilterBypass fb,
                                    int offset, int length, String string, AttributeSet attr) throws BadLocationException {
                    if (length > 0) {
                        fb.remove(offset, length);
                    }
                    insertString(fb, offset, string, attr);
                }
            }
            ((AbstractDocument)fav_Field.getDocument()).setDocumentFilter(new CharFilter());

            favButton = new JButton("Add");
            favButton.setBounds(30, 80, 100, 30);
            favButton.addActionListener(this);
            favFrame.add(favButton);
            //zapis do ulubionych
            favButton.addActionListener(f -> {
                try {
                    BufferedWriter bfw = new BufferedWriter(new FileWriter("./nutrients1.csv", true));
                    bfw.write(fav_Field.getText() + "," + tableModel_Sum.getValueAt(0,1) + "," +
                            tableModel_Sum.getValueAt(0,2) + "," + tableModel_Sum.getValueAt(0,3)
                            + "," + tableModel_Sum.getValueAt(0,4));
                    bfw.newLine();
                    bfw.close();

                } catch (IOException ex) {
                    ex.printStackTrace();
                }

                try {
                    BufferedWriter bfw = new BufferedWriter(new FileWriter("./Favorites.txt", true));
                        bfw.newLine();
                        bfw.write(fav_Field.getText() + "\n");
                        for (int j = 0; j < tableModel_Sum.getColumnCount(); j++) {
                            if (j == 1) {
                                bfw.write("\t");
                                bfw.write(tableModel_Sum.getValueAt(0, j) + " mass (g)" + "\n");
                                bfw.write("\t");
                            }
                            if (j == 2) {
                                bfw.write(tableModel_Sum.getValueAt(0, j) + " kcal" + "\n");
                                bfw.write("\t");
                            }
                            if (j == 3) {
                                bfw.write(tableModel_Sum.getValueAt(0, j) + " fat (g)" + "\n");
                                bfw.write("\t");
                            }
                            if (j == 4) {
                                bfw.write(tableModel_Sum.getValueAt(0, j) + " sugar (g)" + "\n");
                                bfw.write("\t");
                            }
                            if (j == 5) {
                                bfw.write(tableModel_Sum.getValueAt(0, j) + "protein (g)" + "\n");
                                bfw.write("\t");
                            }
                            ;
                        }
                    bfw.close();


                } catch (IOException ex) {
                    ex.printStackTrace();
                }
                favFrame.dispose();
            });

        });
    }





    public static void main(String[] args) throws IOException, ClassNotFoundException, UnsupportedLookAndFeelException, InstantiationException, IllegalAccessException {
        new FoodController();
    }
}
