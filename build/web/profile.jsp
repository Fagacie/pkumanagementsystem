<%-- 
    Document   : profile
    Created on : Jun 3, 2025, 4:02:54 PM
    Author     : Abbas Usman
--%>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"receptionist".equals(user.getRole()) && !"admin".equals(user.getRole()) && !"doctor".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Profile</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Popup notification styles */
        .notification-popup {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 5px;
            color: white;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            animation: slideIn 0.5s, fadeOut 0.5s 2.5s forwards;
            max-width: 300px;
        }
        
        .notification-success {
            background-color: #28a745;
        }
        
        .notification-error {
            background-color: #dc3545;
        }
        
        @keyframes slideIn {
            from { transform: translateX(100%); }
            to { transform: translateX(0); }
        }
        
        @keyframes fadeOut {
            from { opacity: 1; }
            to { opacity: 0; }
        }

        /* Profile form styles - Enhanced */
        .profile-form {
            max-width: 700px;
            margin: 0 auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }
        
        .form-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .form-input:focus {
            border-color: #00a896;
            box-shadow: 0 0 0 3px rgba(0, 168, 150, 0.1);
            outline: none;
        }
        
        .readonly-input {
            background-color: #f8f9fa;
            cursor: not-allowed;
            color: #6c757d;
        }
        
        .form-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .action-buttons {
            display: flex;
            gap: 12px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-primary {
            background-color: #00a896;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #008b7a;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 168, 150, 0.3);
        }
        
        .btn-danger {
            background-color: #e63946;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #d62839;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(230, 57, 70, 0.3);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-1px);
        }
        
        .section-heading {
            color: #00a896;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 24px;
            font-weight: 600;
        }

        /* Modal styles - Enhanced */
        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(3px);
        }
        
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 25px;
            border-radius: 8px;
            width: 450px;
            max-width: 90%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            animation: modalFadeIn 0.3s;
        }
        
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 25px;
            gap: 12px;
        }
        
        .profile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: #00a896;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: bold;
            margin-right: 20px;
        }
        
        .profile-info-container {
            display: flex;
            align-items: center;
        }
        
        .profile-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #343a40;
        }
        
        .profile-role {
            font-size: 14px;
            color: #6c757d;
            background-color: #e9ecef;
            padding: 3px 10px;
            border-radius: 20px;
            display: inline-block;
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
            <a href="profile" class="profile-link active">
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
                    <li><a href="<%= user.getRole().toLowerCase() + "-dashboard.jsp" %>"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile" class="active"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <% if ("receptionist".equals(user.getRole())) { %>
                    <li><a href="payment-form.jsp"><i class="fas fa-money-bill-wave"></i> <span>Add Payments</span></a></li>
                    <% } %>
                    
                    <% if ("receptionist".equals(user.getRole()) || "admin".equals(user.getRole())) { %>
                        <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <% } %>
                        
                    <% if ("receptionist".equals(user.getRole())) { %>
                    <li><a href="manageAppointment.jsp"><i class="fas fa-calendar-plus"></i> <span>Create Appointment</span></a></li>
                    <li><a href="currentAppointments.jsp"><i class="fas fa-calendar-check"></i> <span>Pending</span></a></li>
                    <li><a href="PatientServlet"><i class="fas fa-procedures"></i> <span>Manage Patient</span></a></li>
                    <li><a href="doctorAvailability.jsp"><i class="fas fa-user-md"></i> <span>Doctor Availability</span></a></li>
                    <% } %>
                    
                    <% if ("admin".equals(user.getRole())) { %>
                        <li><a href="StaffServlet"><i class="fas fa-users-cog"></i> <span>Manage Users</span></a></li>
                    <% } %>
                    <% if ("doctor".equals(user.getRole())) { %>
                       <li><a href="viewAppointments.jsp"><i class="fas fa-calendar-check card-icon"></i> <span>Appointment</span></a></li>
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
            <div class="content-panel">
                <div class="profile-header">
                    <div class="profile-info-container">
                        <div class="profile-avatar">
                            <%= user.getName().charAt(0) %>
                        </div>
                        <div>
                            <h1 class="profile-title"><%= user.getName() %></h1>
                            <span class="profile-role"><%= user.getRole() %></span>
                        </div>
                    </div>
                </div>
                
                <h2 class="section-heading">Profile Information</h2>
                <form method="post" action="ProfileServlet" class="profile-form">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="userID" class="form-label">User ID</label>
                            <input type="text" id="userID" name="userID" value="<%= user.getUserID() %>" readonly class="form-input readonly-input" />
                        </div>
                        <div class="form-group">
                            <label for="role" class="form-label">Role</label>
                            <input type="text" id="role" name="role" value="<%= user.getRole() %>" readonly class="form-input readonly-input" />
                        </div>
                        <div class="form-group">
                            <label for="name" class="form-label">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= user.getName() %>" required class="form-input" />
                        </div>
                        <div class="form-group">
                            <label for="icnum" class="form-label">IC Number</label>
                            <input type="text" id="icnum" name="icnum" value="<%= user.getIcnum() %>" required class="form-input" />
                        </div>
                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required class="form-input" />
                        </div>
                        <div class="form-group">
                            <label for="phoneNumber" class="form-label">Phone Number</label>
                            <input type="text" id="phoneNumber" name="phoneNumber" value="<%= user.getPhoneNumber() %>" required class="form-input" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" id="password" name="password" value="<%= user.getPassword() %>" required class="form-input" />
                        <small style="display: block; margin-top: 5px; color: #6c757d; font-size: 13px;">For security, the password is shown in plain text only to you</small>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <% if ("receptionist".equals(user.getRole()) || "doctor".equals(user.getRole())) { %>
                        <button type="button" class="btn btn-danger" onclick="openDeleteModal()">
                            <i class="fas fa-trash-alt"></i> Delete Account
                        </button>
                        <% } %>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3 style="margin-top: 0; color: #e63946;"><i class="fas fa-exclamation-triangle"></i> Confirm Account Deletion</h3>
            <p>Are you sure you want to permanently delete your account? This action will:</p>
            <ul style="padding-left: 20px; margin: 15px 0;">
                <li>Remove all your personal information</li>
                <li>Delete your access to the system</li>
                <li>Cannot be undone</li>
            </ul>
            <p>To confirm, please enter your password:</p>
            <input type="password" id="confirmPassword" class="form-input" placeholder="Enter your password" style="margin-bottom: 15px;">
            <div class="modal-actions">
                <button class="btn btn-secondary" onclick="closeDeleteModal()">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <form id="deleteForm" method="post" action="DeleteProfileServlet" style="display: inline;">
                    <button type="submit" class="btn btn-danger" id="confirmDeleteBtn" disabled>
                        <i class="fas fa-trash-alt"></i> Delete Account
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Notification Popups -->
    <% if (message != null && !message.isEmpty()) { %>
        <div class="notification-popup notification-success">
            <i class="fas fa-check-circle"></i>
            <%= message %>
        </div>
        <script>
            setTimeout(() => {
                const popup = document.querySelector('.notification-popup');
                if (popup) popup.remove();
            }, 3000);
        </script>
    <% } %>
    
    <% if (error != null && !error.isEmpty()) { %>
        <div class="notification-popup notification-error">
            <i class="fas fa-exclamation-circle"></i>
            <%= error %>
        </div>
        <script>
            setTimeout(() => {
                const popup = document.querySelector('.notification-popup');
                if (popup) popup.remove();
            }, 3000);
        </script>
    <% } %>

    <script src="sidebar.js"></script>
    <script>
        // Modal functions
        function openDeleteModal() {
            document.getElementById('deleteModal').style.display = 'block';
            document.getElementById('confirmPassword').value = '';
            document.getElementById('confirmDeleteBtn').disabled = true;
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                closeDeleteModal();
            }
        }
        
        // Password confirmation for delete
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const userPassword = '<%= user.getPassword() %>';
            const confirmBtn = document.getElementById('confirmDeleteBtn');
            confirmBtn.disabled = this.value !== userPassword;
        });
    </script>
</body>
</html>