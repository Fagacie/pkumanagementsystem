<%-- 
    Document   : treatmentHistory
    Created on : 18 May 2025, 4:18:22 pm
    Author     : Azwan
--%>


<%@page import="model.User"%>
<%@ page import="model.Treatment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Treatment> treatments = (List<Treatment>) request.getAttribute("treatments");
    String patientId = (String) request.getAttribute("patientId");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<%
    
    User user = (User) session.getAttribute("user");
    if (user == null || "admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<html>
<head>
    <title>Treatment History</title>

    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/treatmentHistory.css">

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
                        <%-- Dynamically display user role --%>
                        <span class="user-role">(<%= user.getRole() %>)</span>
                    </div>
                </div>
            </a>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="<%= "receptionist".equals(user.getRole()) ? "receptionist-dashboard.jsp" : ("admin".equals(user.getRole()) ? "admin-dashboard.jsp" : "doctor-dashboard.jsp") %>"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile" ><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <% if ("receptionist".equals(user.getRole())) { %>
                    <li><a href="payment-form.jsp"><i class="fas fa-money-bill-wave"></i> <span>Add Payments</span></a></li>
                    <% } %>
                    
                    <% if ("receptionist".equals(user.getRole()) || "admin".equals(user.getRole())) { %>
                        <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <% } %>
                        
                    <% if ("receptionist".equals(user.getRole())) { %>
                    <li><a href="manageAppointment.jsp"><i class="fas fa-calendar-plus"></i> <span>Create Appointment</span></a></li>
                    <li><a href="currentAppointments.jsp"><i class="fas fa-calendar-check"></i> <span>Pending</span></a></li>
                    <li><a href="PatientServlet"class="active"><i class="fas fa-procedures"></i> <span>Manage Patient</span></a></li>
                    <li><a href="doctorAvailability.jsp"><i class="fas fa-user-md"></i> <span>Doctor Availability</span></a></li>
                    <% } %>
                    
                    <% if ("admin".equals(user.getRole())) { %>
                        <li><a href="StaffServlet"><i class="fas fa-users-cog"></i> <span>Manage Users</span></a></li>
                    <% } %>
                    <% if ("doctor".equals(user.getRole())) { %>
                       <li><a href="viewAppointments.jsp"><i class="fas fa-calendar-check card-icon"></i> <span>Appointment</span></a></li>
                    <li><a href="searchPatient_1.jsp"class="active"><i class="fas fa-user-injured card-icon"></i> <span>Patient Records</span></a></li>
                    <li><a href="updateAvailability.jsp"><i class="fas fa-notes-medical card-icon"></i> <span>Update Availability</span></a></li>
                    <% } %>
                </ul>
            </nav>
            <div class="sidebar-footer">
               <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

    
    <% if(treatments == null || treatments.isEmpty()) { %>
        <p class="no-data">No treatment history found for this patient.</p>
    <% } else { %>
        <div class="content-panel treatment-history">
    <h2 class="section-heading">Treatment History for Patient: <%= patientId %></h2>
    
    <% if(treatments == null || treatments.isEmpty()) { %>
        <p class="no-data-message">No treatment history found for this patient.</p>
    <% } else { %>
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Symptoms</th>
                        <th>Diagnosis</th>
                        <th>Medicine</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Treatment t : treatments) { %>
                    <tr>
                        <td><%= t.getDate() != null ? dateFormat.format(t.getDate()) : "N/A" %></td>
                        <td><%= t.getSymptoms() != null ? t.getSymptoms() : "N/A" %></td>
                        <td><%= t.getIllness() != null ? t.getIllness() : "N/A" %></td>
                        <td><%= t.getMedicineId() != null ? t.getMedicineId() : "N/A" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
    

</div>
    <% } %>
    
</body>
</html>