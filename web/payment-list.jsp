<%-- 
    Document   : payment-list
    Created on : Jun 3, 2025, 2:35:16 PM
    Author     : Abbas Usman
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%
    // Ensure user is logged in and is either a receptionist OR an admin for this page
    User user = (User) session.getAttribute("user");
    if (user == null || (!"receptionist".equals(user.getRole()) && !"admin".equals(user.getRole()))) {
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
    <title>Payments List</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/viewpayment.css">
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
                        <li><a href="payment"class="active"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
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
                        <li><a href="appointments.jsp"><i class="fas fa-calendar-alt"></i> <span>View Appointments</span></a></li>
                    <% } %>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>            </div>
        </aside>

        <main class="main-content">
            <div class="content-panel">
                <h2 class="section-heading">Payments List</h2>

                <% if (successMessage != null && !successMessage.isEmpty()) { %>
                    <p class="message success-message"><%= successMessage %></p>
                <% } %>
                <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <p class="message error-message"><%= errorMessage %></p>
                <% } %>

                <% if ("receptionist".equals(user.getRole())) { %>
                    <div class="action-bar">
                        <a href="payment?action=new" class="add-new-button"> <%-- CORRECTED: Link is to 'payment' --%>
                            <i class="fas fa-plus-circle"></i> Add New Payment
                        </a>
                    </div>
                <% } %>
                

                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Receptionist ID</th>
                                <th>Patient ID</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Method</th>
                                <th>Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                            <tbody>
                            <%
                                List<Payment> paymentList = (List<Payment>)request.getAttribute("paymentList");
                                if (paymentList != null && !paymentList.isEmpty()) {
                                    for (Payment p : paymentList) {
                            %>
                            <tr>
                                <td><%= p.getPaymentID() %></td>
                                <td><%= p.getReceptionistID() %></td>
                                <td><%= p.getPatientID() %></td>
                                <td><%= String.format("%.2f", p.getAmount()) %></td>
                                <td><%= p.getPaymentStatus() == 'Y' ? "Paid" : "Pending" %></td>
                                <td><%= p.getMethod() %></td>
                                <td><%= p.getDate() %></td>
                                <td class="actions-column">
                                    <a href="payment?action=edit&paymentID=<%=p.getPaymentID()%>" class="action-button edit-button" title="Edit Payment"> <%-- CORRECTED: Link is to 'payment' --%>
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button class="action-button delete-button" data-payment-id="<%=p.getPaymentID()%>" title="Delete Payment">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8" class="no-data-message">No payments found.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="deleteConfirmationModal" class="modal">
        <div class="modal-content">
            <span class="close-button">&times;</span>
            <h3>Confirm Deletion</h3>
            <p>Are you sure you want to delete payment ID: <strong id="modalPaymentID"></strong>?</p>
            <div class="modal-actions">
                <button id="confirmDeleteButton" class="action-button reject-button">Delete</button>
                <button id="cancelDeleteButton" class="action-button secondary-button">Cancel</button>
            </div>
        </div>
    </div>


    <script src="sidebar.js"></script> 
    <script src="payment-modal.js"></script> 
</body>
</html>

