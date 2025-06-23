package dao;

import model.Staff;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StaffDAO {
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
    
    public static List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Staff staff = new Staff();
                staff.setUserID(rs.getString("userID"));
                staff.setName(rs.getString("name"));
                staff.setRole(rs.getString("role"));
                staff.setStatus(rs.getString("status").charAt(0));
                list.add(staff);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static Staff getStaffById(String id) {
        Staff staff = null;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE userID=?");
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                staff = new Staff(
                    rs.getString("userID"),
                    rs.getString("icnum"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phoneNumber"),
                    rs.getString("status").charAt(0)
                );
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staff;
    }
    
    public static int addStaff(Staff staff, String specialization, Integer deskNo) {
    Connection con = null;
    try {
        con = getConnection();
        con.setAutoCommit(false); // Start transaction
        
        // 1. Insert into users table
        PreparedStatement psUser = con.prepareStatement(
            "INSERT INTO users (userID, icnum, password, role, name, email, phoneNumber, status) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        
        psUser.setString(1, staff.getUserID());
        psUser.setString(2, staff.getIcnum());
        psUser.setString(3, staff.getPassword());
        psUser.setString(4, staff.getRole());
        psUser.setString(5, staff.getName());
        psUser.setString(6, staff.getEmail());
        psUser.setString(7, staff.getPhoneNumber());
        psUser.setString(8, String.valueOf(staff.getStatus()));
        psUser.executeUpdate();
        
        // 2. Insert into role-specific table
        if ("doctor".equals(staff.getRole())) {
            PreparedStatement psDoctor = con.prepareStatement(
                "INSERT INTO doctor (doctorID, specialization) VALUES (?, ?)");
            psDoctor.setString(1, staff.getUserID());
            psDoctor.setString(2, specialization);
            psDoctor.executeUpdate();
        } 
        else if ("receptionist".equals(staff.getRole())) {
            PreparedStatement psRecep = con.prepareStatement(
                "INSERT INTO receptionist (receptionistID, desk_no) VALUES (?, ?)");
            psRecep.setString(1, staff.getUserID());
            psRecep.setInt(2, deskNo);
            psRecep.executeUpdate();
        }
        
        con.commit(); // Commit transaction
        return 1;
    } catch (Exception e) {
        if (con != null) {
            try { con.rollback(); } catch (SQLException ex) {}
        }
        e.printStackTrace();
        return 0;
    } finally {
        if (con != null) {
            try { con.close(); } catch (SQLException e) {}
        }
    }
}
    
    public static int updateStaff(Staff staff) {
        int status = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET icnum=?, password=?, role=?, name=?, email=?, phoneNumber=?, status=? " +
                "WHERE userID=?");
            
            ps.setString(1, staff.getIcnum());
            ps.setString(2, staff.getPassword());
            ps.setString(3, staff.getRole());
            ps.setString(4, staff.getName());
            ps.setString(5, staff.getEmail());
            ps.setString(6, staff.getPhoneNumber());
            ps.setString(7, String.valueOf(staff.getStatus()));
            ps.setString(8, staff.getUserID());
            
            status = ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
public static int deleteStaff(String id) {
    Connection con = null;
    int status = 0;
    
    try {
        con = getConnection();
        con.setAutoCommit(false); // Start transaction
        
        // First delete from role-specific tables
        PreparedStatement ps = con.prepareStatement("DELETE FROM doctor WHERE doctorID = ?");
        ps.setString(1, id);
        ps.executeUpdate();
        
        ps = con.prepareStatement("DELETE FROM receptionist WHERE receptionistID = ?");
        ps.setString(1, id);
        ps.executeUpdate();
        
        // Then delete from users table
        ps = con.prepareStatement("DELETE FROM users WHERE userID = ?");
        ps.setString(1, id);
        status = ps.executeUpdate();
        
        con.commit(); // Commit transaction
    } catch (SQLException e) {
        try {
            if (con != null) con.rollback(); // Rollback on error
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        e.printStackTrace();
    } finally {
        try {
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    return status;
}
    
    // In StaffDAO.java
public static Map<String, Object> getStaffDetails(String userID) {
    Map<String, Object> details = new HashMap<>();
    try (Connection con = getConnection()) {
        // Get basic user info
        Staff staff = getStaffById(userID);
        details.put("user", staff);

        // Get role-specific info
        if ("doctor".equalsIgnoreCase(staff.getRole())) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM doctor WHERE doctorID = ?");
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                details.put("specialization", rs.getString("specialization"));
            }
        } 
        else if ("receptionist".equalsIgnoreCase(staff.getRole())) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM receptionist WHERE receptionistID = ?");
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                details.put("desk_no", rs.getInt("desk_no"));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return details;
}
}