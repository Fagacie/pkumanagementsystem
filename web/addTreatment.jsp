<%@page import="model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // Get list of illnesses
    List<Map<String, String>> illnesses = new ArrayList<>();
    // Get list of medicines
    List<Map<String, String>> medicines = new ArrayList<>();
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pkudb", "root", "");
        
        // Get illnesses
        String illnessSql = "SELECT illnessID, name FROM illness";
        PreparedStatement illnessPs = con.prepareStatement(illnessSql);
        ResultSet illnessRs = illnessPs.executeQuery();

        while (illnessRs.next()) {
            Map<String, String> illness = new HashMap<>();
            illness.put("id", illnessRs.getString("illnessID"));
            illness.put("name", illnessRs.getString("name"));
            illnesses.add(illness);
        }
        
        // Get medicines
        String medicineSql = "SELECT medicineID, name FROM medicine";
        PreparedStatement medicinePs = con.prepareStatement(medicineSql);
        ResultSet medicineRs = medicinePs.executeQuery();

        while (medicineRs.next()) {
            Map<String, String> medicine = new HashMap<>();
            medicine.put("id", medicineRs.getString("medicineID"));
            medicine.put("name", medicineRs.getString("name"));
            medicines.add(medicine);
        }
        
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String doctorId = String.valueOf(user.getUserID());
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Treatment</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/addTreatment.css">
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
                    <li><a href="doctor-dashboard.jsp" ><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="viewAppointments.jsp"class="active"><i class="fas fa-calendar-check card-icon"></i> <span>Appointment</span></a></li>
                    <li><a href="searchPatient_1.jsp"><i class="fas fa-user-injured card-icon"></i> <span>Patient Records</span></a></li>
                    <li><a href="updateAvailability.jsp" ><i class="fas fa-notes-medical card-icon"></i> <span>Update Availability</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>
                    
    <div class="content-panel treatment-form">
    <h2 class="section-heading">Add Treatment</h2>
    
    <form action="AddTreatmentServlet" method="post" class="medical-form">
        <!-- Hidden fields -->
        <input type="hidden" name="appointmentID" value="<%= request.getParameter("appointmentID") %>">
        <input type="hidden" name="patientID" value="<%= request.getParameter("patientID") %>">
        
        <div class="form-group">
            <label for="symptoms">Symptoms:</label>
            <input type="text" id="symptoms" name="symptoms" required class="form-input">
        </div>
        
        <div class="form-group">
            <label for="illnessID">Illness:</label>
            <select id="illnessID" name="illnessID" required class="form-select">
                <option value="" disabled selected>Select illness</option>
                <% for (Map<String, String> illness : illnesses) { %>
                    <option value="<%= illness.get("id") %>"><%= illness.get("name") %></option>
                <% } %>
            </select>
        </div>
        
        <div class="form-group">
            <label for="medicineID">Medicine:</label>
            <select id="medicineID" name="medicineID" required class="form-select">
                <option value="" disabled selected>Select medicine</option>
                <% for (Map<String, String> medicine : medicines) { %>
                    <option value="<%= medicine.get("id") %>"><%= medicine.get("name") %></option>
                <% } %>
            </select>
        </div>
        
        <div class="form-group">
            <label for="dosage">Dosage:</label>
            <input type="text" id="dosage" name="dosage" required class="form-input">
        </div>
        
        <div class="form-group">
            <label for="date">Date:</label>
            <input type="date" id="date" name="date" required class="form-input">
        </div>
        
        <div class="form-actions">
            <button type="submit" class="submit-button">
                <i class="fas fa-save"></i> Submit Treatment
            </button>
        </div>
    </form>
</div>

</body>
</html>