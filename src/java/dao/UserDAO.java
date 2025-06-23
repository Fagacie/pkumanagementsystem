/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.*;
import java.util.*;
import model.User;
/**
 *
 * @author ACER
 */


public class UserDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pkudb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // change as needed

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded!");
        } catch (ClassNotFoundException e) {
            System.err.println("Could not load JDBC driver.");
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
    }

    // Login validation
    public User validateLogin(String userID, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE userID = ? AND password = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        }
        return null;
    }

    // CRUD Operations
    public User getUser(String userID) throws SQLException {
        String sql = "SELECT * FROM users WHERE userID = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return extractUser(rs);
        }
        return null;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) users.add(extractUser(rs));
        }
        return users;
    }

    public void updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET icnum=?, password=?, role=?, name=?, email=?, phoneNumber=?, status=? WHERE userID=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getIcnum());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());
            stmt.setString(4, user.getName());
            stmt.setString(5, user.getEmail());
            stmt.setString(6, user.getPhoneNumber());
            stmt.setString(7, String.valueOf(user.getStatus()));
            stmt.setString(8, user.getUserID());
            stmt.executeUpdate();
        }
    }

public boolean deleteUser(String userID) throws SQLException {
    Connection conn = null;
    try {
        conn = getConnection();
        conn.setAutoCommit(false); // Start transaction

        // 1. Check user role to determine which tables to clean up
        String role = getUserRole(userID, conn);
        
        // 2. Delete from role-specific tables first
        if ("receptionist".equals(role)) {
            deleteFromTable(conn, "payment", "receptionistID", userID);
            deleteFromTable(conn, "appointment", "receptionistID", userID);
            deleteFromTable(conn, "receptionist", "receptionistID", userID);
        } else if ("doctor".equals(role)) {
            deleteFromTable(conn, "appointment", "doctorID", userID);
            deleteFromTable(conn, "doctor", "doctorID", userID);
        } else if ("admin".equals(role)) {
            deleteFromTable(conn, "admin", "userID", userID);
        }

        // 3. Delete from users table
        deleteFromTable(conn, "users", "userID", userID);

        conn.commit(); // Commit transaction
        return true;
    } catch (SQLException e) {
        if (conn != null) conn.rollback(); // Rollback on error
        throw e;
    } finally {
        if (conn != null) conn.setAutoCommit(true);
        if (conn != null) conn.close();
    }
}

private String getUserRole(String userID, Connection conn) throws SQLException {
    String sql = "SELECT role FROM users WHERE userID = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, userID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getString("role");
        }
    }
    return null;
}

private void deleteFromTable(Connection conn, String tableName, String columnName, String value) throws SQLException {
    String sql = "DELETE FROM " + tableName + " WHERE " + columnName + " = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, value);
        stmt.executeUpdate();
    }
}

    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserID(rs.getString("userID"));
        user.setIcnum(rs.getString("icnum"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phoneNumber"));
        user.setStatus(rs.getString("status").charAt(0));
        return user;
    }
}
