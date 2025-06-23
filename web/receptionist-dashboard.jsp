<%-- 
    Document   : receptionist-dashboard
    Created on : Jun 3, 2025, 4:09:20?PM
    Author     : Abbas Usman
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"receptionist".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Receptionist Dashboard</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
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
                        <span class="user-role">(Receptionist)</span>
                    </div>
                </div>
            </a>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="receptionist-dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="payment-form.jsp"><i class="fas fa-money-bill-wave"></i> <span>Add Payments</span></a></li>
                    <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <li><a href="manageAppointment.jsp"><i class="fas fa-calendar-plus"></i> <span>Create Appointment</span></a></li>
                    <li><a href="currentAppointments.jsp"><i class="fas fa-calendar-check"></i> <span>Pending</span></a></li>
                    <li><a href="PatientServlet"><i class="fas fa-procedures"></i> <span>Manage Patient</span></a></li>
                    <li><a href="doctorAvailability.jsp"><i class="fas fa-user-md"></i> <span>Doctor Availability</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                 <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <h1 class="welcome-message">Welcome, <%= user.getName() %>!</h1>

            <div class="dashboard-cards">
                <div class="card activity-card">
                    <div class="card-icon"><i class="fas fa-money-bill-wave"></i></div>
                    <h3>Record Payments</h3>
                    <p>Quickly add new patient payments to the system.</p>
                    <a href="payment-form.jsp" class="card-action-button">Record Now <i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="card activity-card">
                    <div class="card-icon"><i class="fas fa-receipt"></i></div>
                    <h3>View Payments</h3>
                    <p>Access and manage all recorded patient payments.</p>
                    <a href="payment" class="card-action-button">View All <i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="card activity-card">
                    <div class="card-icon"><i class="fas fa-user-md"></i></div>
                    <h3>Check Doctor Availability</h3>
                    <p>Access and view doctor status</p>
                    <a href="doctorAvailability.jsp" class="card-action-button">View Status<i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="card activity-card">
                    <div class="card-icon"><i class="fas fa-calendar-plus"></i></div>
                    <h3>Manage Appointments</h3>
                    <p>Schedule patient appointments.</p>
                    <a href="manageAppointment.jsp" class="card-action-button">Manage Appointment<i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="card activity-card">
                    <div class="card-icon"><i class="fas fa-calendar-check"></i></div>
                    <h3>View Appointments</h3>
                    <p>View pending patient appointments.</p>
                    <a href="currentAppointments.jsp" class="card-action-button">View Appointment<i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="card activity-card">
                    <div class="card-icon"><i class="fas fa-procedures"></i></div>
                    <h3>Patient Records</h3>
                    <p>Access and update detailed patient information and history.</p>
                    <a href="searchPatient_1.jsp" class="card-action-button">View Records<i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
        </main>
    </div>
    <script src="sidebar.js"></script>
</body>
</html>