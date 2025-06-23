<%-- 
    Document   : deleteAppointment
    Created on : 18 May 2025, 10:17:03 am
    Author     : muhdr
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Delete</title>
    </head>
    <body>
        <h1>Delete Appointment</h1>
        
        <form action="AppointmentServlet" method="get">
            <input type="hidden" name="action" value="delete">
            <label for="appointmentID">appointmentID : </label>
            <input type="text" name="appointmentID" id="appointmentID">
            <input type="submit" value="submit">
        </form>
    </body>
</html>
