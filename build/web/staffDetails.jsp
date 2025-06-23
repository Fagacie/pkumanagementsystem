<%@page import="java.util.Map"%>
<%@page import="model.Staff"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Map<String, Object> details = (Map<String, Object>) request.getAttribute("details");
    Staff staff = (Staff) details.get("user");
    
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Details | PKU Medical System</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .staff-details-card {
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
                    <li><a href="admin-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <li><a href="StaffServlet" class="active"><i class="fas fa-users-cog"></i> <span>Manage Users</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <h2 class="welcome-message">Staff Details</h2>
            
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
            
            <div class="staff-details-card">
                <h3 class="section-header">Basic Information</h3>
                
                <div class="detail-row">
                    <div class="detail-label">User ID</div>
                    <div class="detail-value"><%= staff.getUserID() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Name</div>
                    <div class="detail-value"><%= staff.getName() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Role</div>
                    <div class="detail-value"><%= staff.getRole() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Status</div>
                    <div class="detail-value"><%= staff.getStatusText() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Email</div>
                    <div class="detail-value"><%= staff.getEmail() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Password</div>
                    <div class="detail-value"><%= staff.getPassword() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Phone Number</div>
                    <div class="detail-value"><%= staff.getPhoneNumber() %></div>
                </div>
                
                <% if ("doctor".equalsIgnoreCase(staff.getRole())) { %>
                    <h3 class="section-header">Doctor Information</h3>
                    <div class="detail-row">
                        <div class="detail-label">Specialization</div>
                        <div class="detail-value">
                            <%= details.get("specialization") != null ? details.get("specialization") : "N/A" %>
                        </div>
                    </div>
                <% } %>
                
                <% if ("receptionist".equalsIgnoreCase(staff.getRole())) { %>
                    <h3 class="section-header">Receptionist Information</h3>
                    <div class="detail-row">
                        <div class="detail-label">Desk Number</div>
                        <div class="detail-value">
                            <%= details.get("desk_no") != null ? details.get("desk_no") : "N/A" %>
                        </div>
                    </div>
                <% } %>
                
                <div class="action-buttons">
                    <a href="StaffServlet?action=edit&id=<%= staff.getUserID() %>" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit Staff
                    </a>
                    <a href="StaffServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>
        </main>
    </div>

    <script src="sidebar.js"></script>
</body>
</html>