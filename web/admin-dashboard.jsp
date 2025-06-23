<%-- 
    Document   : admin-dashboard
    Created on : Jun 3, 2025, 4:08:29?PM
    Author     : Abbas Usman
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Admin Dashboard</title>
    <%-- CORRECTED: Link to the universal dashboard CSS --%>
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
                        <span class="user-role">(<%= user.getRole() %>)</span> <%-- Dynamically display user role --%>
                    </div>
                </div>
            </a>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="admin-dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <li><a href="StaffServlet"><i class="fas fa-users-cog"></i><span>Manage Users</span></a></li>
                    <%-- Add more admin-specific navigation links here as needed --%>
                </ul>
            </nav>
            <div class="sidebar-footer">
                 <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <h2 class="welcome-message">Welcome, <%= user.getName() %> (Admin)</h2>

            <div class="dashboard-cards">
                <%-- Admin-specific activity cards --%>
                <div class="card activity-card">
                    <i class="fas fa-users-cog card-icon"></i>
                    <h3>User Management</h3>
                    <p>Add, edit, or remove user accounts and manage roles.</p>
                    <a href="StaffServlet" class="card-action-button">Manage Users <i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="card activity-card">
                    <i class="fas fa-receipt card-icon"></i>
                    <h3>View Payments</h3>
                    <p>Review all recorded payments and their details.</p>
                    <a href="payment" class="card-action-button">View Records <i class="fas fa-arrow-right"></i></a>
                </div>

                <div class="card activity-card">
                    <i class="fas fa-chart-line card-icon"></i>
                    <h3>View System Reports</h3>
                    <p>Access detailed reports on system activity and performance.</p>
                    <%-- Placeholder for reports link --%>
                    <a href="adminDashboard.jsp" class="card-action-button">View Reports <i class="fas fa-arrow-right"></i></a>
                </div>

                <%-- Add more admin-specific activity cards here --%>
            </div>

            <%-- You can add more admin-specific content here, e.g., recent activities, summary tables --%>

        </main>
    </div>

    <script src="sidebar.js"></script> 
</body>
</html>
