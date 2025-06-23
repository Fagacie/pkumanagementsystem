

<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    
    User user = (User) session.getAttribute("user");
    if (user == null || !"receptionist".equals(user.getRole())) {
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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Appointment</title>

    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/manageAppointment.css">

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
                    <% if ("receptionist".equals(user.getRole()) || "admin".equals(user.getRole())) { %>
                        <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <% } %>
                    <li><a href="manageAppointment.jsp"class="active"><i class="fas fa-calendar-plus"></i> <span>Create Appointment</span></a></li>
                    <li><a href="currentAppointments.jsp"><i class="fas fa-calendar-check"></i> <span>Pending</span></a></li>
                    <li><a href="PatientServlet"><i class="fas fa-procedures"></i> <span>Manage Patient</span></a></li>
                    <li><a href="doctorAvailability.jsp"><i class="fas fa-user-md"></i> <span>Doctor Availability</span></a></li>
                    <% } %>
                    
                    <% if ("admin".equals(user.getRole())) { %>
                        <li><a href="StaffServlet"><i class="fas fa-users-cog"></i> <span>Manage Users</span></a></li>
                    <% } %>
                    <% if ("doctor".equals(user.getRole())) { %>
                        <li><a href="appointments.jsp"><i class="fas fa-calendar-alt"></i> <span>View Appointments</span></a></li>
                    <% } %>
                </ul>
            </nav>
            <div class="sidebar-footer">
               <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>
                
    <body>
    <main class="main-content">
    <div class="main-form-wrapper">
        <div class="form-container">
            <h2>Create New Appointment</h2>
            <form method="post" action="AppointmentServlet_1">
                <!-- Get doctorId from URL parameter -->
                <% String doctorId = request.getParameter("doctorId"); %>
                
                Doctor ID: <input type="text" name="doctorID" value="<%= doctorId != null ? doctorId : "" %>" required><br>
                Patient ID: <input type="text" name="patientID" required><br>
                <%
                    user = (User) session.getAttribute("user");
                    String receptionistID = String.valueOf(user.getUserID());

                    if (receptionistID == null) {
                %>
                    Receptionist ID:<p style="color:red;">Receptionist not logged in.</p>
                <%
                    } else {
                %>
                    Receptionist ID: <input type="text" name="receptionistID" value="<%= receptionistID %>" readonly><br>
                <%
                    }
                %>
                Date: <input type="date" name="date" required><br>
                Time: <input type="time" name="time" required><br>
                Room No: <input type="text" name="roomNo" required><br>
                <input type="submit" class="submit-button" value="Book Appointment">
            </form>
        </div>
    </div>
</main>
    </div>
    </body>
</html>
