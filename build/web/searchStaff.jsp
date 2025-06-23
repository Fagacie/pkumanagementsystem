<%@page import="java.util.List"%>
<%@page import="model.Staff"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Ensure user is logged in and is an admin for this page
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
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
    <title>Manage Staff</title>
    <link rel="stylesheet" type="text/css" href="styles/dashboard.css">
    <link rel="stylesheet" type="text/css" href="styles/viewpayment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .search-container {
            margin-bottom: 20px;
        }
        
        #searchBar {
            padding: 10px;
            width: 98%;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .highlight {
            background-color: #28a745;
        }
        
        tr {
            cursor: pointer;
        }
        
        #confirmDeleteButton {
            background-color: #dc3545; /* Red color for delete */
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        #confirmDeleteButton:hover {
            background-color: #c82333; /* Darker red on hover */
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
                    <li><a href="admin-dashboard.jsp" ><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="profile"><i class="fas fa-user"></i> <span>My Profile</span></a></li>
                    <li><a href="payment"><i class="fas fa-receipt"></i> <span>Payments List</span></a></li>
                    <li><a href="StaffServlet"class="active"><i class="fas fa-users-cog"></i><span>Manage Users</span></a></li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <a href="login.jsp" class="logout-button"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <main class="main-content">
            <div class="content-panel">
                <h2 class="section-heading">Manage Staff</h2>

                <% if (successMessage != null && !successMessage.isEmpty()) { %>
                    <p class="message success-message"><%= successMessage %></p>
                <% } %>
                <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <p class="message error-message"><%= errorMessage %></p>
                <% } %>

                <div class="action-bar">
                    <a href="addStaff.jsp" class="add-new-button">
                        <i class="fas fa-plus-circle"></i> Add New Staff
                    </a>
                </div>

                <div class="search-container">
                    <input type="text" id="searchBar" placeholder="Search by ID, name, or role..." onkeyup="filterTable()">
                </div>

                <div class="table-container">
                    <table id="staffTable" class="data-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
                                for (Staff staff : staffList) {
                            %>
                            <tr onclick="window.location='StaffServlet?action=details&id=<%= staff.getUserID() %>'">
                                <td class="userid" data-original="<%= staff.getUserID() %>"><%= staff.getUserID() %></td>
                                <td class="name" data-original="<%= staff.getName() %>"><%= staff.getName() %></td>
                                <td class="role" data-original="<%= staff.getRole() %>"><%= staff.getRole() %></td>
                                <td class="actions-column">
                                    <a href="StaffServlet?action=edit&id=<%=staff.getUserID()%>" class="action-button edit-button" title="Edit Staff">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button class="action-button delete-button" 
                                            data-staff-id="<%= staff.getUserID() %>" 
                                            onclick="console.log('Delete clicked for: <%= staff.getUserID() %>')" 
                                            title="Delete Staff">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="deleteConfirmationModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close-button">&times;</span>
            <h3>Confirm Deletion</h3>
            <p>Are you sure you want to delete staff with ID: <strong id="modalStaffID"></strong>?</p>
            <div class="modal-actions">
                <button id="confirmDeleteButton" class="action-button reject-button">Delete</button>
                <button id="cancelDeleteButton" class="action-button secondary-button">Cancel</button>
            </div>
        </div>
    </div>
                        
    <div id="staffDetailsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">Staff Details</h3>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <table class="appointment-table">
                <tbody id="staffDetailsContent">
                    <!-- Content will be loaded here -->
                </tbody>
            </table>
        </div>
    </div>
</div>

    

    <script src="sidebar.js"></script>
    <script>
        function filterTable() {
            const input = document.getElementById("searchBar");
            const filter = input.value.trim().toUpperCase();
            const rows = document.querySelectorAll("#staffTable tbody tr");

            rows.forEach(row => {
                if (row.classList.contains('no-data-message')) return;

                const useridCell = row.querySelector('.userid');
                const nameCell = row.querySelector('.name');
                const roleCell = row.querySelector('.role');
//                const statusCell = row.querySelector('.status');

                const userid = useridCell.getAttribute('data-original');
                const name = nameCell.getAttribute('data-original');
                const role = roleCell.getAttribute('data-original');
//                const status = statusCell.getAttribute('data-original');

                useridCell.innerHTML = userid;
                nameCell.innerHTML = name;
                roleCell.innerHTML = role;
//                statusCell.innerHTML = status;

                const matchUserID = userid.toUpperCase().includes(filter);
                const matchName = name.toUpperCase().includes(filter);
                const matchRole = role.toUpperCase().includes(filter);

                const found = matchUserID || matchName || matchRole;

                if (filter.length > 0 && found) {
                    if (matchUserID) highlightText(useridCell, userid, filter);
                    if (matchName) highlightText(nameCell, name, filter);
                    if (matchRole) highlightText(roleCell, role, filter);
                }

                row.style.display = (found || filter.length === 0) ? "" : "none";
            });
        }

        function highlightText(element, originalText, filter) {
            const regex = new RegExp(`(${filter})`, 'gi');
            element.innerHTML = originalText.replace(regex, '<span class="highlight">$1</span>');
        }

        // Delete confirmation modal handling
        document.addEventListener('DOMContentLoaded', function() {
            // Get all elements
            const deleteButtons = document.querySelectorAll('.delete-button');
            const modal = document.getElementById('deleteConfirmationModal');
            const modalStaffID = document.getElementById('modalStaffID');
            const closeButton = document.querySelector('.close-button');
            const cancelButton = document.getElementById('cancelDeleteButton');
            const confirmButton = document.getElementById('confirmDeleteButton');

            // Function to show modal
            function showModal(staffId) {
                modalStaffID.textContent = staffId;
                modal.style.display = 'block';
            }

            // Function to hide modal
            function hideModal() {
                modal.style.display = 'none';
            }

            // Add click event to all delete buttons
            deleteButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    const staffID = this.getAttribute('data-staff-id');
                    showModal(staffID);
                });
            });

            // Confirm delete button
            confirmButton.addEventListener('click', function() {
                const staffID = modalStaffID.textContent;
                window.location.href = 'StaffServlet?action=delete&id=' + encodeURIComponent(staffID);
                hideModal();
            });

            // Close modal events
            closeButton.addEventListener('click', hideModal);
            cancelButton.addEventListener('click', hideModal);
            window.addEventListener('click', function(event) {
                if (event.target === modal) {
                    hideModal();
                }
            });
        });
        
      
    </script>
</body>
</html>