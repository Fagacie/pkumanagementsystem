<%@page import="model.User"%>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String doctorId = String.valueOf(user.getUserID());
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Appointment</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/viewAppointment.css">
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
                       <li><a href="viewAppointments.jsp"class="active"><i class="fas fa-calendar-check card-icon"></i> <span>Appointment</span></a></li>
                    <li><a href="PatientServlet"><i class="fas fa-user-injured card-icon"></i> <span>Patient Records</span></a></li>
                    <li><a href="updateAvailability.jsp"><i class="fas fa-notes-medical card-icon"></i> <span>Update Availability</span></a></li>
                    <% } %>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pkudb", "root", "");

                String sql = "SELECT appointmentID, date, time, roomNo, patientID " +
                            "FROM appointment " +
                            "WHERE doctorID = ? AND date >= CURDATE() AND status = 'pending' " +
                            "ORDER BY date, time";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, doctorId);

                ResultSet rs = ps.executeQuery();
            %>
            
            <div class="content-panel doctor-appointments">
                <h2 class="section-heading">Appointments for Doctor ID: <%= doctorId %></h2>
                
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Appointment ID</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Room No</th>
                                <th>Patient ID</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while (rs.next()) { 
                                String appointmentID = rs.getString("appointmentID");
                                String patientID = rs.getString("patientID");
                            %>
                            <tr>
                                <td><%= appointmentID %></td>
                                <td><%= rs.getDate("date") %></td>
                                <td><%= rs.getString("time") %></td>
                                <td><%= rs.getString("roomNo") %></td>
                                <td><%= patientID %></td>
                                <td class="actions-column">
                                    <form action="addTreatment.jsp" method="get" class="inline-form">
                                        <input type="hidden" name="appointmentID" value="<%= appointmentID %>">
                                        <input type="hidden" name="patientID" value="<%= patientID %>">
                                        <button type="submit" class="action-button edit-button">
                                            <i class="fas fa-medkit"></i> Treat
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <%
                con.close();
            } catch (Exception e) {
                out.println("<p class='error-message'>Error: " + e.getMessage() + "</p>");
            }
            %>
        </main>
    </div>
</body>
</html>

