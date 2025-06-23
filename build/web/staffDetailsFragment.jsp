<%@page import="java.util.Map"%>
<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Map<String, Object> details = (Map<String, Object>) request.getAttribute("details");
    Staff staff = (Staff) details.get("user");
%>
<table class="staff-details-table">
    <tr class="section-header">
        <th colspan="2">Basic Information</th>
    </tr>
    <tr>
        <th>User ID</th>
        <td><%= staff.getUserID() %></td>
    </tr>
    <tr>
        <th>Name</th>
        <td><%= staff.getName() %></td>
    </tr>
    <tr>
        <th>Role</th>
        <td><%= staff.getRole() %></td>
    </tr>
    <tr>
        <th>Status</th>
        <td><%= staff.getStatusText() %></td>
    </tr>
    <tr>
        <th>Email</th>
        <td><%= staff.getEmail() %></td>
    </tr>
    <tr>
        <th>Phone Number</th>
        <td><%= staff.getPhoneNumber() %></td>
    </tr>

    <% if ("doctor".equalsIgnoreCase(staff.getRole())) { %>
        <tr class="section-header">
            <th colspan="2">Doctor Information</th>
        </tr>
        <tr>
            <th>Specialization</th>
            <td><%= details.get("specialization") != null ? details.get("specialization") : "N/A" %></td>
        </tr>
    <% } %>

    <% if ("receptionist".equalsIgnoreCase(staff.getRole())) { %>
        <tr class="section-header">
            <th colspan="2">Receptionist Information</th>
        </tr>
        <tr>
            <th>Desk Number</th>
            <td><%= details.get("desk_no") != null ? details.get("desk_no") : "N/A" %></td>
        </tr>
    <% } %>
</table>

<div class="modal-actions">
    <a href="StaffServlet?action=edit&id=<%= staff.getUserID() %>" class="edit-button">
        <i class="fas fa-edit"></i> Edit Staff
    </a>
    <button class="close-modal-button" onclick="document.getElementById('staffDetailsModal').style.display='none'">
        <i class="fas fa-times"></i> Close
    </button>
</div>