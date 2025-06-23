package servlet;

import dao.StaffDAO;
import model.Staff;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StaffServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("details".equalsIgnoreCase(action)) {
            String userID = request.getParameter("id");
            Map<String, Object> staffDetails = StaffDAO.getStaffDetails(userID);
            request.setAttribute("details", staffDetails);
            request.getRequestDispatcher("staffDetails.jsp").forward(request, response);
        }
        
        if ("edit".equalsIgnoreCase(action)) {
            String id = request.getParameter("id");
            Staff staff = StaffDAO.getStaffById(id);
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("editStaff.jsp").forward(request, response);
        } 
        else if ("delete".equalsIgnoreCase(action)) {
    String id = request.getParameter("id");
    System.out.println("Attempting to delete staff with ID: " + id); // Debug log
    
    if (id != null && !id.trim().isEmpty()) {
        try {
            // First check if staff exists
            Staff staff = StaffDAO.getStaffById(id);
            if (staff != null) {
                System.out.println("Staff found: " + staff.getName()); // Debug log
                int status = StaffDAO.deleteStaff(id);
                if (status > 0) {
                    request.getSession().setAttribute("successMessage", "Staff deleted successfully");
                    System.out.println("Delete successful"); // Debug log
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete staff (database error)");
                    System.out.println("Delete failed - no rows affected"); // Debug log
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Staff not found with ID: " + id);
                System.out.println("Staff not found in database"); // Debug log
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error deleting staff: " + e.getMessage());
            System.out.println("Exception during delete: " + e.getMessage()); // Debug log
            e.printStackTrace();
        }
    } else {
        request.getSession().setAttribute("errorMessage", "Invalid staff ID");
        System.out.println("Invalid ID received"); // Debug log
    }
    response.sendRedirect("StaffServlet");
}
        else {
            List<Staff> staffList = StaffDAO.getAllStaff();
            request.setAttribute("staffList", staffList);
            request.getRequestDispatcher("searchStaff.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String userID = request.getParameter("userID");
        String icnum = request.getParameter("icnum");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        char status = request.getParameter("status").charAt(0);
        
        Staff staff = new Staff(userID, icnum, password, role, name, email, phoneNumber, status);
        
        if ("edit".equalsIgnoreCase(action)) {
            int result = StaffDAO.updateStaff(staff);
            if (result > 0) {
                response.sendRedirect("StaffServlet");
            } else {
                request.setAttribute("error", "Failed to update staff");
                request.getRequestDispatcher("editStaff.jsp").forward(request, response);
            }
        } 
        else  if ("add".equalsIgnoreCase(action)) {
        // Get common fields
        
        
        // Get role-specific fields
        String specialization = request.getParameter("specialization");
        String deskNoStr = request.getParameter("desk_no");
        Integer deskNo = deskNoStr != null && !deskNoStr.isEmpty() ? Integer.parseInt(deskNoStr) : null;
        
        // Validate role-specific fields
        if ("doctor".equals(staff.getRole()) && (specialization == null || specialization.isEmpty())) {
            request.setAttribute("error", "Specialization is required for doctors");
            request.getRequestDispatcher("addStaff.jsp").forward(request, response);
            return;
        }
        
        if ("receptionist".equals(staff.getRole()) && deskNo == null) {
            request.setAttribute("error", "Desk number is required for receptionists");
            request.getRequestDispatcher("addStaff.jsp").forward(request, response);
            return;
        }
        
        // Save to database
        int result = StaffDAO.addStaff(staff, specialization, deskNo);
        
        if (result > 0) {
            response.sendRedirect("StaffServlet");
        } else {
            request.setAttribute("error", "Failed to add staff");
            request.getRequestDispatcher("addStaff.jsp").forward(request, response);
        }
    }
    }
}