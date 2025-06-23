package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Azwan
 */


import model.Treatment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class treatmentDAO { // Class name should be PascalCase
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.jdbc.Driver"); // Updated driver for MySQL 8+
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/pkudb", 
            "root", 
            "");
    }

    public static List<Treatment> getTreatmentHistory(String patientId) {
    List<Treatment> treatments = new ArrayList<>();
    try (Connection con = getConnection()) {
        String sql = "SELECT A.treatmentID, A.symptom, E.name AS illness, C.medicineID, M.name AS medicineName, D.date " +
            "FROM appointment D " +
            "JOIN treatment A ON D.appointmentID = A.appointmentID " +
            "JOIN treatmentillness B ON A.treatmentID = B.treatmentID " +
            "JOIN illness E ON B.illnessID = E.illnessID " +  
            "JOIN treatmentmedicine C ON B.treatmentID = C.treatmentID " +
            "JOIN medicine M ON C.medicineID = M.medicineID " +  // Added join to medicine table
            "WHERE D.patientID = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Treatment t = new Treatment();
                t.setTreatmentId(rs.getString("treatmentID"));
                t.setSymptoms(rs.getString("symptom"));
                t.setIllness(rs.getString("illness"));
                t.setMedicineId(rs.getString("medicineName")); // Now storing the name instead of ID
                t.setDate(rs.getDate("date"));
                treatments.add(t);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return treatments;
}
    
    public static boolean addTreatment(Treatment treatment) {
    try (Connection con = getConnection()) {
        // Assuming appointmentID and treatmentID are generated automatically
        String insertTreatment = "INSERT INTO treatment (symptom, appointmentID) VALUES (?, ?)";
        String insertIllness = "INSERT INTO treatmentillness (treatmentID, illnessID) VALUES (?, ?)";
        String insertMedicine = "INSERT INTO treatmentmedicine (treatmentID, medicineID) VALUES (?, ?)";
        String insertAppointment = "INSERT INTO appointment (date, patientID) VALUES (?, ?)"; // You might need patient ID

        // This is just an example. You should handle actual IDs properly.
        // Assume dummy appointment ID for now (or implement appointment creation)
        PreparedStatement ps = con.prepareStatement(insertTreatment, Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, treatment.getSymptoms());
        ps.setString(2, "APT001"); // Replace this with actual logic
        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        String treatmentId = null;
        if (rs.next()) {
            treatmentId = rs.getString(1);
        }

        if (treatmentId != null) {
            // Insert illness and medicine mapping
            PreparedStatement psIllness = con.prepareStatement(insertIllness);
            psIllness.setString(1, treatmentId);
            psIllness.setString(2, treatment.getIllness());
            psIllness.executeUpdate();

            PreparedStatement psMedicine = con.prepareStatement(insertMedicine);
            psMedicine.setString(1, treatmentId);
            psMedicine.setString(2, treatment.getMedicineId());
            psMedicine.executeUpdate();

            return true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
}
