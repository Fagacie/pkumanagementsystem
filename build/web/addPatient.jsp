<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Ensure user is logged in and is a receptionist or admin for this page
    User user = (User) session.getAttribute("user");
    if (user == null || (!"receptionist".equals(user.getRole()) && !"admin".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String errorMessage = (String) request.getAttribute("error");
    String successMessage = (String) session.getAttribute("successMessage");
    session.removeAttribute("successMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Patient - PKU Management System</title>
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
        
        input[type="text"], 
        input[type="password"], 
        input[type="email"], 
        input[type="number"], 
        select {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        
        input[type="number"] {
            -moz-appearance: textfield;
        }
        
        input[type="number"]::-webkit-outer-spin-button,
        input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
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
                    <li><a href="searchPatient_1.jsp""><i class="fas fa-user-injured"></i> <span>Patient Records</span></a></li>
                    <li><a href="doctorAvailability.jsp"><i class="fas fa-user"></i> <span>Check Doctor Availability</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                 <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
                
                
                <% if (successMessage != null && !successMessage.isEmpty()) { %>
                    <p class="message success-message"><%= successMessage %></p>
                <% } %>
                <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <p class="message error-message"><%= errorMessage %></p>
                <% } %>

                <div class="form-container">
                    
                    <h2 class="section-heading">Add New Patient</h2>
                    <form action="PatientServlet" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="form-group">
                            <label for="patientID">Patient ID:</label>
                            <input type="text" id="patientID" name="patientID" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="name">Name:</label>
                            <input type="text" id="name" name="name" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="address">Address:</label>
                            <input type="text" id="address" name="address" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="gender">Gender:</label>
                            <select id="gender" name="gender" class="form-control" required>
                                <option value="">-- Select Gender --</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="age">Age:</label>
                            <input type="number" id="age" name="age" class="form-control" min="0" required>
                        </div>

                        <div class="form-group">
                            <label for="bloodType">Blood Type:</label>
                            <select id="bloodType" name="bloodType" class="form-control" required>
                                <option value="">-- Select Blood Type --</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="weight">Weight (kg):</label>
                            <input type="number" id="weight" name="weight" class="form-control" step="0.1" min="0" required>
                        </div>

                        <div class="form-group">
                            <label for="height">Height (cm):</label>
                            <input type="number" id="height" name="height" class="form-control" step="0.1" min="0" required>
                        </div>

                        <button type="submit" class="submit-btn">
                            <i class="fas fa-user-plus"></i> Add Patient
                        </button>
                    </form>
                    
                    <a href="PatientServlet" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Patient List
                    </a>
                </div>
        </main>
    </div>

    <script src="sidebar.js"></script>
    <script>
        // Prevent form submission if any validation fails
        document.querySelector('form').addEventListener('submit', function(e) {
            const age = document.getElementById('age').value;
            const weight = document.getElementById('weight').value;
            const height = document.getElementById('height').value;
            
            if (age <= 0) {
                alert('Age must be greater than 0');
                e.preventDefault();
                return false;
            }
            
            if (weight <= 0) {
                alert('Weight must be greater than 0');
                e.preventDefault();
                return false;
            }
            
            if (height <= 0) {
                alert('Height must be greater than 0');
                e.preventDefault();
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>