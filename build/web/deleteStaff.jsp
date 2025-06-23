<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Delete Staff</title>
</head>
<body>
    <h1>Delete Staff</h1>
    
    <form action="StaffServlet" method="get">
        <input type="hidden" name="action" value="delete">
        <label for="userID">User ID:</label>
        <input type="text" name="userID" id="userID" required>
        <input type="submit" value="Delete">
    </form>
    
    <a href="StaffServlet">Back to Staff List</a>
</body>
</html>