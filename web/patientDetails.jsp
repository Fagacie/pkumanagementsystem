<%@page import="model.Patient"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Patient" %>
<%@ page import="model.Treatment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<% 
    List<Treatment> treatments = (List<Treatment>) request.getAttribute("treatments");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>

<%
    // Ensure user is logged in and is a receptionist, admin, or doctor
    User user = (User) session.getAttribute("user");
    if (user == null || (!"receptionist".equals(user.getRole()) && !"admin".equals(user.getRole()) && !"doctor".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Patient patient = (Patient) request.getAttribute("patient");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Details | PKU Medical System</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .patient-details-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-top: 20px;
            border-left: 4px solid #00a896;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .detail-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .detail-label {
            font-weight: 600;
            color: #5a5c69;
            width: 200px;
            flex-shrink: 0;
        }
        
        .detail-value {
            flex-grow: 1;
            color: #333;
        }
        
        .section-header {
            font-size: 1.2rem;
            color: #000;          
            font-weight: bold;     
            margin: 25px 0 15px 0;
            padding-bottom: 8px;
            border-bottom: 1px solid #e0e6f5;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: #28a745;
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background-color: white;
            color: #5a5c69;
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background-color: #f8f9fa;
            border-color: #ccc;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .status-active {
            background-color: #e6f7ee;
            color: #28a745;
        }
        
        .status-inactive {
            background-color: #fce8e6;
            color: #dc3545;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #777777;
            text-decoration: none;
        }
        
        .table-container {
            margin-top: 20px;
            overflow-x: auto;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .data-table th, .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .data-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }
        
        .data-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .no-data-message {
            text-align: center;
            padding: 20px;
            color: #6c757d;
            font-style: italic;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success {
            background-color: #e6f7ee;
            color: #28a745;
        }
        
        .alert-error {
            background-color: #fce8e6;
            color: #dc3545;
        }
        
        .welcome-message {
            color: #00a896;
            margin-bottom: 20px;
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
                    <li><a href="StaffServlet"class="active"><i class="fas fa-user-injured card-icon"></i> <span>Patient Records</span></a></li>
                    <li><a href="updateAvailability.jsp"><i class="fas fa-notes-medical card-icon"></i> <span>Update Availability</span></a></li>
                    <% } %>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <h2 class="welcome-message">Patient Details</h2>
            
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
                </div>
            <% } %>
            
            <% if (patient != null) { %>
            <div class="patient-details-card">
                <h3 class="section-header">Basic Information</h3>
                
                <div class="detail-row">
                    <div class="detail-label">Patient ID</div>
                    <div class="detail-value"><%= patient.getPatientID() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Name</div>
                    <div class="detail-value"><%= patient.getName() %></div>
                </div>
                
                <% if ("receptionist".equals(user.getRole()) || "admin".equals(user.getRole())) { %>
                <div class="detail-row">
                    <div class="detail-label">Address</div>
                    <div class="detail-value"><%= patient.getAddress() %></div>
                </div>
                <% } %>
                <div class="detail-row">
                    <div class="detail-label">Gender</div>
                    <div class="detail-value"><%= patient.getGender() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Age</div>
                    <div class="detail-value"><%= patient.getAge() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Blood Type</div>
                    <div class="detail-value"><%= patient.getBloodType() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Weight</div>
                    <div class="detail-value"><%= patient.getWeight() %> kg</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Height</div>
                    <div class="detail-value"><%= patient.getHeight() %> cm</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Status</div>
                    <div class="detail-value">
                        <span class="status-badge <%= "Active".equals(patient.getStatus()) ? "status-active" : "status-inactive" %>">
                            <%= patient.getStatus() %>
                        </span>
                    </div>
                </div>
                
                <h3 class="section-header">Treatment History</h3>
                <% if (treatments == null || treatments.isEmpty()) { %>
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
                                <% for (Treatment t : treatments) { %>
                                    <tr>
                                        <td>
                                            <%= t.getDate() != null ? dateFormat.format(t.getDate()) : "N/A" %>
                                        </td>
                                        <td>
                                            <%= t.getSymptoms() != null ? t.getSymptoms() : "N/A" %>
                                        </td>
                                        <td>
                                            <%= t.getIllness() != null ? t.getIllness() : "N/A" %>
                                        </td>
                                        <td>
                                            <%= t.getMedicineId() != null ? t.getMedicineId() : "N/A" %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
                
                <div class="action-buttons">
                    <% if (!"doctor".equals(user.getRole())) { %>
                        <a href="PatientServlet?action=edit&id=<%= patient.getPatientID() %>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Patient
                        </a>
                    <% } %>
                    <a href="<%="doctor".equals(user.getRole()) ? "PatientServlet" : "PatientServlet"%>" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to <%="doctor".equals(user.getRole()) ? "Patient List" : "Patient List"%>
                    </a>
                </div>
            </div>
            <% } else { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> Patient not found
                </div>
                <a href="<%="doctor".equals(user.getRole()) ? "PatientServlet" : "PatientServlet"%>" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to <%="doctor".equals(user.getRole()) ? "Patient List" : "Patient List"%>
                </a>
            <% } %>
        </main>
    </div>

    <script src="sidebar.js"></script>
</body>
</html>