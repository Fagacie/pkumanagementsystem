/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.sql.*;

/**
 * Handles treatment record insertion.
 */
@WebServlet("/AddTreatmentServlet")
public class AddTreatmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appointmentID = request.getParameter("appointmentID");
        String patientID = request.getParameter("patientID");
        String symptoms = request.getParameter("symptoms");
        String illnessID = request.getParameter("illnessID");
        String medicineID = request.getParameter("medicineID");
        String dosage = request.getParameter("dosage");
        String date = request.getParameter("date");

        Connection con = null;
        String treatmentID = null;

        try {
            // Connect to DB
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pkudb", "root", "");

            // Generate new treatment ID
            String prefix = "T";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT treatmentID FROM treatment ORDER BY treatmentID DESC LIMIT 1");
            if (rs.next()) {
                String lastID = rs.getString("treatmentID"); // e.g., "T005"
                int num = Integer.parseInt(lastID.substring(1)); // 5
                treatmentID = prefix + String.format("%03d", num + 1); // T006
            } else {
                treatmentID = "T012"; // first ID... will be changed later
            }
            rs.close();
            stmt.close();

            // Insert into treatment
            String sql1 = "INSERT INTO treatment (treatmentID, appointmentID, symptom) VALUES (?, ?, ?)";
            PreparedStatement ps1 = con.prepareStatement(sql1);
            ps1.setString(1, treatmentID);
            ps1.setString(2, appointmentID);
            ps1.setString(3, symptoms);
            ps1.executeUpdate();

            // Insert into treatmentillness
            String sql2 = "INSERT INTO treatmentillness (treatmentID, illnessID) VALUES (?, ?)";
            PreparedStatement ps2 = con.prepareStatement(sql2);
            ps2.setString(1, treatmentID);
            ps2.setString(2, illnessID);
            ps2.executeUpdate();

            // Insert into treatmentmedicine with dosage
            String sql3 = "INSERT INTO treatmentmedicine (treatmentID, medicineID, dosage) VALUES (?, ?, ?)";
            PreparedStatement ps3 = con.prepareStatement(sql3);
            ps3.setString(1, treatmentID);
            ps3.setString(2, medicineID);
            ps3.setString(3, dosage);
            ps3.executeUpdate();

            // Update appointment status
            String sql4 = "UPDATE appointment SET status = 'completed' WHERE appointmentID = ?";
            PreparedStatement ps4 = con.prepareStatement(sql4);
            ps4.setString(1, appointmentID);
            ps4.executeUpdate();

            response.sendRedirect("success.jsp");

        } catch (Exception e) {
          e.printStackTrace();
         response.sendRedirect("fail.jsp");

        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles treatment record submission";
    }
}
