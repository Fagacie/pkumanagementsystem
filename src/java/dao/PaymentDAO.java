/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.Payment;
/**
 *
 * @author ACER
 */


public class PaymentDAO {
    // Database credentials
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pkudb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // change to your own

    // Static block to load the JDBC driver ONCE when the class is loaded
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver successfully loaded!");
        } catch (ClassNotFoundException e) {
            System.err.println("Could not load JDBC driver.");
            e.printStackTrace();
        }
    }

    // Helper method to get DB connection
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
    }

    // Add a payment
    public void addPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payment (paymentID, receptionistID, patientID, amount, paymentStatus, method, date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, payment.getPaymentID());
            stmt.setString(2, payment.getReceptionistID());
            stmt.setString(3, payment.getPatientID());
            stmt.setDouble(4, payment.getAmount());
            stmt.setString(5, String.valueOf(payment.getPaymentStatus()));
            stmt.setString(6, payment.getMethod());
            stmt.setDate(7, payment.getDate());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error during addPayment()");
            e.printStackTrace();
            throw e;
        }
    }

    // Get payment by ID
    public Payment getPaymentById(String paymentID) throws SQLException {
        String sql = "SELECT * FROM payment WHERE paymentID=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractPayment(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error during getPaymentById()");
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    // Get all payments
    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payment";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                payments.add(extractPayment(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error during getAllPayments()");
            e.printStackTrace();
            throw e;
        }
        return payments;
    }

    // Update payment
    public void updatePayment(Payment payment) throws SQLException {
        String sql = "UPDATE payment SET receptionistID=?, patientID=?, amount=?, paymentStatus=?, method=?, date=? WHERE paymentID=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, payment.getReceptionistID());
            stmt.setString(2, payment.getPatientID());
            stmt.setDouble(3, payment.getAmount());
            stmt.setString(4, String.valueOf(payment.getPaymentStatus()));
            stmt.setString(5, payment.getMethod());
            stmt.setDate(6, payment.getDate());
            stmt.setString(7, payment.getPaymentID());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error during updatePayment()");
            e.printStackTrace();
            throw e;
        }
    }

    // Delete payment
    public void deletePayment(String paymentID) throws SQLException {
        String sql = "DELETE FROM payment WHERE paymentID=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error during deletePayment()");
            e.printStackTrace();
            throw e;
        }
    }

    // Helper to extract a Payment from ResultSet
    private Payment extractPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentID(rs.getString("paymentID"));
        p.setReceptionistID(rs.getString("receptionistID"));
        p.setPatientID(rs.getString("patientID"));
        p.setAmount(rs.getDouble("amount"));
        p.setPaymentStatus(rs.getString("paymentStatus").charAt(0));
        p.setMethod(rs.getString("method"));
        p.setDate(rs.getDate("date"));
        return p;
    }
}
