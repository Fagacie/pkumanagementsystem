package dao;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class ReportDAO {
    
    // Use the same connection method as your other DAOs
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pkudb", "root", "");
        } catch (Exception e) {
            System.out.println(e);
        }
        return con;
    }
    
    /**
     * Gets illness statistics for the current month
     * @return Map of illness names to their counts
     */
    public static Map<String, Integer> getIllnessCountThisMonth() {
        Map<String, Integer> illnessMap = new HashMap<>();
        String sql = "SELECT illnessType, COUNT(*) FROM appointments " +
                     "WHERE MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE()) " +
                     "GROUP BY illnessType";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String illness = rs.getString(1);
                int count = rs.getInt(2);
                illnessMap.put(illness, count);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return illnessMap;
    }
    
    /**
     * Gets illness statistics for a specific month and year
     * @param month The month (1-12)
     * @param year The year (e.g., 2023)
     * @return Map of illness names to their counts
     */
    public static Map<String, Integer> getIllnessStatsByMonth(int month, int year) {
        Map<String, Integer> illnessStats = new HashMap<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            String sql = "SELECT i.name, COUNT(*) as count " +
                         "FROM treatmentillness ti " +
                         "JOIN illness i ON ti.illnessID = i.illnessID " +
                         "JOIN treatment t ON ti.treatmentID = t.treatmentID " +
                         "JOIN appointment a ON t.appointmentID = a.appointmentID " +
                         "WHERE MONTH(a.date) = ? " +
                         "AND YEAR(a.date) = ? " +
                         "GROUP BY i.name";
            
            ps = con.prepareStatement(sql);
            ps.setInt(1, month);
            ps.setInt(2, year);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                illnessStats.put(rs.getString("name"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return illnessStats;
    }
}