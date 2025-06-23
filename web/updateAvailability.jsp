<%-- 
    Document   : updateAvailability
    Created on : 19 May 2025, 7:58:51 pm
    Author     : Azwan
--%>

<%@ page import="java.sql.*" %>
<%@page import="model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get the logged-in doctor
    User user = (User) session.getAttribute("user");

    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userId = user.getUserID(); // or user.getId() if available
    String toggle = request.getParameter("toggle");
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String name = "";
    String status = "";
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pkudb", "root", "");

        // Fetch doctor info from users table
        ps = con.prepareStatement("SELECT name, status FROM users WHERE userID = ? AND role = 'doctor'");
        ps.setString(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            status = rs.getString("status");

            // Toggle status if requested
            if ("yes".equals(toggle)) {
                String newStatus = "A".equals(status) ? "U" : "A";
                PreparedStatement updatePs = con.prepareStatement("UPDATE users SET status = ? WHERE userID = ?");
                updatePs.setString(1, newStatus);
                updatePs.setString(2, userId);
                updatePs.executeUpdate();
                updatePs.close();

                status = newStatus;
            }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Availability</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/updateAvailability.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="dashboard-wrapper">
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <div class="pku-logo">PKU</div>
                <button class="toggle-button" id="sidebarToggle" aria-label="Toggle Navigation">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
            <a href="profile" class="profile-link">
                <div class="profile-section">
                    <i class="fas fa-user-circle profile-icon"></i>
                    <div class="profile-info">
                        <span class="user-name"><%= user.getName() %></span>
                        <span class="user-role">(<%= user.getRole() %>)</span>
                    </div>
                </div>
            </a>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="doctor-dashboard.jsp" ><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <%-- Add more doctor-specific navigation links here as needed --%>
                    <li><a href="viewAppointments.jsp"><i class="fas fa-calendar-check card-icon"></i> <span>Appointment</span></a></li>
                    <li><a href="PatientServlet"><i class="fas fa-user-injured card-icon"></i> <span>Patient Records</span></a></li>
                    <li><a href="updateAvailability.jsp" class="active"><i class="fas fa-notes-medical card-icon"></i> <span>Update Availability</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <div class="availability-panel">
                <% if ("yes".equals(toggle)) { %>
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i> Status updated successfully!
                    </div>
                <% } %>
                
                <h2 class="panel-heading">Update Doctor Availability</h2>
                
                <div class="doctor-info">
                    <h3><i class="fas fa-user-md"></i> Doctor Information</h3>
                    <div class="info-item">
                        <span class="info-label">Name:</span>
                        <span class="info-value"><%= name %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Current Status:</span>
                        <span class="status-badge <%= "A".equals(status) ? "available" : "unavailable" %>">
                            <%= "A".equals(status) ? "Available" : "Unavailable" %>
                        </span>
                    </div>
                </div>

                <form method="post" action="updateAvailability.jsp" class="availability-form">
                    <input type="hidden" name="toggle" value="yes">
                    <button type="submit" class="toggle-button-doctor <%= "A".equals(status) ? "unavailable" : "available" %>">
                        <i class="fas <%= "A".equals(status) ? "fa-times" : "fa-check" %>"></i>
                        Set as <%= "A".equals(status) ? "Unavailable" : "Available" %>
                    </button>
                </form>

            </div>
        </main>
    </div>
</body>
</html>
<%
        } else {
%>
    <main class="main-content">
        <div class="error-panel">
            <i class="fas fa-exclamation-triangle"></i>
            <p>Doctor record not found</p>
            <a href="doctor-dashboard.jsp" class="back-button">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </main>
<%
        }
    } catch (Exception e) {
%>
    <main class="main-content">
        <div class="error-panel">
            <i class="fas fa-exclamation-triangle"></i>
            <p>Error: <%= e.getMessage() %></p>
            <a href="doctor-dashboard.jsp" class="back-button">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </main>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }
%>