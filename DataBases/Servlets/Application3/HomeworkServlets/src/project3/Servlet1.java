package project3;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.*;
import javax.servlet.http.*;

public class Servlet1 extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1250";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet1</title></head>");
        out.println("<body>");
        out.println("<h1>List of Races:</h1>");
        Connection con = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection("jdbc:sqlserver://localhost\\MSSQLEXPRESS: 1433; databaseName=RRaces", "ejowik", "tu6Ieb2a");
            
            PreparedStatement ps = con.prepareStatement("SELECT * FROM [RRaces].[dbo].[Races]" +
                                                        "WHERE City LIKE ?" +
                                                        " AND Distance BETWEEN ? AND ?");
            try{
            ps.setString(1,request.getParameter("city") + "%");
             } catch(Exception e){
                ps.setString(1, "%");
            }
            
            try{
            ps.setDouble(2,Double.valueOf(request.getParameter("mindist")));
            } catch(Exception e){
                ps.setDouble(2,0);
            }
            
            try{
            ps.setDouble(3,Double.valueOf(request.getParameter("maxdist")));
            } catch(Exception e){
                ps.setDouble(3, 0);
            }
            
            ResultSet rs = ps.executeQuery();
                      
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
