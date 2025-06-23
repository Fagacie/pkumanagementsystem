<%-- 
    Document   : payment-form
    Created on : Jun 3, 2025, 2:35:33 PM
    Author     : Abbas Usman
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Payment" %>
<%@ page import="model.User" %>
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
    <title>Record Payment</title>

    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/paymentform.css">

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
                    <li><a href="payment-form.jsp"class="active"><i class="fas fa-money-bill-wave"></i> <span>Add Payments</span></a></li>
                    <% if ("receptionist".equals(user.getRole()) || "admin".equals(user.getRole())) { %>
                        <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <% } %>
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
               <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <div class="main-form-wrapper">
                <div class="form-container">
                    <%
                        Payment payment = (Payment)request.getAttribute("payment");
                        boolean isEdit = (payment != null);
                    %>
                    <h2><%= isEdit ? "Edit" : "Add" %> Payment</h2>

                    <%-- Display success/error messages --%>
                    <% if (successMessage != null && !successMessage.isEmpty()) { %>
                        <p class="message success-message"><%= successMessage %></p>
                    <% } %>
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                        <p class="message error-message"><%= errorMessage %></p>
                    <% } %>

                    <form action="payment" method="post">
                        <input type="hidden" name="formType" value="<%= isEdit ? "edit" : "add" %>"/>

                        <div class="form-group">
                            <label for="paymentID" class="form-label">Payment ID:</label>
                            <input type="text" id="paymentID" name="paymentID" value="<%= isEdit ? payment.getPaymentID() : "" %>" readonly class="form-input readonly-input"/>
                        </div>

                        <div class="form-group">
                            <label for="receptionistID" class="form-label">Receptionist ID:</label>
                            <input type="text" id="receptionistID" name="receptionistID" value="<%= user.getUserID() %>" readonly class="form-input readonly-input"/>
                        </div>

                        <div class="form-group">
                            <label for="patientID" class="form-label">Patient ID:</label>
                            <input type="text" id="patientID" name="patientID" value="<%= isEdit ? payment.getPatientID() : "" %>" required class="form-input"/>
                        </div>

                        <div class="form-group">
                            <label for="amount" class="form-label">Amount:</label>
                            <input type="number" step="0.01" id="amount" name="amount" value="<%= isEdit ? payment.getAmount() : "" %>" required class="form-input"/>
                        </div>

                        <div class="form-group">
                            <label for="paymentStatus" class="form-label">Status:</label>
                            <select id="paymentStatus" name="paymentStatus" required class="form-select">
                                <option value="Y" <%= (isEdit && payment.getPaymentStatus() == 'Y') ? "selected" : "" %>>Paid</option>
                                <option value="N" <%= (isEdit && payment.getPaymentStatus() == 'N') ? "selected" : "" %>>Pending</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="method" class="form-label">Method:</label>
                            <select id="method" name="method" required class="form-select">
                                <option value="Cash" <%= (isEdit && "Cash".equals(payment.getMethod())) ? "selected" : "" %>>Cash</option>
                                <option value="Card" <%= (isEdit && "Card".equals(payment.getMethod())) ? "selected" : "" %>>Card</option>
                                <option value="Online Banking" <%= (isEdit && "Online Banking".equals(payment.getMethod())) ? "selected" : "" %>>Online Banking</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="date" class="form-label">Date:</label>
                            <input type="date" id="date" name="date" value="<%= isEdit ? payment.getDate() : "" %>" required class="form-input"/>
                        </div>

                        <div class="form-actions">
                            <input type="submit" value="<%= isEdit ? "Update" : "Record" %> Payment" class="submit-button"/>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script src="sidebar.js"></script> 
</body>
</html>
