<%@page import="java.util.Map"%>
<%@page import="model.Staff"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Ensure user is logged in and is an admin for this page
    User user = (User) session.getAttribute("user");
    if (user == null || !"receptionist".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
  
    
    Staff staff = (Staff) request.getAttribute("staff");
    String errorMessage = (String) request.getAttribute("error");
    String successMessage = (String) session.getAttribute("successMessage");
    session.removeAttribute("successMessage");
%><!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Patient</title>
     <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/viewpayment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        .form-container {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 20px auto;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-control[readonly] {
            background-color: #f8f9fa;
        }
        
        .role-field {
            background-color: #f8f9fa;
            padding: 15px;
            margin-top: 15px;
            border-left: 4px solid #00a896;
            display: none;
        }
        
        .submit-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .submit-btn:hover {
            background-color: #218838;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #777777;
            text-decoration: none;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        input[type="text"], input[type="password"], input[type="email"], input[type="number"], select {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
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
                        <span class="user-role">(Receptionist)</span>
                    </div>
                </div>
            </a>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="receptionist-dashboard.jsp" ><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="payment-form.jsp"><i class="fas fa-cash-register"></i> <span>Record Payments</span></a></li>
                    <li><a href="payment"><i class="fas fa-file-invoice-dollar"></i> <span>View Payments</span></a></li>
                    <li><a href="manageAppointment.jsp"><i class="fas fa-calendar-alt"></i> <span>Manage Appointments</span></a></li>
                    <li><a href="currentAppointments.jsp"><i class="fas fa-calendar-alt"></i> <span>View Appointments</span></a></li>
                    <li><a href="PatientServlet" class="active"><i class="fas fa-user-injured"></i> <span>Manage Patient</span></a></li>
                    <li><a href="searchPatient_1.jsp"><i class="fas fa-user-injured"></i> <span>Patient Records</span></a></li>
                    <li><a href="doctorAvailability.jsp"><i class="fas fa-user"></i> <span>Check Doctor Availability</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                 <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <% if (request.getAttribute("error") != null) { %>
                <p class="error"><%= request.getAttribute("error") %></p>
            <% } %>
            
            <div class="form-container">
                
                <h2 class="section-heading">Edit Patient</h2>
            
                <form action="PatientServlet" method="post">
                <input type="hidden" name="action" value="edit">

                <div class="form-group">
                    <label>Patient ID:</label>
                    <input type="text" name="patientID" value="${patient.patientID}" readonly>
                </div>

                <div class="form-group">
                    <label>Name:</label>
                    <input type="text" name="name" value="${patient.name}" required>
                </div>

                <div class="form-group">
                    <label>Address:</label>
                    <input type="text" name="address" value="${patient.address}" required>
                </div>

                <div class="form-group">
                    <label>Gender:</label>
                    <select name="gender" required>
                        <option value="Male" ${patient.gender == 'Male' ? 'selected' : ''}>Male</option>
                        <option value="Female" ${patient.gender == 'Female' ? 'selected' : ''}>Female</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Age:</label>
                    <input type="number" name="age" value="${patient.age}" required>
                </div>

                <div class="form-group">
                    <label>Blood Type:</label>
                    <select name="bloodType" required>
                        <option value="A+" ${patient.bloodType == 'A+' ? 'selected' : ''}>A+</option>
                        <option value="A-" ${patient.bloodType == 'A-' ? 'selected' : ''}>A-</option>
                        <option value="B+" ${patient.bloodType == 'B+' ? 'selected' : ''}>B+</option>
                        <option value="B-" ${patient.bloodType == 'B-' ? 'selected' : ''}>B-</option>
                        <option value="AB+" ${patient.bloodType == 'AB+' ? 'selected' : ''}>AB+</option>
                        <option value="AB-" ${patient.bloodType == 'AB-' ? 'selected' : ''}>AB-</option>
                        <option value="O+" ${patient.bloodType == 'O+' ? 'selected' : ''}>O+</option>
                        <option value="O-" ${patient.bloodType == 'O-' ? 'selected' : ''}>O-</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Weight (kg):</label>
                    <input type="number" step="0.1" name="weight" value="${patient.weight}" required>
                </div>

                <div class="form-group">
                    <label>Height (cm):</label>
                    <input type="number" step="0.1" name="height" value="${patient.height}" required>
                </div>

                <button type="submit" class="submit-btn">
                            <i class="fas fa-save"></i> Update Patient
                </button>
                
                <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
            </form>
            <a href="PatientServlet" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Staff List
                    </a>
           </div>
        </main>
    </div>
    
    
    
    
    
</body>
</html>