package dao;

import model.Patient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {
    public static List<Patient> getAllPatients() {
        List<Patient> list = new ArrayList<>();
        try {
            Connection con = StaffDAO.getConnection();
PreparedStatement ps = con.prepareStatement(
    "SELECT patientID, name, address, bloodType, weight, height, gender, age FROM patient");            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Patient patient = new Patient(
                    rs.getString("patientID"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("gender"),
                    rs.getInt("age"),
                    rs.getString("bloodType"),
                    rs.getFloat("weight"),
                    rs.getFloat("height")
                );
                list.add(patient);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static Patient getPatientById(String id) {
        Patient patient = null;
        try {
            Connection con = StaffDAO.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM patient WHERE patientID=?");
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                patient = new Patient(
                    rs.getString("patientID"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("gender"),
                    rs.getInt("age"),
                    rs.getString("bloodType"),
                    rs.getFloat("weight"),
                    rs.getFloat("height")
                );
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patient;
    }
    
    public static int addPatient(Patient patient) {
        int status = 0;
        try {
            Connection con = StaffDAO.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO patient (patientID, name, address, gender, age, bloodType, weight, height) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            
            ps.setString(1, patient.getPatientID());
            ps.setString(2, patient.getName());
            ps.setString(3, patient.getAddress());
            ps.setString(4, patient.getGender());
            ps.setInt(5, patient.getAge());
            ps.setString(6, patient.getBloodType());
            ps.setFloat(7, patient.getWeight());
            ps.setFloat(8, patient.getHeight());
            
            status = ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
    public static int updatePatient(Patient patient) {
        int status = 0;
        try {
            Connection con = StaffDAO.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE patient SET name=?, address=?, gender=?, age=?, bloodType=?, weight=?, height=? " +
                "WHERE patientID=?");
            
            ps.setString(1, patient.getName());
            ps.setString(2, patient.getAddress());
            ps.setString(3, patient.getGender());
            ps.setInt(4, patient.getAge());
            ps.setString(5, patient.getBloodType());
            ps.setFloat(6, patient.getWeight());
            ps.setFloat(7, patient.getHeight());
            ps.setString(8, patient.getPatientID());
            
            status = ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
    // deletePatient remains the same
}