<%-- 
    Document   : login
    Created on : Jun 3, 2025, 4:02:02 PM
    Author     : Abbas Usman
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login</title>
    <%-- Link to our dedicated login CSS file --%>
    <link rel="stylesheet" type="text/css" href="styles/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 400px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .modal-title {
            color: #dc3545;
            font-size: 1.2rem;
            font-weight: bold;
        }
        
        .close-modal {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close-modal:hover {
            color: black;
        }
        
        .modal-body {
            margin-bottom: 20px;
        }
        
        .modal-footer {
            display: flex;
            justify-content: center;
        }
        
        .modal-button {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .modal-button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="split-login-wrapper">
        <div class="login-left">
            <div class="login-container">
                <h2>Login</h2>
                <form method="post" action="LoginServlet" id="loginForm">
                    <div class="form-group">
                        <label for="userID" class="form-label">User ID:</label>
                        <input type="text" id="userID" name="userID" required />
                    </div>
                    <div class="form-group">
                        <label for="password" class="form-label">Password:</label>
                        <input type="password" id="password" name="password" required />
                    </div>
                    <input type="submit" value="Login" class="submit-button" />
                </form>
            </div>
        </div>
                
        <div class="login-right">
            <div class="design-overlay"></div>
            <div class="design-text">
                <h3>Welcome Back!</h3>
                <p>Pusat Kesihatan University   <br>Management System</p>
            </div>
        </div>
    </div>
    
    <!-- Error Modal -->
    <div id="errorModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span class="modal-title"><i class="fas fa-exclamation-circle"></i> Login Error</span>
                <span class="close-modal">&times;</span>
            </div>
            <div class="modal-body">
                <p id="errorMessage">${error}</p>
            </div>
            <div class="modal-footer">
                <button class="modal-button" id="closeButton">OK</button>
            </div>
        </div>
    </div>
    
    <script>
        // Show modal if there's an error
        window.onload = function() {
            const error = "${error}";
            if (error) {
                document.getElementById("errorMessage").textContent = error;
                document.getElementById("errorModal").style.display = "block";
            }
        };
        
        // Close modal when X is clicked
        document.querySelector(".close-modal").onclick = function() {
            document.getElementById("errorModal").style.display = "none";
        };
        
        // Close modal when OK button is clicked
        document.getElementById("closeButton").onclick = function() {
            document.getElementById("errorModal").style.display = "none";
        };
        
        // Close modal when clicking outside the modal
        window.onclick = function(event) {
            const modal = document.getElementById("errorModal");
            if (event.target === modal) {
                modal.style.display = "none";
            }
        };
    </script>
</body>
</html>