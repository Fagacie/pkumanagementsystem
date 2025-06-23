<%@page import="java.util.List"%>
<%@page import="model.Patient"%>
<%@page import="model.User"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Ensure user is logged in and is a receptionist, admin, or doctor
    User user = (User) session.getAttribute("user");
    if (user == null || (!"receptionist".equals(user.getRole()) && !"admin".equals(user.getRole()) && !"doctor".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%="doctor".equals(user.getRole()) ? "View Patients" : "Manage Patients"%></title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/viewpayment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        #searchBar {
            padding: 10px;
            width: 98%;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .search-container {
            margin-bottom: 20px;
        }
        
        .highlight {
            background-color: yellow;
        }
        .hidden-row {
            display: none;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .action-button {
            padding: 5px 8px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
        }
        .edit-button {
            background-color: #00a896;
        }
        .edit-button:hover {
            background-color: #218838;
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
            <div class="content-panel">
                <h2 class="section-heading"><%="doctor".equals(user.getRole()) ? "View Patients" : "Manage Patients"%></h2>

                <% if (successMessage != null && !successMessage.isEmpty()) { %>
                    <p class="message success-message"><%= successMessage %></p>
                <% } %>
                <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <p class="message error-message"><%= errorMessage %></p>
                <% } %>

                <% if (!"doctor".equals(user.getRole())) { %>
                    <div class="action-bar">
                        <a href="addPatient.jsp" class="add-new-button">
                            <i class="fas fa-plus-circle"></i> Register Patient
                        </a>
                    </div>
                <% } %>

                <div class="search-container">
                    <input type="text" id="searchBar" placeholder="Search by ID, name" onkeyup="filterTable()">
                </div>      
                
                <div class="table-container">
                    <table id="patientTable" class="data-table">
                        <thead>
                            <tr>
                                <th>Patient ID</th>
                                <th>Name</th>
                                <th>Blood Type</th>
                                <th>Status</th>
                                <% if (!"doctor".equals(user.getRole())) { %>
                                    <th>Action</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Patient> patientList = (List<Patient>) request.getAttribute("patientList");
                                for (Patient patient : patientList) {
                            %>
                            <tr onclick="window.location='PatientServlet?action=details&id=<%= patient.getPatientID() %>'">
                                <td class="patientid" data-original="<%= patient.getPatientID() %>"><%= patient.getPatientID() %></td>
                                <td class="name" data-original="<%= patient.getName() %>"><%= patient.getName() %></td>
                                <td><%= patient.getBloodType() %></td>
                                <td><%= patient.getStatus() %></td>
                                <% if (!"doctor".equals(user.getRole())) { %>
                                    <td class="actions-column">
                                        <a href="PatientServlet?action=edit&id=<%=patient.getPatientID()%>" class="action-button edit-button" title="Edit Patient">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </td>
                                <% } %>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        function filterTable() {
            const input = document.getElementById("searchBar");
            const filter = input.value.trim().toUpperCase();
            const rows = document.querySelectorAll("#patientTable tbody tr");

            rows.forEach(row => {
                const patientidCell = row.querySelector('.patientid');
                const nameCell = row.querySelector('.name');

                // Restore original text from data-original
                const patientid = patientidCell.getAttribute('data-original');
                const name = nameCell.getAttribute('data-original');

                patientidCell.innerHTML = patientid;
                nameCell.innerHTML = name;

                const matchPatientID = patientid.toUpperCase().includes(filter);
                const matchName = name.toUpperCase().includes(filter);

                const found = matchPatientID || matchName;

                // Apply highlights if found
                if (filter.length > 0 && found) {
                    if (matchPatientID) highlightText(patientidCell, patientid, filter);
                    if (matchName) highlightText(nameCell, name, filter);
                }

                // Show or hide row
                row.classList.toggle('hidden-row', !found && filter.length > 0);
            });
        }

        function highlightText(element, originalText, filter) {
            const regex = new RegExp(`(${filter})`, 'gi');
            element.innerHTML = originalText.replace(regex, '<span class="highlight">$1</span>');
        }
    </script>
</body>
</html>