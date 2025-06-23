    <%-- 
    Document   : addAppointment
    Created on : 14 May 2025, 10:10:43 am
    Author     : muhdr
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
    <h1>Add Appointment</h1>
    <form action="AppointmentServlet" method="post">
        <input type="hidden" name="action" value="add">
        Appointment ID: <input type="text" name="appointmentID" required><br>
        Date: <input type="date" name="date" required><br>
        Time: <input type="time" name="time" required><br>
        Room No: <input type="number" name="roomNo" required><br>
        Doctor ID: <input type="text" name="doctorID" required><br>
        Patient ID: <input type="text" name="patientID" required><br>
        Receptionist ID: <input type="text" name="receptionistID" required><br>
        <input type="submit" value="Add Appointment">
    </form>
    
    <% if (request.getAttribute("successMessage") != null) { %>
    <p style="color:green;"><%= request.getAttribute("successMessage") %></p>
<% } else if (request.getAttribute("errorMessage") != null) { %>
    <p style="color:red;"><%= request.getAttribute("errorMessage") %></p>
<% } %>
    <a href="index.html">Back</a>
    </body>
</html>
