<%@ page import="model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Edit Appointment</title></head>
<body>

<h2>Edit Appointment</h2>

<%
    Appointment appt = (Appointment) request.getAttribute("appointment");
    if (appt != null) {
%>

<form action="AppointmentServlet" method="post">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="appointmentID" value="<%= appt.getAppointmentID() %>">

    <label>Date:</label><input type="date" name="date" value="<%= appt.getDate() %>"><br>
    <label>Time:</label><input type="time" name="time" value="<%= appt.getTime().toString().substring(0,5) %>"><br>
    <label>Room No:</label><input type="number" name="roomNo" value="<%= appt.getRoomNo() %>"><br>
    <label>Doctor ID:</label><input type="text" name="doctorID" value="<%= appt.getDoctorID() %>"><br>
    <label>Patient ID:</label><input type="text" name="patientID" value="<%= appt.getPatientID() %>"><br>
    <label>Receptionist ID:</label><input type="text" name="receptionistID" value="<%= appt.getReceptionistID() %>"><br>

    <input type="submit" value="Update Appointment">
</form>

<% } else { %>
    <p style="color:red;">Appointment not found.</p>
<% } %>

<a href="AppointmentServlet">Back to Appointment List</a>
</body>
</html>
