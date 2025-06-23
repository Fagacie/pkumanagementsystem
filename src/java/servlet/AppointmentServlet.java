/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.treatmentDAO;
import model.Treatment;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Azwan
 */
@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AppointmentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AppointmentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String doctorID = request.getParameter("doctorID");
    String patientID = request.getParameter("patientID");
    String receptionistID = request.getParameter("receptionistID");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String roomNo = request.getParameter("roomNo");

    Connection con = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pkudb", "root", "");

        // Auto-generate appointmentID
        String appointmentID = "";
        String prefix = "A";
        int nextID = 1;

        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT appointmentID FROM appointment ORDER BY appointmentID DESC LIMIT 1");

        if (rs.next()) {
            String lastID = rs.getString("appointmentID").substring(1); // remove 'A'
            nextID = Integer.parseInt(lastID) + 1;
        }else {
        appointmentID = "A015"; // first record will be changed later
        }

        appointmentID = String.format("%s%03d", prefix, nextID); // e.g., A001, A045

        // Insert appointment
        String sql = "INSERT INTO appointment (appointmentID, doctorID, patientID, receptionistID, date, time, roomNo, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, appointmentID);
        ps.setString(2, doctorID);
        ps.setString(3, patientID);
        ps.setString(4, receptionistID);
        ps.setString(5, date);
        ps.setString(6, time);
        ps.setString(7, roomNo);

        ps.executeUpdate();
        con.close();

        response.sendRedirect("currentAppointments.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("fail.jsp");
    }
}


    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
