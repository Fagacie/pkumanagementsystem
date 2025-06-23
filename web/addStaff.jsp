<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Ensure user is logged in and is an admin for this page
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
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
    <title>Add Staff - PKU Management System</title>
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
        
        .role-field {
            background-color: #f8f9fa;
            padding: 15px;
            margin-top: 15px;
            border-left: 4px solid #2f80ed;
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
                        <span class="user-role">(<%= user.getRole() %>)</span>
                    </div>
                </div>
            </a>
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="admin-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="payment"><i class="fas fa-file-invoice-dollar"></i> <span>View Payments</span></a></li>
                    <li><a href="StaffServlet" class="active"><i class="fas fa-users-cog"></i> <span>Manage Users</span></a></li>
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
                    
                    <h2 class="section-heading">Add New Staff</h2>
                    <form action="StaffServlet" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="add">

                        <div class="form-group">
                            <label for="userID">User ID:</label>
                            <input type="text" id="userID" name="userID" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="icnum">IC Number:</label>
                            <input type="text" id="icnum" name="icnum" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="password">Password:</label>
                            <input type="password" id="password" name="password" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="role">Role:</label>
                            <select name="role" id="role" class="form-control" onchange="showRoleFields()" required>
                                <option value="">-- Select Role --</option>
                                <option value="admin">Admin</option>
                                <option value="doctor">Doctor</option>
                                <option value="receptionist">Receptionist</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="name">Name:</label>
                            <input type="text" id="name" name="name" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" id="email" name="email" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber">Phone Number:</label>
                            <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="status">Status:</label>
                            <select name="status" id="status" class="form-control" required>
                                <option value="A">Active</option>
                                <option value="B">Inactive</option>
                            </select>
                        </div>

                        <!-- Doctor Specific Fields -->
                        <div id="doctorFields" class="role-field">
                            <div class="form-group">
                                <label for="specialization">Specialization:</label>
                                <input type="text" id="specialization" name="specialization" class="form-control">
                            </div>
                        </div>

                        <!-- Receptionist Specific Fields -->
                        <div id="receptionistFields" class="role-field">
                            <div class="form-group">
                                <label for="desk_no">Desk Number:</label>
                                <input type="number" id="desk_no" name="desk_no" class="form-control">
                            </div>
                        </div>

                        <button type="submit" class="submit-btn">
                            <i class="fas fa-user-plus"></i> Add Staff
                        </button>
                    </form>
                    
                    <a href="StaffServlet" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Staff List
                    </a>
                </div>
        </main>
    </div>

    <script src="sidebar.js"></script>
    <script>
        function showRoleFields() {
            const role = document.getElementById("role").value;
            document.getElementById("doctorFields").style.display = (role === "doctor") ? "block" : "none";
            document.getElementById("receptionistFields").style.display = (role === "receptionist") ? "block" : "none";
        }
        
        function validateForm() {
            const role = document.getElementById("role").value;
            const specialization = document.getElementById("specialization").value;
            const deskNo = document.getElementById("desk_no").value;
            
            if (role === "doctor" && specialization.trim() === "") {
                alert("Please enter specialization for doctor");
                return false;
            }
            
            if (role === "receptionist" && deskNo.trim() === "") {
                alert("Please enter desk number for receptionist");
                return false;
            }
            
            return true;
        }
        
        // Initialize role fields on page load
        document.addEventListener('DOMContentLoaded', function() {
            showRoleFields();
        });
    </script>
</body>
</html>