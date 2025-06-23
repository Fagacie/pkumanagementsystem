<%-- 
    Document   : fail
    Created on : 19 May 2025, 2:08:09 am
    Author     : Azwan
--%>

<%@page import="model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = "An unknown error occurred while processing the treatment.";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Treatment Failed</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/fail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
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
                    <li><a href="doctor-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="viewAppointments.jsp" class="active"><i class="fas fa-calendar-check card-icon"></i> <span>Today's Appointments</span></a></li>
                    <li><a href="searchPatient.jsp"><i class="fas fa-user-injured card-icon"></i> <span>Patient Records</span></a></li>
                    <li><a href="updateAvailability.jsp"><i class="fas fa-notes-medical card-icon"></i> <span>Update Availability</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>


        <main class="main-content">
            <div class="error-panel">
                <div class="error-icon">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <h2 class="error-heading">Treatment Record Failed</h2>
                <p class="error-message"><%= errorMessage %></p>
                <div class="error-details">
                    <p>Please check the information and try again.</p>
                </div>
                <div class="error-actions">
                    <a href="javascript:history.back()" class="error-button">
                        <i class="fas fa-arrow-left"></i> Back to Form
                    </a>
 
                </div>
            </div>
        </main>
    </div>
</body>
</html>

