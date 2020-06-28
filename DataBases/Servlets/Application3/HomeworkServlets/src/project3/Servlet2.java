package project3;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import java.util.Date;

import javax.servlet.*;
import javax.servlet.http.*;

public class Servlet2 extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1250";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet2</title></head>");
        out.println("<body>");
        
        
        Connection con = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection("jdbc:sqlserver://localhost\\MSSQLEXPRESS: 1433; databaseName=RRaces", "ejowik", "tu6Ieb2a");
            
            Statement statement = con.createStatement();
            
            
            PreparedStatement ps = con.prepareStatement("UPDATE [RRaces].[dbo].[Races] SET Price = ? * Price " +
                                                        "WHERE City LIKE ? AND Distance >= ? ");
            
            PreparedStatement cnt = con.prepareStatement("SELECT COUNT(*) AS count FROM [RRaces].[dbo].[Races] " +
                                                        "WHERE City LIKE ? AND Distance >= ? ");
                        
            try{        
            ps.setDouble(1,(Double.parseDouble(request.getParameter("priceChange"))+1));
            } catch(Exception e){
                ps.setDouble(1, 0);
            }
                    
            try{
            ps.setString(2,request.getParameter("city") + "%");
            cnt.setString(1,request.getParameter("city") + "%");
            } catch(Exception e){
                ps.setString(2, "%");
                cnt.setString(1, "%");
            }
            
            try{        
            ps.setDouble(3,Double.parseDouble(request.getParameter("mindist")));
            cnt.setDouble(2,Double.parseDouble(request.getParameter("mindist")));
            } catch(Exception e){
                ps.setDouble(3, 0);
                cnt.setDouble(2, 0);
            }
            

            ResultSet NrOfRowsAffected = cnt.executeQuery();

            String NrOfRowsChanged = null;
            
            try{
                while (NrOfRowsAffected.next()) {
                    NrOfRowsChanged = NrOfRowsAffected.getString("count");
                }

            } catch(Exception e){
                NrOfRowsChanged = "0";
            }
            ps.executeUpdate();
            con.commit();
            
            out.println("<h2>" + NrOfRowsChanged + " row/rows updated</h2>");
            
            out.println("<h1> NEW PRICES FOR RACES </h1>");  
            ResultSet rs = statement.executeQuery("SELECT * FROM [RRaces].[dbo].[Races]");
            
            out.println(
                "<html>\n" + 
                "<head>\n" + 
                "<style>\n" + 
                "table, th, td {\n" + 
                "  border: 1px solid black;\n" + 
                "}\n" + 
                "</style>" +
                "<table style=\"width:100%\">\n" + 
                "<tr>\n" + 
                "<th>Name</th>\n" + 
                "<th>City</th> \n" + 
                "<th>Price</th>\n" + 
                "<th>Distance</th> \n" + 
                "<th>Number Cups</th>\n" + 
                "</tr>"
                );
            while (rs.next()) { 
                out.println("<tr><td>" +
                            rs.getString("Name") +
                            "</td><td>" + 
                            rs.getString("City") + 
                            "</td><td>" + 
                            rs.getString("Price") + 
                            "</td><td>" + 
                            rs.getString("Distance") + 
                            "</td><td>" + 
                            rs.getString("NumberCups") +
                            "</td></tr>");
                } 
            out.println("</ol>");

            while (rs.next()) { 
                out.println("<li>" + 
                            rs.getString("City") + " " + 
                            rs.getString("Name") + "</li>"); 
                } 
            out.println("</ol>");
            
            statement.close();
            rs.close();
            con.close();
            } 
        catch (Exception e) {
            e.printStackTrace();
            }
        out.println("</body></html>");
        out.close();
    }
}

