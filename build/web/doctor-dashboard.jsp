<%-- 
    Document   : doctor-dashboard
    Created on : Jun 3, 2025, 4:10:20?PM
    Author     : Abbas Usman
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%
  
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Doctor Dashboard</title>
    <!-- Link to the universal dashboard CSS -->
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <!-- Font Awesome for icons -->
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
                    <li><a href="doctor-dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <%-- Add more doctor-specific navigation links here as needed --%>
                    <li><a href="viewAppointments.jsp"><i class="fas fa-calendar-check card-icon"></i> <span>Appointment</span></a></li>
                    <li><a href="PatientServlet"><i class="fas fa-user-injured card-icon"></i> <span>Patient Records</span></a></li>
                    <li><a href="updateAvailability.jsp"><i class="fas fa-notes-medical card-icon"></i> <span>Update Availability</span></a></li>
                    
                </ul>
            </nav>
            <div class="sidebar-footer">
                 <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>            </div>
        </aside>

        <main class="main-content">
            <h2 class="welcome-message">Welcome, Dr. <%= user.getName() %>!</h2>

            <div class="dashboard-cards">
                <%-- Doctor-specific activity cards --%>
                <div class="card activity-card">
                    <i class="fas fa-calendar-check card-icon"></i>
                    <h3>Today's Appointments</h3>
                    <p>View your scheduled appointments for the day.</p>
                    <a href="viewAppointments.jsp" class="card-action-button">View Appointments <i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="card activity-card">
                    <i class="fas fa-user-injured card-icon"></i>
                    <h3>Patient Records</h3>
                    <p>Access and manage patient medical history.</p>
                    <%-- Placeholder for patient records link --%>
                    <a href="PatientServlet" class="card-action-button">Check Records<i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="card activity-card">
                    <i class="fas fa-notes-medical card-icon"></i>
                    <h3>Update Availability</h3>
                    <p>Update doctor availability status.</p>
                    <%-- Placeholder for new diagnosis link --%>
                    <a href="updateAvailability.jsp" class="card-action-button">Update Availability <i class="fas fa-arrow-right"></i></a>
                </div>

            </div>

        </main>
    </div>

    <script src="sidebar.js"></script> 
</body>
</html>
