<%@page import="java.util.List"%>
<%@page import="model.Staff"%>
<%@page import="model.Patient"%>
<%@page import="dao.StaffDAO"%>
<%@page import="dao.PatientDAO"%>
<%@page import="dao.AppointmentDAO"%>
<%@page import="model.Appointment"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get appointments for the modals
    List<Appointment> pendingAppointments = AppointmentDAO.getPendingAppointments();
    List<Appointment> completedAppointments = AppointmentDAO.getCompletedAppointmentsToday();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | PKU Medical System</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Dashboard Specific Styles */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(480px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
            border-left: 4px solid;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .stat-card.staff {
            border-left-color: #4e73df;
        }
        
        .stat-card.patients {
            border-left-color: #1cc88a;
        }
        
        .stat-card.pending {
            border-left-color: #f6c23e;
        }
        
        .stat-card.completed {
            border-left-color: #36b9cc;
        }
        
        .stat-card h3 {
            color: #5a5c69;
            font-size: 1.1rem;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 2rem;
            font-weight: 700;
            margin: 10px 0;
        }
        
        .stat-card .link {
            display: flex;
            align-items: center;
            color: #4e73df;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
        }
        
        .stat-card .link i {
            margin-left: 5px;
            transition: transform 0.3s;
        }
        
        .stat-card .link:hover i {
            transform: translateX(3px);
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 80%;
            max-width: 900px;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e3e6f0;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .modal-title {
            color: #5a5c69;
            font-size: 1.5rem;
            margin: 0;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #333;
        }
        
        .appointment-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .appointment-table th, 
        .appointment-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e3e6f0;
        }
        
        .appointment-table th {
            background-color: #f8f9fc;
            color: #5a5c69;
            font-weight: 600;
        }
        
        .appointment-table tr:hover {
            background-color: #f8f9fc;
        }
    </style>
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
                <li><a href="admin-dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                <li><a href="payment"><i class="fas fa-file-invoice-dollar"></i> <span>View Payments</span></a></li>
                <li><a href="StaffServlet"><i class="fas fa-users-cog"></i> <span>Manage Users</span></a></li>
            </ul>
        </nav>
        <div class="sidebar-footer">
            <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
        </div>
    </aside>

        <main class="main-content">
            <h2 class="welcome-message">System Report</h2>
            
            <div class="dashboard-cards">
                <!-- Staff Card -->
                <div class="stat-card staff">
                    <h3>Total Staff</h3>
                    <div class="value"><%= StaffDAO.getAllStaff().size() %></div>
                </div>
                
                <!-- Patients Card -->
                <div class="stat-card patients">
                    <h3>Total Patients</h3>
                    <div class="value"><%= PatientDAO.getAllPatients().size() %></div>
                </div>
                
                <!-- Pending Appointments Card -->
                <div class="stat-card pending">
                    <h3>Pending Appointments</h3>
                    <div class="value"><%= AppointmentDAO.getPendingAppointmentsCount() %></div>
                    <a href="#" id="viewPendingBtn" class="link">
                        View Pending <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                
                <!-- Completed Appointments Card -->
                <div class="stat-card completed">
                    <h3>Completed Today</h3>
                    <div class="value"><%= AppointmentDAO.getCompletedAppointmentsTodayCount() %></div>
                    <a href="#" id="viewCompletedBtn" class="link">
                        View Completed <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
            
            <!-- Pending Appointments Modal -->
            <div id="pendingModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">Pending Appointments (<%= pendingAppointments.size() %>)</h3>
                        <span class="close">&times;</span>
                    </div>
                    <div class="modal-body">
                        <% if (pendingAppointments.isEmpty()) { %>
                            <p>No pending appointments found.</p>
                        <% } else { %>
                            <table class="appointment-table">
                                <thead>
                                    <tr>
                                        <th>Appointment ID</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Room No</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Appointment appt : pendingAppointments) { %>
                                        <tr>
                                            <td><%= appt.getAppointmentID() %></td>
                                            <td><%= appt.getDate() %></td>
                                            <td><%= appt.getTime() %></td>
                                            <td><%= appt.getPatientID() %></td>
                                            <td><%= appt.getDoctorID() %></td>
                                            <td><%= appt.getRoomNo() %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <!-- Completed Appointments Modal -->
            <div id="completedModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">Completed Appointments Today (<%= completedAppointments.size() %>)</h3>
                        <span class="close">&times;</span>
                    </div>
                    <div class="modal-body">
                        <% if (completedAppointments.isEmpty()) { %>
                            <p>No completed appointments found for today.</p>
                        <% } else { %>
                            <table class="appointment-table">
                                <thead>
                                    <tr>
                                        <th>Appointment ID</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Room No</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Appointment appt : completedAppointments) { %>
                                        <tr>
                                            <td><%= appt.getAppointmentID() %></td>
                                            <td><%= appt.getDate() %></td>
                                            <td><%= appt.getTime() %></td>
                                            <td><%= appt.getPatientID() %></td>
                                            <td><%= appt.getDoctorID() %></td>
                                            <td><%= appt.getRoomNo() %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="sidebar.js"></script>
    <script>
        // Get the modals
        const pendingModal = document.getElementById("pendingModal");
        const completedModal = document.getElementById("completedModal");
        
        // Get the buttons that open the modals
        const pendingBtn = document.getElementById("viewPendingBtn");
        const completedBtn = document.getElementById("viewCompletedBtn");
        
        // Get the <span> elements that close the modals
        const spans = document.getElementsByClassName("close");
        
        // When the user clicks the pending button, open the pending modal 
        pendingBtn.onclick = function() {
            pendingModal.style.display = "block";
        }
        
        // When the user clicks the completed button, open the completed modal 
        completedBtn.onclick = function() {
            completedModal.style.display = "block";
        }
        
        // When the user clicks on <span> (x), close the modal
        spans[0].onclick = function() {
            pendingModal.style.display = "none";
        }
        spans[1].onclick = function() {
            completedModal.style.display = "none";
        }
        
        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == pendingModal) {
                pendingModal.style.display = "none";
            }
            if (event.target == completedModal) {
                completedModal.style.display = "none";
            }
        }
    </script>
</body>
</html>