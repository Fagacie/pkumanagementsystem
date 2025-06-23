<%@ page import="java.util.*, model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User List</title>
</head>
<body>
    <a href='index.html'>Add New User</a>
    <h1>Appointment List</h1>

    <table border='1' width='100%'>
        <tr>
            <th>Appointment Id</th>
            <th>Date</th>
            <th>Time</th>
            <th>Room No</th>
            <th>Doctor ID</th>
            <th>Patient ID</th>
            <th>Receptionist ID</th>
             <th>Receptionist ID</th>
        </tr>

        <%
            
            List<Appointment> list = (List<Appointment>) request.getAttribute("userList");
            for(Appointment e : list){
        %>
        <tr>
            <td><%= e.getAppointmentID()%></td>
            <td><%= e.getDate()%></td>
            <td><%= e.getTime()%></td>
            <td><%= e.getRoomNo()%></td>
            <td><%= e.getDoctorID() %></td>
            <td><%= e.getPatientID() %></td>
            <td><%= e.getReceptionistID() %></td>
            <td><a href="AppointmentServlet_1?action=edit&id=<%= e.getAppointmentID() %>">Edit</a></td>
            
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
